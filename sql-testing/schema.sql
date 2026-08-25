-- Hypothetical relational schema for Investment Tracker's data.
-- The real app uses Firebase Firestore (a NoSQL document store), not SQL - see README.md
-- in this folder for why this schema exists and what it's actually demonstrating.
--
-- Deliberately NOT enforcing PRAGMA foreign_keys = ON: this mirrors the real app, where
-- Firestore also does not enforce referential integrity between the "watchlist" and
-- "stock_data" collections - a watchlist entry can point at a symbol with no corresponding
-- stock_data document. The orphaned-reference query in qa-validation-queries.sql depends on
-- this being unenforced, same as it would be against the real Firestore data.

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  email TEXT NOT NULL,
  created_at TEXT NOT NULL
);

CREATE TABLE stocks (
  symbol TEXT PRIMARY KEY,
  company_name TEXT NOT NULL,
  sector TEXT
);

CREATE TABLE watchlist_items (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id),
  symbol TEXT NOT NULL,
  added_at TEXT NOT NULL
);

CREATE TABLE price_history (
  id INTEGER PRIMARY KEY,
  symbol TEXT NOT NULL,
  price REAL NOT NULL,
  recorded_at TEXT NOT NULL
);