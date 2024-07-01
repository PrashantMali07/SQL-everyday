-- Laptop vs. Mobile Viewership [New York Times SQL Interview Question]

/* 

Assume you're given the table on user viewership categorised by device type where the three types are laptop, tablet, and phone.

Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as the sum of tablet and phone viewership. 
Output the total viewership for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.

Effective 15 April 2023, the solution has been updated with a more concise and easy-to-understand approach.

viewership Table:
	ColumnName				Type
	============================================================
	user_id					integer
	device_type				string ('laptop', 'tablet', 'phone')
	view_time				timestamp

viewership Example Input:

	user_id		device_type		view_time
	==============================================
	123			tablet			01/02/2022 00:00:00
	125			laptop			01/07/2022 00:00:00
	128			laptop			02/09/2022 00:00:00
	129			phone			02/09/2022 00:00:00
	145			tablet			02/24/2022 00:00:00

Example Output:

laptop_views	mobile_views
----------------------------
2				3			

Explanation:
Based on the example input, there are a total of 2 laptop views and 3 mobile views.

*/

-- Problem URL link: https://datalemur.com/questions/laptop-mobile-viewership


SELECT
      SUM(laptop_views) as laptop_views,
      SUM(mobile_views) as mobile_views
FROM
(SELECT 
      CASE WHEN device_type = 'laptop' THEN 1 END AS laptop_views,
      CASE WHEN device_type = 'tablet' THEN 1
          WHEN device_type = 'phone' THEN 1 ELSE 0
          END AS mobile_views
FROM viewership) x1
;

