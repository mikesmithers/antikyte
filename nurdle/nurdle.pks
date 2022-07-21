create or replace package nurdle as

    -- Maximum length of a Word
    GC_LEN constant number := 5;

    type wordlist is table of nurdle_words%rowtype;

    -- add to the dictionary
    procedure add_word ( i_word in nurdle_words.word%type);
    
    -- record a guess and the outcome
    procedure guess( i_guess in varchar2, i_result in varchar2);

    -- show guesses so far and the feedback for each (text version)    
    -- usage : 
    -- exec nurdle.show_guesses;
    procedure show_guesses;
        
    -- In SQLcl turn on sqlformat ansiconsole to get     
    -- usage : 
    -- set sqlformat ansiconsole
    -- select * from table( nurdle.colour_guesses);
    function colour_guesses return sys.ODCIVarchar2List pipelined;

    -- work out the possible words in the dictionary
    -- usage : 
    -- select * from table( nurdle.next_guess);
    function next_guess return wordlist pipelined;


end nurdle;
/
