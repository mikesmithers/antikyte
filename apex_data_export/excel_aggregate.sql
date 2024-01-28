set serverout on size unlimited
clear screen

declare

    cursor c_apex_app is
        select ws.workspace_id, ws.workspace, app.application_id, app.page_id
        from apex_application_pages app
        inner join apex_workspaces ws
            on ws.workspace = app.workspace
        order by page_id;    

    v_apex_app c_apex_app%rowtype;    
   
    v_stmnt varchar2(32000);
    
    v_columns apex_data_export.t_columns;
    v_aggregates  apex_data_export.t_aggregates;
    
    v_context apex_exec.t_context;
    v_export apex_data_export.t_export;
    
    -- File handling variables
    v_dir all_directories.directory_name%type := 'HR_REPORTS';
    v_fname varchar2(128) := 'aggregate.xlsx';

    v_fh utl_file.file_type;
    v_buffer raw(32767);
    v_amount integer := 32767;
    v_pos integer := 1;
    v_length integer;
    
begin

    -- We only need the first record returned by this cursor 
    open c_apex_app; 
    fetch c_apex_app into v_apex_app;
    close c_apex_app;
    
    apex_util.set_workspace(v_apex_app.workspace);
    
    apex_session.create_session
    (
        p_app_id => v_apex_app.application_id,
        p_page_id => v_apex_app.page_id,
        p_username => 'anynameyoulike' 
    );
    
    
    -- Add a row with a count of the records in the file
    -- We need to add the relevant data to the query and then format it
    v_stmnt := 
        'select department_id, department_name, manager_id, location_id,  
            count( 1) over() as record_count 
         from departments';

    -- Make sure only the data columns to display on the report, not the record_count
    -- NOTE - in all of these procs, column names need to be passed as upper case literals
    apex_data_export.add_column( p_columns => v_columns, p_name => 'DEPARTMENT_ID');
    apex_data_export.add_column( p_columns => v_columns, p_name => 'DEPARTMENT_NAME');
    apex_data_export.add_column( p_columns => v_columns, p_name => 'MANAGER_ID');
    apex_data_export.add_column( p_columns => v_columns, p_name => 'LOCATION_ID');
    
    apex_data_export.add_aggregate
    (
        p_aggregates => v_aggregates,
        p_label => 'Data Row Count',
        p_display_column => 'DEPARTMENT_ID',
        p_value_column => 'RECORD_COUNT'
    );    

    v_context := apex_exec.open_query_context
    (
        p_location => apex_exec.c_location_local_db,
        p_sql_query => v_stmnt
    );    

    v_export := apex_data_export.export
    (
        p_context => v_context,
        p_format => apex_data_export.c_format_xlsx, -- XLSX
        p_columns => v_columns,
        p_aggregates => v_aggregates
    );
    
    apex_exec.close( v_context);
    
    v_length := dbms_lob.getlength( v_export.content_blob);
    v_fh := utl_file.fopen( v_dir, v_fname, 'wb', 32767);
    
    while v_pos <= v_length loop
        dbms_lob.read( v_export.content_blob, v_amount, v_pos, v_buffer);
        utl_file.put_raw(v_fh, v_buffer, true);
        v_pos := v_pos + v_amount;
    end loop;
        
    utl_file.fclose( v_fh);

    dbms_output.put_line('File written to HR_REPORTS');
    
exception when others then
    dbms_output.put_line(sqlerrm);
    if utl_file.is_open( v_fh) then
        utl_file.fclose(v_fh);
    end if;    
end;
/
       
