-- Retail Sales Analysis

-- Checking all the rows
select count(*)
from retail_sales;


-- Checking null values
-- We can write all together with OR function
select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

select * from retail_sales
where age is null;


-- Dropping null values
delete from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	customer_id is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;


-- Filling the age column with average 
update retail_sales
set age=(select avg(age) from retail_sales)
where age is null;


-- Business Problems and solutions

-- Find the total Sales per day
select sale_date, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 1;


-- Find the sales trend over the time 
select date_trunc('month', sale_date) as month, sum(total_sale) as total_sales
from retail_sales
group by 1
order by 1;


-- Find the top selling category
select category, sum(total_sale)as total_sales 
from retail_sales
group by 1
order by 2 desc;


-- Find the top 5 most frequent customers who are going for purchase
select customer_id, count(transactions_id)as total_transaction 
from retail_sales
group by 1
order by 2 desc
limit 5;


-- Find the average spending each customer does for shopping
select customer_id, round(avg(total_sale)::numeric, 2)as avg_spending
from retail_sales
group by 1
order by 2 desc


-- Find which age group does more shopping order by descending 
select 
	case
		when age between 18 and 28 then '18-28'
		when age between 29 and 40 then '29-40'
		when age between 41 and 50 then '41-50'
		when age between 51 and 60 then '51-60'
		else '60+'
	end as age_group, 
	sum(total_sale)as total_sales
from retail_sales
group by 1
order by 2 desc;


-- Demographic wise number of sales distribution 
select gender, sum(total_sale)as total_sales
from retail_sales
group by 1
order by 2 desc;


-- Find the total number of transaction made by each gender in each category
select category,
	gender,
	count(*)as total_transaction
from retail_sales
group by 1, 2;


-- Find the number of transaction each category is making aslo break the sales category wise
select category, 
	count(transactions_id)as no_of_transaction, 
	sum(total_sale)as totalSales 
from retail_sales 
group by 1
order by 3 desc;


-- Profitability analysis of categories through overall sales
select category,
	round((sum(total_sale)-sum(cogs))::numeric, 2)as profit
from retail_sales
group by 1
order by 2 desc;


-- Find the number of quantity each product/category among all the sales data
select category,
	sum(quantiy)as total_quantity
from retail_sales
group by 1
order by 2 desc;


-- Find the peak sale hour 
select extract(hour from sale_time)as hour,
	sum(total_sale)as total_sales
from retail_sales
group by 1
order by 2 desc;


-- When is the time the maximum sales are happening according to the different time range
select 
	category,
	case
		when sale_time between '04:00:00' and '11:59:59' then 'Morning'
		when sale_time between '12:00:00' and '15:59:59' then 'Afternoon'
		when sale_time between '16:00:00' and '19:59:59' then 'Evening'
		else 'Night'
	end as time_range, 
	sum(total_sale)as total_sales
from retail_sales
group by 1, 2
order by 3 desc;


-- Find the maximum orders placed in each shift in retail sales
with cte_tb2 as
(select 
	*,
	case
		when sale_time between '04:00:00' and '11:59:59' then 'Morning'
		when sale_time between '12:00:00' and '15:59:59' then 'Afternoon'
		when sale_time between '16:00:00' and '19:59:59' then 'Evening'
		else 'Night'
	end as time_range 
from retail_sales)

select time_range, count(*)as total_orders
from cte_tb2
group by time_range
order by total_orders desc;


-- Find the sales by day of week for the records from the table
select 
	to_char(sale_date, 'Day')as day_of_week, 
	sum(total_sale)as total_sales
from retail_sales
group by 1
order by 2 desc

	
-- Which day has maximum sales weekend or weekday
select 
    case 
        when to_char(sale_date, 'D') in ('1', '7') then 'Weekend'  -- '1' for Sunday, '7' for Saturday
        else 'Weekday'
    end as day_category, 
    sum(total_sale) as total_sales
from retail_sales
group by day_category
order by total_sales desc;	


-- Find the average quantity sold per product
select category,
	avg(quantiy)as avg_quantity
from retail_sales
group by 1
order by 2 desc;


-- Calculate the average sale for each month also find the best selling month in each year
with cte_tb as
(select extract(year from sale_date)as year,
	extract(month from sale_date)as month,
	avg(total_sale)as avg_sales,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc)as rank
from retail_sales
group by 1, 2)

select year, month, avg_sales from cte_tb
where rank=1;


-- Find the profit margin of all the product categories out there
select 
  category, 
  sum(total_sale)as total_sales, 
  sum(cogs)as total_cogs, 
  round(cast((sum(total_sale)-sum(cogs))/sum(total_sale)*100 as numeric), 2)as profit_margin
from retail_sales
group by category
order by profit_margin desc;


-- Find the top 5 customers with total sale
select customer_id, sum(total_sale)as total_sales 
from retail_sales
group by 1
order by 2 desc
limit 5;


-- Find the unique customers who have purchased from each category
select category, count(distinct customer_id)as unique customers
from retail_sales
group by 1;