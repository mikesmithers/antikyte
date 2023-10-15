create table departments
(
    department_id number not null,
    department_name varchar2(30) not null,
    manager_id number,
    location_id number,
    constraint departments_pk primary key ( department_id)
)
/

create table jobs
(
    JOB_ID varchar2(10) not null,
    JOB_TITLE varchar2(35) not null,
    MIN_SALARY number,
    MAX_SALARY number,
    constraint jobs_pk primary key( job_id)
)
/