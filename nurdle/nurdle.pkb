create or replace package body nurdle as

    procedure verify_wordlen( i_word in varchar2) 
    is
    -- Private procedure to ensure that a word is the required length.
    -- Used by multiple sub-programs in the package.
    begin
        if nvl(length(i_word), 0) != GC_LEN then
            raise_application_error(-20990, 'Word is not '||GC_LEN||' characters long');
        end if;
    end verify_wordlen;    
    
    procedure add_word ( i_word in nurdle_words.word%type)
    is
        v_word nurdle_words.word%type;
    begin
        verify_wordlen( i_word);
        -- Canonicalize the WORD value to make searching simple 
        v_word := lower(i_word);
        
        merge into nurdle_words
        using dual
        on (word = v_word)
        when not matched then
            insert( word)
            values(v_word);
    end add_word;
    
    procedure guess( i_guess in varchar2, i_result in varchar2)
    is
        v_guess varchar2(GC_LEN);
        v_result varchar2(GC_LEN);
        v_guess_no todays_guesses.guess_no%type;
    begin 
        verify_wordlen(i_guess);
        verify_wordlen(i_result);
        
        -- canonicalize word to all lowercase, the result to all uppercase, just for a change !
        v_guess := lower(i_guess);
        v_result := upper(i_result);
        
        select nvl(max(guess_no), 0) + 1
        into v_guess_no     
        from todays_guesses;

        -- split the guessed word and the result into the component letters
        for i in 1..GC_LEN loop
            insert into todays_guesses( guess_no, letter, pos_in_word, status)
            values(v_guess_no, substr(v_guess, i, 1), i, substr(v_result, i, 1));
        end loop;
    end guess;
    
    procedure show_guesses
        is
        v_rc sys_refcursor;
    begin
        open v_rc for
            select guess_no, 
                listagg(letter)  within group (order by pos_in_word) as guess,
                listagg(status) within group (order by pos_in_word) as result
            from todays_guesses
            group by guess_no
            order by guess_no;
        dbms_sql.return_result(v_rc);
    end show_guesses;
    
    function colour_guesses return sys.ODCIVarchar2List pipelined
    is
        v_rc sys_refcursor;
        v_rtn sys.ODCIVarchar2List := sys.ODCIVarchar2List();
    begin
        dbms_output.put_line(q'[Don't forget to "set sqlformat ansiconsole"]');
        open v_rc for
            select 
                listagg(
                    case status 
                        when 'B' then '@|bg_black '
                        when 'Y' then '@|bg_yellow '
                        when 'G' then '@|bg_green '
                    end
                    ||letter
                    ||'|@') 
                within group (order by pos_in_word) as guess
            from todays_guesses
            group by guess_no
            order by guess_no;
        loop
            v_rtn.extend(1);
            fetch v_rc into v_rtn(v_rtn.count);
            exit when v_rc%notfound;
            pipe row( v_rtn( v_rtn.count));
        end loop;
        close v_rc;
        return;
    end colour_guesses;    

    function next_guess return wordlist pipelined
    is
        v_row nurdle_words%rowtype;
        v_stmnt clob;
        v_green varchar2(GC_LEN);
        v_blank varchar2(100);
        v_rc sys_refcursor;

        -- Remember your injection protection !
        -- We're only concatenating values from this table. It's a small table.
        -- Therefore, just scan the whole thing and make sure that the values we'll be using are all
        -- alphabetical only
        function is_dodgy return boolean is
            v_count pls_integer;
        begin
            select count(*)
            into v_count
            from todays_guesses
            where length(letter) != regexp_count(letter, '[[:alpha:]]');
            
            return v_count > 0;
        end is_dodgy;    
    begin 
        if is_dodgy then
            raise_application_error(-20902, 'There are non-alphabetical characters in TODAYS_GUESSES.LETTER');
        end if;    

        -- Specifying the where clause here will save us jumping through hoops as we
        -- build the rest of the query. The optimizer will essentially disregard
        -- "where 1=1" so it shouldn't cost anything in performance terms
        
        v_stmnt := 'select word from nurdle_words where 1=1';
        
        -- Build a pattern containing all of the Green letters - i.e. correct letters in the right place -
        -- using a pile of Common Table Expressions that interact with each other.
        -- Account for the fact that the same "green" letter may appear in multiple guesses...
        with greens as (
            select letter, pos_in_word,
                row_number() over (partition by letter order by guess_no) as recnum
            from todays_guesses
            where status = 'G'),
        ungreens as (
            select '_' as letter, rownum as pos_in_word
            from dual
            connect by rownum <= GC_LEN),
        green_pattern as (
            select nvl(g.letter, u.letter) letter, u.pos_in_word
            from ungreens u
            left outer join greens g
                on g.pos_in_word = u.pos_in_word
                and g.recnum = 1
            order by u.pos_in_word)
        select listagg(letter) within group( order by pos_in_word)
        into v_green
        from green_pattern;

        v_stmnt := v_stmnt||chr(10)||q'[and word like ']'||v_green||q'[']';

        -- Now add in all of the Yellows - letters that are in the word but which we've put in
        -- the wrong place. First we need to include the letter in the search...
        for r_like in ( 
            select letter
            from todays_guesses
            where status = 'Y'
            and letter not in ( select letter from todays_guesses where status = 'G'))
        loop
            v_stmnt := v_stmnt||chr(10)||q'[and word like '%]'||r_like.letter||q'[%']';
        end loop;
 
        -- Now exclude words that have our yellow letters in the wrong place...
        for r_pos in (
            select case pos_in_word 
                when 1 then letter||'____'
                when 2 then '_'||letter||'___'
                when 3 then '__'||letter||'__'
                when 4 then '___'||letter||'_'
                when 5 then '____'||letter
                end yellow_pos
            from todays_guesses
            where status = 'Y'
            and letter not in ( select letter from todays_guesses where status = 'G'))
        loop    
            v_stmnt := v_stmnt||chr(10)||q'[and word not like ']'||r_pos.yellow_pos||q'[']';
        end loop;    

        -- Where we've made a guess with a repeating letter and found only one in the word,
        -- Wordle will return one of the letters as yellow or green and the other as blank.
        -- We can use the blank to infer that the letter in question is not in that position in the word
        
        for r_double in (
            select case pos_in_word 
                when 1 then letter||'____'
                when 2 then '_'||letter||'___'
                when 3 then '__'||letter||'__'
                when 4 then '___'||letter||'_'
                when 5 then '____'||letter
                end double_pos
            from todays_guesses
            where status = 'B'
            and letter in ( select letter from todays_guesses where status in ('G', 'Y')))
        loop
            v_stmnt := v_stmnt||chr(10)||q'[and word not like ']'||r_double.double_pos||q'[']';
        end loop;    

        -- Exclude all the Blanks
        select listagg(letter, '|') within group (order by pos_in_word)
        into v_blank
        from todays_guesses
        where status = 'B'
        -- handle guesses with double-letters where the word only contains one of the letter
        and letter not in (select letter from todays_guesses where status != 'B');
    
        -- Handle the remote possibility of getting all 5 letters on the first try
        if nvl(length( v_blank), 0) > 0 then
            v_stmnt := v_stmnt||chr(10)||q'[and not regexp_like( word, '(]'||v_blank||q'[)')]';
        end if;    
        
        -- Output the statement in case we need to debug
        dbms_output.put_line(v_stmnt);

        -- Open a refcursor for the statement and pipe the contents
        open v_rc for v_stmnt;
        loop
            fetch v_rc into v_row;
            exit when v_rc%notfound;
                pipe row(v_row);
        end loop;
        close v_rc;
        return;

    end next_guess;
end nurdle;
