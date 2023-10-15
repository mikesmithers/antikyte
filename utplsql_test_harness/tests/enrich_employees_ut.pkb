create or replace package body enrich_employees_ut
as
    -- Global variables for use in tests
    g_emp employees_core%rowtype;
    g_job jobs%rowtype;
    g_dept departments%rowtype;
   
    g_result employees_core%rowtype;        
      
    -- Set the global variables separately from inserting test values into the table
    -- that way we can just tweak the variable values we need for a particular test.
    procedure set_globals
    is
    begin
        -- start by setting the globals to the values required for the first test, which 
        -- I usually make the test for the most commonly expected behaviour
        
        --
        -- Values for Employees Core record
        --
        
        -- Making numeric values negative means that they are less likely to clash 
        -- with an existing sequence generated value
        g_emp.load_id := -1; 
        g_emp.employee_id := -8;
        
        -- However wide the table, we only have to populate mandatory columns, and
        -- any columns we want for the tests...
        g_emp.department_id := -64;
        g_emp.record_status := 'PROCESS';
        
        -- Job Id is a Varchar - no constraints on it other than length.
        -- I mean, your test data doesn't *have* to be thematic but...
        g_emp.job_id := 'WIZZARD';
        
        --
        -- Values for the Department Lookup ( starting with ones that we expect to find)
        --
        
        -- Values set independently of the EMPLOYEES_CORE values as we'll want to see what happens 
        -- if they DON't match, as well as if they do.
        g_dept.department_id := -64; 
        g_dept.department_name := 'Cruel and Unusual Geography';
        
        --
        -- Values for the Job lookup
        --
        g_job.job_id := 'WIZZARD';
        g_job.job_title := 'Professor';
        
    end set_globals;
    
    procedure setup_data
    is
    -- Populate the tables with our test data
    begin
        insert into employees_core values g_emp;
        insert into departments values g_dept;
        insert into jobs values g_job;
        commit;
    end setup_data;
    
    procedure fetch_results
    is
        cursor c_result is
            select *
            from employees_core
            where load_id = g_emp.load_id
            and employee_id = g_emp.employee_id;
    begin
        open c_result;
        fetch c_result into g_result;
        close c_result;
    end fetch_results;
    
    procedure teardown_data 
    is
        -- Tidy up by removing the test data using unique values where possible.
    begin
        delete from employees_core
        where employee_id = g_emp.employee_id 
        and load_id = g_emp.load_id;
        
        delete from departments
        where department_id = g_dept.department_id;
        
        delete from jobs
        where job_id = g_job.job_id;
    
        commit;
    end teardown_data;    
    
    -- Department Lookup Succeeds
    procedure department_is_found 
    is 
    begin 
        -- Setup
        set_globals;
        setup_data;

        -- Execute
        enrich_employees.department_details(g_emp.load_id);
        
        fetch_results;

        -- Validate
        ut.expect( g_result.department_name).to_(equal(g_dept.department_name));
        ut.expect( g_result.record_status).to_(equal('PROCESS'));
        
        -- Teardown 
        teardown_data;
    exception when others then
        dbms_output.put_line(dbms_utility.format_error_stack);
        ut.fail('Unexpected Error');
        teardown_data;
    end;

    -- Department does not exist
    procedure department_not_found 
    is 
    begin
        
        -- Setup
        set_globals;
        -- Almost exactly the same as the first test excep...
        g_emp.department_id := -4096;
        setup_data;

        -- Execute
        enrich_employees.department_details(g_emp.load_id);
        
        fetch_results;
        
        -- Validate
        ut.expect( g_result.department_name).to_(be_null());
        ut.expect( g_result.record_status).to_(equal('DEPARTMENT_ID_NOT_FOUND'));
        
        -- Teardown 
        teardown_data;
    exception when others then
        dbms_output.put_line(dbms_utility.format_error_stack);
        ut.fail('Unexpected Error');
        teardown_data;
    end;

    -- Department ID is null
    procedure department_is_null 
    is
    begin
        
        -- Setup
        set_globals;
        -- Again, just a single change required :
        g_emp.department_id := null;
        setup_data;

        -- Execute
        enrich_employees.department_details(g_emp.load_id);
        
        fetch_results;
        
        -- Validate
        ut.expect( g_result.department_name).to_(be_null());
        ut.expect( g_result.record_status).to_(equal('DEPARTMENT_ID_NOT_FOUND'));
        
        -- Teardown 
        teardown_data;
    exception when others then
        dbms_output.put_line(dbms_utility.format_error_stack);
        ut.fail('Unexpected Error');
        teardown_data;
    end;

    -- Status is not PROCESS
    procedure status_not_process 
    is 
    begin
        -- Setup
        set_globals;
        -- This time set the status to prevent processing
        g_emp.record_status := 'SUSPENDED';
        setup_data;

        -- Execute
        enrich_employees.department_details(g_emp.load_id);
        
        fetch_results;

        -- Validate
        ut.expect( g_result.department_name).to_(be_null());
        ut.expect( g_result.record_status).to_(equal('SUSPENDED'));
        
        -- Teardown 
        teardown_data;
    exception when others then
        dbms_output.put_line(dbms_utility.format_error_stack);
        ut.fail('Unexpected Error');
        teardown_data;
    end;

    -- JOB Lookup Succeeds
    procedure job_is_found 
    is 
    begin 
            
        -- Setup
        -- We can use the default values here
        set_globals;
        setup_data;

        -- Execute
        enrich_employees.job_details(g_emp.load_id);
        
        fetch_results;        
        
        -- Validate
        ut.expect( g_result.job_title).to_(equal(g_job.job_title));
        
        -- Teardown 
        teardown_data;
    exception when others then
        dbms_output.put_line(dbms_utility.format_error_stack);
        ut.fail('Unexpected Error');
        teardown_data;
    end;

    -- Job does not exist
    procedure job_not_found 
    is 
    begin
        -- Setup
        set_globals;
        g_emp.job_id := -32768;
        setup_data;

        -- Execute
        enrich_employees.job_details(g_emp.load_id);
        
        -- Get the actual results
        fetch_results;
        
        -- Validate
        ut.expect( g_result.job_title).to_(be_null());
        ut.expect( g_result.record_status).to_(equal('PROCESS'));
        
        -- Teardown 
        teardown_data;
    exception when others then
        dbms_output.put_line(dbms_utility.format_error_stack);
        ut.fail('Unexpected Error');
        teardown_data;
    end;

    -- Job ID is null
    procedure job_is_null 
    is 
    begin 
        -- Setup
        set_globals;
        g_emp.job_id := null;
        setup_data;

        -- Execute
        enrich_employees.job_details(g_emp.load_id);
        
        fetch_results;
        
        -- Validate
        ut.expect( g_result.job_title).to_(be_null());
        ut.expect( g_result.record_status).to_(equal('PROCESS'));
        
        -- Teardown 
        teardown_data;
    exception when others then
        dbms_output.put_line(dbms_utility.format_error_stack);
        ut.fail('Unexpected Error');
        teardown_data;
    end;

end enrich_employees_ut;
