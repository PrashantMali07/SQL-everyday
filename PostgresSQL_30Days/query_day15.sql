-- SQL Challenge 15th Day 

CREATE TABLE Flipkart_sales (
    SaleID SERIAL PRIMARY KEY,
    Region VARCHAR(50),
    Amount DECIMAL(10, 2),
    SaleDate DATE
);

INSERT INTO Flipkart_sales (Region, Amount, SaleDate) VALUES
('North', 5000.00, '2024-04-01'),
('South', 6000.00, '2024-04-02'),
('East', 4500.00, '2024-04-03'),
('West', 7000.00, '2024-04-04'),
('North', 5500.00, '2024-04-05'),
('South', 6500.00, '2024-04-06'),
('East', 4800.00, '2024-04-07'),
('West', 7200.00, '2024-04-08'),
('North', 5200.00, '2024-04-09'),
('South', 6200.00, '2024-04-10'),
('East', 4700.00, '2024-04-11'),
('West', 7100.00, '2024-04-12'),
('North', 5300.00, '2024-04-13'),
('South', 6300.00, '2024-04-14'),
('East', 4600.00, '2024-04-15'),
('West', 7300.00, '2024-04-16'),
('North', 5400.00, '2024-04-17'),
('South', 6400.00, '2024-04-18'),
('East', 4900.00, '2024-04-19'),
('West', 7400.00, '2024-04-20'),
('North', 5600.00, '2024-04-21'),
('South', 6600.00, '2024-04-22'),
('East', 5000.00, '2024-04-23'),
('West', 7500.00, '2024-04-24'),
('North', 5700.00, '2024-04-25'),
('South', 6700.00, '2024-04-26'),
('East', 5100.00, '2024-04-27'),
('West', 7600.00, '2024-04-28');



-- Flipkart Business Analyst entry level SQL question

/*

Identify the region with the lowest sales amount for the previous month. 
return region name and total_sale amount.

*/
-- region and sum sale
-- filter last month
-- lowest sale region

-- -----------------------------------------------------
-- My Solution
-- -----------------------------------------------------

SELECT
	Region,
	SUM(Amount) total_sales
FROM Flipkart_sales
WHERE EXTRACT(MONTH FROM SaleDate) = EXTRACT(MONTH FROM CURRENT_DATE - INTERVAL '1 MONTH')
	AND EXTRACT(YEAR FROM SaleDate) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY Region
ORDER BY total_sales
LIMIT 1;