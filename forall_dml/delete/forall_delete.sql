@../setup.sql

insert into target_table
    select id from input_records;

update record_statuses
set status = 'LOADED'
where id in (select id from input_records);

commit;

set timing on
declare
    v_count pls_integer := 0;
    cursor c_input is
        select id
        from input_records;
        
    type typ_input is table of input_records%rowtype index by pls_integer;
    v_arr_id typ_input;
begin
    open c_input;
    loop
        fetch c_input 
        bulk collect into v_arr_id
        limit 1000;
        forall k in 1..v_arr_id.count
            delete from input_records
            where id = v_arr_id(k).id;

        exit when v_arr_id.count = 0;    
    end loop;   
    close c_input;
    commit;
end;
/
set timing off

-- Run 1 : 1:22.226
-- Run 2 : 1:23.280