--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.


with sunks as (select ship from outcomes where result = 'sunk')
select class, count(ship) as count_of_sunk
from ships s 
left join sunks o
on s."name" = o.ship 
group by class

--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.


select c.class, launched
from ships s 
right join classes c 
on c."class" = s."class" 
where c."class" = name
union all
select c.class, min(launched)
from ships s 
right join classes c 
on c."class" = s."class" 
where c."class" != all (select name from ships)
group by c."class" 

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.


with 
a as (select class, count(result) as count_sunk
from ships s 
join (select * from outcomes where result = 'sunk') o 
on s."name" = o.ship 
group by class)
select *
from a
where class in (select class
from
(select class, count(name) as count_ships
from ships
group by class) a
where count_ships >= 3 and class in
(select class
from ships s
join outcomes o 
on s."name" = o.ship 
where result = 'sunk'))

--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

select name from
(select name, numguns, displacement
from ships s 
join classes c 
on s."class" = c."class"
union 
select ship as name, numguns, displacement
from outcomes o 
join classes c2 
on o.ship = c2."class" 
where ship not in (select name from ships)
) one
inner join
(select max(numguns) as maxnumguns, displacement
from classes c 
group by displacement) two
on one.numguns = two.maxnumguns
and one.displacement = two.displacement

--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

select maker from
(select maker, ram, speed
from pc p 
join product p2 
on p.model = p2.model) a
right join
(select ram, speed from
(select min(ram) as minram
from pc p) one
left join
(select ram, max(speed) as speed
from pc p 
group by ram) two
on one.minram = two.ram) b
on a.ram = b.ram
and a.speed = b.speed

