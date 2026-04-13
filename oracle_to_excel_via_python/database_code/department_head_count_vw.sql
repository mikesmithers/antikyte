create or replace view department_head_count_vw
as
select d.department_name, count(e.employee_id) as head_count
from departments d
left outer join employees e
    on d.department_id = e.department_id 
group by d.department_name 
/