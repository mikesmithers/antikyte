create or replace view company_directory_vw 
as
select 
    e.employee_id, e.first_name, e.last_name, e.email, e.phone_number,
        j.job_title,
        m.first_name||' '||m.last_name as manager,
        d.department_name,
        case when d.manager_id = e.employee_id then 'Y' else null end as department_manager,
        l.city,
        c.country_name
from employees e
left outer join jobs j
    on e.job_id = j.job_id
left outer join employees m
    on e.manager_id = m.employee_id
left outer join departments d
    on e.department_id = d.department_id 
left outer join locations l 
    on d.location_id = l.location_id 
left outer join countries c
    on l.country_id = c.country_id 
order by case when d.department_id = 90 then 1 else d.department_id end,
    case when d.manager_id = e.employee_id then 1 else 2 end,
    e.last_name, e.first_name
/
