-- SQL Project - Library system management

-- Checking all the created table

SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;

-- Project TASK


-- ### 2. CRUD Operations


-- Task 1. Create a New Book Record
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

-- Task 2: Update an Existing Member's Address
UPDATE members-- updating the first row's address where member_id = C101
SET member_address = '127 Vyse st'
WHERE member_id = 'C101';
SELECT * FROM members;

-- Task 3: Delete a Record from the Issued Status Table
-- Objective: Delete the record with issued_id = 'IS104' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS104';

-- Task 4: Retrieve All Books Issued by a Specific Employee
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT issued_book_name, issued_book_isbn FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT
	issued_emp_id,
	COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;

-- ### 3. CTAS (Create Table As Select)

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt

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

-- Verify the table
SELECT * FROM issued_book_count;

-- ### 4. Data Analysis & Findings

-- Task 7. **Retrieve All Books in a Specific Category:

SELECT
	category,
	book_title
FROM books
GROUP BY 1,2
WHERE category = 'Classic';


-- Task 8: Find Total Rental Income by Category:


SELECT
	b.category,
	SUM(b.rental_price) AS total_rental_price,
	COUNT(*) AS book_issued_count
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1
ORDER BY 2 DESC;


-- Task 9. **List Members Who Registered in the Last 180 Days**:

-- Checking the member able
SELECT * FROM members;

-- All dates are from year '2021', need to create few enteries to write required query

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES ('C120', 'Robert Tame', '458 Eve St', '2025-11-09'),
	   ('C121', 'Chris Evans', '905 Rook St', '2025-09-25');

SELECT 
	*
FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days'
	   
-- Task 10: List Employees with Their Branch Manager's Name and their branch details**:

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

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold
CREATE TABLE books_rental_price_GreaterThanSeven AS
SELECT * FROM books
WHERE rental_price > 7;

SELECT * FROM books_rental_price_GreaterThanSeven;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
	ist.issued_book_name AS books_not_returned
FROM issued_status AS ist
LEFT JOIN return_status AS rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL;
    
-- ### Advanced SQL Operations

-- Task 13: Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 30-day return period). Display the member's name, book title, issue date, and days overdue.

-- Changing the year as '2025' for all the date column in each table
SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;

-- Updating members table
UPDATE members 
SET reg_date = make_date(2025, EXTRACT(MONTH FROM reg_date)::integer, EXTRACT(DAY FROM reg_date)::integer)
WHERE reg_date IS NOT NULL;

-- Updating issued_status table
UPDATE issued_status 
SET issued_date = make_date(2025, EXTRACT(MONTH FROM issued_date)::integer, EXTRACT(DAY FROM issued_date)::integer)
WHERE issued_date IS NOT NULL;

-- Updating return_status table
UPDATE return_status 
SET return_date = make_date(2025, EXTRACT(MONTH FROM return_date)::integer, EXTRACT(DAY FROM return_date)::integer)
WHERE return_date IS NOT NULL;

-- Logic for the Task 13: issued_status JOIN members JOIN books LEFT JOIN return_status
-- Filter books which is return
-- Overdue by >30 days
SELECT
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	-- rs.return_date,
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

-- Task 14: Update Book Status on Return
-- Write a query to update the status of books in the books table to "available" when they are returned (based on entries in the return_status table).

--Altering Table and adding a column 'book_quality'
ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(10);

-- Adding values in the new column
UPDATE return_status
SET book_quality = 'Damaged'
WHERE issued_id IN ('IS112', 'IS117', 'IS118');

UPDATE return_status
SET book_quality = 'Good'
WHERE book_quality IS NULL;

-- SQL query for TASK 14

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);
    
BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
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


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM return_status
WHERE issued_id = 'IS135';

-- calling function 
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function 
CALL add_return_records('RS148', 'IS140', 'Good');

-- Task 15: Branch Performance Report
-- Create a query that generates a performance report for each branch, showing the number of books issued, the number of books returned, and the total revenue generated from book rentals.

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

SELECT * FROM branch_reports;

-- Task 16: CTAS: Create a Table of Active Members
-- Use the CREATE TABLE AS (CTAS) statement to create a new table active_members containing members who have issued at least one book in the last 6 months.

CREATE TABLE active_members
AS
SELECT * FROM members
WHERE member_id IN (SELECT 
                        DISTINCT issued_member_id   
                    FROM issued_status
                    WHERE 
                        issued_date >= CURRENT_DATE - INTERVAL '2 month'
                    )
;

SELECT * FROM active_members;

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. Display the employee name, number of books processed, and their branch.

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
GROUP BY 1, 2

-- Task 18: Identify Members Issuing High-Risk Books
-- Write a query to identify members who have issued books more than twice with the status "damaged" in the books table. Display the member name, book title, and the number of times they've issued damaged books.    

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

-- Task 19: Stored Procedure
-- Objective: Create a stored procedure to manage the status of books in a library system.
--     Description: Write a stored procedure that updates the status of a book based on its issuance or return. Specifically:
--     If a book is issued, the status should change to 'no'.
--     If a book is returned, the status should change to 'yes'.

CREATE OR REPLACE PROCEDURE issue_book(p_issued_id VARCHAR(10), p_issued_member_id VARCHAR(30), p_issued_book_isbn VARCHAR(30), p_issued_emp_id VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
-- all the variabable
    v_status VARCHAR(10);

BEGIN
-- all the code
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

-- Testing The function
SELECT * FROM books;
-- "978-0-553-29698-2" -- yes
-- "978-0-375-41398-8" -- no
SELECT * FROM issued_status;

CALL issue_book('IS155', 'C108', '978-0-553-29698-2', 'E104');
CALL issue_book('IS156', 'C108', '978-0-375-41398-8', 'E104');

SELECT * FROM books
WHERE isbn = '978-0-375-41398-8'

-- Task 20: Create Table As Select (CTAS)
-- Objective: Create a CTAS (Create Table As Select) query to identify overdue books and calculate fines.

-- LOGIC: 
-- Description: Write a CTAS query to create a new table that lists each member and the books they have issued but not returned within 30 days. The table should include:
--     The number of overdue books.
--     The total fines, with each day's fine calculated at $0.54.
--     The number of books issued by each member.
--     The resulting table should show:
--     Member ID
--     Number of overdue books
--     Total fines
CREATE TABLE applicable_fines
AS
SELECT
	ist.issued_member_id,
	m.member_name,
	bk.book_title,
	ist.issued_date,
	-- rs.return_date,
	CURRENT_DATE - ist.issued_date AS due_by_days,
	(CURRENT_DATE - ist.issued_date) * 0.54 AS total_fine -- Apply fine of $0.54 per day
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