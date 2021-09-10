--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

with help_table as (select name, grade, marks
from Students S
inner join Grades G
on S.Marks between G.Min_Mark and G.Max_Mark)
select *
from (select *
from help_table
where grade > 7
union
select NULL as name, grade, marks
from help_table
where grade < 8)
order by grade desc, name, marks;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select Doctor, Professor, Singer, Actor from
(select row_number() over(order by name) as id, name
from OCCUPATIONS) a
full outer join
(select row_number() over(order by name) as id, name as Doctor
from OCCUPATIONS
where occupation = 'Doctor') b
on a.id=b.id
full outer join
(select row_number() over(order by name) as id, name as Professor
from OCCUPATIONS
where occupation = 'Professor') c
on a.id=c.id
full outer join
(select row_number() over(order by name) as id, name as Singer
from OCCUPATIONS
where occupation = 'Singer') d
on a.id=d.id
full outer join
(select row_number() over(order by name) as id, name as Actor
from OCCUPATIONS
where occupation = 'Actor') e
on a.id=e.id
where Professor is not null;

--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city
from station
where city not like 'A%' and
city not like 'E%' and
city not like 'I%' and
city not like 'O%' and
city not like 'U%';

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where city not like '%a' and
city not like '%e' and
city not like '%i' and
city not like '%o' and
city not like '%u';

--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city from station
where city not in (select * from (select city
from station
where city like 'A%' or
city like 'E%' or
city like 'I%' or
city like 'O%' or
city like 'U%')
where city like '%a' or
city like '%e' or
city like '%i' or
city like '%o' or
city like '%u');

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city
from station
where city not like 'A%' and
city not like 'E%' and
city not like 'I%' and
city not like 'O%' and
city not like 'U%' and
city not like '%a' and
city not like '%e' and
city not like '%i' and
city not like '%o' and
city not like '%u';

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name
from Employee 
where salary > 2000
and months < 10;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
-- тодк что и 1 задание

with help_table as (select name, grade, marks
from Students S
inner join Grades G
on S.Marks between G.Min_Mark and G.Max_Mark)
select *
from (select *
from help_table
where grade > 7
union
select NULL as name, grade, marks
from help_table
where grade < 8)
order by grade desc, name, marks;