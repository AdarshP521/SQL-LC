with cte1 as(
    select
        *,
        coalesce(
            datediff(action_date,
                    lag(action_date) over(
                        partition by user_id,action 
                        order by action_date)
                    ), 
            1) as date_diff,
        count(*) over(partition by user_id, action_date) as one_day_action_cnt
    from activity
),
cte2 as (
    select
    user_id,
    action,
    sum(date_diff) as streak_length,
    row_number() over(
        partition by user_id 
        order by sum(date_diff) desc
        ) as rnk,
    min(action_date) as start_date,
    max(action_date) as end_date
from cte1
where date_diff = 1
    and one_day_action_cnt = 1
group by user_id, action
having count(*) >= 5
)
select
    user_id,
    action,
    streak_length,
    start_date,
    end_date
from cte2
where rnk = 1
order by streak_length desc, user_id asc
