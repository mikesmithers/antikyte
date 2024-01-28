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
    
    v_context apex_exec.t_context;
   
    v_print_config apex_data_export.t_print_config;
    v_export apex_data_export.t_export;    

    -- File handling variables
    v_dir all_directories.directory_name%type := 'HR_REPORTS';
    v_fname varchar2(128) := 'crayons.xlsx';

    v_fh utl_file.file_type;
    v_buffer raw(32767);
    v_amount integer := 32767;
    v_pos integer := 1;
    v_length integer;
begin


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

    v_stmnt := 'select * from departments';
    
    v_context := apex_exec.open_query_context
    (
        p_location => apex_exec.c_location_local_db,
        p_sql_query => v_stmnt
    );    
    
    -- Let's do some formatting.
    -- OK, let's just scribble with the coloured crayons...
    v_print_config := apex_data_export.get_print_config
    (
        p_header_font_family => apex_data_export.c_font_family_times, -- Default is "Helvetica"
        p_header_font_weight => apex_data_export.c_font_weight_bold, --  Default is "normal"
        p_header_font_color => '#FFFFFF', -- White
        p_header_bg_color => '#2F4F4F', -- DarkSlateGrey/DarkSlateGray
        p_body_font_family => apex_data_export.c_font_family_times,
        p_body_bg_color => '#40E0D0', -- Turquoise
        p_body_font_color => '#191970' -- MidnightBlue
    );        

    -- Specify the print_config in the export
    v_export := apex_data_export.export
    (
        p_context => v_context,
        p_format => apex_data_export.c_format_xlsx,
        p_print_config => v_print_config
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