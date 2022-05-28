create or replace package salary_by_dept_rpt
as

    GC_DIR constant all_directories.directory_name%type := 'APP_DIR';
    
    -- Package members to generate the individual worksheets in the report workbook.
    -- These would normally be private.
    procedure title_sheet( i_dept in departments.department_id%type);
    procedure job_summary_sheet(i_dept in departments.department_id%type);
    procedure detail_sheet(i_dept in departments.department_id%type);
    
    -- Main entry point - this is the procedure to create the report itself.
    procedure run_report( i_dept in departments.department_id%type);
end salary_by_dept_rpt;
/