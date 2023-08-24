# Refers to the file : sql assignments
# Both problems have been answered below and labeled accordingly


# 1. ATS : LinkedIn >>
create DATABASE ats;
use ats;

create table techmap(
applicant_id int not NULL,
tech varchar(25) not null
);

insert into techmap values
(1, "ds"), 
(1, "py"),
(1, "sql"),
(2, "sql"),
(2, "py"),
(2, "ds"),
(2, "tableau"),
(3, "tableau"),
(3, "sql"),
(1, "tableau"),
(1, "c"),
(1, "c++"),
(3, "as3"),
(3, "java"),
(2, "php"),
(2, "java");
# select * from techmap;
# Query : Select all applicants who know all the required skills, in this case : (ds, sql, java) >>
select applicant_id from techmap where tech = "ds" and applicant_id in (
select applicant_id from techmap where tech = "sql" and applicant_id in (
select applicant_id from techmap where tech = "java"
));


# 2. E-Commerce Website : product info likes Query >>
create database ecomdb;
use ecomdb;

create table product_info(
prod_id INT not null,
prod_name VARCHAR(35),
primary key(prod_id)
);
INSERT into product_info values (1001, "blog"), (1002, "youtube"), (1003, "education");
#select * from product_info;

create table product_likes(
user_id int not null,
prod_id INT not null,
like_date DATE,
FOREIGN KEY (prod_id) references product_info(prod_id)
);
INSERT into product_likes values (1, 1001, "2023-08-22"), (2, 1003, "2022-01-16");
#select * from product_likes;

# Query : Return ids of products that have 0 likes >>
SELECT prod_id from product_info where prod_id not in (
SELECT prod_id from product_likes where like_date is NOT NULL);

