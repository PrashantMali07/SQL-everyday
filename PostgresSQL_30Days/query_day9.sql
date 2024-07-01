

-- 185. Department Top Three Salaries

/*
+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| id           | int     |
| name         | varchar |
| salary       | int     |
| departmentId | int     |
+--------------+---------+
id is the primary key (column with unique values) for this table.
departmentId is a foreign key (reference column) of the ID from the Department table.
Each row of this table indicates the ID, name, and salary of an employee. It also contains the ID of their department.
 

Table: Department

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table indicates the ID of a department and its name.
 

A company's executives are interested in seeing who earns the most money in each of the company's departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.

Write a solution to find the employees who are high earners in each of the departments.

Return the result table in any order.

The result format is in the following example.


Example 1:

Input: 
Employee table:
+----+-------+--------+--------------+
| id | name  | salary | departmentId |
+----+-------+--------+--------------+
| 1  | Joe   | 85000  | 1            |
| 2  | Henry | 80000  | 2            |
| 3  | Sam   | 60000  | 2            |
| 4  | Max   | 90000  | 1            |
| 5  | Janet | 69000  | 1            |
| 6  | Randy | 85000  | 1            |
| 7  | Will  | 70000  | 1            |
+----+-------+--------+--------------+
Department table:
+----+-------+
| id | name  |
+----+-------+
| 1  | IT    |
| 2  | Sales |
+----+-------+
Output: 
+------------+----------+--------+
| Department | Employee | Salary |
+------------+----------+--------+
| IT         | Max      | 90000  |
| IT         | Joe      | 85000  |
| IT         | Randy    | 85000  |
| IT         | Will     | 70000  |
| Sales      | Henry    | 80000  |
| Sales      | Sam      | 60000  |
+------------+----------+--------+

Explanation: 
In the IT department:
- Max earns the highest unique salary
- Both Randy and Joe earn the second-highest unique salary
- Will earns the third-highest unique salary

In the Sales department:
- Henry earns the highest salary
- Sam earns the second-highest salary
- There is no third-highest salary as there are only two employees
*/

-- Problem URL: https://leetcode.com/problems/department-top-three-salaries/description/

-- Creating the Department table
CREATE TABLE department(
	id INT PRIMARY KEY,
	department_name VARCHAR(50))
;

-- Creating the Employee table
CREATE TABLE Employee(
	id INT,
	name VARCHAR(50),
	salary INT,
	department_id INT,
FOREIGN KEY (department_id) REFERENCES department(id));

-- Insert records into the department table
INSERT INTO department (id, department_name,
			e.name) VALUES
	(1, 'IT'),
	(2, 'Sales');

-- Insert additional records into Employee table
INSERT INTO Employee (id, name, salary, department_id) VALUES
(1 , 'Joe'  , 85000, 1),
(2 , 'Henry', 80000, 2),
(3 , 'Sam'  , 60000, 2),
(4 , 'Max'  , 90000, 1),
(5 , 'Janet', 69000, 1),
(6 , 'Randy', 85000, 1),
(8, 'Alice', 75000, 2),
(9, 'Bob', 82000, 2),
(10, 'Carol', 78000, 1),
(11, 'David', 70000, 1),
(12, 'Eva', 85000, 2),
(13, 'Frank', 72000, 1),
(14, 'Gina', 83000, 1),
(15, 'Hank', 68000, 1),
(16, 'Irene', 76000, 2),
(17, 'Jack', 74000, 2),
(18, 'Kelly', 79000, 1),
(19, 'Liam', 71000, 1),
(20, 'Molly', 77000, 2),
(21, 'Nathan', 81000, 1),
(22, 'Olivia', 73000, 2),
(23, 'Peter', 78000, 1),
(24, 'Quinn', 72000, 1),
(25, 'Rachel', 80000, 2),
(26, 'Steve', 75000, 2),
(27, 'Tina', 79000, 1);

-- checking the enteries in table
select * from Employee;
select * from department;

-- Solution #1: SubQuery

SELECT
	department_name,
	emp_name,
	Salary
FROM
	(SELECT 
			d.department_name as department_name,
			e.name as emp_name,
			e.salary as Salary,
			DENSE_RANK() OVER(PARTITION BY d.department_name ORDER BY e.salary DESC) AS rn
	FROM Employee as e
	JOIN department as d
	ON e.department_id = d.id) final_table
WHERE rn <= 3;

-- Solution #2: with CTE
WITH max_salary AS
	(SELECT 
			d.department_name as department_name,
			e.name as emp_name,
			e.salary as Salary,
			DENSE_RANK() OVER(PARTITION BY d.department_name ORDER BY e.salary DESC) AS rn
	FROM Employee as e
	JOIN department as d
	ON e.department_id = d.id)
SELECT
	department_name,
	emp_name,
	Salary
FROM max_salary
WHERE rn < 4;
		