drop table employees_core;
create table employees_core
(
    -- Columns populated by initial load
    load_id number not null,
    employee_id number not null,
    first_name varchar2(20),
    last_name varchar2(25),
    email varchar2(25),
    phone_number varchar2(20),
    hire_date date,
    job_id varchar2(10),
    salary number,
    commission_pct number,
    manager_id number,
    department_id number,
    -- Additional columns populated as part of enrichment process
    -- Job details
    job_title varchar2(50),
    -- Department Details
    department_name varchar2(50),
    -- Enrichment status
    record_status varchar2(25),
    constraint employees_core_pk primary key (load_id, employee_id)
)
/

