-- Problem 1.

-- Leetcode problem LeetCode SQL Premium Problem 2853: 'Highest Salary Difference'

-- DDL for Salaries table
CREATE TABLE Salaries (
	emp_name VARCHAR(50),
	department VARCHAR(50),
	salary INT,
	PRIMARY KEY (emp_name, department)
);


INSERT INTO Salaries (emp_name, 
					  department, salary) VALUES
('Kathy', 'Engineering', 50000),
('Roy', 'Marketing', 30000),
('Charles', 'Engineering', 45000),
('Jack', 'Engineering', 85000),
('Benjamin', 'Marketing', 34000),
('Anthony', 'Marketing', 42000),
('Edward', 'Engineering', 102000),
('Terry', 'Engineering', 44000),
('Evelyn', 'Marketing', 53000),
('Arthur', 'Engineering', 32000);


/*
Write an SQL query to calculate the difference 
between the highest salaries 
in the marketing and engineering department. 
Output the absolute difference in salaries.
*/

SELECT * FROM Salaries;

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 					Solution
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT
		ABS(MAX(CASE WHEN department = 'Marketing' THEN salary END) -
			MAX(CASE WHEN department = 'Engineering' THEN salary END)) as differenced_salary
FROM Salaries;


--Problem 2.

-- Teams Power Users [Microsoft SQL Interview Question]

/*
Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams in August 2022. 
Display the IDs of these 2 users along with the total number of messages they sent.
Output the results in descending order based on the count of the messages.

Assumption:

		No two users have sent the same number of messages in August 2022.

messages Table:
	+------------------+-----------+
	|	Column Name		|	Type	|
	+------------------+-----------+
	|	message_id		|  integer	|
	|	sender_id		|  integer	|
	|	receiver_id		|  integer	|
	|	content			|  varchar	|
	|	sent_date		|  datetime	|
	+------------------------------+
messages Example Input:
+---------------+--------------+-------------------+--------------------------+-----------------------+
|	message_id	|	sender_id	|	receiver_id		|	content					|	sent_date			|
+---------------+--------------+-------------------+--------------------------+-----------------------+
|	901			|	3601		|	4500			|	You up?					|	08/03/2022 00:00:00	|
|	902			|	4500		|	3601			|	Only if you're buying	|	08/03/2022 00:00:00	|
|	743			|	3601		|	8752			|	Let's take this offline	|	06/14/2022 00:00:00	|
|	922			|	3601		|	4500			|	Get on the call			|	08/10/2022 00:00:00	|
+---------------+--------------+-------------------+--------------------------+-----------------------+


Example Output:
	+---------------+------------------+
	|	sender_id	|	message_count	|
	+---------------+------------------+
	|	3601		|		2			|
	|	4500		|		1			|
	+---------------+------------------+
	
*/

-- Link of the problem: https://datalemur.com/questions/teams-power-users

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- 					Solution
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT
    sender_id,
    COUNT(message_id) AS msg_count
FROM messages
WHERE EXTRACT(MONTH FROM sent_date) = '8'
      AND EXTRACT(YEAR FROM sent_date)  = '2022'
GROUP BY sender_id
ORDER BY msg_count DESC
LIMIT 2;
