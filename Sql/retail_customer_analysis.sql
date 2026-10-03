CREATE DATABASE Retail_Analytics;

USE Retail_Analytics;


SELECT COUNT(*) AS Customer_Rows
FROM dbo.Customer;

SELECT COUNT(*) AS Transaction_Rows
FROM dbo.Transactions;

SELECT COUNT(*) AS Product_Rows
FROM dbo.Prod_cat_info;

------Checking missing values

SELECT COUNT(*) - COUNT(city_code) AS missing_city
FROM dbo.Customer;

SELECT COUNT(*) - COUNT(total_amt) AS missing_amt
FROM dbo.Transactions;

----------- Checking duplicates

SELECT customer_id, COUNT (*) AS cnt
FROM dbo.Customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

SELECT transaction_id, COUNT (*) AS cnt
FROM dbo.Transactions
GROUP BY transaction_id
HAVING COUNT(*) > 1;



SELECT
    t.transaction_id,
    t.cust_id,
    c.customer_id,
    c.Gender,
    c.city_code,
    t.prod_cat_code,
    t.prod_subcat_code,
    t.total_amt
FROM dbo.Transactions t
LEFT JOIN dbo.Customer c
    ON t.cust_id = c.customer_id;

/* =========================================================
   RETAIL CUSTOMER BEHAVIOR & SALES ANALYSIS
   SQL SERVER PROJECT

   Database: Retail_Analytics
   Tool: Microsoft SQL Server / SSMS

   Objective:
   Analyze retail sales and customer behavior to identify
   sales trends, customer patterns, product performance,
   and store-level insights.
   ========================================================= */


   /* =========================================================
   1. OVERALL SALES PERFORMANCE

   Business Question:

   What is the overall sales performance of the retail store?

   Metrics:
   - Total Sales
   - Total Quantity Sold
   - Average Transaction Value
   ========================================================= */

  SELECT
    SUM(total_amt) AS total_sales,
    SUM(Qty) AS total_quantity_sold,
    AVG(total_amt) AS avg_transaction_value
FROM dbo.Transactions;


/* =========================================================
   2. SALES PERFORMANCE BY STORE TYPE

   Business Question:
   How does sales performance vary across store types?
   ========================================================= */


SELECT
    SUM(total_amt) AS total_sales,
    store_type
FROM dbo.Transactions
GROUP BY store_type
ORDER BY total_sales DESC;


/* =========================================================
   3. SALES BY PRODUCT CATEGORY

   Business Question:
   Which product categories generate the highest sales?
   ========================================================= */


SELECT 
      p.prod_cat,
      SUM(total_amt) AS total_sales
FROM dbo.Transactions t
JOIN(
    SELECT DISTINCT
    prod_cat_code,
    prod_cat
    FROM dbo.Prod_cat_info
)p
ON t.prod_cat_code = p.prod_cat_code
GROUP BY p.prod_cat
ORDER BY total_sales DESC;


/* =========================================================
   4. SALES BY PRODUCT SUBCATEGORY

   Business Question:
   Which product subcategories generate the highest sales?
   ========================================================= */

SELECT p.prod_subcat,
      SUM(total_amt) AS total_sales
FROM dbo.Transactions t
JOIN dbo.Prod_cat_info p
ON t.prod_cat_code = p.prod_cat_code
AND t.prod_subcat_code = p.prod_sub_cat_code
GROUP BY p.prod_subcat
ORDER BY total_sales DESC;



/* =========================================================
   5. SALES BY GENDER

   Business Question:
   How does total sales vary by customer gender?
   ========================================================= */

SELECT  COALESCE(c.Gender, 'Unknown') AS Gender,
      SUM(total_amt) AS total_sales
FROM dbo.Transactions t
JOIN dbo.Customer c
ON t.cust_id = c.customer_id
GROUP BY COALESCE(c.Gender, 'Unknown')
ORDER BY total_sales DESC;


/* =========================================================
   6. TOP 10 CUSTOMERS BY SALES

   Business Question:
   Which 10 customers contribute the most sales?
   ========================================================= */


SELECT TOP 10
       c.customer_id,
       SUM(t.total_amt) AS total_sales
FROM dbo.Transactions t
JOIN dbo.Customer c
ON t.cust_id = c.customer_Id
GROUP BY customer_id
ORDER BY total_sales DESC;


/* =========================================================
   7. CUSTOMER PURCHASE FREQUENCY

   Business Question:
   Which customers make the highest number of purchases?
   ========================================================= */


SELECT TOP 10
    cust_id,
    COUNT(DISTINCT transaction_id) AS puchase_count
FROM dbo.Transactions
GROUP BY cust_id
ORDER BY puchase_count DESC;


/* =========================================================
   8. SALES BY CITY

   Business Question:
   Which cities generate the highest sales?
   ========================================================= */

SELECT
    c.city_code,
    SUM(t.total_amt) AS total_sales
FROM dbo.Transactions t
JOIN dbo.Customer c
ON t.cust_id = c.customer_id
WHERE c.city_code IS NOT NULL
GROUP BY c.city_code
ORDER BY total_sales DESC;


/* =========================================================
   9. MONTHLY SALES TREND

   Business Question:
   How do sales change over time?
   ========================================================= */


SELECT
    YEAR(tran_date) AS sales_year,
    MONTH(tran_date) AS sales_month,
    SUM(total_amt) AS total_sales
FROM dbo.Transactions
GROUP BY 
     YEAR(tran_date),
     MONTH(tran_date)
ORDER BY 
    sales_year,
    sales_month;


 /* =========================================================
   10. CUSTOMER AVERAGE SPEND

   Business Question:
   Which customers have the highest average spend per transaction?
   ========================================================= */

   SELECT TOP 10
        c.customer_id,
        AVG(t.total_amt) AS avg_spend_per_trans

    FROM dbo.Transactions t
    JOIN dbo.Customer c
    ON t.cust_id = c.customer_id
    GROUP BY c.customer_id
    ORDER BY avg_spend_per_trans DESC;


    /* =========================================================
   11. TOP CUSTOMERS WITHIN EACH CITY

   Business Question:
   Who are the top 3 customers by sales in each city?
   ========================================================= */
  
  
  WITH customer_sales AS (
    SELECT
        c.city_code,
        c.customer_id,
        SUM(t.total_amt) AS total_sales
    FROM dbo.Transactions t
    JOIN dbo.Customer c
        ON t.cust_id = c.customer_id
    WHERE c.city_code IS NOT NULL
    GROUP BY
        c.city_code,
        c.customer_id
),
ranked_customers AS (
    SELECT
        city_code,
        customer_id,
        total_sales,
        ROW_NUMBER() OVER (
            PARTITION BY city_code
            ORDER BY total_sales DESC
        ) AS customer_rank
    FROM customer_sales
)
SELECT
    city_code,
    customer_id,
    total_sales,
    customer_rank
FROM ranked_customers
WHERE customer_rank <= 3
ORDER BY
    city_code,
    customer_rank;


     /* =========================================================
    12. CATEGORY PERFORMANCE BY STORE TYPE

    Business Question:
    Which product categories perform best within each store type?
    ========================================================= */


SELECT 
       SUM(t.total_amt) AS total_sales,
       p.prod_cat,
       t.store_type
FROM dbo.Transactions t
JOIN (
    SELECT DISTINCT prod_cat_code, prod_cat
    FROM dbo.Prod_Cat_Info
) p
ON p.prod_cat_code = t.prod_cat_code
GROUP BY p.prod_cat,
         t.store_type
ORDER BY t.store_type,
         total_sales DESC;


 /* =========================================================
    13. CUSTOMER SEGMENTATION BY SPENDING

    Business Question:
    How can customers be segmented based on their total spending?
    ========================================================= */


  SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        total_spend,
        CASE
            WHEN total_spend < 5000 THEN 'Low'
            WHEN total_spend < 15000 THEN 'Medium'
            ELSE 'High'
        END AS customer_segment
    FROM (
        SELECT
            cust_id AS customer_id,
            SUM(total_amt) AS total_spend
        FROM dbo.Transactions
        GROUP BY cust_id
    ) AS customer_sales
) AS segmented_customers
GROUP BY customer_segment
ORDER BY customer_segment;
/* =========================================================
   14. CUSTOMER VALUE ANALYSIS

   Business Question:
   Which customers are both frequent buyers and high-value customers?
   ========================================================= */


   WITH customer_summary AS(

        SELECT 
        cust_id AS customer_id,
        SUM(total_amt) AS total_spend,
        COUNT(DISTINCT transaction_id) AS purchase_count
        FROM dbo.Transactions
        GROUP BY cust_id
    )
    SELECT 
        customer_id, 
        total_spend,
        purchase_count,
        CASE 
            WHEN total_spend >= 15000
            AND purchase_count >= 5
            THEN 'High Value - Frequent'
            WHEN total_spend >= 15000
            THEN 'High Value - Lower Frequent'
            WHEN purchase_count >= 5
            THEN 'Frequent - Low Value'
            ELSE 'Less Frequent - Low Value'
            END AS customer_type
        FROM customer_summary
        ORDER BY total_spend DESC;







