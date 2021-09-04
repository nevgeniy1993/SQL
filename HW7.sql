--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/

select Email from
(select Email, count(Email)
from Person
having count(Email)>1
group by Email)

--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

with a as (select Name, Salary, ManagerId
from Employee
where ManagerId is not null), 
b as (select Id, Salary as man_salary
from Employee
where ManagerId is null)
Select Name as Employee 
from a
join b
on a.ManagerId=b.Id
where Salary > man_salary


--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/

with a as (select Score
from Scores),
b as (select Score as b_Score, row_number() over(order by Score desc) as Rank
from (select distinct Score from Scores))
select Score, Rank from
(select * from a left join b on a.Score=b.b_Score)
order by Score desc

--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/

select FirstName, LastName, City, State
from Person
left join Address
on Person.PersonId = Address.PersonId