create or replace package body maintain_public_holidays
as
    function calculate_easter( i_year in number default null) 
        return date
    is
        a pls_integer;
        b pls_integer;
        c pls_integer;
        d pls_integer;
        e pls_integer;
        f pls_integer;
        g pls_integer;
        h pls_integer;
        i pls_integer;
        k pls_integer;
        l pls_integer;
        m pls_integer;
        p pls_integer;

        v_month pls_integer;
        v_day pls_integer;
        v_year pls_integer;
     
        v_easter_sunday date;
    begin
        v_year := nvl(i_year, extract( year from sysdate));
        a := mod( v_year, 19);
        b := floor(v_year/100);
        c := mod(v_year,100);
        d := floor(b/4);
        e := mod(b,4);
        f := floor((b+8)/25);
        g := floor((b-f+1)/3);
        h := mod((19*a+b-d-g+15),30);
        i := floor(c/4);
        k := mod(c,4);
        l := mod((32+2*e+2*i-h-k),7);
        m := floor((a+11*h+22*l)/451);

        v_month := floor((h+l-7*m+114)/31);  -- 3=March, 4=April

        p := mod((h+l-7*m+114),31);
        v_day := p+1 ;  -- date in Easter Month

        v_easter_sunday := to_date(v_day||'-'||v_month||'-'||v_year, 'DD-MM-YYYY');
        return v_easter_sunday;
    end calculate_easter;

    procedure add_standard_holidays( i_year in number)
    is 
        type rec_holidays is record (
            holiday_name public_holidays.holiday_name%type,
            calendar_string varchar2(4000),
            holiday_date date);
            
        type typ_holidays is table of rec_holidays
            index by pls_integer;
           
        tbl_holidays typ_holidays;   
        
        v_start_date date;
        v_easter_sunday date;
    begin 
        -- We'll be using this as the RETURN_DATE_AFTER parameter in the call to
        -- DBMS_SCHEDULER.EVALUATE_CALENDAR_STRING so set it to the last day of the year
        -- *before* the one we want to add dates for
        v_start_date := to_date(i_year -1||'1231', 'YYYYMMDD');
        
        tbl_holidays(1).holiday_name := 'NEW YEARS DAY';
        tbl_holidays(1).calendar_string := 'freq=yearly; bymonth=1; byday=mon,tue,wed,thu,fri; bysetpos=1';

        tbl_holidays(2).holiday_name := 'MAY DAY';
        tbl_holidays(2).calendar_string := 'freq=yearly; bydate=0501+span:7D; byday=mon; bysetpos=1';
        
        tbl_holidays(3).holiday_name := 'SPRING BANK HOLIDAY';
        tbl_holidays(3).calendar_string := 'freq=yearly; bydate=0531-span:7D; byday=mon; bysetpos=1';
        
        tbl_holidays(4).holiday_name := 'AUGUST BANK HOLIDAY';
        tbl_holidays(4).calendar_string := 'freq=yearly; bydate=0831-span:7D; byday=mon; bysetpos=1';

        tbl_holidays(5).holiday_name := 'CHRISTMAS DAY';
        tbl_holidays(5).calendar_string := 'freq=yearly; bydate=1225+span:7d; byday=mon,tue,wed,thu,fri; bysetpos=1';
        
        tbl_holidays(6).holiday_name := 'BOXING DAY';
        tbl_holidays(6).calendar_string := 'freq=yearly; bydate=1225+span:7d; byday=mon,tue,wed,thu,fri; bysetpos=2';

        for i in 1..tbl_holidays.count loop
            dbms_scheduler.evaluate_calendar_string( 
                calendar_string => tbl_holidays(i).calendar_string,
                start_date => null,
                return_date_after => v_start_date,
                next_run_date => tbl_holidays(i).holiday_date);    
        end loop;
        
        v_easter_sunday := calculate_easter( i_year);
        tbl_holidays(7).holiday_name := 'GOOD FRIDAY';
        tbl_holidays(7).holiday_date := v_easter_sunday - 2;
        
        tbl_holidays(8).holiday_name := 'EASTER MONDAY';
        tbl_holidays(8).holiday_date := v_easter_sunday + 1;
        
        for j in 1..tbl_holidays.count loop
            dbms_output.put_line(tbl_holidays(j).holiday_name||' : '||to_char(tbl_holidays(j).holiday_date, 'DD-MON-YYYY'));            
            insert into public_holidays( holiday_name, holiday_date, notes)
            values( tbl_holidays(j).holiday_name, tbl_holidays(j).holiday_date, 'Generated record');
        end loop;
    end add_standard_holidays;

    procedure generate_schedule
    is
        C_SCHEDULE_NAME constant user_scheduler_schedules.schedule_name%type := 'PUBLIC_HOLIDAYS_ENGLAND';
        v_calendar_string user_scheduler_schedules.repeat_interval%type;
        
        v_start_date date;
        
        v_placeholder pls_integer;
        v_exists boolean;
        cursor c_schedule_exists is
            select null
            from user_scheduler_schedules
            where schedule_name = C_SCHEDULE_NAME;
            
    begin 
        v_calendar_string := 'freq=yearly;bydate=';
        
        for r_hols in (
            select to_char(holiday_date, 'YYYYMMDD') as string_date
            from public_holidays
            order by holiday_date)
        loop
            v_calendar_string := v_calendar_string||r_hols.string_date||',';
        end loop;
        -- strip off the last ','
        v_calendar_string := rtrim(v_calendar_string, ',');
        
        dbms_output.put_line(v_calendar_string);
        
        open c_schedule_exists;
        fetch c_schedule_exists into v_placeholder;
        v_exists := c_schedule_exists%found;
        close c_schedule_exists;
        
        if v_exists then
            dbms_scheduler.set_attribute( C_SCHEDULE_NAME, 'repeat_interval', v_calendar_string);
        else 
            dbms_scheduler.create_schedule(
                schedule_name => C_SCHEDULE_NAME,
                repeat_interval => v_calendar_string,
                comments => 'Bank Holidays in England');
        end if; 
    end generate_schedule;    
end maintain_public_holidays;
/