# Refers to the file : SQL-questions-set1pdf

# city
create database if not exists db_assign_set1;
use db_assign_set1;

create table if not exists city (
id INT,
name VARCHAR(17),
countrycode VARCHAR(3),
district VARCHAR(20),
population INT
);
desc city;

# Inserting values in the table from a stored procedure to avoid clutter
call populate_city_data();
select * from city;


# Answers >> 

# Q1: Query all columns for all American(USA) cities in the CITY table with populations larger than 100000.
select * from city where countrycode = "USA" and population > 100000;

# Q2: Query the NAME field for all American cities in the CITY table with populations larger than 120000.
select name from city where countrycode = "USA" and population > 120000;

# Q3: Query all columns (attributes) for every row in the CITY table.
select * from city;

# Q4: Query all columns for a city in CITY with the ID 1661.
select * from city where id  = "1661";

# Q5: Query all attributes of every Japanese city in the CITY table.
select * from city where countrycode = "JPN";

# Q6: Query the names of all the Japanese cities in the CITY table.
select name from city where countrycode = "JPN";


# city-station
CREATE TABLE IF NOT EXISTS station (
id INT  NOT NULL,
city   VARCHAR(21),
state  VARCHAR(2),
lat_n  INT,
long_w INT
);
desc station;

# Inserting values in the table from a stored procedure to avoid clutter
call populate_station_data();
select * from station;


# Q7: Query a list of CITY and STATE from the STATION table.
select city, state from station;

# Q8: Query a list of CITY names from STATION for cities that have an even ID number. Print the results, but exclude duplicates from the answer.
select DISTINCT city from station where (id % 2 = 0);

# Q9: Find the difference between the total number of CITY entries in the table and the number of distinct CITY entries in the table.
select count(city) - count(DISTINCT city) from station;

# Q10: Query the two cities in STATION with the shortest and longest CITY names, as well as their respective lengths (i.e.: number of characters in the name).
# Shortest
select city, length(city) from station order by length(city) ASC limit 1;
# Longest
select city, length(city) from station order by length(city) DESC limit 1;

# Q11: Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION
select DISTINCT city from station where substring(city, 1, 1) in ('a','e','i','o','u');

# Q12: Query the list of CITY names ending with vowels (a, e, i, o, u) from STATION.
select DISTINCT city from station where substring(city, length(city), 1) in ('a','e','i','o','u');

# Q13: Query the list of CITY names from STATION that do not start with vowels.
select DISTINCT city from station where substring(city, 1, 1) not in ('a','e','i','o','u');

# Q14: Query the list of CITY names not ending with vowels (a, e, i, o, u) from STATION.
select DISTINCT city from station where substring(city, length(city), 1) not in ('a','e','i','o','u');

# Q15: Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels.
select DISTINCT city from station where substring(city, 1, 1) not in ('a','e','i','o','u') or substring(city, length(city), 1) not in ('a','e','i','o','u');

# Q16: Query the list of CITY names from STATION that neither do not start with vowels nor do not end with vowels.
select DISTINCT city from station where substring(city, 1, 1) not in ('a','e','i','o','u') and substring(city, length(city), 1) not in ('a','e','i','o','u');


# product-sales >> 
# Q17: Write an SQL query that reports the products that were only sold in the first quarter of 2019. That is, between 2019-01-01 and 2019-03-31 inclusive.
select product.product_id, product.product_name
from product,sales
where sales.product_id = product.product_id
and (sales.sale_date between "2019-01-01" and "2019-03-31")
and sales.product_id not in (select product_id from sales where sale_date > "2019-03-31");


# Q18: query to find all the authors that viewed at least one of their own articles. Return the result table sorted by id in ascending order.
select DISTINCT author_id from article_views where author_id = viewer_id ORDER BY author_id ASC;

# Q19: query to find the percentage of immediate orders in the table, rounded to 2 decimal places.
select @immediate := count(delivery_id) from delivery where order_date = customer_pref_delivery_date;
select @total := count(delivery_id) from delivery;
select round((@immediate/@total)*100,2);


# Q20: Write an SQL query to find the ctr of each Ad. Round ctr to two decimal points.Return the result table ordered by ctr in descending order and by ad_id in ascending order.
# Using stored procedures to call for each id >>
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

# Calling the procedure for each ad_id >> 
call get_ctr_for_id(1,@ctr);
call get_ctr_for_id(2,@ctr);
call get_ctr_for_id(3,@ctr);
call get_ctr_for_id(5,@ctr);


# Q21: 
















