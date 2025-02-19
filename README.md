# Data-analysis-project
I developed a project by using Sql and Power BI ,creating report and tables to analyze the data. This process involved several stages ,including data pre processing ,data cleaning, and data visualization 

This project analyzes chocolate sales data using SQL for data preprocessing and Power BI for visualization. The dataset consists of four tables:

sales  - Transaction records with amounts, boxes, and salesperson IDs
people - Salesperson details like name and team
products  - Product details for each sale
geo  - Geographic information for sales

The goal is to clean, transform, and visualize data to generate insights like:
1.Total Sales & Performance by Salesperson
2.Sales Trends Over Time
3.Geographical Sales Distribution
4.LBS% (Loss Before Sale) Analysis.

SQL Queries Used
SELECT * FROM sales;
SELECT * FROM geo;
SELECT * FROM people;
SELECT * FROM products;

Amount per box for each salesperson:
SELECT SPID, Amount / Boxes AS Amount_per_box FROM sales;

Filtering high-value sales:
SELECT * FROM sales WHERE amount > 10000 ORDER BY amount DESC;

Sales trends over time:
SELECT SaleDate, Amount 
FROM sales 
WHERE YEAR(SaleDate) = 2022 
ORDER BY Amount DESC;


Joining sales & people to get salesperson details:
SELECT s.SaleDate, s.Amount, s.SPID, p.Salesperson
FROM sales AS s  
JOIN people AS p ON p.SPID = s.SPID;

Joining sales, people & products to see product-wise sales:
SELECT s.SaleDate, s.Amount, s.SPID, p.Salesperson, pd.Product, p.team 
FROM sales AS s  
JOIN people AS p ON p.SPID = s.SPID  
JOIN products AS pd ON s.PID = pd.PID;

Sales grouped by region:
SELECT g.GeoID, SUM(s.Amount) AS Total_Sales, SUM(s.Amount) / SUM(s.Boxes) AS Avg_Per_Box
FROM sales AS s 
JOIN geo AS g ON g.GeoID = s.GeoID 
GROUP BY g.GeoID;


 Key Metrics:
1.Total Sales: $1.99M
2.Total Boxes Sold: 131K
3.Shipment Count: 352
4.LBS%: 10.5%

Visuals Created:

Sales by Geography (India leads with $0.39M)
Sales Trends (Fluctuations from $306K to $442K)
Top Salespersons (Sales & Box Contribution %)
