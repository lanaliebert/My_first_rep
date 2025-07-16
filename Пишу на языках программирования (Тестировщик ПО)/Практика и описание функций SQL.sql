--выбрать столбец из таблицы
select <столбцы>
from <таблица>

--выбрать все из таблицы
select *
from <таблица>

--выбрать все из таблицы "employees"
select *
from employees e 

--выбрать несколько столбцов из таблицы "employees"
select last_name, first_name 
from employees e 

--выбрать столбцы по короткому имени из таблицы "employees"
select e.last_name, e.first_name 
from employees e 

select pg_typeof(1::bigint) --поменять тип числа

select 1.0546876879::numeric(5,3) --поменять сколько знаков после запятой. первое число это сколько символов в целом, 
-- а второе это сколько знаков после запятой 

--создать вычислимый столбец
select product_name, unit_price * units_in_stock 
from products

--создать вычислимый столбец и дать ему имя
select product_name, unit_price * units_in_stock as expected_revenue
from products 

select *
from products p 
--с условием: цена больше 20 и меньше 30. Тут от себя еще добавила прикол со скобками, они влияют на результат
where unit_price > 20 and unit_price < 30 and (units_in_stock > 100
or category_id = 7)


select *
from products p 
--с условием: цена больше или равна 20 и меньше или равна 30 
where unit_price between 20 and 30
--оператор and позволяет группировать условия
and units_in_stock > 50


select * 
from products p 
where unit_price between 20 and 30
--оператор or задает необязательное условие
or units_in_stock > 100

select *
from employees e 
--оставить строки, где нет пропусков в столбце region
where region is not null


select *
from employees e 
--оставить строки, где есть пропуски в столбце region
where region is null


select *
from employees e 
where region is true

select *
from products p
--оператор in проверяет значения по списку
where supplier_id in (1, 2, 3)

select *
from products p
where supplier_id = 1 or supplier_id = 2 or supplier_id = 3
--можно так записатьи будет тоже самое что и с in

select *
from products p  
where product_id in (
    select product_id 
    from order_details od 
    where quantity > 40)
--не всегда полезно использовать in, лучше join. 

select distinct product_id
from order_details
where quantity > 40
--distinct работает только с одним столбцом! Distinct про уникальные числа, он нужен чтобы 
--понять что например бананы (их product id) продавались ли больше 40 штук впринципе или нет. 
--Если не указать distinct то он покажет случаи когда бананы продавались по 50 штук, по 79 штук и короче будет повторятся
    
select *
from products p
where exists (select 1 from order_details od where product_id=p.product_id and quantity>50)
-- можно еще использовать not где угодно

--отсортировать строки по поставщику
--по умолчанию сортировка идет по возрастанию
select *
from products p 
order by supplier_id 


--используйте desc для сортировки по убыванию
select *
from products p 
order by supplier_id desc


--отсортировать по нескольким столбцам
select *
from products p 
order by supplier_id desc, units_in_stock 


--можете указывать не название столбца, а порядковый номер
--нумерация столбцов начинается с 1
-- НО ТАК ДЕЛАТЬ НЕ НАДА
select *
from products p 
order by 3 desc, 7


--отсортировать по вычисляему столбцу
select *
from products p 
order by unit_price * units_in_stock desc


-- в order by можно указывать алиасы
select unit_price * units_in_stock as expected_revenue
from products p 
order by expected_revenue desc

-- задать шаблон для поиска
-- % = любая последовательность символов
-- _ = один любой символ
select *
from customers c 
where company_name like 'D%'


-- привет
-- %прив%ет%
-- при_вет


-- можно использовать ilike чтобы и с заглавными и незаглавными искал
select 'привет' ilike 'Привет'


-- задать регулярное выражение (необязательно, целая тема которую можно изучить но я не буду)
select *
from customers c 
where company_name similar to '(D|B)_{10,}'

--это полезная функция case. Позволяет группировать данные либо другие интересные штуки провертывать
select *,
    case
    when unit_price > 100 then 'A'
    when unit_price > 50 then 'B'
    else 'C'
    end price_group
from products p 
    

select *,
    case
    when unit_price > 100 then unit_price 
    when unit_price/2 > 25 and category_id = 2 then unit_price/2
    else NULL
    end price_group
from products p 


select *, 
    case
    when fax is not null then fax
    when phone is not null then phone
    else null
    end contacts
from customers c
--типа нам нужно разобраться если у клиента указан факс то его используем, если не указан то хотя бы телефон
--если же нет ничего то null оч грустно

select *, coalesce (fax, phone) as contacts
from customers c 
-- coalesce это тоже самое что выше только элегантнее

-- "Приветсвуем, 'имя'!" Это например в рассылках либо указывается имя клиента либо если его нет то дорогой друг
select coalesce (name, 'Дорогой друг')

-- nullif для сравнения значений и замены отличных на NULL
-- простым языком тоже самое можно сделать подругому, как выше, но nullif элегантнее
select product_name, nullif (units_in_stock, 0)
from products p

select pg_typeof(1+4)

select pg_typeof(1 + 4.0)

-- преобразовать тип данных (приводимые типы)
select cast (1 as numeric)

select cast(units_in_stock as numeric)
from products p

select units_in_stock::numeric
from products p
--так немного удобнее писать. Можно еще умножать на 1.0 чтобы приводить в numeric, лучше делай это, страхуйся


select 'Привет' || 'Как тебя зовут?' || 'Меня зовут Андрон!' as mytext

select contact_name || '; ' || contact_title as info
from customers c 

-- соединить строки
select concat(contact_name, '; ', contact_title) as info
from customers c 

select concat(company_name, '; ', contact_name, '; ', contact_title) as info
from customers c 

-- единый разделитель
select concat_ws(';', company_name, contact_name, contact_title)
from customers c 

-- найти длину строки
select company_name , length(company_name) as len
from customers c 

-- преобразовать регистр
select company_name , lower (company_name), upper (company_name), initcap (company_name)
from customers c 

select *
from customers c 
where company_name like 'd%'

-- найти позицию подстроки в строке
select position('ab' in 'foo ab bar')

select position(')' in phone)
from customers c 

-- вывести подстроку
select substring('Меня зовут Вася' from 1 for 3) 

-- вывести подстроку - регулярные выражения
select substring('Меня зовут Вася' from '....$') 

-- убрать пробелы с начала или конца строки
select trim ('  Привет  ')

-- убрать символы с начала и конца строки
select trim(both 'xyz' from 'xy   привет  z')

-- убрать сиволы только слева
select trim(leading 'xyz' from 'xy   привет  z')

-- убрать символы только справа
select trim(trailing 'xyz' from 'xy   привет  z')

-- отобрать несколько левых символов
select left('aaa bbb', -2)

-- отобрать несколько правых символов
select right('aaa bbb', -2)

-- текущее время и дата
select current_time
-- или select now()

select order_date, extract(month from order_date)
from orders o

-- сложить даты
select make_date(2021, 3, 31) + interval '3 days 5 hours 31 minutes'

select make_date(2021, 3, 31) - order_date  
from orders o 

-- вычесть даты
select shipped_date - order_date 
from orders o 

-- преобразовать строку к дате
select to_date('10 Apr 2021' , 'DD Mon YYYY')

select to_timestamp('10 04 2021 21 05 31', 'DD MM YYYY HH24 MI SS') 

--преобразовать дату в строку
select to_char(make_date(2021, 3, 31), 'DD.MM.YYYY')
--учитель говорит с датой все просто, нужно в справочник заглянуть, если это понадобится, чтобы точно знать обозначения и все

--чтобы посмотреть диаграмму всех таблиц и как они связаны друг с другом нажми на пкм над таблицей в списке и посмотреть диаграмму

--возможные выражения для соединения таблиц: INNER JOIN, FULL JOIN, RIGHT JOIN, LEFT JOIN, OUTER JOIN, CROSS JOIN
--По диаграмме хорошо видно но объясню так. Например есть таблица с данными 1 2 3 и таблица с данными 2 3 4
--INNER JOIN это появляется таблица с данными 2 3
-- FULL JOIN появляется таблица с данными 1 2 3 4
-- LEFT JOIN это пересечение плюс то что есть в левой таблице тоесть 1 2 3 (на этих примерах плохо видно но понятно)
-- RIGHT JOIN это пересечение плюс то что есть в правой таблице тоесть 2 3 4
-- CROSS JOIN это если есть таблица с M и и таблица с N то каждое перемножается по декарту M*N. Формируются все возможные пары
-- можно писать right outer join или left inner join, короче объединять

-- как присоединяем и с чем
<вид> join <таблица>

-- принцип соединения
on таблица1.поле = таблица2.поле


-- соединение inner по умолчанию
inner join customers c
ON o.customer_id = c.customer_id --это по чему мы соединяем. условия. это тупо foreign key.
-- ну типа в одной таблице только customer_id указан, в другой уже сама таблица про customer_id со всеми подробностями. Поняла?


select o.*
from orders o
right join customers c
ON o.customer_id = c.customer_id


select o.* --это что показываем/выводим
from orders o
left join customers c


--using иногда пишут вместо on, если ключевые поля одинаковы (но нахуй надо)
using(customer_id)


select o.order_id, o.employee_id, e.employee_id
from orders 
join employees e
ON o.employee_id > e.employee_id -- тут интересно и редко возникает необходимость. Это означает что выводятся 
-- все возможные e.employee id которые меньше o. employee id

select *
from products p 
join suppliers s 
on p.supplier_id = s.supplier_id 
join categories c 
on p.category_id = c.category_id
-- наложить фильтр на join
where p.product_name like 'C%'

select o.order_id, c.company_name
from orders o 
right join customers c
on o.customer_id = c.customer_id 
join employees e 
on o.employee_id = e.employee_id 
-- это просто еще парочка примеров

-- кратность, например на 3, проверяется по формуле % 3 = 0

-- про группировки. Они убирают дубликаты по простому. Вместо 1 в каждой строчке оставляют только одну 1

-- убрать дубликаты
select product_id
from order_details od
group by product_id 
order by product_id desc


select od.product_id, min(p.product_name), sum(quantity) --я не знаю что делает sum. сумма значений типа
--min можно подставить часто чтобы избежать ошибок в терминале
from order_details od 
join products p
on od.product_id = p.product_id 
group by od.product_id 


select p.product_name, avg(od.unit_price)*count(quantity) --avg это среднее значение в столбце
--count считает количество строчек в столбце, неважно null там или нет
from order_details od 
join products p 
on od.product_id = p.product_id 
group by p.product_name 


select o.customer_id , count(*) as count_rows, count(coalesce(ship_region, '')) as cnt_col
-- если бы я не написала coalesce, а написала count(ship_region) то он бы посчитал не все строчки, он бы не учитывал строчки с null. Это запутывает
-- Поэтому например count(*) означает что он посчитает все строчки в группированном столбце, учитывая null строчки
from orders o 
group by o.customer_id 


select string_agg(first_name  || ' ' || last_name, ', ') --тупо соелиняет строчки
from employees e 
group by city

-- группировка по вычисленному выражению
select to_char(o.order_date, 'YYYY') as year, count(*) as cnt -- можно extract использовать вместо to_char
from orders o 
group by year
order by year

-- группировка по вычислимым столбцам
select quantity * unit_price, count(*)
from order_details od 
group by quantity * unit_price 


select to_char(o.order_date, 'YYYY') as year, count(*) as cnt 
from orders o 
-- where year = '1996' ОШИБКА т.к. where обрабатывается до назначения алиаса
where to_char(o.order_date, 'YYYY') = '1996'
-- сначала фильтрация where, потом группировка
group by year
order by year


-- узнать, какие категории товаров и в каком колчиестве возит каждый поставщик
select supplier_id, category_id, count(*) as cnt
from products p 
group by supplier_id, category_id 
order by supplier_id, category_id 

-- сколько различных товаров поставляет поставщик
select s.company_name, count(*) as cnt 
from products p 
join suppliers s 
on s.supplier_id = p.supplier_id 
-- where count(*) > 3 ОШИБКА: агрегатные функции нельзя использовать внутри where
group by s.company_name


-- оператор having для фильтрации сгруппированных значений
-- только те поставщики, которые возят более 2 товаров 
select s.company_name, count(*) as cnt 
from products p 
join suppliers s 
on s.supplier_id = p.supplier_id 
where p.category_id = 1
group by s.company_name
having count(*) > 2

every, bool_and -- нужны чтобы искать true что бы это нахуй не значило

-- grouping sets, cube, rollup оч редко нужны, эти штуки нужны чтобы группировать все в таблице впринципе

select s.company_name, c.category_name, count (p.product_name) as cnt
from suppliers s
cross join categories c --перемножает числа в столбцах по декарту
left join products p
on p.supplier_id=s.supplier_id and p.category_id = c.category_id 
group by s.company_name, c.category_name

--как сделать из "длинной" таблицы "широкую" (если надо вспомнить загугли)
select name,
max(case when key ='FID' then value end) as FID,
max(case when key ='Phone' then value end) as Phone,
max(case when key ='email' then value end) as email,
from LongTable,
group by name
--это задача не из этой базы данных но она показывает крутой прием аж для Senior 


select *
from order_details od 
where unit_price > (select avg(unit_price) from order_details od )


-- только те записи, где product_id 2 или 3
select *
from order_details od
where od.product_id in (
    select product_id 
    from products p 
    where p.supplier_id = '1'
    )
    
    
-- коррелируемые подзапросы зависят от внешнего запроса
select *
from order_details od 
where exists (
    select * 
    from products p 
    -- таблица od определена в запросе, поэтому вне запроса 
    -- подзапрос не будет работать
    where od.product_id = p.product_id and p.category_id = '1'
    
    -- как использовать подзапрос в select
select
    unit_price,
    quantity,
    (select product_name from products p where od.product_id = p.product_id) as name
from order_details od 


-- решение аналогичной задачи без подзапроса
select 
    od.unit_price,
    od.quantity,
    p.product_name
from order_details od
join products p 
on od.product_id = p.product_id 

-- как использовать подзапрос в from
-- пример без подзапроса:
select order_id , to_char(order_date, 'YYYY-MM') as dt
from orders o 
where to_char(order_date, 'YYYY-MM') = '1996-07'


-- пример с подзапросом:
select order_id, dt
from (
    select order_id, to_char(order_date, 'YYYY-MM') as dt 
    from orders o
    -- таблице нужно присвоить имя после скобок!
    ) t
where t.dt = '1996-07'

-- какой сотрудник сколько времени работает
-- date_trunc берет начальное состояние (тоесть сбрасывает все числа до 01. Если указать year то месяц тоже сбросится до 01)
--считаем максимальную, минимальную  дату
select max(date_trunc('month', o.order_date)) - min(date_trunc('month', o.order_date)) as dt, e.last_name || ' ' || e.first_name as name 
from orders o
join employees e 
on o.employee_id = e.employee_id
group by e.last_name || ' ' || e.first_name
-- только те сотрудники, между первым и последним заказом которых прошло более 640 дней
having max(date_trunc('month', o.order_date)) - min(date_trunc('month', o.order_date)) > interval '640 days'


-- как переписать запрос с помощью подзапросов
-- 3. Вычислим значение в агрегированных данных
select name, mx-mn as diff
from (
-- 2. Сгруппируем таблицу по сотрудникам
    select name, max(dt) as mx, min(dt) as mn
    from (
-- 1. Cформуруем таблицу, где будет дата и время
        select date_trunc('month', o.order_date) as dt, e.last_name || ' ' || e.first_name as name 
        from orders o
        join employees e 
        on o.employee_id = e.employee_id
        ) t
    group by name ) t2
where mx-mn > interval '640 days'

-- запрос с временными таблицами (самый лучший вариант, удобнее всего использовать)
-- создадим временные таблицы с помощью with
with t as(
        select date_trunc('month', o.order_date) as dt, e.last_name || ' ' || e.first_name as name 
        from orders o
        join employees e 
        on o.employee_id = e.employee_id
        ),
        t2 as (
        select name, max(dt) as mx, min(dt) as mn
        from t group by name
        )
-- итоговые расчеты: 
select name, mx - mn as diff
from t2
where mx - mn > interval '640 days'

--union помогает объединять результаты двух запросов. Если не хочешь чтобы числа повторялись то union all
--except и intersect в postgresql нет, но могут спросить на собесе. их можно написать с помощью join


-- синтаксис оконных функций
-- аргументы кроме over являются необязательными
select *, функция(аргументы) over(partition by название полей order by название полей <правило обработки строк>)
from employees e 


-- вывести id сотрудника, который первый в списке по этому городу
select employee_id, city, first_value(employee_id) over(partition by city order by employee_id)
from employees e 
order by employee_id

-- берем окно не между первой и текущей строчкой (по умолчанию), а первой и последней
range between unbounded preceding and unbounded following 
range between 1 preceding and 1 following 

select employee_id, city, first_value(employee_id) over(partition by city order by employee_id
range between unbounded preceding and unbounded following )
from employees e 
order by employee_id

-- row_number() нумерует строки
select product_id, od.order_id, order_date,
    row_number() over(partition by product_id order by order_date desc)
from order_details od 
join orders o
on od.order_id = o.order_id 
order by product_id, order_date desc


-- rank ранжирует строки от значений в столбце
-- ранжирование с разрывами
select *,
    rank() over(order by quantity desc)
from order_details od 

-- dense_rank ранжирует строки от значений в столбце бeз разрывов
select *,
    dense_rank() over(order by quantity desc)
from order_details od 


-- функции lag и lead выполняют сдвиг строк внутри окна
select order_id, employee_id, order_date,
   lag(order_date) over(partition by employee_id order by order_id),
   lead(order_date) over(partition by employee_id order by order_id)
from orders o
order by employee_id, order_date desc 


-- функции lag и lead помогают рассчитать динамику, разницу между соседними значениями
-- количество дней между последней и предпоследней продажей
select order_id, employee_id, ld - lg
from (
select order_id, employee_id, order_date,
   lag(order_date) over(partition by employee_id order by order_id) as lg,
   lead(order_date) over(partition by employee_id order by order_id) as ld
from orders o
order by employee_id, order_date desc 
) t

-- рассчитать среднюю цену для каждого продукта
select *, avg(unit_price) over(partition by product_id)
from order_details od 

-- рассчитать отклюнения цены продукта от средней
select *, unit_price - avg(unit_price) over(partition by product_id)
from order_details od 


-- рассчитать сумму каждого заказа и дату
with t as(
     select order_id, sum(unit_price * quantity) as sm
     from order_details od 
     group by order_id 
), t2 as (
    select t.order_id, t.sm, o.order_date 
    from t
    join orders o
    on t.order_id = o.order_id
)
-- рассчитать накопительный итог
select *, sum(sm) over(order by order_date) as cum_sum
from t2

-- Как создавать DDL
-- чтобы ты не путала то сначала это тип таблички,
--потом название, потом ограничение или еще какие то уточнения
create table if not exists demo1 (
        id serial primary key,
        name varchar(30) not null default 'myname',
        birth_date date check (birth_day > '1900-01-01'),
        count_n numeric,
        constraint con1 check (count_n >3),
        constraint con2 unique(count_n)
)

select * from demo

--уничтожает нахуй все если есть такой уже
drop table if exists demo1,demo2

create table demo1 (
        id int primary key
)

insert into demo1(id, name, birth_day, count_n) 
values(1, 'myname2', '1910-01-01', 3)

insert into demo1(id, name, birth_day, count_n) 
values(1, 'myname2', '1910-01-01', 4)

--можно еще записать так главное чтобы порядок был правильным, 
--но если установлен default можно пропустить
insert into demo1
values(1, 'myname2', '1910-01-01', 4),
(2, 'myname2', '1910-01-01', 5)

--уничтожает нахуй все, осторожно с ними, возможно код с ними
--не запустит нихуя потому что все уже зачистил
trunicate table demo

drop table if exists demo2

create table demo2 (
        id int primary key
        d_id int,
        constraint fk_demo
        foreign key (d_id)
        references demo1(id)
        on delete set null
        on update cascade --типа установить то как апдейтнуло
)

select * from demo2

insert into demo1 values (1),(2),(3),(4)
--тут был какой то прикол типа почему нельзя поставить другое число на это второе место но мне лень
insert into demo1 values (1,1),(2,2),(3,3),(4,4)

--DML: select, insert, update, delete

delete from demo1 where id=3

update demo1 set id = 100 where id = 2

update table_name set column_name = ... where id = (select id from demo)

create table a as select * from demo2 where id > 1
-- а теперь лайфхак чтобы скопировать структуру таблицы но удалить содержимое. типа 1 никогда не равно 0, поняла?
create table a as select * from demo2 where 1=0

with a as (
     select * from demo2 where id > 2
)
insert into b select id, name from a
insert into b select * from a
returning *
-- возвращает то что ты пишешь даже если команда удаление
delete from b where id > 2
returning *

insert into table(col1, col2) values(val1,val2)

truncate table b

drop table if exists demo2

create table demo2 (
        id int primary key
        name char(20) default 'myname',
        count_n int unique
)

alter table demo alter column name type varchar(30)

alter table demo alter column name drop default

alter table demo rename count_n to count_m

alter table demo rename to demo2

alter table demo2 add constraint con1 check (count_m > 10)


