--task1 (lesson8)
Ч oracle: https://leetcode.com/problems/department-top-three-sa..

with full_info as (select D.Name as Department, E.Name as Employee, Salary
from Employee E
join Department D
on E.DepartmentId=D.Id)
select fi.Department, Employee, fi.Salary
from full_info fi
join (select Department, Salary from
(select * from
(select Department, Salary, row_number() over(partition by Department order by Salary desc) as rank from (select distinct Department, Salary from full_info)) where rank<=3)) list
on fi.Salary=list.Salary and fi.Department=list.Department
order by Department, Salary desc

--task2 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/17

select member_name, status, sum(costs) as costs from
(select member_name, status, unit_price*amount as costs, date
from FamilyMembers FM
join Payments P
on FM.member_id=P.family_member
where YEAR(date)=2005) a
group by member_name, status

--task3 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/13

select name from (select name, count(name) as count  
from Passenger
group by name
having count > 1) a
where name in
(select name
from Passenger P
LEFT JOIN Pass_in_trip PIT
on P.id=PIT.passenger)

--task4 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count from
(select first_name, class FROM Student S
join Student_in_class SIC
on S.id=SIC.student) S2
join Class C
on S2.class = C.id
where first_name = 'Anna'

--task5 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/35

select count(classes) as count from
(select distinct classroom as classes
from Schedule
where date='2019-09-02') a

--task6 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/38

ѕовтор€етс€

--task7 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/32

select (age-age%1) as age from
(SELECT avg(2021-YEAR(birthday)) as age
from FamilyMembers) a

--task8 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/27

select good_type_name, costs from
(select sum((amount*unit_price)) as costs, type
from Payments P
join Goods G
on P.good=G.good_id
where YEAR(date)=2005
group by type) a
join GoodTypes GT
on a.type=GT.good_type_id

--task9 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/37

select year - year%1 as year from
(select min(datediff(date('2021-09-05'), birthday)/365) as year
from Student) a

--task10 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/44

select year - year%1 as max_year from
(select max(datediff(date('2021-09-05'), birthday)/365) as year
from Student
where id in 
(select student
from Student_in_class SIC
join Class C 
on SIC.class=C.id
where name like '%10%')
) a

--task11 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/20

select status, member_name, sum(amount*unit_price) as costs
from Payments P
join FamilyMembers FM
on P.family_member=FM.member_id
where good in (select good_id
from Goods G
join GoodTypes GT
on G.type=GT.good_type_id
where good_type_name='entertainment')
group by family_member


--task12 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/55

with trip_counter as (select company, count(id) as count
from Trip
group by Company)
delete from Company where id in (select company from
trip_counter where count in (select min(count) from trip_counter))

--task13 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/45

with class_count as (select classroom, count(classroom) as count
from Schedule
group by classroom)
select classroom
from class_count
where count in (select max(count) from class_count)

--task14 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/43

select distinct last_name
from Teacher T
join Schedule s
on T.id = S.teacher
where subject in (select id from Subject where name = 'Physical Culture')
order by last_name

--task15 (lesson8)
Ч https://sql-academy.org/ru/trainer/tasks/63

select CONCAT(last_name, '.', LEFT(first_name, 1), '.', LEFT(middle_name, 1), '.') as name
from Student
order by last_name
