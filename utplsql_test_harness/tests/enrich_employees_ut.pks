create or replace package enrich_employees_ut
as
    --%suite(enrich_employees_ut)
    --%rollback(Manual)
    
    --%test( Department Lookup Succeeds)
    procedure department_is_found;
    
    --%test( Department does not exist)
    procedure department_not_found;
    
    --%test( Department ID is null)
    procedure department_is_null;
    
    --%test( Status is not PROCESS)
    procedure status_not_process;
    
    --%test( Job Lookup Succeeds)
    procedure job_is_found;
    
    --%test( Job does not exist)
    procedure job_not_found;
    
    --%test( Job ID is null)
    procedure job_is_null;
    
end enrich_employees_ut;
