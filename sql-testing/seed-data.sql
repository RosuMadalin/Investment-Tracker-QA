-- Test data for the hypothetical schema in schema.sql.
-- Mostly realistic rows, plus a handful of DELIBERATELY seeded data-quality issues
-- (each marked below), so the queries in qa-validation-queries.sql have real,
-- reproducible problems to catch. These are engineered test fixtures, not claims
-- about bugs found in the real application.

INSERT INTO users (id, email, created_at) VALUES
  (1, 'madalin@example.com', '2026-08-01T09:00:00Z'),
  (2, 'test.user@example.com', '2026-08-02T10:15:00Z'),
  (3, 'ana.popescu@example.com', '2026-08-03T11:30:00Z'),
  (4, 'test.user@example.com', '2026-08-04T08:45:00Z'); -- SEEDED ISSUE: duplicate email (same as user 2)

INSERT INTO stocks (symbol, company_name, sector) VALUES
  ('AAPL', 'Apple Inc.', 'Technology'),
  ('MSFT', 'Microsoft Corporation', 'Technology'),
  ('GOOGL', 'Alphabet Inc.', 'Technology'),
  ('TSLA', 'Tesla Inc.', 'Automotive'),
  ('NVDA', 'NVIDIA Corporation', 'Technology');

INSERT INTO watchlist_items (id, user_id, symbol, added_at) VALUES
  (1, 1, 'AAPL', '2026-08-05T09:00:00Z'),
  (2, 1, 'MSFT', '2026-08-05T09:05:00Z'),
  (3, 2, 'GOOGL', '2026-08-06T14:20:00Z'),
  (4, 3, 'TSLA', '2026-08-07T16:00:00Z'),
  (5, 1, 'AAPL', '2026-08-08T10:00:00Z'), -- SEEDED ISSUE: duplicate watchlist entry (user 1 already watches AAPL via id 1) - mirrors TC-02 (duplicate symbol) from the manual test suite, now checked at the data layer
  (6, 3, 'ZZZZ', '2026-08-09T12:00:00Z'); -- SEEDED ISSUE: orphaned reference - 'ZZZZ' does not exist in stocks

-- Note: GOOGL intentionally has no price_history row below (SEEDED ISSUE: missing price data,
-- e.g. a failed price fetch), so watchlist item 3 has nothing to join against.
INSERT INTO price_history (id, symbol, price, recorded_at) VALUES
  (1, 'AAPL', 227.55, '2026-08-20T16:00:00Z'),
  (2, 'MSFT', 415.30, '2026-08-20T16:00:00Z'),
  (3, 'TSLA', 214.11, '2026-08-20T16:00:00Z'),
  (4, 'NVDA', -12.00, '2026-08-20T16:00:00Z'); -- SEEDED ISSUE: invalid negative price