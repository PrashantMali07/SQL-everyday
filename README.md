# SQL Everyday

**Repository:** [https://github.com/PrashantMali07/SQL-everyday](https://github.com/PrashantMali07/SQL-everyday)  
**Author:** PrashantMali07

## Overview
This repository serves as a comprehensive collection of SQL projects, queries, and database management scripts designed to demonstrate proficiency in SQL. The projects cover end-to-end database implementation, from schema design to advanced data analysis and stored procedures.

---

## 📂 Project 1: Library Management System

**Folder Name:** `SQL Project - Library Management System`

### 📖 Project Description
The **Library Management System** is a relational database project that simulates the core operations of a library. It manages branches, employees, members, books, and their circulation status (issued/returned). The system is designed to track inventory, handle transactions, and generate performance reports.

---

### 📂 Project 2: Retail Sales Analysis SQL Project

**Folder Name:** `SQL Project - Retail Sales Analysis`

#### 📖 Project Overview

This project involves the analysis of a retail sales dataset to extract insights on customer behavior, sales trends, and product performance. It simulates a real-world workflow including database setup, data cleaning, and exploratory data analysis (EDA).

---

### 📂 Project 3: Employee Data Analysis

**Folder Name:** `SQL Project - Employee Analysis`

#### 📖 Project Overview

This project analyzes the **Employee** database, a employee management, to answer business questions regarding employee department, their hierarchy, and department, etc. It focuses on complex data retrieval across multiple related tables.

---

### 📂 Project 4: Sales Analysis with Location

**Folder Name:** `SQL Project - Sales Analysis with Locations`

#### 📖 Project Overview

A full-cycle SQL project analyzing sales records to uncover insights into product popularity and location-based performance. The workflow demonstrates real-world database management skills, from schema setup and data sanitization to exploratory analysis.

---

### 📝 Topics Covered
* **Database Design:** Schema normalization, constraints (PK, FK), and table creation.
* **CRUD Operations:** creating, reading, updating, and deleting records.
* **Data Analysis:** Revenue calculation, member activity tracking, and overdue book identification.
* **Advanced SQL:**
    * **CTAS (Create Table As Select):** Generating summary tables for reporting.
    * **Stored Procedures:** Automating business logic for issuing books and handling returns.
    * **Date & Time Manipulation:** Calculating overdue days and fines using `INTERVAL` and date functions.

### 🔍 SQL Clauses & Functions Used
The following SQL clauses and functions were extensively used in this project:

| Category | Clauses / Functions Used |
| :--- | :--- |
| **Data Definition** | `CREATE TABLE`, `DROP TABLE`, `ALTER TABLE` |
| **Data Manipulation** | `INSERT INTO`, `UPDATE`, `DELETE` |
| **Selection & Filtering** | `SELECT`, `WHERE`, `DISTINCT`, `LIMIT`, `PARTITION BY`, `Window Functions (RANK, ROW_NUMBER)` |
| **Aggregation & Grouping**| `GROUP BY`, `HAVING`, `COUNT`, `SUM` |
| **Joins** | `JOIN` (Inner), `LEFT JOIN`, `SELF JOIN` |
| **Ordering** | `ORDER BY`, `DESC`, `ASC` |
| **Procedures** | `CREATE OR REPLACE PROCEDURE`, `CALL`, `PL/pgSQL`, `CTEs` |
| **Date Functions** | `CURRENT_DATE`, `INTERVAL`, `MAKE_DATE`, `EXTRACT` |

### 🚀 Key Tasks Implemented
1.  **Inventory Management:** Inserting new books and updating member details.
2.  **Circulation Logic:** * *Stored Procedure*: `issue_book` (Checks availability before issuing).
    * *Stored Procedure*: `add_return_records` (Updates return status and book quality).
3.  **Reporting:** * **Branch Performance:** Sales and issuance counts per branch.
    * **Active Members:** Table of members with recent activity.
    * **Overdue Analysis:** Identifying members with books overdue by >30 days and calculating fines ($0.54/day).

---

## 🛠️ How to Use
-  **Clone the Repository:**
    ```bash
    git clone [https://github.com/PrashantMali07/SQL-everyday.git](https://github.com/PrashantMali07/SQL-everyday.git)
    ```

   **Data Analysis** project mentioned above, explaining the schema relationships and solving the standard "Easy-Moderate-Advanced" business questions typically associated with this portfolio project.
