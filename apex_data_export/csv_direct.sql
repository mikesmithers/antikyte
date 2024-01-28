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
    v_export apex_data_export.t_export;
begin

    dbms_output.put_line('Getting app details...');
    -- We only need the first record returned by this cursor 
    open c_apex_app; 
    fetch c_apex_app into v_apex_app;
    close c_apex_app;
    
    apex_util.set_workspace(v_apex_app.workspace);
    
    dbms_output.put_line('Creating session');

    apex_session.create_session
    (
        p_app_id => v_apex_app.application_id,
        p_page_id => v_apex_app.page_id,
        p_username => 'anynameyoulike' -- this parameter is mandatory but can be any string apparently
    );
    
    v_stmnt := 'select * from departments';

    dbms_output.put_line('Opening context');
    
    v_context := apex_exec.open_query_context
    (
        p_location => apex_exec.c_location_local_db,
        p_sql_query => v_stmnt
    );    
    
    dbms_output.put_line('Running Report');
    v_export := apex_data_export.export
    (
        p_context => v_context,
        p_format => 'CSV', -- patience ! We'll get to the Excel shortly.
        p_as_clob => true -- by default the output is saved as a blob. This overrides to save as a clob
    );
    
    apex_exec.close( v_context);

    dbms_output.put_line(v_export.content_clob);
end;
/
        