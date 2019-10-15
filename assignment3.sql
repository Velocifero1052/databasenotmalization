create database assignment3;
use assignment3;
drop database assignment3;
drop table customer;

create table customer(
	id int primary key auto_increment,
	name_ varchar(30),
    country varchar(30)
);
create table order_(
	id int primary key auto_increment,
    date_ date,
    cust_id int references customer(id)
);
create table invoice(
	id int primary key auto_increment,
	order_id int unique references order_(id),
    amount int,
    issued date,
    due date
);
create table payment(
	id int primary key auto_increment,
    time_ timestamp, 
	amount int,
	inv_id int references invoice(id)
);
create table product(
	id int primary key auto_increment,
	name_ varchar(30),
	description_ varchar(30),
    price int,
    photo varchar(1024)
);
create table detail(
	id int primary key auto_increment,
    ord_id int references order_(id),
	pr_id int references product(id),
	quantity int
);

insert into customer(name_, country) values('Grace Kelly', 'USA');
select * from customer;
select * from detail;
select * from product;
insert into product(name_, description_, price) values ('alienware r5 17', 'Gaming laptop', 1700);
insert into product(name_, description_, price) values ('macbook air', 'Budget, entry level', 800);
insert into product(name_, description_, price) values ('Lenovo legion Y740', 'Gaming laprop', 1800);
insert into product(name_, description_, price) values ('Macbook pro 13', 'laptop for professionals 13', 2000);
insert into product(name_, description_, price) values ('Macbook pro 15', 'laptop for professionals 15', 3000);

insert into detail(pr_id, quantity) values ((select id from product where name_ = 'Macbook pro 13'), 20);
insert into detail(pr_id, quantity) values((select id from product where name_ = 'alienware r5 17'), 20); 
insert into detail(pr_id, quantity) values((select id from product where name_ = 'macbook air'), 20); 
insert into detail(pr_id, quantity) values((select id from product where name_ = 'Lenovo legion Y740'), 20); 
insert into detail(pr_id, quantity) values((select id from product where name_ = 'Macbook pro 15'), 20); 

select * from detail;

insert into order_ (date_, cust_id) values('2019-10-29', (select id from customer where name_ = 'Brit Marling'));  
insert into invoice(order_id, amount, issued, due) values((select id from order_ where cust_id = (select id from Customer where name_ = 'Brit Marling') and date_ = '2019-10-29'), 1, '2019-10-29', '2021-10-29');
insert into payment(time_, amount, inv_id) values('2019-10-29 15:39:20', 1, (select id from invoice where order_id = (select id from order_ where cust_id = (select id from customer where name_ = 'Brit Marling') and date_ = '2019-10-29')));
insert into detail(ord_id, pr_id, quantity) values((select id from order_ where cust_id = (select id from Customer where name_ = 'Brit Marling') and date_ = '2019-10-29'), (select id from product where name_ = 'alienware r5 17'), 1);                                     

select * from detail;
select * from customer;
select * from product;
select * from order_;
select * from invoice;
select * from payment;

insert into order_(date_, cust_id) values('2015-09-09', (select id from customer where name_ = 'Grace Kelly'));
insert into invoice(order_id, amount, issued, due) values((select id from order_ where cust_id = (select id from customer where name_ = 'Grace Kelly') and date_ = '2015-09-09'), 1, '2015-09-09', '2018-09-09');
insert into payment(time_, amount, inv_id) values('2015-09-09 15:00:00', 1 * (select price from product where name_ = 'Macbook pro 15'), (select id from invoice where order_id = (select id from order_ where cust_id = (select id from customer where name_ = 'Grace Kelly') and date_ = '2015-09-09')));
insert into detail(ord_id, pr_id, quantity) values((select id from order_ where cust_id = (select id from customer where name_ = 'Grace Kelly') and date_ = '2015-09-09'), (select id from product where name_ = 'Macbook pro 15'), 1);
select * from detail;
delete  from detail where id >= 9 and id <=10;

insert into order_(date_, cust_id) values('2016-05-08', (select id from customer where name_ = 'Greta Garbo'));
insert into invoice(order_id, amount, issued, due) values((select id from order_ where cust_id = (select id from customer where name_ = 'Greta Garbo') and date_ = '2016-05-08'), 1 * (select price from product where name_ = 'alienware r5 17'),'2019-05-08', '2019-05-08');
insert into payment(time_, amount, inv_id) values('2016-05-08 17:00:00', 1 * (select price from product where name_ = 'alienware r5 17'), (select id from invoice where order_id = (select id from order_ where cust_id = (select id from customer where name_ = 'Greta Garbo') and date_ = '2016-05-08')));
insert into detail(ord_id, pr_id, quantity) values((select id from order_ where cust_id = (select id from customer where name_ = 'Greta Garbo') and date_ = '2016-05-08'), (select id from product where name_ = 'alienware r5 17'), 1);
-- 1

select id, issued, order_id from invoice where issued < (select date_ from order_ where id = order_id);
-- 2
select invoice.id, issued, order_id, date_ from invoice, order_  where issued < (select date_ from order_ where id = order_id);

-- 3

select * from order_ where id not in (select ord_id from detail where ord_id is not null) and date_ < '2016-09-01';

-- 4

select * from customer where  exists (select cust_id from order_ where customer.id = cust_id and  date_ > '2016-01-01' and date_ < '2016-12-31');

-- 5

select customer.id, name_, date_ from order_, customer where cust_id = (select id from customer where id = cust_id) and date_ = (select max(date_) from order_ where cust_id = (select id from customer where id = cust_id));

-- 6

select id, amount * (select count(*) from payment where invoice.id = inv_id) as payed, amount, amount * (select count(*) from payment where invoice.id = inv_id)  - amount as to_return   from invoice where (select count(*) from payment where invoice.id = inv_id) > 1;

-- 7

select product.id, name_, (select count(*) from detail where pr_id = product.id) as ordered from product where (select count(*) from detail where pr_id = product.id) > 10;

-- 8

select name_, price from product where (select count(*) from detail where pr_id = product.id) > (select avg((select count(*) from detail where pr_id = product.id)) from detail, product); 

-- 9

select distinct country as country_name, (select count(*) from order_ where cust_id in (select id from customer where country = country_name))as ordered from customer where id in (select cust_id from order_ where date_>= '2016-01-01' and date_ <= '2016-12-31');

-- 10
select * from order_ where not exists(select order_id from invoice where order_.id = order_id) and cust_id is not null;



