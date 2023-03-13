@../setup.sql

insert into target_table(id)
    select id from input_records;
    
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

        forall j in 1..v_arr_id.count 
            update record_statuses
            set status = 'LOADED'
            where id = v_arr_id(j).id;

        exit when v_arr_id.count = 0;    
    end loop;   
    close c_input;
    commit;
end;
/
set timing off

