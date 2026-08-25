-- QA validation queries against the hypothetical schema (schema.sql + seed-data.sql).
-- Each one models a real thing a QA engineer checks at the data layer after actions
-- happen through the UI - not just "does the query run", but "does the data make sense".

-- QUERY: Orphaned watchlist items (symbol not present in stocks)
SELECT w.id, w.user_id, w.symbol
FROM watchlist_items w
LEFT JOIN stocks s ON w.symbol = s.symbol
WHERE s.symbol IS NULL;

-- QUERY: Duplicate user emails
SELECT email, COUNT(*) AS occurrences
FROM users
GROUP BY email
HAVING COUNT(*) > 1;

-- QUERY: Duplicate watchlist entries (same user watching the same symbol twice)
SELECT user_id, symbol, COUNT(*) AS occurrences
FROM watchlist_items
GROUP BY user_id, symbol
HAVING COUNT(*) > 1;

-- QUERY: Invalid (negative) prices in price history
SELECT symbol, price, recorded_at
FROM price_history
WHERE price < 0;

-- QUERY: Watchlist items with no matching price data
SELECT w.id, w.user_id, w.symbol
FROM watchlist_items w
LEFT JOIN price_history p ON w.symbol = p.symbol
WHERE p.symbol IS NULL;

-- QUERY: Watchlist count per user
SELECT u.email, COUNT(w.id) AS watchlist_count
FROM users u
LEFT JOIN watchlist_items w ON u.id = w.user_id
GROUP BY u.id
ORDER BY watchlist_count DESC;