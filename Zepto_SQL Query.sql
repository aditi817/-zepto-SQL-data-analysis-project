drop table if exists zepto;

create table zepto (
sku_id SERIAL PRIMARY KEY,
category VARCHAR(120),
name VARCHAR(150) NOT NULL,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,	
quantity INTEGER
);

--data exploration

--count of rows
select count(*) from zepto;

--sample data
select * from zepto limit 10;

--null values
select * from zepto where name is null
OR
category IS NULL
OR
mrp IS NULL
OR
discountPercent IS NULL
OR
discountedSellingPrice IS NULL
OR
weightInGms IS NULL
OR
availableQuantity IS NULL
OR
outOfStock IS NULL
OR
quantity IS NULL;

--different product categories
select distinct category from zepto
order by category;

--product in stock vs out of stock
select outOfStock, Count(sku_id) from zepto
group by outOfStock;

--product names present multiple times
select name, count(sku_id) as "Number of SKUs"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

--data cleaning
--products with price =0
select * from zepto
where mrp=0 or discountedSellingPrice = 0;

Delete from zepto
where mrp =0;

--convert paise to rupees
update zepto
set mrp = mrp/100.0,
discountedSellingPrice =discountedSellingPrice / 100.0;
Select mrp, discountedSellingPrice from zepto;

--data analysis
--Q1. Find the top 10 best-value products based on the discount percentage.
select distinct name,mrp,discountPercent
from zepto
order by discountPercent DESC
limit 10;

--Q2. What are the products with High MRP but Out of Stock
select distinct name,mrp
from zepto
where outOfStock = True and mrp > 300
order by mrp desc;

--Q3.Calculate Estimated Revenue for each category
select category, sum(discountedSellingPrice * availableQuantity) As total_revenue
from zepto
group by category
order by total_revenue;

--Q4. Find all products where MRP is greater than ₹500 and discount is less than 10 %
select distinct name,mrp, discountPercent
from zepto
where mrp>500 and discountPercent < 10
order by mrp desc, discountPercent desc;

--Q5. Identify top 5 categories offering the highest average discount percentage
select category,
round(avg(discountPercent),2) As avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

--Q6.Find the price per gram for products above 100gm and sort by best value.
select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gram
from zepto
where weightInGms >= 100
order by price_per_gram;

--Q7.Group the products into categories like Low,Medium,Bulk.
select distinct name , weightInGms, 
case when weightInGms < 1000 then 'Low'
     when weightInGms < 5000 then 'Medium'
	 else 'Bulk'
	 end as weight_category
	 from zepto;

--Q8.What is the total inventory weight per category
select category,
sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;