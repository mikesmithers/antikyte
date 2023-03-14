create or replace package body generate_jnl_trigger 
as
    function check_object_name( i_name in varchar2)
        return boolean
    is
    begin
        -- Ensure that object name does not contain any suspicious characters
        return length(regexp_replace(i_name, '[[:alnum:]]|[$_#]')) = 0;
    end check_object_name;    
 
    procedure build_trigger(
        i_base_table in varchar2,
        i_jnl_table in varchar2 default null,
        i_trigger_name in varchar2 default null,
        i_canonicalize_cols in varchar2 default null)
    is
        v_base_table user_tables.table_name%type;
         
        v_tab_name_max_len pls_integer;
         
        v_jnl_table varchar2(4000);
        v_trigger varchar2(4000);
         
        v_jnl_tab_ddl_stmnt clob;
        v_stmnt clob;
         
        v_canon_count binary_integer;
        v_canon_arr dbms_utility.lname_array;
        v_canon_stmnt clob;
         
        v_target_col_arr dbms_utility.lname_array;
        v_ins_cols varchar2(32767);
        v_old_cols varchar2(32767);
         
        C_TRIGGER_TEMPLATE constant clob := 
            q'[
            create or replace trigger <trigger_name>
                before insert or update or delete on <base_table>
                for each row
            declare
                v_user varchar2(4000);
                v_operation varchar2(25);
            begin
                v_user := sys_context('userenv', 'os_user');
                v_operation := case when inserting then 'INSERT' when updating then 'UPDATE' else 'DELETE' end;
                 
                if inserting then
                    <canonicalize_cols>
                end if;
                 
                if updating or deleting then
                    insert into <jnl_table> ( 
                        operation, os_user, change_ts, 
                        <col_list>)
                    values( v_operation, v_user, systimestamp, 
                        <old_list>);
                end if;
            end; ]';
         
        C_JNL_TAB_DDL_TEMPLATE constant clob :=
            q'[
                create table <jnl_table> as
                select 
                    rpad(' ', 6) as operation,
                    rpad(' ', 4000) as os_user,
                    systimestamp as change_ts,
                    t.*
                from <base_table> t
                where 1=0]';
                 
        C_CANON_TEMPLATE constant varchar2(4000) := ':new.<col_name> := upper(:new.<col_name>);';        
    begin
        if i_base_table is null then
            raise_application_error(-20000, 'Base Table must be specified.');
        end if;
         
        -- Make sure that we've been passed the name of an existing table
        v_base_table := dbms_assert.sql_object_name(i_base_table);
         
        --
        -- Determine the maxiumum length of a table_name in this Oracle version
        -- 
        select data_length
        into v_tab_name_max_len
        from all_tab_columns
        where table_name = 'USER_TABLES'
        and column_name = 'TABLE_NAME';
         
        v_trigger := nvl(i_trigger_name, substr(v_base_table,1,(v_tab_name_max_len -4))||'_TRG');
         
        if not check_object_name(v_trigger) then
            raise_application_error(-20010, 'Trigger Name '||v_trigger||' not allowed');
        end if;    
 
        v_jnl_table := nvl(i_jnl_table, substr(v_base_table,1, (v_tab_name_max_len -4))||'_JNL');
 
        if not check_object_name(v_jnl_table) then
            raise_application_error(-20020, 'Trigger Name '||v_jnl_table||' not allowed');
        end if;    
         
        -- Create the Journal table
        -- Replace the placeholder text in the template with the actual values.
        -- Doing this one placeholder at-a-time for readability
        v_jnl_tab_ddl_stmnt := replace(C_JNL_TAB_DDL_TEMPLATE, '<jnl_table>', v_jnl_table);
        v_jnl_tab_ddl_stmnt := replace(v_jnl_tab_ddl_stmnt, '<base_table>', v_base_table);
        execute immediate v_jnl_tab_ddl_stmnt;
         
        v_stmnt := replace(C_TRIGGER_TEMPLATE, '<trigger_name>', v_trigger);
        v_stmnt := replace(v_stmnt, '<base_table>', i_base_table);
        v_stmnt := replace(v_stmnt, '<jnl_table>', v_jnl_table);
         
        if i_canonicalize_cols is not null then
            dbms_utility.comma_to_table( i_canonicalize_cols, v_canon_count, v_canon_arr);
            -- Remember to use the count returned from the procedure...
            for i in 1..v_canon_count loop
                v_canon_stmnt := v_canon_stmnt ||
                    replace(C_CANON_TEMPLATE, '<col_name>', trim(v_canon_arr(i)))||chr(10);
            end loop;
            v_stmnt := replace(v_stmnt, '<canonicalize_cols>', v_canon_stmnt);
        else
            -- Just do nothing
            v_stmnt := replace(v_stmnt, '<canonicalize_cols>', 'null;');
        end if;
 
 
        select column_name
        bulk collect into v_target_col_arr
        from user_tab_columns
        where table_name = upper(i_base_table)
        order by column_id;
 
        -- We know that these columns belong to the base table because we've just got them from the data dictionary.
        -- However, we want to double check there's nothing fishy about them.
        -- Check that they contain only valid characters ( which may not be the case if the column names are quoted).
        -- I know I don't have any quoted column names in my data model...
         
        for i in 1..v_target_col_arr.count loop
            if not check_object_name(v_target_col_arr(i)) then
                raise_application_error(-20030, 'Column name contains invalid characters : '||v_target_col_arr(i));
            end if;
             
            v_ins_cols := v_ins_cols||v_target_col_arr(i)||', ';
            v_old_cols := v_old_cols||':old.'||v_target_col_arr(i)||', ';
        end loop;
        v_ins_cols := rtrim(v_ins_cols, ', ');
        v_old_cols := rtrim(v_old_cols, ', ');
         
        v_stmnt := replace(v_stmnt, '<col_list>', v_ins_cols);
        v_stmnt := replace(v_stmnt, '<old_list>', v_old_cols);
         
        execute immediate(v_stmnt);
    end build_trigger;        
end;
/