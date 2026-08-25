# SQL Testing

**Investment Tracker has no SQL database.** Its real backend is Firebase Firestore, a NoSQL document store (see `../api-testing/README.md`, which even confirms Firestore's REST surface directly). There is nothing SQL to point at that belongs to the live app, and pretending otherwise would break this project's own rule of only documenting real, observed execution.

So this section is a deliberate, self-contained SQL skills demonstration, split into two real, executed pieces:

1. **A hypothetical relational schema**, designed to model what Investment Tracker's data *would* look like if it were relational — `users`, `stocks`, `watchlist_items`, `price_history` — seeded with realistic data plus a handful of deliberately planted data-quality issues, then queried with QA-relevant validation queries.
2. **A short exercise against [Chinook](https://github.com/lerocha/chinook-database)**, the standard public sample database, to show the same QA query skills applied to a schema someone else designed — closer to a first day on a real QA job than only ever querying your own schema.

## Tooling

No `sqlite3` CLI or database server needed. Node 22.5+ ships a built-in `node:sqlite` module (used here behind the `--experimental-sqlite` flag) — same idea as Newman being the runner for the Postman collection: the `.sql` files are the real, tool-agnostic deliverable (open them in any SQLite tool — DB Browser for SQLite, the `sqlite3` CLI, etc.), `run-queries.js` is just what was used here to execute them for real and capture the output below.

```
node --experimental-sqlite run-queries.js
```

## Part 1 — Own schema

`schema.sql` defines the tables. `seed-data.sql` inserts realistic rows plus 4 intentionally seeded issues (each marked `-- SEEDED ISSUE` in the file, so it reads as engineered test data, not a false claim about a real system):

| Seeded issue | Where |
|---|---|
| Duplicate user email | `users` — user 4 shares user 2's email |
| Orphaned watchlist reference | `watchlist_items` id 6 points at symbol `ZZZZ`, which doesn't exist in `stocks` |
| Duplicate watchlist entry | `watchlist_items` id 5 — user 1 already watches `AAPL` via id 1 — mirrors **TC-02** (duplicate symbol) from the manual test suite, checked here at the data layer |
| Missing price data | `GOOGL` is a valid stock with no row in `price_history` (e.g. a failed price fetch) |
| Invalid price | `NVDA` has a negative price in `price_history` |

The schema deliberately does **not** enforce foreign keys (`PRAGMA foreign_keys` stays off) — this mirrors the real app, where Firestore also doesn't enforce referential integrity between its `watchlist` and `stock_data` collections, so an orphaned reference is a realistic condition to check for, not an artificial one.

`qa-validation-queries.sql` has 6 queries, each modeling something a QA engineer actually checks at the data layer after actions happen through the UI. Real output from running them (2026-08-24):

```
-- Orphaned watchlist items (symbol not present in stocks)
  id | user_id | symbol
  6 | 3 | ZZZZ

-- Duplicate user emails
  email | occurrences
  test.user@example.com | 2

-- Duplicate watchlist entries (same user watching the same symbol twice)
  user_id | symbol | occurrences
  1 | AAPL | 2

-- Invalid (negative) prices in price history
  symbol | price | recorded_at
  NVDA | -12 | 2026-08-20T16:00:00Z

-- Watchlist items with no matching price data
  id | user_id | symbol
  3 | 2 | GOOGL
  6 | 3 | ZZZZ

-- Watchlist count per user
  email | watchlist_count
  madalin@example.com | 3
  ana.popescu@example.com | 2
  test.user@example.com | 1
  test.user@example.com | 0
```

All 4 seeded issues were caught by their corresponding query, exactly as designed — including the "missing price data" query catching both `GOOGL` (a real gap) and `ZZZZ` (a downstream effect of the orphaned reference), which is a realistic way for one data-quality issue to surface in more than one check.

## Part 2 — Chinook (unfamiliar schema)

Chinook itself is **not committed to this repo** — same reasoning as not committing the RapidAPI key in `../api-testing/`: it's a large third-party asset, not something of ours to check in. To reproduce:

```
curl -L -o Chinook_Sqlite.sql https://github.com/lerocha/chinook-database/releases/download/v1.4.5/Chinook_Sqlite.sql
node --experimental-sqlite run-queries.js Chinook_Sqlite.sql
```

`chinook-qa-queries.sql` has 4 queries against Chinook's real schema (`Customer`, `Invoice`, `InvoiceLine`, `Track`): customers with no invoices, invoices whose `Total` doesn't match the sum of their line items, invoice lines referencing a non-existent track, and duplicate customer emails.

Real output from running them (2026-08-24) — Chinook is a clean, well-formed reference dataset, so all four came back empty, which is itself the correct, expected result (it confirms the queries are checking the right thing against real data, not just against data engineered to fail):

```
-- Customers with no invoices
  (0 rows)

-- Invoices whose Total doesn't match the sum of their line items
  (0 rows)

-- Invoice line items referencing a TrackId that doesn't exist in Track
  (0 rows)

-- Duplicate customer emails
  (0 rows)
```