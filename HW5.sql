--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- � ������ �� �����

--task10 (lesson5)
-- ������������ �����: ��� ������� ������������� ������� �� ��� ����� ������� ���������� � ��������� view (products_with_lowest_price).

create view products_with_lowest_price_second_stream as
select * from
(select *, row_number() over(partition by type order by price) as rank
from all_product_info_second_stream) a
where rank in (1, 2, 3)

--task11 (lesson5)
-- ������������ �����: ��������� ������ � �� ������� � ������������ ������ �� ���� products_with_lowest_price (X: maker, Y1: max_price, Y2: avg_price

select distinct maker, max(price) over(partition by maker) as max_price, avg(price) over(partition by maker) as avg_price
from products_with_lowest_price_second_stream

--task12 (lesson5)
-- ������������ �����: ������� view, � ������� ����� ������������ �������� ���� laptop (�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������

select *,
case when page_number%2=0 then page_number/2 else cast(page_number/2 as int)+1 end page_num,
case when total%2=0 then total/2 else cast(total/2 as int)+1 end page_total
from (select *, row_number() over() as page_number, count(*) over() as total
from laptop) a

-- �������� ������
--task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products), � ������� ����� ������������ �������� ���� ��������� (�� ����� ���� ��������� �� ����� ��������). �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������

drop view pages_all_products_second_stream

create pages_all_products_second_stream as

select *, ROW_NUMBER() over(PARTITION by type) as page
from product

--task2 (lesson5)
-- ������������ �����: ������� view (distribution_by_type), � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������. �����: �������������,

drop view distribution_by_type_second_stream

create or replace view distribution_by_type_second_stream as
select *
from (select type, count_by_type*1.00/count_all as type_percent
from(select *, count(type) over() as count_all, count(type) over(partition by type) as count_by_type
from product) a) b
group by type, type_percent

--task3 (lesson5)
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������

-- python

--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� � �������� ������� ������ �������� �� ���� ����

create table ships_two_words_second_stream as
select *
from ships s 
where name like '% %'

--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"

select *
from ((select ss.name, class
from (select name from ships s 
union all
select ship as name from outcomes o) ss
left join ships ss2 on ss.name = ss2."name")
union 
(select ship as name, class
from outcomes o2
join classes c
on o2.ship=c."class" 
where o2.ship not in (select name from ships))) a
where class is null and name like ('S%')

--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A' �� ���������� ���� ������� �� ��������� ������������� = 'C' � ��� ����� ������� (����� ������� �������). ������� model

with help as (select p.model, maker, price, avg(price) over(partition by maker) as avgprice, row_number() over(order by price DESC) as pricerank
from printer p 
join product p2 
on p.model = p2.model)
select model from help
where pricerank < 4
and maker = 'A'
and price > all(select avgprice from help where maker = 'C')
