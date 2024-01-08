create database if not exists walmart.sales;

create table Wsales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(30) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL,
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10,2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(6,4) NOT NULL,
total DECIMAL(12,4) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(15) NOT NULL,
cogs DECIMAL(10,2) NOT NULL,
cogs_margin_pct float(11,9),
gross_income DECIMAL(12,4) NOT NULL,
rating float(2,1)
);
select *from wsales;

select time,
    (CASE
        WHEN `time` between "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` between "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
     END
     )AS time_of_date from wsales;

SET SQL_SAFE_UPDATES = 0;

-----------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------Feature Engineering--------------------------------------------------------------------


-------------------time of day:


 ALTER TABLE wsales ADD COLUMN time_of_day  VARCHAR(20);
 UPDATE wsales SET time_of_day=
          (CASE
        WHEN `time` between "00:00:00" AND "12:00:00" THEN "Morning"
		WHEN `time` between "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
     END
     );
 

-- ------------------DAY_NAME:
  
   ALTER TABLE wsales ADD COLUMN day_name  VARCHAR(20);
   UPDATE wsales SET day_name=
    DAYNAME(date);
    
---------------------MONTH_NAME:

  ALTER TABLE wsales ADD COLUMN month_name  VARCHAR(20); 
  UPDATE wsales SET month_name=
    MONTHNAME(date);


-------- ---------------------------------------------------------------------------------------------------------------------------------    
----- -----GENERIC QUESTIONS--------------------------------------------------------------------------------------------------------------

-- Q1:How many unique cities does the data have?

SELECT DISTINCT city FROM wsales;

SELECT DISTINCT branch FROM wsales;

-- Q2:In which city is each branch?

SELECT DISTINCT city,branch FROM wsales;


----------- --------------------------------------------------------------------------
-------- -------PRODUCT ANALYSIS------------------------------------------------------

-- --Q1:How many unique product lines does the data have?


SELECT DISTINCT 
count(product_line) from wsales;


-- ---Q2:What is the most common payment method?

SELECT payment_method,count(payment_method) as cnt from wsales 
group by payment_method
order by cnt desc;

-- ---Q3:What is the most selling product line?

select product_line ,count(product_line) as cnt
from wsales
group by product_line
order by cnt desc;
-- answer: Fashion accessories.---

-- ---Q4:What is the total revenue by month?

SELECT month_name as month,
sum(total) AS total_revenue
FROM wsales GROUP BY month_name
ORDER BY total_revenue desc; 
-- ----ans:January(total_revenue=116291.8680)


-- ---Q5:Which month has the largest COGS?


SELECT month_name as month,
SUM(cogs) as cogs from wsales
GROUP BY month_name
ORDER BY cogs desc;

-- --ans:January(cogs=110754.16)


-- ---Q6:Which product line had the largest revenue?

SELECT product_line,
sum(total) as total_revenue
FROM wsales 
GROUP BY product_line
ORDER BY total_revenue desc;

-- --ans:Food and beverages(total_revenue=56144.8440)


-- --Q7:what is the city with the ;argest revenue?

SELECT branch,city,
SUM(total) as total_revenue 
FROM wsales
GROUP BY branch,city
ORDER BY total_revenue desc;

-- --ans:Naypyitaw(total_revenue=110490.7755)

-- --Q8:What product line had the largest VAT?

SELECT product_line,
AVG(vat) as avg_tax
FROM wsales
GROUP BY product_line
ORDER BY avg_tax desc;

-- --ans:Home and lifestyle(avg_tax=16.03033124)


SELECT branch,
avg(quantity) as qty
FROM wsales
GROUP BY branch
HAVING SUM(quantity)>(SELECT AVG(quantity)
FROM wsales);

-- --ans:branch(qty=5.4543)


-- ----Q9:Which branch sold more products than average product sold?


SELECT branch,
avg(quantity) as qty
FROM wsales
GROUP BY branch
HAVING SUM(quantity)>(SELECT AVG(quantity)
FROM wsales);

-- --ans:female(Fashion accessories,count=96)


-- --Q10:what is the most common product line by gender?


SELECT gender,product_line,
count(gender) as total_cnt
from wsales
group by gender,product_line
order by total_cnt desc;



-- --Q11:What is the average rating of each product line?


SELECT product_line,
AVG(rating) AS avg_rating
FROM wsales
GROUP BY product_line
ORDER BY avg_rating desc;


------- -- -------------------------------------------------------------------------
----- --SALES-----------------------:-- --------------------------------------------


-- -Q1:No of Sales made in each time of the day per weekend?

SELECT 
   time_of_day,
   count(*) AS total_sales
FROM wsales
GROUP BY time_of_day
ORDER BY total_sales desc;

-- ------ans:Evening(total sales:429)

-- --Q2:Which of the customer types brings the most revenue?

SELECT customer_type,
SUM(total) AS total_rev
FROM wsales
GROUP BY customer_type
ORDER BY total_rev desc;

-- --ans:Member(total_rev=163625.1015)

-- Q3:Which city has the largest tax percent/VAT(value added tax)?

SELECT city,
AVG(VAT) AS VAT
FROM wsales
GROUP BY city
ORDER BY VAT DESC;

-- ---ans:Naypyitaw (vat=16.090..)

-- --Q4:Which customer type pays the most in VAT?

SELECT customer_type,
AVG(VAT) AS avg_vat
FROM wsales
GROUP BY customer_type
ORDER BY avg_vat desc;

-- -ans:Member(avg_vat:15.6145..)


-- -----------------------------------------------------------------------------------
-- -------------------------------customer------------------- ------------------------


-- -Q1:How many unique customer type does the data Have?

SELECT DISTINCT customer_type
FROM wsales;

-- --Q2:How many unique payment methods does the data Have?

SELECT DISTINCT payment_method
FROM wsales;

-- --Q3:What is the most common customer type?


-- --Q4:Which customer type buys the most?

SELECT customer_type,
count(*) as cstm_cnt
FROM wsales
GROUP BY customer_type ;

-- -ans:member(499)

-- --Q5:What is the gender of most of the customers?

SELECT gender,
count(*) as gender_cnt
FROM wsales
GROUP BY gender
ORDER BY gender_cnt desc;

-- -ans:Male(gender_cnt=498)

-- -Q6:Gender distribution in branch c?

SELECT gender,
count(*) as gender_cnt
FROM wsales
WHERE branch="C"
GROUP BY gender
ORDER BY gender_cnt desc;

-- -ans: Female :177 and Male:150

-- -Q7:which time of the day do customers give the most ratings?

SELECT time_of_day,
AVG(rating) AS avg_rating
FROM wsales
GROUP BY time_of_day
ORDER BY avg_rating desc;

-- -ans:afternoon(avg_rating=7)

-- -Q8:which time of the day do customers give the most ratings by branch C?

SELECT time_of_day,
AVG(rating) AS avg_rating
FROM wsales
WHERE branch="C"
GROUP BY time_of_day
ORDER BY avg_rating desc;

-- -Q9:which day do customers give the most avg ratings ?

SELECT day_name,
AVG(rating) as avg_rating
FROM wsales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- -ans:Monday(avg_rating=7.13)

-- -Q10:which day of the week has the best avg ratings for branch "B"?

SELECT time_of_day,
AVG(rating) AS avg_rating
FROM wsales
WHERE branch="B"
GROUP BY time_of_day
ORDER BY avg_rating desc;

-- --ans:Morning(avg_rating=6.83)

-- ------ ------ ---------------DONE ---------------------- ------------------------------

select *from wsales;
           
