# Dataset Overview

- **Total records:** 1,117,957  
- **Features:** 21 numeric predictors (e.g., *feature_1* … *feature_21*)  
- **Target variable:** 1 binary/continuous column named `target`  
- **Data type:** Mostly continuous; some features exhibit mild skewness.  
- **Missing values:** < 0.5% across all columns, handled with mean imputation in the preprocessing pipeline.  
- **Outlier handling:** Outliers identified via IQR and 3σ rules; removed or robustly scaled depending on feature importance (see `preprocessing.py`).  

This dataset is ready for exploratory analysis, model training, and benchmarking of machine‑learning algorithms.  

---

## SQL Project – Retail Sales Analysis  
*(README for `retail_sales_query.sql`)*  

---

### 📚 Overview

This repository contains a single **SQL script** that creates, populates, cleans and explores a small retail‑sales dataset.  
The goal is to demonstrate end‑to‑end data engineering skills:

1. **Database & Table creation**
2. **Data ingestion / cleaning**
3. **Exploratory Data Analysis (EDA)**
4. **Business‑focused queries**

Feel free to run the script on any PostgreSQL or compatible RDBMS that supports standard SQL.

---

## 🛠️ Steps Performed

| Step | Description | Key SQL Statements |
|------|-------------|--------------------|
| 1 | Create a new database | `CREATE DATABASE sql_project_retail_sales;` |
| 2 | Drop and recreate the main table | `DROP TABLE IF EXISTS retail_sales;`<br>`CREATE TABLE retail_sales (...);` |
| 3 | Verify empty table | `SELECT * FROM retail_sales;` |
| 4 | Load data (CSV or Git‑pull) – **placeholder** | *(not included in script, but you can use `COPY` or a staging table)* |
| 5 | Clean the data<br>• Check for NULLs (excluding gender/age)<br>• Delete rows containing NULLs | `SELECT … WHERE … IS NULL;`<br>`DELETE FROM retail_sales WHERE … IS NULL;` |
| 6 | Basic EDA<br>• Total sales count<br>• Unique customers<br>• Category counts | `COUNT(*)`, `COUNT(DISTINCT customer_id)`, `COUNT(DISTINCT category)` |
| 7 | Business queries (10 in total)<br>Examples: top customers, average age for Beauty category, shift‑based order counts, etc. | See the **Queries** section below |

---

## 📦 How to Run

```bash
# Connect to PostgreSQL
psql -U <user> -d postgres

# Drop & create database (if not already present)
DROP DATABASE IF EXISTS sql_project_retail_sales;
CREATE DATABASE sql_project_retail_sales;

# Switch to the new database
\c sql_project_retail_sales

# Run the script
\i path/to/sql_project_retail_sales.sql
```

> **Tip**: If you are using a GUI (pgAdmin, DBeaver, etc.), simply open the file and execute all statements.

---

## 📊 Business Queries – What They Reveal

| Query | Purpose |
|-------|---------|
| **Q1** | Retrieve every column for sales on 2022‑11‑05. Useful for audit or deep dives on a specific day. |
| **Q2** | Find *Clothing* transactions with high quantity in Nov‑22 – helps spot bulk purchases or inventory issues. |
| **Q3** | Sum of `total_sale` per category; gives revenue breakdown by product line. |
| **Q4** | Average age of Beauty customers – informs targeted marketing campaigns. |
| **Q5** | High‑value transactions ( > $1000 ) – useful for fraud detection or VIP customer identification. |
| **Q6** | Transactions count per gender & category – measures demographic preferences. |
| **Q7** | Monthly average sales and best‑selling month each year – supports seasonal planning. |
| **Q8** | Top 5 customers by total spend – ideal for loyalty programs. |
| **Q9** | Unique customer count per category – gauges brand reach. |
| **Q10** | Shift classification (Morning, Afternoon, Evening) and order counts – helps staffing & logistics decisions. |

---

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

---

## 🔍 Useful Learnings

1. **Data Cleaning in SQL**  
   * Checking for NULLs across multiple columns and removing them keeps downstream analysis reliable.*

2. **Date/Time Manipulation**  
   * `EXTRACT` and `TO_CHAR` let you slice data by month, year, or hour without external tools.*

3. **Window Functions**  
   * `RANK()` used in Q7 to pick the best‑selling month per year—great for ranking scenarios.*

4. **Conditional Aggregation**  
   * The CASE expression in Q10 shows how to bucket continuous values (hours) into categories.*

5. **Performance Tips**  
   * Index on primary key (`transactions_id`) and frequently queried columns (`sale_date`, `category`) can speed up the queries.*

6. **Reproducibility**  
   * By scripting every step, you ensure that another analyst or data scientist can reproduce the same environment.*

---

## 📁 File Structure

```
sql_project_retail_sales/
├── sql_project_retail_sales.sql   # Main script (this file)
├── SQL - Retail Sales Analysis_utf .csv
└── README.md                      # This document
```

---

### 📝 Final Note

Feel free to extend this project by adding more analytical queries, visualizations (via BI tools), or automated reporting. Happy querying!
