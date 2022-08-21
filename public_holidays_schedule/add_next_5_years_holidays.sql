set serverout on size unlimited
clear screen
declare
    v_start_year number(4);
    v_end_year number(4);
    v_range number := 5;
begin
    -- find the latest year for which we have holidays defined
    -- If none then use the current year
    select max(calc_year) 
    into v_start_year
    from (
        select extract( year from sysdate) as calc_year from dual
        union
        select extract( year from max(holiday_date)) from public_holidays);
    
    v_start_year := v_start_year + 1;
    v_end_year := v_start_year + v_range;
    
    for i in v_start_year..v_end_year loop
        dbms_output.put_line('Adding Standard Holidays for '||i);
        maintain_public_holidays.add_standard_holidays(i);
    end loop;
    commit;
end;
/
