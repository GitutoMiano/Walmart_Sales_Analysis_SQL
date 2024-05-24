CREATE database IF NOT EXISTS Walmart_Sales;

Create table if not exists sales(
invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
branch VARCHAR(5) NOT NULL,
city VARCHAR(50) NOT NULL,
customer_type VARCHAR(30) NOT NULL,
gender VARCHAR(10) NOT NULL, 
product_line VARCHAR(100) NOT NULL,
unit_price DECIMAL(10, 2) NOT NULL,
quantity INT NOT NULL,
VAT FLOAT(10) NOT NULL,
total DECIMAL(10, 2) NOT NULL,
date DATETIME NOT NULL,
time TIME NOT NULL,
payment_method VARCHAR(20) NOT NULL, 
cogs DECIMAL(10,2) NOT NULL,
gross_margin_percentage FLOAT(11) NOT NULL,
gross_income DECIMAL(10,2) NOT NULL,
rating FLOAT(2) NOT NULL);

---------------------------------------------------------------------------------------------------------------------------------
-------------- Feature Engineering ( Adding a few columns Month, day of week, and date time(3 segments)--------------------------
SET SQL_SAFE_UPDATES = 0;
--------------------------------------------------------
--------------- Month -- -------------------------------
-- SELECT MONTHNAME(date) as Month_name FROM sales;
-- add month name to the table
ALTER TABLE sales ADD COLUMN Month_name VARCHAR(20); 
-- Update the column with appropriate month names based on the date column
UPDATE sales
SET Month_name = MONTHNAME(date);
------------------------------------------------------------
----------------- Get day of the week-----------------------
-- Add the column to the table
ALTER TABLE sales ADD COLUMN week_day VARCHAR(20); 
UPDATE sales
SET week_day = DAYNAME(date);

-----------------------------------------------------
---- Get part of the day (morning, afternoon, evening)------
-- add the column to the table
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
 -- Update the time_of_day column based on the time column
UPDATE sales
SET time_of_day = CASE
    WHEN time BETWEEN '00:00:00' AND '11:59:59' THEN 'Morning'
    WHEN time BETWEEN '12:00:00' AND '15:59:59' THEN 'Afternoon'
    ELSE 'Evening'
END;
-- add hour to the table
ALTER TABLE sales ADD COLUMN hour_of_day INT; 
-- Update the column with appropriate hours based on the time column
UPDATE sales
SET hour_of_day = HOUR(time);

-- check all the data
SELECT * FROM sales;

------------------------------------------------------------------------------------
-------------------------- Get location of each branch------------------------------
SELECT DISTINCT branch, city
FROM sales;

------------------------------------------------------------------------------------
-------------------------- Product analysis ----------------------------------------
------- 1.	What are the unique products sold?
SELECT DISTINCT product_line FROM sales;

------- 2.	How do the products perform?
SELECT
	DISTINCT product_line,
    SUM(Quantity) AS Quantity_Ordered,
    SUM(gross_income) as total_gross_income
    FROM sales
    GROUP BY product_line
    ORDER BY total_gross_income DESC;
    
    

------------------------------------------------------------------------------------
-------------------------- Sales Analysis ------------------------------------------
 --- 1.	What are the sales by city?
 SELECT city, SUM(Quantity) AS Quantity_ordered, SUM(gross_income) AS Total_gross_income
 FROM sales
 GROUP BY city
 ORDER BY Total_gross_income DESC;

--- 2.	What are the sales by payment method?
SELECT payment_method, SUM(Quantity) AS Quantity_ordered, SUM(gross_income) AS Total_gross_income
FROM sales
GROUP BY payment_method
ORDER BY Total_gross_income DESC;

--- 3.	What are the sales by branch?

SELECT branch, SUM(Quantity) AS Quantity_ordered, SUM(gross_income) AS Total_gross_income
FROM sales
GROUP BY branch
ORDER BY Total_gross_income DESC;

--- 4.	When (day) are the sales at their pick, and at the lowest point?

SELECT week_day, SUM(Quantity) AS Quantity_ordered
FROM sales
GROUP BY week_day
ORDER BY Quantity_ordered DESC;

---- 5.	What are the sales by time of day?
SELECT time_of_day, SUM(Quantity) AS Quantity_ordered
FROM sales
GROUP BY time_of_day
ORDER BY Quantity_ordered DESC;

---- 6.	What are the sales by hour?
SELECT hour_of_day, SUM(Quantity) AS Quantity_ordered
FROM sales
GROUP BY hour_of_day
ORDER BY Quantity_ordered DESC;

------------------------------------------------------------------------------------
-------------------------- Customer Analysis ------------------------------------------

--- 1	What are the sales by gender?

SELECT gender, SUM(Quantity) AS Quantity_ordered, SUM(gross_income) AS Total_gross_income
FROM sales
GROUP BY gender
ORDER BY Total_gross_income DESC;

--- 2	What are the sales by customer type?

SELECT customer_type, SUM(Quantity) AS Quantity_ordered, SUM(gross_income) AS Total_gross_income
FROM sales
GROUP BY customer_type
ORDER BY Total_gross_income DESC;


--- 3	What are the ratings by city?

SELECT city, ROUND(AVG(rating), 2) AS Average_rating
FROM sales
GROUP BY city
ORDER BY Average_rating DESC;

--- 4	What are the customer ratings by payment method?
SELECT payment_method, ROUND(AVG(rating), 2) AS Average_rating
FROM sales
GROUP BY payment_method
ORDER BY Average_rating DESC;

--- 5	What are the customer ratings by product line?
SELECT product_line, ROUND(AVG(rating), 2) AS Average_rating
FROM sales
GROUP BY product_line
ORDER BY Average_rating DESC;

--- 6	What is the customer rating by gender?
SELECT gender, ROUND(AVG(rating), 2) AS Average_rating
FROM sales
GROUP BY gender
ORDER BY Average_rating DESC;

--- 7	What is the customer rating by branch? 
SELECT branch, ROUND(AVG(rating), 2) AS Average_rating
FROM sales
GROUP BY branch
ORDER BY Average_rating DESC;

--- 8 What is the customer rating by customer type?
SELECT customer_type, ROUND(AVG(rating), 2) AS Average_rating
FROM sales
GROUP BY customer_type
ORDER BY Average_rating DESC;