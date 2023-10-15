exec dbms_session.modify_package_state(dbms_session.reinitialize);
clear screen
set serveroutput on size unlimited
exec ut.run('enrich_employees_ut');