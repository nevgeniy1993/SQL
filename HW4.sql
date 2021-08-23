--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--������������ �����: ������� ������ ���� ��������� � ������������� � ��������� ���� �������� (pc, printer, laptop). �������: model, maker, type

select *
from product p 

--task14 (lesson3)
--������������ �����: ��� ������ ���� �������� �� ������� printer ������������� ������� ��� ���, � ���� ���� ����� ������� PC - "1", � ��������� - "0"

select *, 
case 
when price > (select avg(price) from printer)
then 1
else 0
end more_then_avgprice
from printer

--task15 (lesson3)
--�������: ������� ������ ��������, � ������� class ����������� (IS NULL)

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
--�������: ������� ��������, ������� ��������� � ����, �� ����������� �� � ����� �� ����� ������ �������� �� ����. (����� with)

with launched_date as (SELECT distinct launched FROM ships)
select * from
(select name, cast(date as int) as date2 from
(SELECT name, TO_CHAR(date, 'YYYY') as date FROM battles b)  timer) a
WHERE date2 NOT IN (select launched from launched_date)

--task17
--�������: ������� ��������, � ������� ����������� ������� ������ Kongo �� ������� Ships.

select battle from battles b 
join outcomes o 
on b."name" = o.battle 
join ships s 
on s."name" = o.ship 
where class = 'Kongo'

-- �� ������ �� �����
--task8 (lesson4)
-- ������������ �����: ������� view (�������� products_price_categories), � ������� �� ���� ��������� ����� ��������� ���������� ��������� ����� � ����������� �� ����:
-- ���� ���� > 1000, �� category_price = 2
-- ���� ���� < 1000 � ���� > 500, ��  category_price = 1
-- ����� category_price = 0
-- �������: category_price, count

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
-- ������� ���������� �������, �� ������������� ������� ��� �� �������������� (�������� products_price_categories_with_makers). �������: category_price, count, price

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
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� ������� ������������� ������ (X: category_price, Y: count)

-- � python

--task11 (lesson4)
-- ������������ �����: �� ���� products_price_categories_with_makers �� ������� �� A & D ������ (X: category_price, Y: count)

-- � python

--task12 (lesson4)
-- �������: ������� ����� ������� ships, �� � �������� ������� �� ������ ���������� � ����� N (ships_without_n)

create table ships_without_n_second_stream as
select *
from ships s 
where name not like 'N%'

select *
from ships_without_n_second_stream

-- �������� �������
--task1  (lesson4)
-- ������������ �����: ������� view (�������� all_products_flag_300) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ > 300. �� view ��� �������: model, price, flag

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
-- ������������ �����: ������� view (�������� all_products_flag_avg_price) ��� ���� ������� (pc, printer, laptop) � ������, ���� ��������� ������ c������ . �� view ��� �������: model, price, flag

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
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

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
-- ������������ �����: ������� ��� ������ ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'D' � 'C'. ������� model

select model 
from all_product_info
where price > (select avg(price)
from all_product_info
where maker in ('D', 'C')
and type = 'Printer')
and maker = 'A'

--task5 (lesson4)
-- ������������ �����: ����� ������� ���� ����� ���������� ��������� ������������� = 'A' (printer & laptop & pc)

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
-- ������������ �����: ������� view � ����������� ������� (�������� count_products_by_makers) �� ������� �������������. �� view: maker, count

drop view  count_products_by_makers_second_stream

create or replace view count_products_by_makers_second_stream as
select maker, count(maker)
from all_product_info
group by maker

--task7 (lesson4)
-- �� ����������� view (count_products_by_makers) ������� ������ � colab (X: maker, y: count)

-- � python

--task8 (lesson4)
-- ������������ �����: ������� ����� ������� printer (�������� printer_updated) � ������� �� ��� ��� �������� ������������� 'D'

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
-- ������������ �����: ������� �� ���� ������� (printer_updated) view � �������������� �������� ������������� (�������� printer_updated_with_makers)

create or replace view printer_updated_with_makers_decond_stream as
select code, a.model, color, a.type, price, maker
from printer_updated_second_stream a
join product b 
on a.model = b.model

--task10 (lesson4)
-- �������: ������� view c ����������� ����������� �������� � ������� ������� (�������� sunk_ships_by_classes). �� view: count, class (���� �������� ������ ���/IS NULL, �� �������� �� 0)

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
-- �������: �� ����������� view (sunk_ships_by_classes) ������� ������ � colab (X: class, Y: count)

-- python

--task12 (lesson4)
-- �������: ������� ����� ������� classes (�������� classes_with_flag) � �������� � ��� flag: ���� ���������� ������ ������ ��� ����� 9 - �� 1, ����� 0

drop table classes_with_flag_second_stream

create table classes_with_flag_second_stream as
select *, case
when numguns >= 9
then 1
else 0
end flag
from classes c 

--task13 (lesson4)
-- �������: ������� ������ � colab �� ������� classes � ����������� ������� �� ������� (X: country, Y: count)

-- python

--task14 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ���������� � ����� "O" ��� "M".

select count(ship)
from (select ship
from outcomes
union
select name as ship
from ships) a
where ship like 'O%' or ship like 'M%'

--task15 (lesson4)
-- �������: ������� ���������� ��������, � ������� �������� ������� �� ���� ����.

select count(ship)
from (select ship
from outcomes
union
select name as ship
from ships) a
where ship like '% %'

--task16 (lesson4)
-- �������: ��������� ������ � ����������� ���������� �� ���� �������� � ����� ������� (X: year, Y: count)

-- python
