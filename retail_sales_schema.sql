-- Create Schema
drop table if exists retail_sales
create table retail_sales(
	transactions_id int primary key,
	sale_date date,	
	sale_time time,
	customer_id	int,
	gender char(8),	
	age int,
	category char(12),	
	quantiy	int,
	price_per_unit float,	
	cogs float,	
	total_sale float
);


select * from retail_sales;

