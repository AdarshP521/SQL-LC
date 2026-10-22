with cte as 
(select * , row_number()
over(partition by patient_id,
result order by test_date) as rnk1
from covid_tests),

cte2 as
(select c1.patient_id, row_number()
over(partition by c1.patient_id order by 
c2.test_date) as rnk2, 
datediff(c2.test_date, c1.test_date) as recovery_time
from cte as c1
left join cte as c2
on c1.patient_id = c2.patient_id 
and c1.test_date < c2.test_date
where c1.result = 'Positive'
and c1.rnk1 = 1
and c2.result = 'Negative')

select c.patient_id, p.patient_name, p.age, c.recovery_time
from cte2 as c
left join patients as p 
on c.patient_id = p.patient_id 
where c.rnk2 = 1
order by c.recovery_time, p.patient_name;