--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select *
from product p 

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *, 
case 
when price > (select avg(price) from printer)
then 1
else 0
end more_then_avgprice
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select name from
(select name, class 
from ships s 
union
select ship, class
from outcomes o 
left join classes c 
on o.ship = c."class" 
where ship not in (select name from ships)) a
where class is null

--task16
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. (через with)

with launched_date as (SELECT distinct launched FROM ships)
select * from
(select name, cast(date as int) as date2 from
(SELECT name, TO_CHAR(date, 'YYYY') as date FROM battles b)  timer) a
WHERE date2 NOT IN (select launched from launched_date)

--task17
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.

select battle from battles b 
join outcomes o 
on b."name" = o.battle 
join ships s 
on s."name" = o.ship 
where class = 'Kongo'

-- ИЗ РАБОТЫ НА УРОКЕ
--task8 (lesson4)
-- Компьютерная фирма: Сделать view (название products_price_categories), в котором по всем продуктам нужно посчитать количество продуктов всего в зависимости от цены:
-- Если цена > 1000, то category_price = 2
-- Если цена < 1000 и цена > 500, то  category_price = 1
-- иначе category_price = 0
-- Вывести: category_price, count

create or replace view products_price_categories_second_stream as
select category_price, count(category_price)
from (select case 
when price > 1000 then 2
when price < 1000 and price > 500 then 1
else 0
end category_price
from all_product_info) a
group by category_price

select *
from products_price_categories_second_stream

--task9 (lesson4)
-- Сделать предыдущее задание, но дополнительно разбить еще по производителям (название products_price_categories_with_makers). Вывести: category_price, count, price

create or replace view products_price_categories_with_makers_second_stream as
select category_price, maker, count(category_price)
from (select case 
when price > 1000 then 2
when price < 1000 and price > 500 then 1
else 0
end category_price, maker
from all_product_info) a
group by category_price, maker
order by category_price, maker

select *
from products_price_categories_with_makers_second_stream

--task10 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по каждому производителю график (X: category_price, Y: count)

-- в python

--task11 (lesson4)
-- Компьютерная фирма: На базе products_price_categories_with_makers по строить по A & D график (X: category_price, Y: count)

-- в python

--task12 (lesson4)
-- Корабли: Сделать копию таблицы ships, но у название корабля не должно начинаться с буквы N (ships_without_n)

create table ships_without_n_second_stream as
select *
from ships s 
where name not like 'N%'

select *
from ships_without_n_second_stream

-- ДОМАШНЕЕ ЗАДАНИЕ
--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag

create or replace view all_products_flag_300_second_stream as
select model, price, 
case 
when price > 300
then 1
else 0
end flag
from (
select model, price from pc
union
select model, price from printer
union
select model, price from laptop
) a


--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag

create or replace view all_products_flag_avg_price_second_stream as
select model, price, 
case 
when price > (select avg(price) from all_products_flag_300_second_stream)
then 1
else 0
end flag
from (
select model, price from pc
union all
select model, price from printer
union all
select model, price from laptop
) a

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

drop table all_product_info

create table all_product_info as
select a.model, price, maker, p.type
from (
select model, price from pc
union all
select model, price from printer
union all
select model, price from laptop
) a
join product p
on a.model = p.model 

select *
from all_product_info 

select model 
from all_product_info
where price > (select avg(price)
from all_product_info
where maker in ('D', 'C')
and type = 'Printer')
and maker = 'A'
and type = 'Printer'


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

select model 
from all_product_info
where price > (select avg(price)
from all_product_info
where maker in ('D', 'C')
and type = 'Printer')
and maker = 'A'

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)

create table unique_product_info as
select a.model, price, maker, p.type
from (
select model, price from (select distinct * from pc) p2
union
select model, price from (select distinct * from printer) p3
union
select model, price from (select distinct * from laptop) l
) a
join product p
on a.model = p.model 

select avg(price)
from all_product_info
where maker = 'A'

--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

drop view  count_products_by_makers_second_stream

create or replace view count_products_by_makers_second_stream as
select maker, count(maker)
from all_product_info
group by maker

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

-- в python

--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

drop table printer_updated_second_stream

create table printer_updated_second_stream as
table printer

DELETE FROM printer_updated_second_stream 
where model in (select model
from product p 
where type = 'Printer'
and maker = 'D')

select *
from printer_updated_second_stream

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

create or replace view printer_updated_with_makers_decond_stream as
select code, a.model, color, a.type, price, maker
from printer_updated_second_stream a
join product b 
on a.model = b.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

drop view sunk_ships_by_classes_second_stream

create or replace view sunk_ships_by_classes_second_stream as
select classname, count(classname)
from (select case 
when class is null
then '0'
else class
end classname
from outcomes s 
left outer join ships s2
on s.ship = s2."name") a
group by classname

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

-- python

--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0

drop table classes_with_flag_second_stream

create table classes_with_flag_second_stream as
select *, case
when numguns >= 9
then 1
else 0
end flag
from classes c 

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

-- python

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

select count(ship)
from (select ship
from outcomes
union
select name as ship
from ships) a
where ship like 'O%' or ship like 'M%'

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

select count(ship)
from (select ship
from outcomes
union
select name as ship
from ships) a
where ship like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)

-- python
