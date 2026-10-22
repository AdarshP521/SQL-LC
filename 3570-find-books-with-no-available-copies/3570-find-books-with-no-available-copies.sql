with cte as
(select book_id, count(distinct record_id) as num_b
from borrowing_records
where return_date is null
group by book_id)
select b.book_id, b.title, b.author, b.genre, b.publication_year,
c.num_b as current_borrowers
from library_books as b
left join cte as c
on b.book_id = c.book_id
where b.total_copies - c.num_b = 0
order by current_borrowers desc, b.title;