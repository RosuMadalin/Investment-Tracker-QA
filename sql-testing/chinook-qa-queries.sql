-- QA validation queries against Chinook, the standard public sample database
-- (https://github.com/lerocha/chinook-database). Chinook itself is NOT committed to this
-- repo (it's a large third-party dataset, same reasoning as not committing the RapidAPI key
-- in ../api-testing/) - see README.md for how to fetch it and reproduce these results.
--
-- The point of this file is different from qa-validation-queries.sql: that one runs against
-- a schema we designed ourselves. This one proves the same QA skills transfer to an
-- unfamiliar schema someone else built - closer to what a first day on a QA job looks like.

-- QUERY: Customers with no invoices
SELECT c.CustomerId, c.FirstName, c.LastName
FROM Customer c
LEFT JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE i.InvoiceId IS NULL;

-- QUERY: Invoices whose Total doesn't match the sum of their line items
SELECT i.InvoiceId, i.Total AS recorded_total, ROUND(SUM(il.UnitPrice * il.Quantity), 2) AS calculated_total
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId
HAVING ROUND(i.Total, 2) != ROUND(SUM(il.UnitPrice * il.Quantity), 2);

-- QUERY: Invoice line items referencing a TrackId that doesn't exist in Track
SELECT il.InvoiceLineId, il.TrackId
FROM InvoiceLine il
LEFT JOIN Track t ON il.TrackId = t.TrackId
WHERE t.TrackId IS NULL;

-- QUERY: Duplicate customer emails
SELECT Email, COUNT(*) AS occurrences
FROM Customer
GROUP BY Email
HAVING COUNT(*) > 1;