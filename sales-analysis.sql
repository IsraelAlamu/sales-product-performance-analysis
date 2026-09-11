USE AdventureWorks2022

GO


WITH OrderSummary AS (
    SELECT 
        SOD.SalesOrderID
        ,SUM(SOD.OrderQty) AS TotalQty
        ,SUM(SOD.LineTotal) AS TotalSales
        ,STRING_AGG(PP.[Name], ', ') AS ProductList
        ,SUM(SOD.UnitPrice * SOD.OrderQty) AS GrossAmount
        ,SUM(SOD.UnitPrice * SOD.OrderQty * SOD.UnitPriceDiscount) AS DiscountAmount
        ,SUM(PP.StandardCost * SOD.OrderQty) AS CostAmount
        ,COUNT(DISTINCT SOD.ProductID) AS DistinctProducts
    FROM Sales.SalesOrderDetail AS SOD
    JOIN Production.Product AS PP
        ON PP.ProductID = SOD.ProductID
    GROUP BY SOD.SalesOrderID
)

SELECT 
    SOH.SalesOrderID 

    -- Customer Name Fix
    ,CASE 
        WHEN DC.FirstName IS NULL AND DC.LastName IS NULL THEN 'Unknown'
        ELSE LTRIM(RTRIM(CONCAT(ISNULL(DC.FirstName, ''), ' ', ISNULL(DC.LastName, ''))))
    END AS [Customer Name]

    -- Age Fix
    ,CASE 
        WHEN DC.BirthDate IS NULL THEN NULL
        ELSE DATEDIFF(YEAR, DC.BirthDate, GETDATE())
    END AS Age

    -- Age Group Fix
    ,CASE 
        WHEN DC.BirthDate IS NULL THEN 'Unknown'
        WHEN DATEDIFF(YEAR, DC.BirthDate, GETDATE()) BETWEEN 0 AND 17 THEN '0-17'
        WHEN DATEDIFF(YEAR, DC.BirthDate, GETDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN DATEDIFF(YEAR, DC.BirthDate, GETDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN DATEDIFF(YEAR, DC.BirthDate, GETDATE()) BETWEEN 36 AND 45 THEN '36-45'
        WHEN DATEDIFF(YEAR, DC.BirthDate, GETDATE()) BETWEEN 46 AND 60 THEN '46-60'
        ELSE '60+'
    END AS AgeGroup

    -- Gender
    ,CASE 
        WHEN ISNULL(DC.Gender, 'Unknown') = 'F' THEN 'Female'
        WHEN ISNULL(DC.Gender, 'Unknown') = 'M' THEN 'Male'
        ELSE 'Unknown'
    END AS [Gender]

    -- Marital Status
    ,CASE 
        WHEN ISNULL(DC.MaritalStatus, 'Unknown') = 'M' THEN 'Married'
        WHEN ISNULL(DC.MaritalStatus, 'Unknown') = 'S' THEN 'Single'
        ELSE 'Unknown'
    END AS [Marital Status]

    -- Country Mapping
    ,CASE 
        WHEN SST.[Name] IN ('Central','Northwest', 'Northeast', 'Southwest', 'Southeast') THEN 'United States'
        ELSE SST.[Name]
    END AS [Country]

    -- Sales Channel
    ,CASE 
        WHEN SOH.OnlineOrderFlag = 1 THEN 'Online'
        WHEN SOH.OnlineOrderFlag = 0 THEN 'Store'
        ELSE 'Unknown'
    END AS SalesChannel

    -- Customer Attributes
    ,ISNULL(DC.YearlyIncome, 0) AS [New YearlyIncome]
    ,ISNULL(DC.EnglishEducation, 'Unknown') AS [New EnglishEducation]
    ,ISNULL(DC.NumberChildrenAtHome, 0) AS [New NumberOfChildrenAtHome]

    -- Order Info
    ,SOH.OrderDate
    ,OS.TotalQty
    ,SST.CountryRegionCode
    ,ISNULL(SS.[Name], 'Unknown') AS Store

    -- Product Info
    ,OS.ProductList AS [Product Name]

    -- Measures
    ,SOH.TotalDue AS Revenue
    ,OS.TotalQty AS ItemsPerTransaction
    ,OS.TotalSales AS NetProductRevenue
    ,OS.DiscountAmount AS DiscountValue
    ,OS.CostAmount AS Cost

    -- Renamed (not Attachment Rate anymore)
    ,OS.DistinctProducts AS DistinctProductsPerOrder

FROM Sales.SalesOrderHeader AS SOH

LEFT JOIN OrderSummary AS OS 
    ON OS.SalesOrderID = SOH.SalesOrderID

LEFT JOIN Sales.Customer AS C 
    ON C.CustomerID = SOH.CustomerID

LEFT JOIN Sales.Store AS SS 
    ON SS.BusinessEntityID = C.StoreID

LEFT JOIN Sales.SalesTerritory AS SST 
    ON SST.TerritoryID = SOH.TerritoryID

LEFT JOIN AdventureWorksDW2022.dbo.DimCustomer AS DC 
    ON DC.CustomerKey = C.CustomerID;
