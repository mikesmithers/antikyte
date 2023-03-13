set timing off
@setup.sql

drop table gtt_array;
create global temporary table gtt_array (
    id number)
    on commit delete rows;

set timing on
begin
    insert into gtt_array
        select id from input_records;

    insert into target_table(id)
        select id from gtt_array;
    
    update record_statuses
    set status = 'LOADED'
    where id in (select id from gtt_array);

    delete from input_records
    where id in (select id from gtt_array);

    commit;
end;
/
set timing off

