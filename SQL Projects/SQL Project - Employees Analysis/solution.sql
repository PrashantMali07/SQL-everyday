/*
SQL Assignment
Create the following Tables and insert the values accordingly and
Perform the tasks mentioned below.

Table:
	1.employee Table - employee_id(PK), first_name, last_name, salary, joining_date, department
	2.employee Bonus Table - employee_ref_id, bonus_amount, bonus_date
	3.employee Title Table - employee_ref_id, employee_title, affective_date

Tasks To Be Performed:
1 Display the “FIRST_NAME” from Employee table using the alias name
as Employee_name.
2 Display “LAST_NAME” from Employee table in upper case.
3 Display unique values of DEPARTMENT from EMPLOYEE table.
4 Display the first three characters of LAST_NAME from EMPLOYEE table.
5 Display the unique values of DEPARTMENT from EMPLOYEE table and
prints its length.
6 Display the FIRST_NAME and LAST_NAME from EMPLOYEE table into a
single column AS FULL_NAME.
a space char should separate them.
7 DISPLAY all EMPLOYEE details from the employee table
order by FIRST_NAME Ascending.
8. Display all EMPLOYEE details order by FIRST_NAME Ascending and
DEPARTMENT Descending.9 Display details for EMPLOYEE with the first name as “VEENA” and
“KARAN” from EMPLOYEE table.
10 Display details of EMPLOYEE with DEPARTMENT name as “Admin”.
11 DISPLAY details of the EMPLOYEES whose FIRST_NAME contains ‘V’.
12 DISPLAY details of the EMPLOYEES whose SALARY lies between
100000 and 500000.
13 Display details of the employees who have joined in Feb-2020.
14 Display employee names with salaries >= 50000 and <= 100000.
16 DISPLAY details of the EMPLOYEES who are also Managers.
17 DISPLAY duplicate records having matching data in some fields of a
table.
18 Display only odd rows from a table.
19 Clone a new table from EMPLOYEE table.
20 DISPLAY the TOP 2 highest salary from a table.
21. DISPLAY the list of employees with the same salary.
22 Display the second highest salary from a table.
23 Display the first 50% records from a table.
24. Display the departments that have less than 4 people in it.
25. Display all departments along with the number of people in there.
26 Display the name of employees having the highest salary in each
department.
27 Display the names of employees who earn the highest salary.
28 Diplay the average salaries for each department
29 display the name of the employee who has got maximum bonus
30 Display the first name and title of all the employees
*/

-- Creating employee table

DROP TABLE IF EXISTS employee;

CREATE TABLE employee(
	employee_id INT PRIMARY KEY, first_name VARCHAR(255), last_name VARCHAR(255), salary FLOAT, joining_date TIMESTAMP, department VARCHAR(50)
);

-- Creating employee_bonus table

DROP TABLE IF EXISTS employee_bonus;

CREATE TABLE employee_bonus(
	employee_ref_id INT, bonus_amount FLOAT, bonus_date TIMESTAMP, FOREIGN KEY (employee_ref_id) REFERENCES employee(employee_id)
);

-- Creating employee_ table

DROP TABLE IF EXISTS employee_title;

CREATE TABLE employee_title(
	employee_ref_id INT, employee_title VARCHAR(50), affective_date TIMESTAMP,FOREIGN KEY (employee_ref_id) REFERENCES employee(employee_id)
);


-- inserting values into the above created table

INSERT INTO employee
VALUES(1,'Anika','Arora',100000,'2020-02-14 9:00:00','HR'),
	(2,'Veena','Verma',80000,'2011-06-15 9:00:00','Admin'),
	(3,'Vishal','Singhal',300000,'2020-02-16 9:00:00','HR'),
	(4,'Sushanth','Singh',500000,'2020-02-17 9:00:00','Admin'),
	(5,'Bhupal','Bhati',500000,'2011-06-18 9:00:00','Admin'),
	(6,'Dheeraj','Diwan',200000,'2011-06-19 9:00:00','Account'),
	(7,'Karan','Kumar',75000,'2020-01-14 9:00:00','Account'),
	(8,'Chandrika','Chauhan',90000,'2011-04-15 9:00:00','Admin');


INSERT INTO employee_bonus
VALUES(1,5000,'2020-02-16 0:00:00'),
		(2,3000,'2011-06-16 0:00:00'),
		(3,4000,'2020-02-16 0:00:00'),
		(1,4500,'2020-02-16 0:00:00'),
		(2,3500,'2011-06-16 0:00:00');

INSERT INTO employee_title
VALUES(1,'Manager','2016-02-20 0:00:00'),
	(2,'Executive','2016-06-11 0:00:00'),
	(8,'Executive','2016-06-11 0:00:00'),
	(5,'Manager','2016-06-11 0:00:00'),
	(4,'Asst Manager','2016-06-11 0:00:00'),
	(7,'Executive','2016-06-11 0:00:00'),
	(6,'Lead','2016-06-11 0:00:00'),
	(3,'Lead','2016-06-11 0:00:00');

SELECT * FROM employee;
SELECT * FROM employee_bonus;
SELECT * FROM employee_title;

-- ======================================
-- *			SOLUTION				*
-- ======================================

-- 1 Display the “FIRST_NAME” from Employee table using the alias name as Employee_name.

SELECT
	first_name AS Employee_name
FROM
	employee;

-- 2 Display “LAST_NAME” from Employee table in upper case.

SELECT
	UPPER(last_name) AS LAST_NAME
FROM
	employee;

-- 3 Display unique values of DEPARTMENT from EMPLOYEE table.

SELECT
	DISTINCT department AS Active_department
FROM
	employee;

-- 4 Display the first three characters of LAST_NAME from EMPLOYEE table.

SELECT
	LEFT(last_name,3) AS first_three_char
FROM
	employee;

-- 5 Display the unique values of DEPARTMENT from EMPLOYEE table and prints its length.

SELECT
	department_name,
	LENGTH(department_name) as char_len
FROM
	(SELECT
		DISTINCT department AS department_name
	FROM
		employee) x1;

-- 6 Display the FIRST_NAME and LAST_NAME from EMPLOYEE table into a single column AS FULL_NAME. a space char should separate them.

SELECT
	CONCAT(first_name, ' ', last_name) AS full_name
FROM
	employee;

-- 7 DISPLAY all EMPLOYEE details from the employee tablec order by FIRST_NAME Ascending.

SELECT
	*
FROM
	employee
ORDER BY first_name ASC;

-- 8. Display all EMPLOYEE details order by FIRST_NAME Ascending and DEPARTMENT Descending.

SELECT
	*
FROM
	employee
ORDER BY first_name ASC, department DESC;

-- 9 Display details for EMPLOYEE with the first name as “VEENA” and “KARAN” from EMPLOYEE table.

SELECT
	*
FROM
	employee
WHERE first_name IN ('Veena','Karan');


-- 10 Display details of EMPLOYEE with DEPARTMENT name as “Admin”.

SELECT
	*
FROM
	employee
WHERE department = 'Admin';

-- 11 DISPLAY details of the EMPLOYEES whose FIRST_NAME contains ‘V’.

SELECT
	*
FROM
	employee
WHERE first_name LIKE '%V%';

-- 12 DISPLAY details of the EMPLOYEES whose SALARY lies between
-- 100000 and 500000.

SELECT
	*
FROM
	employee
WHERE salary BETWEEN 100000 AND 500000;

-- 13 Display details of the employees who have joined in Feb-2020.

SELECT
	*
FROM
	employee
WHERE EXTRACT(MONTH FROM joining_date) = '2'
AND EXTRACT(YEAR FROM joining_date) = '2020';

-- 14 Display employee names with salaries >= 50000 and <= 100000.

SELECT
	*
FROM
	employee
WHERE salary>= 50000 AND salary<= 100000;

-- 16 DISPLAY details of the EMPLOYEES who are also Managers.

SELECT * FROM employee;
SELECT * FROM employee_title;

SELECT
	e.employee_id,
	e.first_name,
	e.last_name,
	e.salary,
	e.joining_date,
	e.department,
	et.employee_title
FROM employee as e
JOIN employee_title as et
ON e.employee_id = et.employee_ref_id
WHERE et.employee_title = 'Manager';

-- 17 DISPLAY duplicate records having matching data in some fields of a table.

SELECT
	salary,
	department,
	COUNT(*)
FROM
	employee
GROUP BY salary, department
HAVING COUNT(*)>1;


-- 18 Display only odd rows from a table.

SELECT
	employee_id,
	first_name,
	last_name,
	salary,
	joining_date,
	department
FROM
	(SELECT *, ROW_NUMBER() OVER(ORDER BY employee_id) as RowID
		FROM employee) x1
WHERE (x1.RowID % 2) = 1;

-- 19 Clone a new table from EMPLOYEE table.

CREATE TABLE new_employee (LIKE employee);
INSERT INTO new_employee SELECT * FROM employee;

SELECT * FROM new_employee;

-- 20 DISPLAY the TOP 2 highest salary from a table.

SELECT 
	employee_id, first_name, last_name, salary, joining_date, department
FROM
	(SELECT 
		*,
		DENSE_RANK() OVER (ORDER BY salary DESC) AS drank
	FROM
		employee) e
WHERE drank < 3;

-- 21. DISPLAY the list of employees with the same salary.

SELECT
	employee_name
FROM
		(SELECT 
			CONCAT(first_name, ' ', last_name) AS employee_name,
			salary,
			DENSE_RANK() OVER (ORDER BY salary DESC) AS drank
		FROM employee)
WHERE drank = 1;

-- 22 Display the second highest salary from a table.

SELECT
	salary as second_highest_salary
FROM
		(SELECT 
			CONCAT(first_name, ' ', last_name) AS employee_name,
			salary,
			DENSE_RANK() OVER (ORDER BY salary DESC) AS drank
		FROM employee)
WHERE drank = 2;

-- 23 Display the first 50% records from a table.

SELECT
	employee_id,
	first_name,
	last_name,
	salary,
	joining_date,
	department
FROM
	(SELECT *, PERCENT_RANK() OVER(ORDER BY employee_id) as prn
		FROM employee) x1
WHERE x1.prn <= 0.5;

-- 24. Display the departments that have less than 4 people in it.

SELECT
	department,
	COUNT(department) emp_count_in_department
FROM employee
GROUP BY department
HAVING COUNT(department) < 4;


-- 25. Display all departments along with the number of people in there.

SELECT
	department,
	COUNT(department) emp_count_in_department
FROM employee
GROUP BY department;

-- 26 Display the name of employees having the highest salary in each department.

SELECT
	employee_name,
	salary,
	department
FROM
		(SELECT 
			CONCAT(first_name, ' ', last_name) AS employee_name,
			salary,
			department,
			DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS drank
		FROM employee GROUP BY first_name, last_name, salary, department)
WHERE drank = 1;

-- 27 Display the names of employees who earn the highest salary.

SELECT
	employee_name
FROM
		(SELECT 
			CONCAT(first_name, ' ', last_name) AS employee_name,
			salary,
			department,
			DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS drank
		FROM employee GROUP BY first_name, last_name, salary, department)
WHERE drank = 1;

-- 28 Diplay the average salaries for each department

SELECT
	department,
	AVG(salary) AS avg_salary
FROM employee
GROUP BY department;

-- 29 display the name of the employee who has got maximum bonus

SELECT
	CONCAT(f_name, ' ' , l_name) AS employee_name
	-- ,bonus_amount
FROM 
	(SELECT
		e.first_name as f_name,
		e.last_name as l_name,
		eb.bonus_amount bonus_amount
	FROM
		employee e
	JOIN employee_bonus eb
	ON e.employee_id = eb.employee_ref_id) x
ORDER BY bonus_amount DESC
LIMIT 1;

-- to verify

SELECT
	e.first_name as f_name,
	e.last_name as l_name,
	eb.bonus_amount bonus_amount
FROM
	employee e
JOIN employee_bonus eb
ON e.employee_id = eb.employee_ref_id
ORDER BY bonus_amount DESC;

-- 30 Display the first name and title of all the employees

SELECT 
	e.first_name first_name,
	et.employee_title title
FROM 
	employee e
JOIN employee_title et
ON e.employee_id = et.employee_ref_id;