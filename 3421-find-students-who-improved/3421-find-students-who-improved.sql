WITH FirstExam AS (
    SELECT student_id, subject, score AS first_score, exam_date
    FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY student_id, subject ORDER BY exam_date ASC) as rn
        FROM Scores
    ) t WHERE rn = 1
),
LatestExam AS (
    SELECT student_id, subject, score AS latest_score, exam_date
    FROM (
        SELECT *, ROW_NUMBER() OVER(PARTITION BY student_id, subject ORDER BY exam_date DESC) as rn
        FROM Scores
    ) t WHERE rn = 1
)
SELECT 
    f.student_id, 
    f.subject, 
    f.first_score, 
    l.latest_score
FROM FirstExam f
JOIN LatestExam l 
  ON f.student_id = l.student_id 
 AND f.subject = l.subject
WHERE l.latest_score > f.first_score
  AND f.exam_date < l.exam_date
ORDER BY f.student_id, f.subject;