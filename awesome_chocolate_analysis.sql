USE `awesome chocolates`;
show tables;
select * from geo;
select * from people;
select * from products;
select * from sales;

-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
select * from sales where Amount>2000 and Boxes<100;

-- How many shipments (sales) each of the sales persons had in the month of January 2022?
select count(*) from sales where year(SaleDate)=2022 and month(SaleDate)=1;
select p.Salesperson,count(*) as no_of_sales from sales as s join people as p on s.SPID=p.SPID
where year(s.SaleDate)=2022 and month(s.SaleDate)=1
group by p.Salesperson;


-- Which product sells more boxes? Milk Bars or Eclairs?
with cte  as (select p.Product, sum(s.Boxes) as no_of_boxes_sold from products as p join sales as s on p.PID=s.PID 
group by p.Product having p.Product='Milk Bars' or p.Product='Eclairs') 
select * from cte where no_of_boxes_sold= (select max(no_of_boxes_sold) from cte);
 -- or 
select pr.product, sum(boxes) as Total_Boxes
from sales as s
join products as pr on s.pid = pr.pid
where pr.Product in ("Milk Bars", "Eclairs")
group by pr.product;

-- Which product sold more boxes in the first 7 days of February 2022?

with cte as (select p.Product, sum(s.Boxes) as no_of_boxes_sold from products as p join sales as s on p.PID=s.PID  
where s.SaleDate >= '2022-02-01' and s.SaleDate < '2022-02-08'
group by p.Product)  select * from cte  where no_of_boxes_sold=(select max(no_of_boxes_sold) from cte);

-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs

with cte as (select p.Product, sum(s.Boxes) as no_of_boxes_sold from products as p join sales as s on p.PID=s.PID  
where s.SaleDate >= '2022-02-01' and s.SaleDate < '2022-02-08'
group by p.Product
having p.Product ='Milk Bars ' or p.Product='Eclairs')  select * from cte  where no_of_boxes_sold=(select max(no_of_boxes_sold) from cte );

-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday?
select * from  sales where Boxes<100
 and Customers<100;
 
 select *,
case when weekday(saledate)=2 then 'Wednesday_Shipment'
else 'other_day'
end as W_Shipment
from sales
where customers < 100 and boxes < 100;



-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
SELECT DISTINCT p.Salesperson
FROM people AS p
JOIN sales AS s ON p.SPID = s.SPID
WHERE s.SaleDate >= '2022-01-01' AND s.SaleDate <= '2022-01-07';
-- Which salespersons did not make any shipments in the first 7 days of January 2022?
select p.salesperson
from people p
where p.spid not in
(select distinct s.spid from sales s where s.SaleDate between '2022-01-01' and '2022-01-07');


SELECT MONTHNAME(SaleDate) AS month_name, SUM(Boxes) AS total_boxes
FROM sales GROUP BY MONTHNAME(SaleDate) HAVING total_boxes > 1000;
-- or 
select month(SaleDate), sum(Boxes) as total_boxes from sales group by month(SaleDate) having total_boxes>1000;

-- How many times we shipped more than 1,000 boxes in each month?
select monthname(SaleDate), count(*) as no_of_1000boxes_shipped  from  sales where Boxes>1000 group by monthname(SaleDate);
 -- or
SELECT year(SaleDate) as year,MONTH(SaleDate) AS month_number,MONTHNAME(SaleDate) AS month_name, COUNT(*) AS no_of_1000boxes_shipped
FROM sales WHERE Boxes > 1000 GROUP BY year(SaleDate),MONTH(SaleDate), MONTHNAME(SaleDate)
ORDER BY year,month_number;

-- Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
set @product_name = 'After_Nines';
set @country_name = 'New_Zealand';

select year(saledate) as 'Year', month(saledate) as 'Month',
if(sum(boxes)>1, 'Yes','No')as 'Status'
from sales s
join products pr on pr.PID = s.PID
join geo g on g.GeoID=s.GeoID
where pr.Product = @product_name and g.Geo = @country_name
group by year(saledate), month(saledate)
order by year(saledate), month(saledate);
-- India or Australia? Who buys more chocolate boxes on a monthly basis?
with cte as 
(select  g.Geo AS Geo, sum(s.Boxes) as no_of_boxes 
from sales as s join geo as g on s.GeoID=g.GeoID 
group by g.geo having g.Geo in ('Australia','India')) 
select * from cte where no_of_boxes=(select max(no_of_boxes) from cte);
-- or 


 select year(s.saledate) as 'Year', month(s.saledate) as 'Month',
sum(CASE WHEN g.geo='India' THEN boxes ELSE 0 END) 'India_Boxes',
sum(CASE WHEN g.geo='Australia'  THEN boxes ELSE 0 END) as 'Australia_Boxes'
from sales s
join geo g on g.GeoID=s.GeoID
group by year(s.saledate), month(s.saledate)
order by year(s.saledate), month(s.saledate);
--  or
select year(s.saledate) as 'year' , month(s.saledate) as 'Month' ,g.geo ,sum(s.Boxes) as total_boxes_in_boxes 
from sales as s 
join geo as g  on g.GeoID=s.GeoID 
group by year(s.saledate), month(s.saledate) , g.geo
having g.geo in ('India','Australia')
order by year(s.saledate), month(s.saledate);