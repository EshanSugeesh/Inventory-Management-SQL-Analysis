-- Inventory Management SQL Analysis
-- Project: Urban Retail Co. Inventory Optimization
-- Author: Eshan Sugeesh
-- Organization: Consulting Analytics Club, IIT Guwahati

-- creating database and table
CREATE DATABASE inventorydb;
SHOW DATABASES;
USE inventorydb;

DROP TABLE IF EXISTS inventory;

CREATE TABLE inventory (
    DATE DATE,
    StoreID VARCHAR(10),
    ProductID VARCHAR(10),
    Category VARCHAR(20),
    Region VARCHAR(10),
    InventoryLevel INT,
    UnitsSold INT,
    UnitsOrdered INT,
    DemandForecast DECIMAL(10,2),
    Price DECIMAL(10,2),
    Discount INT,
    WeatherCondition VARCHAR(20),
    HolidayPromotion BOOLEAN,
    CompetitorPricing DECIMAL(10,2),
    Seasonality VARCHAR(20)
);

SHOW TABLES;
SHOW VARIABLES LIKE 'secure_file_priv';

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/inventory.csv'
INTO TABLE inventory
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- check structure of the dataset
SELECT * FROM inventory;
DESCRIBE inventory;

SELECT COUNT(*) AS total_rows FROM inventory;

SELECT MIN(DATE) AS start_date , MAX(DATE) AS end_date FROM inventory;

-- check for missing values
SELECT 
    SUM(CASE WHEN DATE IS NULL THEN 1 ELSE 0 END) AS null_DATE,
    SUM(CASE WHEN StoreID IS NULL THEN 1 ELSE 0 END) AS null_storeid,
    SUM(CASE WHEN ProductID IS NULL THEN 1 ELSE 0 END) AS null_productID,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN Region IS NULL THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN InventoryLevel IS NULL THEN 1 ELSE 0 END) AS null_inventory,
    SUM(CASE WHEN UnitsSold IS NULL THEN 1 ELSE 0 END) AS null_units_sold,
    SUM(CASE WHEN UnitsOrdered IS NULL THEN 1 ELSE 0 END) AS null_units_ordered,
    SUM(CASE WHEN DemandForecast IS NULL THEN 1 ELSE 0 END) AS null_demand_forecast,
    SUM(CASE WHEN Price IS NULL THEN 1 ELSE 0 END) AS null_price,
    SUM(CASE WHEN Discount IS NULL THEN 1 ELSE 0 END) AS null_discount,
    SUM(CASE WHEN WeatherCondition IS NULL THEN 1 ELSE 0 END) AS null_weather_condition,
    SUM(CASE WHEN HolidayPromotion IS NULL THEN 1 ELSE 0 END) AS null_holiday_promotion,
    SUM(CASE WHEN CompetitorPricing IS NULL THEN 1 ELSE 0 END) AS null_competitor_pricing,
    SUM(CASE WHEN Seasonality IS NULL THEN 1 ELSE 0 END) AS null_seasonality
FROM inventory;

-- Basic KPIs
-- 1. Top 10 Most Sold
SELECT ProductID, SUM(UnitsSold) AS total_sold
FROM inventory
GROUP BY ProductID
ORDER BY total_sold DESC
LIMIT 10;

-- 2. Top 10 overstocking products
SELECT ProductID, AVG(InventoryLevel) AS avg_inventory, AVG(UnitsSold) AS avg_sales
FROM inventory
GROUP BY ProductID
HAVING avg_inventory > 1.5*avg_sales
ORDER BY avg_inventory DESC
LIMIT 10;

-- Top 10 stock out Products
SELECT ProductID, Region, UnitsSold, InventoryLevel, DemandForecast,
       DemandForecast - UnitsSold AS MissedSales
FROM inventory
WHERE UnitsSold<DemandForecast AND DemandForecast>InventoryLevel
ORDER BY MissedSales DESC
LIMIT 10;

-- Splitting the tables
-- Product Table
CREATE TABLE products AS
SELECT DISTINCT ProductID, Category, Price, Seasonality
FROM inventory;

-- Store table
CREATE TABLE stores AS
SELECT DISTINCT StoreID, Region
FROM inventory;

-- Date table
CREATE TABLE date_dim AS
SELECT DISTINCT DATE, 
       YEAR(DATE) AS Year, 
       MONTH(DATE) AS Month, 
       DAYNAME(DATE) AS Weekday
FROM inventory;

CREATE TABLE inventory_facts AS
SELECT DATE, StoreID, ProductID, InventoryLevel, UnitsSold, UnitsOrdered,
       DemandForecast, Discount, HolidayPromotion, CompetitorPricing
FROM inventory;

-- Indexing
CREATE INDEX idx_inventory_product ON inventory_facts(ProductID);
CREATE INDEX idx_inventory_store ON inventory_facts(StoreID);
CREATE INDEX idx_inventory_date ON inventory_facts(Date);
CREATE INDEX idx_products_productid ON products(ProductID);
CREATE INDEX idx_stores_storeid ON stores(StoreID);
CREATE INDEX idx_date_date ON date_dim(DATE);

-- Inventory Analysis Queries

-- Low Inventory Products
SELECT * FROM inventory
WHERE InventoryLevel < 30
ORDER BY InventoryLevel ASC;

-- Fast selling stocks
SELECT ProductID, ROUND(AVG(UnitsSold), 2) AS avg_daily_sales
FROM inventory
GROUP BY ProductID
ORDER BY avg_daily_sales DESC;

-- Reorder Point check with 3 day buffer
SELECT i.ProductID, i.StoreID, i.DATE, i.InventoryLevel, 
       s.avg_daily_sales, s.avg_daily_sales * 3 AS reorder_point
FROM inventory i
JOIN (
    SELECT ProductID, AVG(UnitsSold) AS avg_daily_sales
    FROM inventory
    GROUP BY ProductID
) s ON i.ProductID = s.ProductID
WHERE i.InventoryLevel < (s.avg_daily_sales * 3)
ORDER BY i.DATE;

-- Overstocking logic
SELECT i.ProductID, i.StoreID, i.Date, i.InventoryLevel, 
       s.avg_daily_sales, 
       ROUND(s.avg_daily_sales * 3, 2) AS optimal_stock_level,
       i.InventoryLevel - ROUND(s.avg_daily_sales * 3, 2) AS excess_stock
FROM inventory i
JOIN (
    SELECT ProductID, AVG(UnitsSold) AS avg_daily_sales
    FROM inventory
    GROUP BY ProductID
) s ON i.ProductID = s.ProductID
WHERE i.InventoryLevel > (s.avg_daily_sales * 3)
ORDER BY excess_stock DESC;

-- Inventory Turnover Ratio
SELECT ProductID, 
       ROUND(SUM(UnitsSold)/NULLIF(AVG(InventoryLevel),0),2) AS turnover_ratio
FROM inventory
GROUP BY ProductID
ORDER BY turnover_ratio DESC;

-- Category wise turnover
SELECT Category, 
       ROUND(SUM(UnitsSold) / NULLIF(AVG(InventoryLevel), 0), 2) AS Category_Turnover
FROM inventory
GROUP BY Category
ORDER BY Category_Turnover DESC;

-- Store wise turnover
SELECT StoreID, Region, 
       ROUND(SUM(UnitsSold) / NULLIF(AVG(InventoryLevel), 0), 2) AS Store_Turnover
FROM inventory
GROUP BY StoreID, Region
ORDER BY Store_Turnover DESC;

-- Demand Forecast Accuracy
SELECT ProductID, 
       ROUND(AVG(ABS(UnitsSold - DemandForecast)),2) AS avg_forecast_error
FROM inventory
GROUP BY ProductID
ORDER BY avg_forecast_error ASC;

-- Holiday Impact on sales
SELECT HolidayPromotion, AVG(UnitsSold) AS avg_units
FROM inventory
GROUP BY HolidayPromotion;

-- Rolling 7 Day Sales
SELECT ProductID, StoreID, Date, UnitsSold,
       ROUND(AVG(UnitsSold) OVER (
           PARTITION BY ProductID, StoreID 
           ORDER BY Date 
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
       ), 2) AS rolling_7day_sales
FROM inventory;

-- Top selling regions
SELECT Region, ProductID, SUM(UnitsSold) AS total_sales,
       RANK() OVER (PARTITION BY Region ORDER BY SUM(UnitsSold) DESC) AS regional_rank
FROM inventory
GROUP BY Region, ProductID;
