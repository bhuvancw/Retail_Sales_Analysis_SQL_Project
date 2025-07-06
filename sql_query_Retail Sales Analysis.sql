
drop table if exists retail_sales;
CREATE table retail_sales (
							transactions_id int,
							sale_date date,
							sale_time time,
							customer_id	INT,
							gender varchar(10),
							age int,
							category varchar(20),
							quantity int,
							price_per_unit float,
							cogs float,
							total_sale float
							);

select * from retail_sales;

select 
	*
from retail_sales where age is null;

select * from retail_sales
where 
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null;

delete from retail_sales
where
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null;

-- Data Exploration --
-- How many sales? --
select sum(total_sale) from retail_sales;

-- How many customers we have --
select count(distinct customer_id) from retail_sales;

select distinct category from retail_sales;

-- Data Analysis and Business Key Problems and Answers --

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * from retail_sales 
	where sale_date='2022-11-05';
	
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select * from retail_sales 
where 
	category='Clothing' 
	and
	quantity>3
	and
	to_char(sale_date,'yyyy-mm')='2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select 
	category,
	sum(total_sale) as Total_Amount 
from retail_sales 
	group by category;
	
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),2) as avg_age from retail_sales where category='Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select 
	*
from retail_sales
	where
		total_sale>1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
	gender, category,
	count(transactions_id) as number_of_orders
from retail_sales
	group by 1,2;
	
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

select sale_year,sale_month,avg_sale from(
select 
	extract(year from sale_date) as sale_year,	
	extract(month from sale_date) as sale_month,
	avg(total_sale) as avg_sale,
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail_sales
	group by 1,2)
	where rank=1;



-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

select 
	customer_id, 
	sum(total_sale) 
from retail_sales
	group by customer_id
	order by sum(total_sale) desc limit 5;
	
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
	category,
	count(distinct customer_id)
from retail_sales
	group by 1 order by 1,2;

	
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

with hourly_sale 
as (
	select *,
		case
			when extract(hour from sale_time)<12 then 'Morning'
			when extract(hour from sale_time)<17 then 'Afternoon'
			else 'Evening'
		END shift
	from retail_sales
	)
select shift,count(transactions_id) from hourly_sale
group by shift;




