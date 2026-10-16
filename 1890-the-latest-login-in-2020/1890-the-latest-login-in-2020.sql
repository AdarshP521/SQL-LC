select distinct user_id , first_value(time_stamp)
over(partition by user_id order by
time_stamp desc) as last_stamp
from Logins
where year(time_stamp) = '2020'

