-- 1) Set suitable SQL contraints to column while creating tables.
-- 2) Write a command to display first 10 rows.
-- 3) Identify unique items?
-- 4) Identify any unit cost is negative?
-- 5) Identify minimum and maximum unit price happened for same item.
-- 6) Identify the Total sales happened in the year of 2021?
-- 7) Which item is sold maximum in the year 2021?
-- 8) Identify the region with highest and lowest sales.
-- 9) Identify the customer name having highest sales for the year 2022.
-- 10) Which item has highest and lowest unit cost?
-- 11) Identify items starts with letter 'P'.
-- 12) Filter the table having items Pen and Pencil.
-- 13) Filter the table with unit cost between 1 and 100.
-- 14) Identify the customer with more no of transaction(no of entries).
-- 15) Identify which item has maximum sales in each region.
-- 16) Create 5 more scenarios using important inbuilt functions of MySQL.
SELECT * FROM sales_database.customer_master;
SELECT * FROM sales_database.sales_order;

SELECT * FROM sales_database.customer_master LIMIT 10;
SELECT * FROM sales_database.sales_order LIMIT 10;

SELECT DISTINCT Item FROM sales_database.sales_order;


SELECT * FROM sales_database.sales_order WHERE `Unit Cost` < 0;

SELECT Item, MIN(`Unit Cost`) AS MinUnitCost, MAX(`Unit Cost`) AS MaxUnitCost
FROM sales_database.sales_order
GROUP BY Item;

SELECT SUM(Total) AS TotalSales
FROM sales_database.sales_order
WHERE YEAR(OrderDate) = 2021;

SELECT Item, SUM(Units) AS TotalUnits
FROM sales_database.sales_order
WHERE YEAR(OrderDate) = 2021
GROUP BY Item
ORDER BY TotalUnits DESC
LIMIT 1;

SELECT cm.Region, SUM(so.Total) AS TotalSales
FROM sales_database.sales_order so
JOIN sales_database.customer_master cm ON so.Customer_ID = cm.Customer_ID
GROUP BY cm.Region
ORDER BY TotalSales DESC
LIMIT 1; -- For the region with the highest sales

SELECT cm.Region, SUM(so.Total) AS TotalSales
FROM sales_database.sales_order so
JOIN sales_database.customer_master cm ON so.Customer_ID = cm.Customer_ID
GROUP BY cm.Region
ORDER BY TotalSales ASC
LIMIT 1; -- For the region with the lowest sales

SELECT cm.Customer, SUM(so.Total) AS TotalSales
FROM sales_database.sales_order so
JOIN sales_database.customer_master cm ON so.Customer_ID = cm.Customer_ID
WHERE YEAR(so.OrderDate) = 2022
GROUP BY cm.Customer
ORDER BY TotalSales DESC
LIMIT 1;


SELECT Item, MAX(`Unit Cost`) AS HighestUnitCost
FROM sales_database.sales_order
GROUP BY Item;

SELECT Item, MIN(`Unit Cost`) AS LowestUnitCost
FROM sales_database.sales_order
GROUP BY Item;

SELECT Item
FROM sales_database.sales_order
WHERE Item LIKE 'P%';

SELECT *
FROM sales_database.sales_order
WHERE Item IN ('Pen', 'Pencil');

SELECT *
FROM sales_database.sales_order
WHERE `Unit Cost` BETWEEN 1 AND 100;

SELECT Customer_ID, COUNT(*) AS TransactionCount
FROM sales_database.sales_order
GROUP BY Customer_ID
ORDER BY TransactionCount DESC
LIMIT 1;

WITH RankedSales AS (
    SELECT 
        cm.Region,
        so.Item,
        SUM(so.Total) AS TotalSales,
        ROW_NUMBER() OVER (PARTITION BY cm.Region ORDER BY SUM(so.Total) DESC) AS SalesRank
    FROM 
        sales_database.sales_order so
    JOIN 
        sales_database.customer_master cm ON so.Customer_ID = cm.Customer_ID
    GROUP BY 
        cm.Region, so.Item
)
SELECT 
    Region,
    Item,
    TotalSales
FROM 
    RankedSales
WHERE 
    SalesRank = 1;
    
SELECT Customer_ID, SUM(Total) AS TotalRevenue
FROM sales_database.sales_order
GROUP BY Customer_ID;











