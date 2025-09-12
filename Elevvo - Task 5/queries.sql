# This SQL query file contains all my queries for the attempt of the Elevvo Pathways Data Analyst Internship Programme. 
# Provided below is the code for the Task 5 of the respective program. 

SHOW TABLES;

SELECT * FROM Customer LIMIT 5;
SELECT * FROM Invoice LIMIT 5;
SELECT * FROM InvoiceLine LIMIT 5;
SELECT * FROM Track LIMIT 5;

# Top 10 Tracks by Total Revenue
SELECT 
    t.Name AS TrackName,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY t.TrackId, t.Name
ORDER BY TotalRevenue DESC
LIMIT 10;

# Total Revenue by Customer Country
SELECT 
    c.Country,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
JOIN Customer c ON i.CustomerId = c.CustomerId
GROUP BY c.Country
ORDER BY TotalRevenue DESC
LIMIT 10;

# Revenue per Month
SELECT 
    DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS Month,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY Month
ORDER BY Month ASC;

# Revenue per Month
SELECT 
    DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS Month,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY Month
ORDER BY Month ASC;

# Monthly Sales Performance
SELECT 
    DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS Month,
    SUM(il.UnitPrice * il.Quantity) AS TotalRevenue,
    COUNT(DISTINCT i.InvoiceId) AS NumberOfInvoices
FROM InvoiceLine il
JOIN Invoice i ON il.InvoiceId = i.InvoiceId
GROUP BY Month
ORDER BY Month ASC;

# Writing JOINS to combine product and sales tables 
SELECT 
    il.InvoiceLineId,
    t.TrackId,
    t.Name AS TrackName,
    t.UnitPrice AS TrackUnitPrice,
    il.Quantity,
    (il.UnitPrice * il.Quantity) AS LineTotal
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
LIMIT 20;

# BONUS TASK: 
# Using a window function (eg. row_numer or rank) 
WITH RankedTracks AS (
    SELECT 
        c.CustomerId,
        CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
        t.Name AS TrackName,
        SUM(il.UnitPrice * il.Quantity) AS TotalSpent,
        ROW_NUMBER() OVER (
            PARTITION BY c.CustomerId 
            ORDER BY SUM(il.UnitPrice * il.Quantity) DESC
        ) AS RankWithinCustomer
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Customer c ON i.CustomerId = c.CustomerId
    JOIN Track t ON il.TrackId = t.TrackId
    GROUP BY c.CustomerId, CustomerName, t.Name
)
SELECT *
FROM RankedTracks
WHERE RankWithinCustomer <= 3
ORDER BY CustomerId, RankWithinCustomer;