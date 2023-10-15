create or replace package body enrich_employees 
is
    procedure department_details( i_load_id in number)
    is
        -- Populate the Department Name.
        -- Suspend the record if we don't get a match.
    begin
        merge into employees_core emp
        using departments dept
        on 
        ( 
                emp.department_id = dept.department_id
            and emp.load_id = i_load_id
            and emp.record_status = 'PROCESS'
        )
        when matched then update
            set emp.department_name = dept.department_name;
    
        update employees_core
        set record_status = 'DEPARTMENT_ID_NOT_FOUND'
        where record_status = 'PROCESS'
        and department_name is null;

        commit;
    end department_details;    
            
    procedure job_details( i_load_id in number)
    is
        -- Don't suspend if we don't get a match, just leave the job_title empty.
    begin  
        merge into employees_core emp
        using jobs j
        on
        (
                emp.job_id = j.job_id
            and emp.record_status = 'PROCESS'                
            and emp.load_id = i_load_id
        )
        when matched then update
            set emp.job_title = j.job_title;
        
        commit;            
        
    end job_details;
end;
/