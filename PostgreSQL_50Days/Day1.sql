-- DAY 1

-- Creating table

CREATE TABLE employees (
    name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);

INSERT INTO employees (name, department, salary)
VALUES
('Alice Johnson', 'Sales', 60000.00),
('Bob Smith', 'Marketing', 55000.00),
('Charlie Brown', 'Engineering', 62000.00),
('David Lee', 'Marketing', 58000.00),
('Emma Garcia', 'Sales', 54000.00),
('Frank Wilson', 'Marketing', 57000.00),
('Grace Martinez', 'Engineering', 53000.00),
('Henry Taylor', 'Sales', 65000.00),
('Ivy Anderson', 'Marketing', 56000.00),
('Jack Harris', 'Engineering', 61000.00);

/*

1. Write a SQL Query to find the second highest salary?

*/

-- My Solution

-- First Approach = this will fail when we have duplicate enteries for salary column

SELECT * FROM employees
	ORDER BY salary DESC
	LIMIT 1 OFFSET 1; -- OFFSET Helps to skip/filter the number of records


-- Second Approach = this won't fail
SELECT name, department, salary
	FROM
	(
	SELECT *,
			DENSE_RANK() OVER(ORDER BY salary DESC) as rnk
	FROM employees
	)
WHERE rnk = 2;


-- Adding 2 more records having some duplicate salaries

INSERT INTO employees (name, department, salary)
VALUES
('Karen Scott', 'Marketing', 62000.00),  -- Duplicate salary
('Liam Wilson', 'Sales', 55000.00);      -- Duplicate salary


/*

2. Get the second highest salary from the each departments

*/

WITH RankedSalary AS (
			SELECT name, department, salary,
				DENSE_RANK() OVER(PARTITION BY department ORDER BY salary DESC) as rnk
			FROM employees
			)

SELECT name, department, salary
FROM RankedSalary
WHERE rnk = 2;
