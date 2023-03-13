@setup.sql

-- If we try to declare and use the varray entirely within the PL/SQL block
-- we run into PLS-00642 : local collection types not allowed in SQL statements
-- so...

create or replace type prince_varray as varray(100000) of number
/

set timing on
declare
    v_id_arr prince_varray := prince_varray();
begin
    select id 
    bulk collect into v_id_arr
    from input_records;
    

    insert into target_table(id)
        select * from table(v_id_arr);

    update record_statuses
    set status = 'LOADED'
    where id in (select * from table(v_id_arr));

    delete from input_records
    where id in (select * from table(v_id_arr));

    commit;
end;
/
set timing off

