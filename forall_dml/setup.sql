clear screen
set serverout on size unlimited
clear screen
set serverout on size unlimited

drop table input_records;
drop table record_statuses;
drop table target_table;

create table input_records
as
    select rownum as id
    from dual
    connect by rownum <=100000;
    
create table record_statuses
as
    select id, 'WAITING' as status
    from input_records;
    
create table target_table ( id number);
