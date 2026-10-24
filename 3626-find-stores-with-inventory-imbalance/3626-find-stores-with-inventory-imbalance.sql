with cte as 
(select *,
row_number() over(partition by store_id
order by price desc) as exp_rnk,
row_number() over(partition by store_id
order by price) as chp_rnk
from inventory),

cte2 as 
(select store_id, max(case when exp_rnk = 1
then product_name else null end) as most_exp_product,
max(case when chp_rnk = 1
then product_name else null end) as cheapest_product,
sum(case when exp_rnk = 1 then quantity else 0 end) as exp_q,
sum(case when chp_rnk = 1 then quantity else 0 end) as chp_q,
round(sum(case when chp_rnk = 1 then quantity else 0 end)/
sum(case when exp_rnk = 1 then quantity else 0 end),2) as imbalance_ratio
from cte 
group by store_id
having count(distinct product_name) >= 3)


select s.*, cte2.most_exp_product, cte2.cheapest_product, cte2.imbalance_ratio
from cte2
left join stores as s
on cte2.store_id = s.store_id
where exp_q < chp_q
order by cte2.imbalance_ratio desc, s.store_name;