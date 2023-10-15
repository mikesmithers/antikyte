clear screen
set heading off
set lines 130
set pages 500
set feedback off
set verify off
column pkg new_value v_package_name noprint
select '&1' as pkg from dual;

spool  '&v_package_name..pkb'

with package_skeleton as 
(
    select 1 as line, 'create or replace package body &v_package_name' as text from dual
    union 
    select line,
        case 
            when line < ( select max(line) from user_source where name = upper('&v_package_name') and type = 'PACKAGE')
            then
                replace (
                    replace( 
                        replace(text, '%test('), 
                        ')')
                    ,';', q'[ is begin ut.fail('Not yet written'); end;]')
            else text
        end as text
    from user_source
    where name = upper('&v_package_name')
    and type = 'PACKAGE'
    and line > 1 
    and
    (
        regexp_replace(text, '[[:space:]]') not like '--\%%' escape '\'
        or 
        regexp_replace(text, '[[:space:]]') like '--\%test%' escape '\'
    )    
)
select text from package_skeleton order by line
/