with cte as (
select d.name as Department , e.name as Employee, e.salary
, rank() over(partition by e.departmentId order by e.salary desc) as rn
from employee e
inner join Department d on e.departmentId = d.id
)
select Department , Employee , salary
from cte
where rn=1

