# E-Commerce Sales & Customer Analytics Using MySQL

## 📌 Project Overview

This project analyzes an e-commerce dataset using MySQL to understand sales performance, customer behavior, product performance, payment activity, and business trends.

The project covers data cleaning, SQL analysis, advanced SQL techniques, and business insights to support data-driven decision making.

## 🎯 Objectives

- Analyze overall e-commerce sales performance
- Identify top-performing products and categories
- Analyze customer spending and purchasing behavior
- Segment customers based on spending
- Analyze monthly sales trends and revenue growth
- Evaluate order and payment performance
- Identify inactive and repeat customers
- Generate actionable business recommendations

## 🗂️ Dataset

The dataset contains five relational tables:

| Table | Description |
|---|---|
| customers | Customer information |
| products | Product and category information |
| orders | Customer order information |
| order_items | Products included in each order |
| payments | Payment transaction information |

## 🛠️ Tools & Technologies

- MySQL
- MySQL Workbench
- SQL
- GitHub

## 🧹 Data Cleaning

The following data-quality checks were performed:

- Checked for NULL values
- Checked for duplicate records
- Checked for invalid customer IDs
- Checked for invalid product IDs
- Checked for invalid order IDs
- Checked for negative or zero quantities
- Checked for invalid prices
- Checked for invalid dates
- Checked for invalid order statuses
- Checked for invalid payment statuses
- Checked for invalid payment methods
- Checked for inconsistent text values
- Checked for orphan records
- Checked for duplicate orders
- Validated relationships between tables

## 📊 SQL Analysis

### Basic Analysis

- Total customers
- Total products
- Total orders
- Total quantity sold
- Total revenue
- Average product price
- Orders by status
- Products by category
- Revenue by category
- Top products
- Top customers
- Monthly orders
- Monthly revenue
- Payment method analysis

### Intermediate Analysis

- Average order value
- Customers spending above average
- Customer segmentation
- Purchase frequency
- Top products within categories
- Category revenue contribution
- Repeat customers
- One-time customers
- Products never ordered
- Revenue by state
- Customer spending analysis
- Inactive customers

### Advanced Analysis

- Customer ranking using `RANK()`
- Product ranking using `DENSE_RANK()`
- Running monthly revenue
- Month-over-month revenue growth using `LAG()`
- Highest-spending customer in each state
- Category revenue percentage
- Customers above average spending
- Customer segmentation
- Payment success rate
- Order status percentage
- State-wise revenue ranking
- Monthly average order value

## 💡 Business Insights

- **Total Revenue:** Approximately ₹62.72 lakh
- **Total Orders:** 300
- **Units Sold:** 799
- **Average Order Value:** Approximately ₹20,907.74
- **Top Category:** Electronics
- **Top Product:** Laptop Air 13
- **Highest-Spending Customer:** Divya 36
- **Highest-Revenue State:** Maharashtra
- **Highest-Revenue Month:** August 2025
- **Repeat Customers:** 76
- **One-Time Customers:** 19
- **Customers With No Orders:** 5
- **Delivered Orders:** 252
- **Cancelled Orders:** 29
- **Returned Orders:** 19
- **Successful Payments:** 252
- **UPI Transactions:** 110
- **Inactive Customers:** 44
- **Inactive Products:** 0

## 💼 Business Recommendations

- Focus marketing efforts on high-performing categories such as Electronics.
- Promote top-selling products through targeted offers and discounts.
- Use loyalty programs and personalized offers to increase repeat purchases.
- Re-engage inactive customers through targeted email and promotional campaigns.
- Analyze cancelled and returned orders to identify operational issues.
- Promote convenient payment methods such as UPI.
- Monitor monthly revenue trends to improve sales and inventory planning.
- Provide rewards and exclusive offers to high-value customers.
- Review low-performing products to improve product strategy.
- Focus regional marketing efforts on high-revenue states such as Maharashtra.

## 📁 Project Structure

```text
ECommerce-SQL-Analysis/
│
├── Dataset/
│   ├── customers.csv
│   ├── products.csv
│   ├── orders.csv
│   ├── order_items.csv
│   └── payments.csv
│
├── SQL/
│   ├── database_setup.sql
│   ├── data_cleaning.sql
│   ├── basic_analysis.sql
│   ├── intermediate_analysis.sql
│   └── advanced_analysis.sql
│
├── Screenshots/
│   ├── 1.database_tables.png
│   ├── 2.database_cleaning.png
│   ├── 3.total_revenue.png
│   ├── 4.category_revenue.png
│   ├── 5.top_products.png
│   ├── 6.top_customers.png
│   ├── 7.monthly_revenue.png
│   ├── 8.customer_segmentation.png
│   ├── 9.customer_ranking.png
│   └── 10.monthly_growth_percentage.png
│
└── README.md
