# Write your MySQL query statement below
with cte as (
    select employee_id, review_date, rating, row_number() over(partition by employee_id order by review_date desc) as rn, count(*) over(partition by employee_id) as cnt
    from performance_reviews 
),
cte2 as
(select employee_id, review_date, rating, rn
from cte
where rn<=3 and cnt>=3
order by employee_id, review_date desc),
cte3 as(
    select a.employee_id, a.rating as r1, b.rating as r2, c.rating as r3
    from cte2 a
    join cte2 b on a.employee_id=b.employee_id and a.rn+1=b.rn
    join cte2 c on a.employee_id=c.employee_id and a.rn+2=c.rn
)
select a.employee_id, name, r1-r3 as improvement_score
from cte3 a
join employees b
on a.employee_id=b.employee_id
where r1>r2 and r2>r3
order by r1-r3 desc, name