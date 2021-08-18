--СЃС…РµРјР° Р‘Р”: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing


--task1
--Компьютерная фирма: Найдите среднюю цену всех устройств, сгруппированую по производителям. 
--Вывод: цена, производитель


select maker, avg(price)
from
(
		select maker, price 
		from PC 
		join product
		on pc.model = product.model 
	union all
		select maker, price 
		from printer 
		join product
		on printer.model = product.model 
	union all
		select maker, price 
		from laptop 
		join product
		on laptop.model = product.model
)  a
group by maker


--task2
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL).


select flag_price_500, count(*) from 
(

select *,
case 
	when price > 500
	then 1 
	else 0 
end flag_price_500
from product 
join pc 
on product.model = pc.model 
) t1
group by flag_price_500


--task3
--Компьютерная фирма: Найти поставщиков/производителей компьютеров, моделей которых нет в продаже (то есть модели этих поставщиков отсутствуют в таблице PC)

select distinct maker 
from product 
where maker not in 
(
	select maker 
	from product 
	where type = 'PC' 
	and model not in (
		select model 
		from pc
	)
)

--task4
--Компьютерная фирма: Найти модели и цены портативных компьютеров, стоимость которых превышает стоимость любого ПК

select model, price
from laptop 
where price > all(select price from pc)


--task5 +++
--Компьютерная фирма: Найдите номер модели продукта (ПК, ПК-блокнота или принтера), имеющего самую высокую цену. Вывести: model

select model
from 
(
	select model, price from pc 
	union all
	select model, price from printer 
	union all
	select model, price from laptop 
) a 
order by price desc
limit 1

select 1 + 2 as variable 





--task6
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена больше 300 - "1", у остальных - "0"


select *,
case 
	when price > 300 then 1
	else 0
end flag
from printer

--task7
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней - "1", у остальных - "0"

select *,
case 
	when price > (select AVG(price) from printer)
	then 1
	else 0
end flag
from printer



--task9
--Компьютерная фирма: Вывести список всех уникальных PC и производителя с ценой выше хотя бы одного принтера. Вывод: model, maker

select * 
from pc
join product 
on pc.model = product.model
where price > any (select price from printer)


select * 
from pc
join product 
on pc.model = product.model
where price > (select min(price) from printer)



--task10
--Компьютерная фирма: Вывести список всех уникальных продуктов и производителя в рамках БД. Вывести model, maker


select distinct * from (
select product.model, product.maker 
from product join laptop on product.model = laptop.model 
union 
select product.model, product.maker 
from product join pc on product.model = pc.model 
union 
select product.model, product.maker 
from product join printer on product.model = printer.model 
) a 



--task11
--Корабли: Вывести список всех кораблей и класс. Для тех у кого нет класса - вывести 0, для остальных - class


select  name, launched, 
case 
	when class is null
	then '0' 
	else class
end "class"
from ships



--task12
--Корабли: Для каждого класса определить год, когда был спущен на воду первый корабль этого класса. Вывести: класс, год



select ships.class, min(launched)
from ships 
group by ships.class



--task13
--Компьютерная фирма: Вывести список всех продуктов и происзводителя с указанием типа продукта (pc, printer, laptpo). Вывести: model, maker, type

select product.model, product.maker, product.type 
from product join laptop on product.model = laptop.model 
union 
select product.model, product.maker, product.type 
from product join pc on product.model = pc.model 
union 
select product.model, product.maker, product.type
from product join printer on product.model = printer.model

--task14
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *, 
case 
	when price > (select avg(price) from pc)
	then 1 
	else 0
end flag 
from printer


--task15
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

select * 
from ships 
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

--task18
--

--task19
--

--task20
--

--task21
--

--task22
--

--task23
--

--task24
--

--task25
--

--task26
--

