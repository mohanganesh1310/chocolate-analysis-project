# chocolate-analysis-project
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


--  details of shipments (sales) where amounts are > 2,000 and boxes are <100
select * from sales where amount>2000 and boxes<100;

-- How many shipments (sales) each of the sales persons had in the month of January 2022
select p.Salesperson,count(*) as shipments_count  from sales as s join people as p on s.SPID=p.SPID  where s.SaleDate between '2022-01-01' and '2022-02-01' group by  p.Salesperson;

-- product sells more boxes? Milk Bars or Eclairs?
select pr.product,sum(s.Boxes)  from sales as s join products as pr on pr.PID=s.PID where pr.Product in ('Milk Bars' ,'Eclairs') group by pr.product;

-- product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs
select  pr.product,sum(s.Boxes)  from sales as s join products as pr on pr.PID=s.PID where  pr.Product in ('Milk Bars' ,'Eclairs') and s.SaleDate between '2022-02-01' and '2022-02-07' group by pr.product;


--  shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday
select * from sales
where customers < 100 and boxes < 100;

SELECT *,
  CASE 
    WHEN WEEKDAY(saledate) = 2 THEN 'Wednesday Shipment' 
    ELSE '' 
  END AS `W Shipment`
FROM sales
WHERE customers < 100 AND boxes < 100;

 -- names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022
 
 SELECT DISTINCT p.Salesperson FROM sales AS s JOIN people AS p ON s.SPID = p.SPID WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07';
 select p.Salesperson,count(*) as shipment_count from sales as s join people as p on s.SPID=p.SPID where s.SaleDate between '2022-01-01' and '2022-01-07' group by p.Salesperson having count(*)>1;

-- — times we shipped more than 1,000 boxes in each month?

SELECT 
    YEAR(saledate) AS `Year`, 
    MONTH(saledate) AS `Month`, 
    COUNT(*) AS `Times we shipped 1k boxes`
FROM sales
WHERE boxes > 1000
GROUP BY YEAR(saledate), MONTH(saledate)
ORDER BY YEAR(saledate), MONTH(saledate);


-- — Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?

SET @product_name = 'After Nines';
SET @country_name = 'New Zealand';

SELECT 
    YEAR(s.SaleDate) AS `Year`, 
    MONTH(s.SaleDate) AS `Month`,
    IF(SUM(s.Boxes) > 1, 'Yes', 'No') AS `Status`
FROM sales as s
JOIN products  as pr ON pr.PID = s.PID
JOIN geo as g ON g.GeoID = s.GeoID
WHERE pr.Product = @product_name 
AND g.Geo = @country_name
GROUP BY YEAR(s.SaleDate), MONTH(s.SaleDate)
ORDER BY YEAR(s.SaleDate), MONTH(s.SaleDate);


-- — India or Australia? Who buys more chocolate boxes on a monthly basis?
SELECT 
    YEAR(s.SaleDate) AS `Year`, 
    MONTH(s.SaleDate) AS `Month`,
    SUM(CASE WHEN g.Geo = 'India' THEN s.Boxes ELSE 0 END) AS `India Boxes`,
    SUM(CASE WHEN g.Geo = 'Australia' THEN s.Boxes ELSE 0 END) AS `Australia Boxes`
FROM sales s
JOIN geo g ON g.GeoID = s.GeoID
GROUP BY YEAR(s.SaleDate), MONTH(s.SaleDate)
ORDER BY YEAR(s.SaleDate), MONTH(s.SaleDate);



 Key Metrics:
1.Total Sales: $1.99M
2.Total Boxes Sold: 131K
3.Shipment Count: 352
4.LBS%: 10.5%

Visuals Created:

Sales by Geography (India leads with $0.39M)
Sales Trends (Fluctuations from $306K to $442K)
Top Salespersons (Sales & Box Contribution %)
