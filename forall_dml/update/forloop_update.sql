@../setup.sql

insert into target_table
    select id from input_records;
    
commit;

set timing on
declare
    v_count pls_integer := 0;
        
begin
    for r_rec in(
        select id
        from input_records)
    loop
        update record_statuses
        set status = 'LOADED'
        where id = r_rec.id;
       
    end loop;    
    commit;
end;
/
set timing off
