with recursive cte as
(
    select employee_id, employee_name, manager_id, 1 as level
    from Employees
    where manager_id is null

    union

    select e.employee_id, e.employee_name, e.manager_id, c.level + 1
    from Employees as e
    inner join cte as c
    on e.manager_id = c.employee_id
),
cte2 as 
(
    select employee_id, employee_id as manager_id
    from Employees

    union

    select e.employee_id , c2.manager_id
    from cte2 as c2
    inner join Employees as e
    on c2.employee_id = e.manager_id
),

cte3 as
(select c1.employee_id, c1.employee_name, c1.level,
c2.manager_id , c2.employee_id as eid , e.salary
from cte as c1
inner join cte2 as c2
on c1.employee_id = c2.manager_id
inner join Employees as e
on c2.employee_id = e.employee_id)

select employee_id , employee_name , level, 
count(distinct case when employee_id <> eid
then eid else null end) as team_size, sum(salary)
as budget
from cte3
group by employee_id , employee_name , level
order by level , budget desc , employee_name;
















