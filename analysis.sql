SELECT *
FROM invoice;

SELECT *
FROM customer;

SELECT *
FROM genre;

SELECT *
FROM customer AS c
INNER JOIN invoice AS iv
USING(customerid);

SELECT *
FROM Genre;

SELECT *
FROM invoiceline;

SELECT *
FROM track;

SELECT *
from artist;

SELECT *
FROM album;

--1 Total Revenue
SELECT Sum(total) AS TotalRevenue
FROM invoice;

--2 Total Customers
SELECT COUNT(*) AS TotalCustomers
FROM customer;

--3 Total Orders
SELECT COUNT(*) AS TotalOrders
FROM invoice;

--4 Average Order Value
SELECT AVG(total) AS AverageOrderValue
FROM invoice;

--5 Average Spending per Customer
SELECT SUM(total)/COUNT(DISTINCT customerid) AS AverageSpendingPerCustomer
FROM invoice;

--6 Top 10 Customers by Spending
SELECT customerid, firstname || ' ' || lastname AS CustomerName, sum(total) AS TotalSpending
FROM customer AS c
INNER JOIN invoice AS iv
USING(customerid)
GROUP BY customerid
ORDER BY sum(total) DESC
LIMIT 10;

--7 Revenue by Country
SELECT billingcountry, SUM(total) AS Revenue
FROM invoice
GROUP BY billingcountry
ORDER BY Revenue DESC;

--8 Customer Count by Country
SELECT country, COUNT(*) AS CustomerCount
FROM customer
GROUP BY country;

--9 Top-Selling Genres
SELECT g.name as GenreName, SUM(ivl.unitprice * quantity) AS Revenue
FROM invoiceline AS ivl
INNER JOIN track AS t
USING(trackid)
INNER JOIN genre AS g
USING(genreid)
GROUP BY g.name
ORDER BY Revenue DESC;

--10 Top-Selling Artists
SELECT ar.name AS ArtistName, SUM(ivl.unitprice * quantity) AS Revenue
FROM invoiceline AS ivl
INNER JOIN track AS t
USING(trackid)
INNER JOIN album AS al
USING(albumid)
INNER JOIN artist AS ar
USING(artistid)
GROUP BY ar.name
ORDER BY Revenue DESC;

--11 Top-Selling Tracks
SELECT t.trackid, t.name AS TrackName, SUM(quantity) AS UnitsSold
FROM invoiceline AS ivl
INNER JOIN track AS t
USING(trackid)
GROUP BY t.trackid
ORDER BY UnitsSold DESC;

--12 Revenue by Year
SELECT strftime('%Y', invoicedate) AS Year, SUM(total) AS Revenue
FROM invoice
GROUP BY year;

--13 Revenue by Month
SELECT strftime('%Y-%m', invoicedate) AS Month, SUM(total) AS Revenue
FROM invoice
GROUP BY month
ORDER BY Month;

--14 Monthly / Yearly Sales Growth
WITH yearlyrevenue AS (
	SELECT strftime('%Y', invoicedate) AS Year, SUM(total) AS Revenue
	FROM invoice
	GROUP BY year
)
SELECT cur.year, cur.revenue, prev.revenue AS PrevYearRevenue,
       ROUND((cur.revenue - prev.revenue) * 100.0 / prev.revenue, 2) AS GrowthPercent
FROM yearlyrevenue cur
LEFT JOIN yearlyrevenue prev ON CAST(cur.year AS INTEGER) = CAST(prev.year AS INTEGER) + 1
ORDER BY cur.year;


--15 Highest-Performing Country
SELECT billingcountry AS HighestPerformingCountry, SUM(total) AS Revenue
FROM invoice
GROUP BY billingcountry
ORDER BY Revenue DESC
LIMIT 1;

--16 Highest-Performing Month
SELECT strftime('%m', InvoiceDate) AS Month, SUM(total) AS Revenue
FROM invoice
GROUP BY month
ORDER BY Revenue DESC
LIMIT 1;

--17 Highest-Performing Artist
SELECT ar.name AS ArtistName, SUM(ivl.unitprice * quantity) AS Revenue
FROM invoiceline AS ivl
INNER JOIN track AS t
USING(trackid)
INNER JOIN album AS al
USING(albumid)
INNER JOIN artist AS ar
USING(artistid)
GROUP BY ar.name
ORDER BY Revenue DESC
LIMIT 1;

--18 Customers with Highest Purchase Frequency
SELECT customerid, firstname || ' ' || lastname AS CustomerName, COUNT(invoiceid) AS PurchaseFrequency
FROM customer AS c
INNER JOIN invoice AS iv
USING(customerid)
GROUP BY customerid
HAVING COUNT(invoiceid) >= 7
ORDER BY COUNT(invoiceid) DESC;

--19 Revenue Contribution of Top Customers
WITH customerrevenue AS (
    SELECT c.customerid, SUM(i.total) AS totalspent
    FROM customer AS c
    JOIN invoice AS i ON c.customerid = i.customerid
    GROUP BY c.customerid
)
SELECT
    (SELECT SUM(totalspent) FROM (SELECT totalspent FROM customerrevenue ORDER BY totalspent DESC LIMIT 10)) AS Top10Revenue,
    (SELECT SUM(total) FROM invoice) AS TotalRevenue,
    ROUND((SELECT SUM(totalspent) FROM (SELECT totalspent FROM customerrevenue ORDER BY totalspent DESC LIMIT 10)) * 100.0
          / (SELECT SUM(total) FROM invoice), 2) AS Top10RevenuePercent;

--20 High, Medium and Low-Value Customer Segments
WITH customerspend AS (
    SELECT c.customerid, SUM(i.total) AS totalspent
    FROM customer AS c
    JOIN invoice AS i ON c.customerid = i.customerid
    GROUP BY c.customerid
)
SELECT
    CASE
        WHEN totalspent >= 45 THEN 'High-Value'
        WHEN totalspent >= 30 THEN 'Medium-Value'
        ELSE 'Low-Value'
    END AS segment,
    COUNT(*) AS CustomerCount,
    SUM(totalspent) AS segmentrevenue
FROM customerspend
GROUP BY segment
ORDER BY segmentrevenue DESC;

--21 Revenue by Country for 2023
SELECT billingcountry, SUM(total) AS Revenue
FROM invoice
WHERE strftime('%Y', invoicedate) = '2023'
GROUP BY billingcountry
ORDER BY Revenue DESC;
