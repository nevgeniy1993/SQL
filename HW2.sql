--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--Задание 1: Вывести name, class по кораблям, выпущенным после 1920

select *
from ships
where launched > 1920

--Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942

select *
from ships
where launched > 1920 and launched <= 1942

--Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class

select count(class), class
from ships
group by class

--Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)

select distinct c."class", country
from classes c
join ships s
on c.class = s.class
where bore >= 16

--Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.

select distinct ship
from Outcomes
where result = 'sunk'

--Задание 6: Вывести название (ship) последнего потопленного корабля


select ship
from outcomes o 
join battles s 
on o.battle = s.name
where date = (select max(date)
from outcomes o
join battles b 
on o.battle = b."name") 
and result = 'sunk'



--Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
-- т.к. по последним потопленным кораблям отсутствует класс, в данном запросе мною была обнаружена дата последнего потопленного корабля, имеющего класс.


select ship, class
from ships s2
join outcomes o3 
on s2."name" = o3.ship 
where ship in (select ship
from outcomes o 
join battles s 
on o.battle = s.name
where date = (select max(date)
from outcomes o2 
join battles b 
on o2.battle = b."name" 
where ship in (select ship
from outcomes o 
join ships s 
on s."name" = o.ship) and result='sunk') 
and result = 'sunk')

-- второй вариант решения задачи это вывод всех последний потопленных кораблей и с отметкой о том, что у них нету класса

select ship, class 
from ships s 
right join outcomes o 
on s."name" = o.ship 
where ship in
(select ship
from outcomes o 
join battles s 
on o.battle = s.name
where date = (select max(date)
from outcomes o
join battles b 
on o.battle = b."name") 
and result = 'sunk')

--Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class

select ship, class 
from ships s 
right join outcomes o 
on s."name" = o.ship 
where ship in
(select ship
from battles b 
join outcomes o 
on b."name" = o.battle 
where ship in (select name
from ships s 
join classes c 
on s."class" = c."class" 
where bore >= 16) and result = 'sunk')

--Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class

select distinct class
from classes c 
where country = 'USA'

--Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select distinct name, s.class
from classes c 
join ships s 
on c."class" = s."class" 
where country = 'USA'


