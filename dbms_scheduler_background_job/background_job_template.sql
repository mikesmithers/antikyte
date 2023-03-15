declare
    stmnt_block varchar2(4000);
begin
    -- Replace <statement block> with the PL/SQL block you want to run.
    -- For example :
    -- begin
    --     long_runner.marathon( 30, 'Teddy for PM!');
    -- end;
    
    stmnt_block := q'[ <statement_block>]';
         
    -- Replace <job_name> with the name you want to assign to the job
    dbms_scheduler.create_job(
        job_name => '<job_name>',
        job_type => 'PLSQL_BLOCK',
        job_action => stmnt_block,
        start_date => sysdate, -- run now
        enabled => true,
        auto_drop => true,
        comments => null);
end;
/