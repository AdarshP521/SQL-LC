with top_perf as 
(select user_id
from course_completions
group by user_id
having count(distinct course_id) >= 5
and avg(course_rating) >= 4),

course_info as 
(select *, 
lead(course_name,1)
over(partition by user_id
order by completion_date) as second_course
from course_completions
where user_id in (select user_id from top_perf))

select course_name as first_course, second_course,
count(distinct user_id) as transition_count
from course_info 
where second_course is not null
group by course_name , second_course
order by transition_count desc, first_course, second_course;