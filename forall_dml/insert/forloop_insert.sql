@../setup.sql
set timing on
declare
    v_count pls_integer := 0;
        
begin
    for r_rec in(
        select id
        from input_records)
    loop
        insert into target_table(id)
        values( r_rec.id);
       
    end loop;    
    commit;
end;
/
set timing off
