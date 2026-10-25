# Write your MySQL query statement below
with cte as 
(select book_id , 
count(session_id) as num_sess, 
max(session_rating) - min(session_rating) as rating_spread,
round(sum(case when session_rating <= 2 or session_rating >= 4
then 1 else 0 end) / count(session_id),2) as polarization_score,
sum(case when session_rating <= 2
then 1 else 0 end) as two_or_lower,
sum(case when session_rating >=4 
then 1 else 0 end) as four_or_more
from reading_sessions
group by book_id)

select b.*, cte.rating_spread, cte.polarization_score 
from cte
left join books as b
on cte.book_id = b.book_id
where cte.num_sess >= 5
and cte.four_or_more >= 1
and cte.two_or_lower >= 1
and cte.polarization_score >= 0.6
order by cte.polarization_score desc, b.title desc;