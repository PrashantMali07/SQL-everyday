-- SQL Project - Library Management System

-- Create a Database
CREATE DATABASE sql_project_library_management;

-- Creating table 'branch'
DROP TABLE IF EXISTS branch;
CREATE table branch() (
	branch_id VARCHAR(10) PRIMARY KEY, 
	manager_id VARCHAR(10),
	branch_address VARCHAR(50),
	contact_no VARCHAR(15)
);

-- Creating table 'employees'
DROP TABLE IF EXISTS employees; 
CREATE table employees (
	emp_id VARCHAR(10) PRIMARY KEY,
	emp_name VARCHAR(25),
	position VARCHAR(15),
	salary FLOAT,
	branch_id VARCHAR(10) -- FK branch(branch_id)
);

-- Creating table 'books'
DROP TABLE IF EXISTS books; 
CREATE table books (
	isbn VARCHAR(50) PRIMARY KEY,
	book_title VARCHAR(70),
	category VARCHAR(50),
	rental_price FLOAT,
	status VARCHAR(50),
	author VARCHAR(50),
	publisher VARCHAR(50)
);

-- Creating table 'members'
DROP TABLE IF EXISTS members; 
CREATE table members (
	member_id VARCHAR(5) PRIMARY KEY,
	member_name VARCHAR(25), 
	member_address VARCHAR(20),
	reg_date DATE
);

-- Creating table 'issued_status'
DROP TABLE IF EXISTS issued_status; 
CREATE table issued_status (
	issued_id VARCHAR(5) PRIMARY KEY,
	issued_member_id VARCHAR(5), -- FK members(member_id)
	issued_book_name VARCHAR(75),
	issued_date DATE,
	issued_book_isbn VARCHAR(20), -- FK books(isbn)
	issued_emp_id VARCHAR(20) -- employees(emp_id)
);

-- Creating table 'return_status'
DROP TABLE IF EXISTS return_status; 
CREATE table return_status (
	return_id VARCHAR(5) PRIMARY KEY,
	issued_id VARCHAR(5), -- FK issued_status(issued_id)
	return_book_name VARCHAR(75),
	return_date DATE,
	return_book_isbn VARCHAR(20) -- FK issued_status(issued_book_isbn)
);

-- Altering Tables and adding Foreign Key
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_emp_id
FOREIGN KEY (issued_emp_id)
REFERENCES employees(emp_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_id
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);


-- Got an error altering with FK in return_status table, so deleted the row where issued_id = 'IS101', 'IS103', 'IS105'
DELETE FROM return_status
WHERE issued_id = 'IS101';

DELETE FROM return_status
WHERE issued_id = 'IS105';

DELETE FROM return_status
WHERE issued_id = 'IS103';

SELECT * FROM return_status;