# Retail Customer Behavior & Sales Analysis Using SQL

## About the Project

I used a retail Point-of-Sale dataset to analyze sales and customer purchasing behavior using **Microsoft SQL Server**.

The dataset contains customer information, transaction records, and product category/subcategory information. I used SQL to explore the data from different angles — overall sales, store types, products, customers, cities, and monthly trends.

The main goal was to turn the raw transaction data into findings that could be useful from a retail business perspective and use them for decision making. 

---

## Business Questions

Some of the questions I wanted to answer were:

* Which store type generates the most sales?
* Which product categories and subcategories perform best?
* Do sales differ by gender or city?
* Who are the highest-spending customers?
* Which customers purchase most frequently?
* How does sales performance change over time?
* Can customers be grouped based on their spending and purchase behavior?
* Which product categories perform best within each store type?

---

## Dataset Structure

I worked with three tables:

| Table           | What it contains                                                                 |
| --------------- | -------------------------------------------------------------------------------- |
| `Customer`      | Customer ID, DOB, gender and city                                                |
| `Transactions`  | Transaction, customer, product, quantity, rate, tax, sales amount and store type |
| `Prod_Cat_Info` | Product categories and subcategories                                             |

The main relationships were:

```text
Customer
   │
   │ customer_id = cust_id
   ▼
Transactions
   │
   │ prod_cat_code + prod_subcat_code
   ▼
Prod_Cat_Info
```

---

## Data Validation

Before starting the analysis, I checked the basic quality of the imported data.

* Customer records: **5,647**
* Transaction records: **23,053**
* Product mapping records: **23**
* Missing customer city values: **2**
* Missing transaction total amounts: **34**
* No duplicate `customer_id` records
* Transaction IDs were repeated because the transaction table contains line items

One issue I found during the analysis was particularly important.

`prod_cat_code` was **not unique** in the product information table. Joining the transaction table using only the category code caused transaction values to be counted multiple times.

I therefore used:

`prod_cat_code + prod_subcat_code`

for the product-level join, and used distinct category codes where only category-level information was required.

This was an important validation step because the incorrect join produced inflated sales figures.

---

## Analysis & Key Findings

### 1. Overall Sales

The dataset contains total sales of approximately:

* **48.69M** in total sales
* **56,074** units sold
* **2,115** average line amount

The average is based on transaction line amounts rather than distinct transactions because transaction IDs can occur across multiple line items.

## Results Preview

### Overall Sales Performance

![Overall Sales Performance](results/screenshots/sales.png)
---

### 2. Sales by Store Type

**e-Shop** generated the highest sales at approximately **19.86M**.

The other store types were relatively close to each other:

* Flagship store: **~9.73M**
* MBR: **~9.70M**
* TeleShop: **~9.40M**

This shows a clear difference between e-Shop sales and the other three store types in this dataset.

---

### 3. Sales by Product Category

The main category results were:

| Category         |   Sales |
| ---------------- | ------: |
| Books            | ~12.84M |
| Electronics      | ~10.75M |
| Home and kitchen |  ~8.45M |
| Clothing         |  ~6.28M |
| Footwear         |  ~6.24M |
| Bags             |  ~4.13M |

**Books** was the highest-selling category, while **Bags** recorded the lowest sales.

---

### 4. Sales by Product Subcategory

The highest-selling subcategories were:

| Subcategory |  Sales |
| ----------- | -----: |
| Women       | ~6.20M |
| Mens        | ~6.18M |
| Kids        | ~4.27M |
| Mobiles     | ~2.25M |
| Fiction     | ~2.23M |

The remaining subcategories were mostly in the **~2.05M–2.23M** range.

---

### 5. Sales by Gender

Sales were approximately:

* Male: **25.00M**
* Female: **23.67M**
* Unknown: **20.63K**

The difference between male and female sales was relatively small compared with the overall sales volume.

---

### 6. Top Customers

The highest-spending customer generated approximately **41.51K** in sales.

Among the top 10 customers, total sales ranged from approximately **31.12K to 41.51K**.

I also analyzed purchase frequency separately. The most frequent customers recorded **11 distinct purchases**.

---

### 7. Sales by City

Sales were fairly evenly distributed across the cities in the dataset.

* Highest: **City 3 — ~5.17M**
* Lowest: **City 6 — ~4.38M**

No single city accounted for an overwhelmingly large share of total sales.

---

### 8. Monthly Sales Trend

Sales increased sharply after January 2011 and then remained relatively stable through 2012 and 2013.

January 2014 recorded approximately **1.50M** in sales.

February 2014 recorded approximately **735K**, but I have not treated this as a major downward trend because the dataset contains only **January and February 2014**.

---

### 9. Customer Spending

For each customer, I calculated the average amount per transaction line.

Among the highest averages, the top customer had an average of approximately **8.20K**, while the top 10 ranged from approximately **7.40K to 8.20K**.

---

### 10. Customer Segmentation

I grouped customers based on their total spending using defined spending thresholds.

| Segment | Customers |
| ------- | --------: |
| Medium  |     3,032 |
| Low     |     1,620 |
| High    |       854 |

I also combined spending with purchase frequency to create customer-value groups such as **High Value - Frequent** and **Frequent - Lower Value**.

---

### 11. Category Performance by Store Type

Books was the highest-selling category across **all four store types**.

For example, Books generated approximately **5.30M** in e-Shop sales.

This allowed me to look beyond overall category performance and see how categories behaved across individual sales channels.

---

## SQL Techniques Used

This project gave me an opportunity to work with:

* `SELECT`, `WHERE`, `GROUP BY`, `HAVING`
* `SUM()`, `AVG()`, `COUNT()`
* `JOIN`
* `DISTINCT`
* `CASE WHEN`
* `COALESCE()`
* Subqueries
* CTEs
* `ROW_NUMBER()`
* `PARTITION BY`
* `YEAR()` and `MONTH()`
* Data validation and duplicate checks

---

## Project Structure

```text
retail-customer-sql-analysis/
│
├── sql/
│   └── retail_customer_analysis.sql
│
├── results/
│   └── screenshots/
│
└── README.md
```

---

## How to Run

1. Open the SQL script in **SQL Server Management Studio (SSMS)**.
2. Load the three tables into the `Retail_Analytics` database.
3. Run the data validation section first.
4. Run the analysis queries.
5. Compare the results with the findings documented above.

---

## Dataset

The project uses a retail Point-of-Sale dataset containing customer, transaction, product category, and product subcategory information.

**Source:** Kaggle / course-provided retail dataset.

---

## Skills Demonstrated

**SQL Server · Data Validation · Data Cleaning · Sales Analysis · Customer Analysis · Relational Data · CTEs · Window Functions · Business Analysis**

