@../setup.sql
set timing on
begin
    insert into target_table(id)
        select id from input_records;
        
    commit;
end;
/
set timing off
