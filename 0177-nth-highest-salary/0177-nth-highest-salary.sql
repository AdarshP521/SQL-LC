CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
select max(case when rn=N then salary else null end) as SecondHighestsalary
        from (
            select salary
            , dense_rank() over(order by salary desc) as rn
            from employee) a

  );
END