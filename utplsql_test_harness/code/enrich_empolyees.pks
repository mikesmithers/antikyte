create or replace package enrich_employees 
is
    procedure department_details( i_load_id in number);
    procedure job_details( i_load_id in number);
end;
/