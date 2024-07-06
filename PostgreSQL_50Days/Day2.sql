

-- Day 2

/*

Given the Orders table with columns OrderID, OrderDate, and TotalAmount, and the
Returns table with columns ReturnID and OrderID.


1. Write an SQL query to calculate the total numbers of returned orders for each month.

*/


-- Create Orders table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2)
);

-- Inserting random records into Orders table
INSERT INTO Orders (OrderID, OrderDate, TotalAmount)
VALUES
(1, '2023-01-05', 120.50),
(2, '2023-02-15', 230.75),
(3, '2023-03-20', 150.00),
(4, '2023-04-10', 300.25),
(5, '2023-05-12', 180.00),
(6, '2023-06-25', 210.80),
(7, '2023-07-08', 175.50),
(8, '2023-08-19', 260.00),
(9, '2023-09-22', 195.30),
(10, '2023-10-14', 280.90),
(11, '2023-11-30', 320.25),
(12, '2023-12-05', 200.60);

-- Create Returns table
CREATE TABLE Returns (
    ReturnID INT PRIMARY KEY,
    OrderID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insertin records into Returns table
-- Assuming we randomly link some Orders to Returns for demonstration
INSERT INTO Returns (OrderID, ReturnID)
VALUES
(1, 101),
(2, 103),
(2, 105),
(4, 107),
(5, 109),
(4, 111),
(7, 102),
(5, 104),
(3, 106),
(8, 108);


SELECT * FROM Orders;
SELECT * FROM Returns;

SELECT
	EXTRACT(MONTH FROM o.orderdate) || '-' || EXTRACT(YEAR FROM o.orderdate) as MonthYear,
	COUNT(r.ReturnID) as TotalReturns
FROM Returns as r
LEFT JOIN Orders as O
ON r.OrderID = o.OrderID
GROUP BY 1
ORDER BY 1;

