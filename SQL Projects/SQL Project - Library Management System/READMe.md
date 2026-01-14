# Library Management System - SQL Project

## 1. Topics Covered

This project covers a comprehensive range of SQL topics, demonstrating data management and analytical capabilities within a Relational Database Management System (RDBMS).

* **Database Design & Schema:** Table creation, Primary Keys, Foreign Keys, and Constraints.
* **CRUD Operations:** Create, Read, Update, and Delete records.
* **Data Definition Language (DDL):** Creating databases, tables, and altering table structures.
* **Data Manipulation Language (DML):** Inserting data, updating records, and performing complex deletions.
* **Advanced Querying:** `GROUP BY`, `HAVING`, `ORDER BY`, and `JOINs` (Inner, Left, Self).
* **Stored Procedures:** Automating business logic (e.g., issuing and returning books) using PL/pgSQL.
* **Date & Time Functions:** Handling intervals, timestamps, and date formatting for overdue calculations.
* **CTAS (Create Table As Select):** Generating summary tables and performance reports from existing query results.

## 2. Description of Operations Performed

The project involves several key operational workflows common in library management:

* **Library Setup:** Establishing the database architecture with tables for `branch`, `employees`, `books`, `members`, `issued_status`, and `return_status`.
* **Inventory Management:** Adding new books, updating book details, and checking stock availability.
* **Member Management:** Registering members and updating their contact information.
* **Circulation Control:**
* **Issuing Books:** Validating book availability and recording issue dates.
* **Returning Books:** Updating return dates, calculating fines, and updating book status (Good/Damaged).


* **Financial Analysis:** Analyzing rental revenue based on book categories and calculating potential fines for overdue items.
* **Staff Performance:** Tracking books issued by specific employees and generating branch-level performance reports.

## 3. Useful Functions & Logic Applied

The following functions and SQL logic were utilized to manage the data effectively:

* **`make_date(year, month, day)`:** Used to standardize dates for analysis (e.g., updating historical data to the current year 2025).
* **`CURRENT_DATE - INTERVAL 'x days'`:** Essential for filtering records within specific timeframes (e.g., "last 180 days").
* **`EXTRACT(part FROM date)`:** Used to isolate specific date components (Day, Month) during data updates.
* **`CREATE OR REPLACE PROCEDURE`:** Encapuslates logic to perform multiple actions in a single call (e.g., inserting a return record AND updating the book's availability status simultaneously).
* **`RAISE NOTICE`:** Used within procedures to provide feedback messages to the user upon successful execution.
* **`CTAS` (Create Table As Select):** Used to snapshot complex analytical queries into static tables for reporting (e.g., `active_members`, `branch_reports`).

---

## 4. Project Tasks & Queries

Below are the solutions for the tasks outlined in the project, derived from `query_medium+advanced.sql`.

### Task 1: Create a New Book Record

Objective: Insert a new book record into the `books` table.

```sql
INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

```

### Task 2: Update an Existing Member's Address

Objective: Update the address for member 'C101'.

```sql
UPDATE members
SET member_address = '127 Vyse st'
WHERE member_id = 'C101';

```

### Task 3: Delete a Record from the Issued Status Table

Objective: Delete the record with `issued_id = 'IS104'`.

```sql
DELETE FROM issued_status
WHERE issued_id = 'IS104';

```

### Task 4: Retrieve All Books Issued by a Specific Employee

Objective: Select all books issued by the employee with `emp_id = 'E101'`.

```sql
SELECT issued_book_name, issued_book_isbn FROM issued_status
WHERE issued_emp_id = 'E101';

```

### Task 5: List Members Who Have Issued More Than One Book

Objective: Find members who have issued multiple books.

```sql
SELECT
	issued_emp_id,
	COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;

```

### Task 6: Create Summary Tables (CTAS)

Objective: Create a table `issued_book_count` based on book issuance frequency.

```sql
CREATE TABLE issued_book_count AS 
SELECT
	b.isbn,
	b.book_title,
	COUNT(ist.issued_id) AS issued_book_count
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2
ORDER BY 3 DESC;

```

### Task 7: Retrieve All Books in a Specific Category

Objective: Fetch books from the 'Classic' category.

```sql
SELECT
	category,
	book_title
FROM books
WHERE category = 'Classic';

```

### Task 8: Find Total Rental Income by Category

Objective: Calculate total rental price and count of issued books per category.

```sql
SELECT
	b.category,
	SUM(b.rental_price) AS total_rental_price,
	COUNT(*) AS book_issued_count
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1
ORDER BY 2 DESC;

```

### Task 9: List Members Who Registered in the Last 180 Days

Objective: Find recently registered members.

```sql
SELECT 
	*
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

```

### Task 10: List Employees with Their Branch Manager's Name

Objective: Use a Self Join to link employees to their branch managers.

```sql
SELECT
	e1.emp_name AS employee_name,
	e2.emp_name AS manager_name,
	br.branch_id,
	br.branch_address
FROM employees AS e1
JOIN branch AS br	
ON br.branch_id = e1.branch_id
JOIN employees AS e2
ON e2.emp_id = br.manager_id;

```

### Task 11: Create a Table of Books with Rental Price > $7

Objective: Use CTAS to filter expensive books.

```sql
CREATE TABLE books_rental_price_GreaterThanSeven AS
SELECT * FROM books
WHERE rental_price > 7;

```

### Task 12: Retrieve the List of Books Not Yet Returned

Objective: Identify books that are currently issued but have no return record.

```sql
SELECT 
	ist.issued_book_name AS books_not_returned
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;

```

### Task 13: Identify Members with Overdue Books

Objective: Identify members with books issued more than 30 days ago that have not been returned.

```sql
SELECT
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	CURRENT_DATE - ist.issued_date AS due_by_days
FROM issued_status AS ist
JOIN members AS m
ON ist.issued_member_id = m.member_id
JOIN books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
ON rs.issued_id = ist.issued_id 
WHERE rs.return_id IS NULL
		AND
		(CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;

```

### Task 14: Update Book Status on Return (Stored Procedure)

Objective: A stored procedure that inserts a return record and updates the book's status to 'yes' (available).

```sql
CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    INSERT INTO return_status(return_id, issued_id, return_date, book_quality)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE, p_book_quality);

    SELECT 
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;
    
END;
$$

```

### Task 15: Branch Performance Report

Objective: Generate a report showing books issued, returned, and revenue per branch.

```sql
CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY 1, 2;

```

### Task 16: CTAS: Create a Table of Active Members

Objective: Create a table of members who issued a book in the last 2 months.

```sql
CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    );

```

### Task 17: Find Employees with the Most Book Issues Processed

Objective: Identify the top employees by issuance volume.

```sql
SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2;

```

### Task 18: Identify Members Issuing High-Risk Books

Objective: Find members who have returned books marked as 'Damaged'.

```sql
SELECT
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	COUNT(ist.issued_id) AS issued_count
FROM issued_status AS ist
JOIN members AS m
ON ist.issued_member_id = m.member_id
JOIN books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
ON rs.issued_id = ist.issued_id 
WHERE rs.book_quality = 'Damaged'
GROUP BY 1,2,3;

```

### Task 19: Stored Procedure for Issuing Books

Objective: A procedure to check book availability before issuing it. If available, it issues the book and updates the status to 'no'.

```sql
CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_status VARCHAR(10);

BEGIN
    -- checking if book is available 'yes'
    SELECT 
        status 
        INTO
        v_status
    FROM books
    WHERE isbn = p_issued_book_isbn;

    IF v_status = 'yes' THEN

        INSERT INTO issued_status(issued_id, issued_member_id, issued_date, issued_book_isbn, issued_emp_id)
        VALUES
        (p_issued_id, p_issued_member_id, CURRENT_DATE, p_issued_book_isbn, p_issued_emp_id);

        UPDATE books
            SET status = 'no'
        WHERE isbn = p_issued_book_isbn;

        RAISE NOTICE 'Book records added successfully for book isbn : %', p_issued_book_isbn;

    ELSE
        RAISE NOTICE 'Sorry to inform you the book you have requested is unavailable book_isbn: %', p_issued_book_isbn;
    END IF;
END;
$$

```

### Task 20: CTAS - Overdue Books and Fines

Objective: Create a table calculating fines ($0.54/day) for members with books overdue by >30 days.

```sql
CREATE TABLE applicable_fines
AS
SELECT
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	CURRENT_DATE - ist.issued_date AS due_by_days,
	(CURRENT_DATE - ist.issued_date) * 0.54 AS total_fine
FROM issued_status AS ist
JOIN members AS m
ON ist.issued_member_id = m.member_id
JOIN books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN return_status AS rs
ON rs.issued_id = ist.issued_id 
WHERE rs.return_id IS NULL
		AND
		(CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;

```

---

## 5. Pointers about `schemas.sql`

The `schemas.sql` file is responsible for the foundational setup of the project.

* **Initialization:** It creates the database `sql_project_library_management`.
* **Table Creation:** It defines the structure for 6 main tables:
* `branch`: Stores branch details and manager information.
* `employees`: Stores staff details, linked to branches.
* `books`: Stores bibliographic data, rental price, and availability status.
* `members`: Stores library user registration data.
* `issued_status`: A transaction table recording book issues.
* `return_status`: A transaction table recording book returns.


* **Relationships:** It enforces data integrity by adding Foreign Key constraints (e.g., linking `issued_status` to `members`, `books`, and `employees`).
* **Data Cleaning:** The file includes `DELETE` statements at the end to handle specific records (`IS101`, `IS103`, `IS105`) in `return_status` that caused foreign key constraint errors during the setup process.
