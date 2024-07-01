-- SCHEMA

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT,
    customer_id INT,
    order_date DATE,
    total_items_ordered INT
);

INSERT INTO orders VALUES
(1, 101, '2022-01-01', 5),
(2, 102, '2022-01-02', 10),
(3, 103, '2022-01-03', 8),
(4, 104, '2022-01-04', 12),
(5, 105, '2022-01-05', 15),
(6, 106, '2022-01-06', 20),
(7, 107, '2022-01-07', 25),
(8, 108, '2022-01-08', 30),
(9, 109, '2022-01-09', 35),
(10, 110, '2022-01-10', 40),
(11, 111, '2022-01-11', 45),
(12, 112, '2022-01-12', 50),
(13, 113, '2022-01-13', 55),
(14, 114, '2022-01-14', 60),
(15, 115, '2022-01-15', 65);


DROP TABLE IF EXISTS returns;

CREATE TABLE returns (
    return_id INT,
    order_id INT,
    return_date DATE,
    returned_items INT
);

INSERT INTO returns VALUES
(1, 1, '2022-01-03', 2),
(2, 2, '2022-01-05', 3),
(3, 3, '2022-01-07', 1),
(4, 5, '2022-01-08', 4),
(5, 6, '2022-01-08', 6),
(6, 7, '2022-01-09', 7),
(7, 8, '2022-01-10', 8),
(8, 9, '2022-01-11', 9),
(9, 10, '2022-01-12', 10),
(10, 11, '2022-01-13', 11),
(11, 12, '2022-01-14', 12),
(12, 13, '2022-01-15', 13),
(13, 14, '2022-01-16', 14),
(14, 15, '2022-01-17', 15);




/*
-- Amazon Data Analyst Interview 
Hard Category Questions Time 15min

Question:

Suppose you are given two tables - Orders and Returns. 
The Orders table contains information about orders placed by customers, 
and the Returns table contains information about returned items. 

Design a SQL query to 
find the top 5 ustomer with the highest percentage 
of returned items out of their total orders. 
	
Return the customer ID 
and the percentage of returned items rounded to two decimal places.

*/

-- customer_id,
-- total_items_ordered by each cx
-- total_items_returned by each cx
-- 2/4*100 50% total_items_returned/total_items_ordered*100

SELECT * FROM orders;
SELECT * FROM returns;

-- Solution

WITH ORDER_
AS
(

	SELECT customer_id, SUM(total_items_ordered) as total_items_ordered
	FROM orders GROUP BY customer_id
),
	RETURN_
AS
(
	SELECT o.customer_id, SUM(r.returned_items) AS total_returned_items
	FROM returns AS r JOIN orders AS o
	ON r.order_id = o.order_id
	GROUP BY o.customer_id
)

SELECT customer_id,
		CONCAT(return_percentage, sign) AS return_percentage
FROM
	(SELECT
		O.customer_id,
		O.total_items_ordered,
		R.total_returned_items,
		ROUND(CASE
			WHEN O.total_items_ordered > 0 THEN 
				(R.total_returned_items::FLOAT/O.total_items_ordered::FLOAT)*100
			ELSE 0
			END::NUMERIC,2
		) AS return_percentage,
		TEXT('%') AS sign -- Adding a column to CONCAT the result with '%' sign
	FROM ORDER_ AS O
	JOIN RETURN_ AS R
	ON O.customer_id = R.customer_id
	ORDER BY return_percentage DESC)
LIMIT 5;
	
	
	
	
	SELECT CONCAT(returned_items, TEXT('%') as sign) AS percentage
FROM
	(SELECT returned_items,TEXT('%') AS sign FROM returns)
