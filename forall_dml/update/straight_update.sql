@../setup.sql

insert into target_table
    select id from input_records;
    
commit;

set timing on
begin
    update record_statuses
    set status = 'LOADED'
    where id in ( select id from input_records);
        
    commit;
end;
/
set timing off
