--
-- This is an example which creates a workspace called SCRIPTED_WS
-- then imports an APEX application from an APEX export file

-- NOTE the following call to ADD_WORKSPACE is only needed if the Workspace does not
-- already exist.
-- The APEX_ADMINISTRATOR_ROLE is required to run this
exec apex_instance_admin.add_workspace( p_workspace => 'SCRIPTED_WS', p_primary_schema => 'HR');

--
-- Installation script based on the examples in the Oracle docs at :
-- https://docs.oracle.com/en/database/oracle/apex/22.2/aeapi/Import-Script-Examples.html#GUID-3FA670B9-823F-4630-9E0E-29F3A61666F2
begin
    apex_application_install.set_workspace('SCRIPTED_WS');
    apex_application_install.generate_application_id; -- assign a new id
    apex_application_install.generate_offset; -- not sure what this does but in examples
end;    
/

-- The location of the Application Export on the client 
@/home/mike/Desktop/shared_folders/blog_code/apex_reports/apex22_hr_report_files_app.sql

-- Verify Workspace creation
select *
from apex_workspaces
where workspace = 'SCRIPTED_WS';

-- Verify application import
select *
from apex_applications
where workspace = 'SCRIPTED_WS';

-- verify page available
select *
from apex_application_pages
where workspace = 'SCRIPTED_WS'
and application_id = 102
and page_id = 1;