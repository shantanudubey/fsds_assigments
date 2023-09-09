

create table product(
product_id int primary key,
product_name  varchar(30),
unit_price int
);
desc product;

insert into product(product_id, product_name, unit_price) values
(1, "S8", 1000),
(2, "G4", 800),
(3, "iPhone", 1400),
(4, "Razr", 1100);
select * from product;

create table sales(
seller_id int,
product_id int,
buyer_id int,
sale_date DATE,
quantity int,
price INT,
foreign key (product_id) references product(product_id)
);
desc sales;

insert into sales(seller_id, product_id, buyer_id, sale_date, quantity, price) values
(1, 1, 1, "2019-01-21", 2, 2000),
(1, 2, 2, "2019-02-17", 1, 800),
(2, 2, 3, "2019-06-02", 1, 800),
(3, 3, 4, "2019-05-13", 2, 2800);
select * from sales;

/*
Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is,
between 2019-01-01 and 2019-03-31 inclusive.
*/
select product.product_id, product.product_name, sale_date
from product,sales
where sales.product_id = product.product_id
and (sales.sale_date between "2019-01-01" and "2019-03-31")
and sales.product_id not in (select product_id from sales where sale_date > "2019-03-31");

create table article_views(
article_id int,
author_id int,
viewer_id int,
view_date DATE
);
desc article_views;

insert into article_views(article_id, author_id, viewer_id, view_date) values
(1,3,5,"2019-08-01"),
(1,3,6,"2019-08-02"),
(2,7,7,"2019-08-01"),
(2,7,6,"2019-08-02"),
(4,7,1,"2019-07-22"),
(3,4,4,"2019-07-21"),
(3,4,4,"2019-07-21");
select * from article_views;

# query to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order.
select DISTINCT author_id from article_views where author_id = viewer_id ORDER BY author_id ASC;


create table delivery(
delivery_id int PRIMARY KEY,
customer_id int,
order_date date,
customer_pref_delivery_date date
);
desc delivery;

insert into delivery(delivery_id, customer_id, order_date, customer_pref_delivery_date) values
(1,1,"2019-08-01","2019-08-02"),
(2,5,"2019-08-02","2019-08-02"),
(3,1,"2019-08-11","2019-08-11"),
(4,3,"2019-08-24","2019-08-26"),
(5,4,"2019-08-21","2019-08-22"),
(6,2,"2019-08-11","2019-08-13");
select * from delivery;

# query to find the percentage of immediate orders in the table, rounded to 2 decimal places.
select @immediate := count(delivery_id) from delivery where order_date = customer_pref_delivery_date;
select @total := count(delivery_id) from delivery;
select round((@immediate/@total)*100,2);


/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
create table ads(
ad_id int not null,
user_id int not null,
action ENUM('Clicked', 'Viewed', 'Ignored'),
PRIMARY KEY(ad_id,user_id)
);
desc ads;

insert into ads(ad_id, user_id, action) values
(1, 1, "Clicked"),
(2, 2, "Clicked"),
(3, 3, "Viewed"),
(5, 5, "Ignored"),
(1, 7, "Ignored"),
(2, 7, "Viewed"),
(3, 5, "Clicked"),
(1, 4, "Viewed"),
(2, 11, "Viewed"),
(1, 2, "Clicked");
select * from ads;

# Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.Return the result table ordered by ctr in descending order and by ad_id in ascending order.
# ctr = (total_clicks/(total_clicks+total_views))*100 
/*
# to be repeated for each id
select @total_clicks := count(ad_id) from ads where ad_id=1 and action = "Clicked";
select @total_views := count(ad_id) from ads where ad_id=1 and action = "Viewed";
select @ctr := round((@total_clicks / (@total_clicks + @total_views)) * 100, 2);
select @ctr;
*/

call get_ctr_for_id(1,@ctr);
call get_ctr_for_id(2,@ctr);
call get_ctr_for_id(3,@ctr);
call get_ctr_for_id(5,@ctr);

USE `db_assign_set1`;
DROP procedure IF EXISTS `get_ctr`;

DELIMITER $$
USE `db_assign_set1`$$
CREATE PROCEDURE `get_ctr` (in clicks int, in views int, out ctr FLOAT)
BEGIN
select @ctr := round((clicks / (clicks + views)) * 100, 2);
END$$

DELIMITER ;

USE `db_assign_set1`;
DROP procedure IF EXISTS `get_ctr_for_id`;

DELIMITER $$
USE `db_assign_set1`$$
CREATE PROCEDURE `get_ctr_for_id` (in id INT, out ctr FLOAT)
BEGIN
select @total_clicks := count(ad_id) from ads where ad_id=id and action = "Clicked";
select @total_views := count(ad_id) from ads where ad_id=id and action = "Viewed";
call get_ctr(@total_clicks, @total_views, ctr);
END$$

DELIMITER ;

/* ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ */
create table employee(
employee_id int primary key,
team_id int not null
);
desc employee;

insert into employee(employee_id, team_id) values
(1,8),
(2,8),
(3,8),
(4,7),
(5,9),
(6,9);
select * from employee;

# query to find the team size of each of the employees.
/*
    Disable : SET sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
    Enable  : SET sql_mode=(SELECT CONCAT(@@sql_mode,'ONLY_FULL_GROUP_BY',''));
    Check   : SHOW VARIABLES LIKE 'sql_mode'; 
        Sample after disabling full_group_by : 'sql_mode', 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION'
*/
select team_id, count(team_id) from employee group by team_id;
select employee_id, team_id, count(team_id) as "team_size" from employee group by employee_id;














