--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--������� 1: ������� name, class �� ��������, ���������� ����� 1920

select *
from ships
where launched > 1920

--������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942

select *
from ships
where launched > 1920 and launched <= 1942

--������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class

select count(class), class
from ships
group by class

--������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)

select distinct c."class", country
from classes c
join ships s
on c.class = s.class
where bore >= 16

--������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.

select distinct ship
from Outcomes
where result = 'sunk'

--������� 6: ������� �������� (ship) ���������� ������������ �������


select ship
from outcomes o 
join battles s 
on o.battle = s.name
where date = (select max(date)
from outcomes o
join battles b 
on o.battle = b."name") 
and result = 'sunk'



--������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
-- �.�. �� ��������� ����������� �������� ����������� �����, � ������ ������� ���� ���� ���������� ���� ���������� ������������ �������, �������� �����.


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

-- ������ ������� ������� ������ ��� ����� ���� ��������� ����������� �������� � � �������� � ���, ��� � ��� ���� ������

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

--������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class

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

--������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class

select distinct class
from classes c 
where country = 'USA'

--������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class

select distinct name, s.class
from classes c 
join ships s 
on c."class" = s."class" 
where country = 'USA'


