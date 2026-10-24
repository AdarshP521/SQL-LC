with cte as 
(select customer_id, 
sum(case when transaction_type = 'purchase' then 1 else 0 end)
as num_p,
sum(case when transaction_type = 'refund' then 1 else 0 end)/count(distinct
transaction_id) as refund_rate,
datediff(max(transaction_date),
min(transaction_date)) as active_days
from customer_transactions
group by customer_id)

select customer_id
from cte
where num_p >= 3
and active_days >= 30
and refund_rate < 0.2
order by customer_id;