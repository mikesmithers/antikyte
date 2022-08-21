clear screen
set serverout on
declare
    v_start_from date;
    v_next_run date;
    v_first_working_day varchar2(4000) := 'freq=monthly; byday=mon,tue,wed,thu,fri; exclude=public_holidays_england; bysetpos=1';
    v_last_working_day varchar2(4000) := 'freq=monthly; byday=mon,tue,wed,thu,fri; exclude=public_holidays_england; bysetpos=-1';
    v_payday varchar2(4000) := 'freq=monthly; bymonthday=6,7,8,9,10; byday=mon,tue,wed,thu,fri; exclude=public_holidays_england; bysetpos=1';

    function next_due_date( i_string in varchar2, i_start in date)
        return date
    is
        v_rtn date;
    begin 
        dbms_scheduler.evaluate_calendar_string(
            calendar_string => i_string,
            start_date => null,
            return_date_after => i_start,
            next_run_date => v_rtn);
        return v_rtn;
    end next_due_date;    
        

begin
    v_start_from := date '2021-12-31';
    dbms_output.put_line('First Working Day for each month in 2022');

    for i in 1..12 loop
        v_next_run := next_due_date( v_first_working_day, v_start_from);
        dbms_output.put_line(to_char( v_next_run, 'Day fmddth Month YYYY'));    
        v_start_from := add_months(v_start_from, 1);
        
    end loop;

    v_start_from := date '2021-12-31';    
    dbms_output.put_line('Last Working Day for each month in 2022');

    for j in 1..12 loop
        v_next_run := next_due_date( v_last_working_day, v_start_from);
        dbms_output.put_line(to_char( v_next_run, 'Day fmddth Month YYYY'));    
        v_start_from := add_months(v_start_from, 1);

    end loop;
    
    v_start_from := date '2021-12-31';
    dbms_output.put_line('Pay Day for each month in 2022');

    for k in 1..12 loop
        v_next_run := next_due_date( v_payday, v_start_from);
        dbms_output.put_line(to_char(v_next_run, 'Day fmddth Month YYYY'));
        v_start_from := add_months(v_start_from, 1);
    end loop;    
end;
/