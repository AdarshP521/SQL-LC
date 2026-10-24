with cte as 
(select user_id,
count(prompt) as prompt_count,
round(sum(tokens)/count(prompt),2) as avg_tokens
from prompts
group by user_id
having count(prompt) >= 3)

select distinct p.user_id, cte.prompt_count, cte.avg_tokens
from prompts as p 
inner join cte
on p.user_id = cte.user_id
where p.tokens > cte.avg_tokens
order by cte.avg_tokens desc, p.user_id;

