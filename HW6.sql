--task5  (lesson6)
-- ������������ �����: ������� ������� all_products_with_index_task5 ��� ����������� ���� ������ �� ����� code (union all) � ������� ���� (flag) �� ���� > ������������ �� ��������. ����� �������� ��������� (����� ������� �������) �� ������ ��������� �������� � ������� ����������� ���� (price_index). �� ����� price_index ������� ������

drop table all_products_with_index_task5_second_stream

create table all_products_with_index_task5_second_stream as
select *, 
case when price > (select distinct max(price) from printer p4) then 1 else 0 end flag,
row_number() over(order by price) price_index
from
(select p2.model, maker, price, p2.type
from pc p 
join product p2 
on p.model = p2.model 
union all 
select p2.model, maker, price, p2.type
from printer p3 
join product p2 
on p3.model = p2.model 
union all 
select p2.model, maker, price, p2.type
from laptop l 
join product p2 
on l.model = p2.model) a
order by price

CREATE UNIQUE INDEX title_idx ON all_products_with_index_task5_second_stream (price_index);
