# SQL Test Execution – Database Validation

Executed via `node --experimental-sqlite run-queries.js` (own schema) and `node --experimental-sqlite run-queries.js Chinook_Sqlite.sql` (Chinook).
Execution date: 2026-08-24.
Real output captured in `README.md` — every row below traces back to that actual run, not to an assumed result.

| ID | Test Case | Status | Bug | Evidence | Notes |
|----|-----------|--------|-----|----------|-------|
| SQL-TC-01 | Detect orphaned watchlist references | PASS | - | `README.md` → "Orphaned watchlist items" output | Returned exactly the seeded row (id 6, `ZZZZ`) |
| SQL-TC-02 | Detect duplicate user emails | PASS | - | `README.md` → "Duplicate user emails" output | Returned `test.user@example.com`, occurrences 2, as seeded |
| SQL-TC-03 | Detect duplicate watchlist entries | PASS | - | `README.md` → "Duplicate watchlist entries" output | Returned user_id 1 / `AAPL`, occurrences 2, as seeded |
| SQL-TC-04 | Detect invalid (negative) prices | PASS | - | `README.md` → "Invalid (negative) prices" output | Returned `NVDA`, -12, as seeded |
| SQL-TC-05 | Detect watchlist items with no matching price data | PASS | - | `README.md` → "Watchlist items with no matching price data" output | Returned both `GOOGL` (id 3) and `ZZZZ` (id 6) — the orphaned reference from SQL-TC-01 also shows up here, since it has no price data either. One seeded issue surfacing in two checks is realistic, not a duplicate bug. |
| SQL-TC-06 | Report watchlist count per user | PASS | - | `README.md` → "Watchlist count per user" output | 4 rows returned, counts 3/2/1/0, matching the seed data exactly |
| SQL-TC-07 | Detect customers with no invoices (Chinook) | PASS | - | `README.md` → Chinook section, "Customers with no invoices" | 0 rows, as expected against clean data |
| SQL-TC-08 | Detect invoice totals that don't match their line items (Chinook) | PASS | - | `README.md` → Chinook section, "Invoices whose Total doesn't match..." | 0 rows, as expected |
| SQL-TC-09 | Detect invoice lines referencing a non-existent track (Chinook) | PASS | - | `README.md` → Chinook section, "Invoice line items referencing a TrackId..." | 0 rows, as expected |
| SQL-TC-10 | Detect duplicate customer emails (Chinook) | PASS | - | `README.md` → Chinook section, "Duplicate customer emails" | 0 rows, as expected |

## Summary
- **Executed:** 10 / 10
- **Passed:** 10
- **Failed:** 0
- **Blocked:** 0

## Why no bug report
Every "PASS" above means the validation query correctly detected the issue it was designed to catch (SQL-TC-01 to 06) or correctly confirmed clean data (SQL-TC-07 to 10) — not that a defect in a real system was found. SQL-TC-01 to 06 run against a hypothetical schema seeded with deliberately engineered test fixtures (see `README.md`), not against a real production system. Filing a `BUG-00X` against fixtures we planted ourselves would misrepresent what was actually found, which breaks this project's rule of only documenting real, observed execution (the same rule that produced BUG-001 as a genuine defect, not a staged one). If this pipeline were run against a real relational backend with real data, the same queries and the same PASS/FAIL logic would apply — only then would a FAIL become a bug report.