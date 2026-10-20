with cte as
(select user_id, session_id, timestampdiff(minute,
min(event_timestamp), max(event_timestamp)) as ses_dur,
sum(case when event_type = 'scroll'
then 1 else 0 end)
as num_scroll, sum(case when event_type = 'click'
then 1 else 0 end) / sum(case when event_type = 'scroll'
then 1 else 0 end) as click_to_scroll,
sum(case when event_type = 'purchase'
then 1 else 0 end) as num_p
from app_events
group by user_id, session_id)

select session_id, user_id, ses_dur as session_duration_minutes ,
num_scroll as scroll_count 
from cte 
where ses_dur > 30
and num_scroll >= 5
and click_to_scroll < 0.20
and num_p = 0

order by scroll_count desc , session_id;
