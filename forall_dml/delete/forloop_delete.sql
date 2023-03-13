@../setup
insert into target_table
    select id from input_records;

update record_statuses
set status = 'LOADED'
where id in (select id from input_records);

commit;

set timing on
begin
    for r_rec in (
        select id
        from input_records)
    loop 
        delete from input_records
        where id = r_rec.id;
    end loop;
    commit;
end;
/
set timing off 
