create or replace package body salary_by_dept_rpt
as
        
    procedure title_sheet( i_dept in departments.department_id%type)
    is 
        v_dept_name varchar2(250);
    begin
        
        -- the value of width appears to be 1/10th of the default width of a column.
        -- Default is 2.47 cm (24.7 mm), which makes 1 2.47 mm
        -- For reference, the title of the report is 27 characters
        as_xlsx.set_column_width( 
            p_col => 1,
            p_width => 30,
            p_sheet => 1);

        -- Print the Report Title in bold in cell A1 
        as_xlsx.cell(
            p_col => 1,
            p_row => 1,
            p_sheet => 1,
            p_value =>  'Salary by Department Report', 
            p_fontid => as_xlsx.get_font('Arial', p_bold => true),
            p_numFmtId =>  0);

        -- Detail the parameters used to generate the report
        -- Section label in A2
        as_xlsx.cell( 1,2, 'Parameters :', p_sheet => 1, p_numFmtId =>  0);
                   
        -- Parameter Name in A3
        as_xlsx.cell(1,3, 'Department', p_sheet => 1, p_numFmtId =>  0);
        
        -- Parameter value and Department name in B3
        select department_id||' ( '||department_name||')'
        into v_dept_name
        from departments
        where department_id = i_dept;
        
        as_xlsx.cell(2,3, v_dept_name, p_sheet => 1, p_numFmtId => 0);

        -- Run Date label in A4
        as_xlsx.cell( 1, 4, 'Report Run Date', p_sheet => 1, p_numFmtId =>  0);

        -- Run Date in B4
        as_xlsx.cell( 2, 4, sysdate, p_sheet => 1, p_numfmtid => as_xlsx.get_numfmt('dd/mm/yyyy h:mm'));

    end title_sheet;
    
    procedure job_summary_sheet(i_dept in departments.department_id%type)
    is
        v_row pls_integer := 1; -- need to account for the header row
        v_tot_row pls_integer;
        v_formula varchar2(4000);
        v_ave_sal number;
        v_sal_mid_range number;
        
        v_rgb varchar2(25);
    begin

    -- Set the column widths to allow for the header lengths
    as_xlsx.set_column_width( p_col => 1, p_width => 15, p_sheet => 2);
    as_xlsx.set_column_width( p_col => 2, p_width => 15, p_sheet => 2);
    as_xlsx.set_column_width( p_col => 3, p_width => 15, p_sheet => 2);
    as_xlsx.set_column_width( p_col => 4, p_width => 15, p_sheet => 2);

    -- Set the column headings
    -- NOTE - for second and subsequent sheets, we need to specify the number format or else we'll get
    -- ORA-1403 no data found at line 724 of AS_XLSX.
    -- Specifying the sheet number as it seems sensible to do so at this point !
    as_xlsx.cell(1,1, 'Department Name', p_sheet => 2, p_numFmtId =>  0);
    as_xlsx.cell(2,1, 'Job Title', p_sheet => 2, p_numFmtId =>  0);
    as_xlsx.cell(3,1, 'No of Employees', p_sheet => 2, p_numFmtId =>  0);
    as_xlsx.cell(4,1, 'Total Salary', p_sheet => 2, p_numFmtId =>  0);
    
    -- Retrive the data rows and populate the relevant cells, applying any
    -- conditional formatting.
    for r_jobs in (
        select dept.department_name, job.job_title, 
            count(emp.employee_id) as employees,
            sum(emp.salary) as total_salary,
            job.min_salary, job.max_salary
        from employees emp
        inner join departments dept
            on dept.department_id = emp.department_id
        inner join jobs job
            on job.job_id = emp.job_id
        where dept.department_id = i_dept    
        group by dept.department_name, job.job_title,
        job.min_salary, job.max_salary
        order by job.max_salary desc, job.job_title)
    loop
        v_row := v_row + 1;
        as_xlsx.cell(1, v_row, r_jobs.department_name, p_numFmtId =>  0, p_sheet => 2);
        as_xlsx.cell(2, v_row, r_jobs.job_title,  p_numFmtId =>  0, p_sheet => 2);
        as_xlsx.cell(3, v_row, r_jobs.employees,  p_numFmtId =>  0, p_sheet => 2);
        
        -- If the average salary is lower than the mid-range for this job then
        -- display in red because someone needs a pay rise !
        -- Otherwise, display in green
        v_ave_sal := r_jobs.total_salary / r_jobs.employees;
        v_sal_mid_range :=  r_jobs.min_salary + ((r_jobs.max_salary - r_jobs.min_salary) / 2);
        if v_ave_sal > v_sal_mid_range then
            v_rgb := '009200'; -- green
        else    
            v_rgb := 'ff0000'; -- red
        end if;
        as_xlsx.cell(4, v_row, r_jobs.total_salary, 
            p_fontId => as_xlsx.get_font( 'Arial', p_rgb => v_rgb ),
            p_numFmtId => 0, 
            p_sheet => 2);
            
    end loop;
        if v_row = 1 then
            raise_application_error(-20001, 'No data returned from query');
        end if;    
        v_tot_row := v_row + 1;
        as_xlsx.cell(1, v_tot_row, 'Total', p_numFmtID => 0, p_sheet => 2);
        -- Number of employees
        v_formula := '=SUM(C2:C'||v_row||')';
        -- Number format requried to avoid ORA-1403
        as_xlsx.num_formula( 3, v_tot_row, v_formula,  p_numFmtID => 0, p_sheet => 2);
        
        -- Total Salary
        v_formula := '=SUM( D2:D'||v_row||')';
        as_xlsx.num_formula( 4, v_tot_row, v_formula,  p_numFmtID => 0, p_sheet => 2);

    end job_summary_sheet;
    
    procedure detail_sheet(i_dept in departments.department_id%type) is
        v_rc sys_refcursor;
    begin 
        -- Format the column headings in the ref cursor query
        open v_rc for 
            select emp.employee_id as "Employee ID", 
                emp.first_name as "First Name", 
                emp.last_name as "Last Name",
                job.job_title as "Job Title", 
                emp.salary as "Salary"
            from employees emp
            inner join jobs job
                on job.job_id = emp.job_id
            where emp.department_id = i_dept;
        
        as_xlsx.query2sheet( v_rc, p_sheet => 3);
        
        -- Any formatting gets overwritten by the query2sheet so
        -- we need to do it afterwards
        as_xlsx.set_column_width( p_col => 1, p_width => 15, p_sheet => 3);
        as_xlsx.set_column_width( p_col => 2, p_width => 15, p_sheet => 3);
        as_xlsx.set_column_width( p_col => 3, p_width => 15, p_sheet => 3);
        as_xlsx.set_column_width( p_col => 4, p_width => 15, p_sheet => 3);
        -- Leave salary as is

    end detail_sheet;
    
    procedure run_report( i_dept in departments.department_id%type)
    is
        v_fname varchar2(250);
    begin
        v_fname := 'salary_report_dept_'||i_dept||'.xlsx';
        -- Ensure we have nothing hanging around from a previous run in this session
        as_xlsx.clear_workbook;

        -- For the query2sheet call to work where it's not the first sheet or
        -- any other sheet preceeding it is not being created using this call,
        -- you need to define all of the sheets upfront.
        -- Otherwise, it will only write a single integer to that sheet.
        as_xlsx.new_sheet('Title');
        as_xlsx.new_sheet('Summary by Job');
        as_xlsx.new_sheet('Department Employees');

        -- Call each procedure in turn to populate the worksheets
        title_sheet( i_dept);
        job_summary_sheet(i_dept);       
        detail_sheet(i_dept);
        
        as_xlsx.save( GC_DIR, v_fname);        
            
    end run_report;    
end salary_by_dept_rpt;
/