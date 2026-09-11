# Sales & Product Performance  Analysis

## 📌 Project Overview
This project analyzes sales performance across regions, products, and sales channels (online vs in-store) to uncover trends and support business decision-making.

## 🎯 Business Problem
The business is experiencing variations in sales performance across regions and sales channels (online vs in-store). The business needs to understand key drivers of revenue, customer purchasing behavior, and the impact of discounting in order to improve profitability and optimize sales strategy.

## 🛠 Tools Used
- SQL (data extraction & transformation)
- Power BI (data visualization & dashboards)

- ## 💻 SQL Analysis

The SQL query was used to extract, clean, and prepare the dataset for Power BI analysis by combining sales, product, and customer data into an order-level dataset.

### 🔍 Sample Query

```sql
WITH OrderSummary AS (
    SELECT 
        SOD.SalesOrderID,
        SUM(SOD.OrderQty) AS TotalQty,
        SUM(SOD.LineTotal) AS TotalSales,
        STRING_AGG(PP.[Name], ', ') AS ProductList,
        SUM(SOD.UnitPrice * SOD.OrderQty) AS GrossAmount,
        SUM(SOD.UnitPrice * SOD.OrderQty * SOD.UnitPriceDiscount) AS DiscountAmount,
        SUM(PP.StandardCost * SOD.OrderQty) AS CostAmount
    FROM Sales.SalesOrderDetail AS SOD
    JOIN Production.Product AS PP
        ON PP.ProductID = SOD.ProductID
    GROUP BY SOD.SalesOrderID
)

SELECT 
    SOH.SalesOrderID,
    SOH.OrderDate,
    SOH.TotalDue AS Revenue,
    OS.TotalQty AS ItemsPerTransaction,
    OS.TotalSales AS NetProductRevenue
FROM Sales.SalesOrderHeader AS SOH
LEFT JOIN OrderSummary AS OS 
    ON OS.SalesOrderID = SOH.SalesOrderID;
```

👉 [View Full SQL File](./SQL/ahg-sales-analysis.sql)

## 📊 Key Insights
- Store sales showed a declining trend over time, while online sales increased, indicating a shift in customer purchasing behaviour toward digital channels.

- The online channel generated a higher number of orders but contributed less overall revenue compared to in-store sales, indicating lower average transaction value (ATV).

- In-store purchases showed higher revenue per transaction, suggesting customers tend to buy more items or higher-value products in physical locations.

- Certain product categories consistently drove the majority of total sales, highlighting opportunities for targeted promotions and bundling.

- Regional performance varied, with some regions outperforming others in both order volume and revenue contribution.

## 📈 Business Recommendations
- Improve online sales strategy by increasing average order value through product bundling and cross-selling.

- Align pricing and promotional strategies between online and in-store channels to maximize revenue.

- Focus marketing efforts on high-performing product categories to drive further growth.

- Investigate underperforming regions and implement targeted campaigns to boost sales.

## 📷 Dashboard Preview

- Below are Power Bi dashboards developed to visualize key business insights and support data-driven decision making.

### Sales Overview

<p align="center">
  <img src="https://github.com/IsraelAlamu/ahg_sales-analysis/blob/main/AHG_Executive_Dashboard_Screenshot.png" width="800"/>
</p>

### Product Analysis

<p align="center">
  <img src="https://github.com/IsraelAlamu/ahg_sales-analysis/blob/main/AHG_Product-analysis_screenshot.png" width="800"/>
</p>






