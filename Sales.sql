use SalesDB

-- Total Customers
SELECT COUNT(DISTINCT Customer_ID) AS TotalCustomers FROM Sales;

-- Total Orders
SELECT COUNT(DISTINCT Order_ID) AS TotalOrders FROM Sales;

-- Total Sales
SELECT SUM(Sales) AS TotalSales FROM Sales;

-- Total Profit
SELECT SUM(Profit) AS TotalProfit FROM Sales;

-- Profit Margin %
SELECT ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS ProfitMarginPercent FROM Sales;

--Top 10 Customers by Sales
SELECT Top 10 Customer_ID, Customer_Name, SUM(Sales) AS TotalSales
FROM Sales
GROUP BY Customer_ID, Customer_Name
ORDER BY TotalSales DESC

--Orders per day
SELECT Order_Date,
       COUNT(Order_ID) AS OrdersPerDay,
       AVG(COUNT(Order_ID)) OVER () AS AvgOrdersPerDay
FROM Sales
GROUP BY Order_Date;

-- Sum of Sales by Category
SELECT Category, SUM(Sales) AS TotalSales
FROM Sales
GROUP BY Category
ORDER BY TotalSales DESC;

-- Total Orders by Category
SELECT Category, COUNT(Order_ID) AS TotalOrders
FROM Sales
GROUP BY Category
ORDER BY TotalOrders DESC;

-- Total Sales by Date
SELECT Order_Date, SUM(Sales) AS DailySales
FROM Sales
GROUP BY Order_Date
ORDER BY Order_Date;

--Sales by Ship Mode
SELECT Ship_Mode, SUM(Sales) AS TotalSales
FROM Sales
GROUP BY Ship_Mode
ORDER BY TotalSales DESC;

--Profit by Region
SELECT Region, SUM(Profit) AS TotalProfit,
       ROUND((SUM(Profit) / (SELECT SUM(Profit) FROM Sales)) * 100, 2) AS ProfitPercent
FROM Sales
GROUP BY Region;

SELECT *
FROM Sales
WHERE Region = 'East' AND Segment = 'Consumer';

--Product Performance by Profit Margin
SELECT Product_Name,
       SUM(Sales) AS TotalSales,
       SUM(Profit) AS TotalProfit,
       ROUND(SUM(Profit) / SUM(Sales) * 100, 2) AS ProfitMargin
FROM Sales
GROUP BY Product_Name
HAVING SUM(Sales) > 1000
ORDER BY ProfitMargin DESC;


--Average Order Value by Segment
SELECT Segment, 
       ROUND(SUM(Sales) / COUNT(DISTINCT Order_ID), 2) AS AvgOrderValue
FROM Sales
GROUP BY Segment;

--Sales and Profit by Region and Category
SELECT Region, Category, 
       SUM(Sales) AS TotalSales, 
       SUM(Profit) AS TotalProfit
FROM Sales
GROUP BY Region, Category
ORDER BY Region, TotalSales DESC;

--Profitability by Product
SELECT Top 10 Product_Name, 
       SUM(Sales) AS TotalSales, 
       SUM(Profit) AS TotalProfit,
       ROUND((SUM(Profit) / SUM(Sales)) * 100, 2) AS ProfitMarginPercent
FROM Sales
GROUP BY Product_Name
ORDER BY TotalProfit DESC;

--Sales Contribution by Segment within Each Region
SELECT Region, Segment,
       SUM(Sales) AS SegmentSales,
       ROUND(SUM(Sales) * 100.0 / SUM(SUM(Sales)) OVER (PARTITION BY Region), 2) AS SegmentSharePercent
FROM Sales
GROUP BY Region, Segment;

--Customer Retention – Repeat Buyers
SELECT Customer_ID,
       COUNT(DISTINCT Order_ID) AS TotalOrders,
       MIN(Order_Date) AS FirstOrderDate,
       MAX(Order_Date) AS LastOrderDate
FROM Sales
GROUP BY Customer_ID
HAVING COUNT(DISTINCT Order_ID) > 1;

--Year-over-Year Sales Growth
SELECT 
  YEAR(Order_Date) AS Year,
  SUM(Sales) AS TotalSales,
  LAG(SUM(Sales)) OVER (ORDER BY YEAR(OrderDate)) AS PreviousYearSales,
  ROUND(((SUM(Sales) - LAG(SUM(Sales)) OVER (ORDER BY YEAR(OrderDate))) / 
         LAG(SUM(Sales)) OVER (ORDER BY YEAR(OrderDate))) * 100, 2) AS YoYGrowthPercent
FROM Sales
GROUP BY YEAR(Order_Date);

--Rank Customers by Sales
SELECT 
  Customer_ID,
  Customer_Name,
  SUM(Sales) AS TotalSales,
  RANK() OVER (ORDER BY SUM(Sales) DESC) AS SalesRank
FROM Sales
GROUP BY Customer_ID, Customer_Name;

