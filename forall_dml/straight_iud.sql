@setup.sql
set timing on
begin
    insert into target_table(id)
        select id from input_records;

    update record_statuses
    set status = 'LOADED'
    where id in ( select id from input_records);
        
    delete from input_records
    where id in ( select id from record_statuses where status = 'LOADED');
        
    commit;
end;
/
set timing off
