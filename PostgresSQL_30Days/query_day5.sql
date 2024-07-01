-- Question 1

-- User's Third Transaction [Uber SQL Interview Question]

/*
Assume you are given the table below on Uber transactions made by users. 
Write a query to obtain the third transaction of every user. 
Output the user id, spend and transaction date.

transactions Table:

Column Name			Type
==============================
user_id				integer
spend				decimal
transaction_date	timestamp
==============================

transactions Example Input:

user_id		spend	transaction_date
==========================================
111			100.50	01/08/2022 12:00:00
111			55.00	01/10/2022 12:00:00
121			36.00	01/18/2022 12:00:00
145			24.99	01/26/2022 12:00:00
111			89.60	02/05/2022 12:00:00
==========================================

Example Output:

user_id		spend	transaction_date
=====================================
111			89.60	02/05/2022 12:00:00

*/

-- URL of the Problem: https://datalemur.com/questions/sql-third-transaction


-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 					Solution
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-- Solution #1: Using Subquery
SELECT
  user_id,
  spend,
  transaction_date
FROM(
SELECT
  user_id,
  spend,
  transaction_date,
  ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY transaction_date) as rn
FROM transactions
) x1
WHERE rn = 3
;

-- Solution #2: Using CTE

WITH trans_num AS (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    ROW_NUMBER() OVER (
      PARTITION BY user_id ORDER BY transaction_date) AS row_num 
  FROM transactions)

SELECT 
  user_id, 
  spend, 
  transaction_date 
FROM trans_num 
WHERE row_num = 3;

-- Question 2

/*
Question:
Find the top 5 products whose revenue has decreased in comparison to the 
previous year (both 2022 and 2023). Return the product name, 
revenue for the previous year, revenue for the current year, 
revenue decreased, and the decreased ratio (percentage).
*/

-- Create product_revenue table
CREATE TABLE product_revenue (
    product_name VARCHAR(255),
    year INTEGER,
    revenue DECIMAL(10, 2)
);

-- Insert sample records
INSERT INTO product_revenue (product_name, year, revenue) VALUES
('Product A', 2022, 10000.00),
('Product A', 2023, 9500.00),
('Product B', 2022, 15000.00),
('Product B', 2023, 14500.00),
('Product C', 2022, 8000.00),
('Product C', 2023, 8500.00),
('Product D', 2022, 12000.00),
('Product D', 2023, 12500.00),
('Product E', 2022, 20000.00),
('Product E', 2023, 19000.00),
('Product F', 2022, 7000.00),
('Product F', 2023, 7200.00),
('Product G', 2022, 18000.00),
('Product G', 2023, 17000.00),
('Product H', 2022, 3000.00),
('Product H', 2023, 3200.00),
('Product I', 2022, 9000.00),
('Product I', 2023, 9200.00),
('Product J', 2022, 6000.00),
('Product J', 2023, 5900.00);

SELECT * FROM product_revenue;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 					Solution
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

WITH previous_year AS (
	SELECT product_name, year, revenue
	FROM product_revenue
	WHERE year = '2022'
),

	current_year AS (
	SELECT product_name, year, revenue
	FROM product_revenue
	WHERE year = '2023'
)

SELECT
	previous_year.product_name,
	previous_year.revenue as previous_year_revenue,
	current_year.revenue as current_year_revenue,
	(previous_year.revenue - current_year.revenue) as revenue_decreased,
	((previous_year.revenue - current_year.revenue)/previous_year.revenue) * 100 as revenue_decreased_ratio
FROM previous_year
JOIN current_year
ON previous_year.product_name = current_year.product_name
WHERE current_year.product_name < previous_year.product_name
LIMIT 5;