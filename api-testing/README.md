# API Testing

Investment Tracker talks to Firebase Firestore through the Firebase SDK in the app itself, and to a third-party RapidAPI service ("Yahoo Finance" on RapidAPI) for prices, historical chart data, and news. This folder tests both: the RapidAPI dependency (the app's only external data source), and — since Firestore also exposes a plain REST API under the hood, not just the SDK — a direct CRUD test against the app's own backend.

## How to use the collection

**In the Postman app:**
1. Import `postman-collection.json` into Postman.
2. Set the `rapidapi_key` collection variable's *Current Value* (not *Initial Value*, so it never gets re-exported) to a valid RapidAPI key for the `yahoo-finance166` API — the placeholder value will fail with a 401. The `firestore_base_url` variable needs no key — the database requires no authentication (see Observations below).
3. Run the collection (or individual requests) — each request has built-in `pm.test` assertions.

**From the command line, with Newman** (Postman's official CLI runner — this is what runs a collection in a CI/CD pipeline instead of a person clicking "Run" in the app):
```
npm install -g newman
newman run postman-collection.json --env-var "rapidapi_key=<your-key>"
```
Or with the environment file: `newman run postman-collection.json -e postman-environment.json` (after filling in the key there instead). To run just the Firestore folder (no key needed): `newman run postman-collection.json --folder "Firebase Firestore (qa_test_objects)"`.

**Note on the key:** the real key is intentionally *not* committed here — it's a live credential and the file is meant to be public on GitHub. As a side note unrelated to this test scope: the app's own frontend code currently hardcodes this key in plain JS (visible in the deployed site's source), which is a separate finding worth addressing later even though security testing is out of scope for this project.

## Endpoints covered

**RapidAPI (Yahoo Finance) — third-party, read-only:**

| Endpoint | Purpose |
|----------|---------|
| `GET /api/stock/get-price` | Current price for a symbol (used by the watchlist) |
| `GET /api/stock/get-chart` | Historical candlestick data for a symbol/range (used by the charts) |
| `GET /api/news/list-by-symbol` | News articles for one or more symbols (used by the Home/news view) |

**Firestore REST API — the app's own backend, isolated `qa_test_objects` collection:**

| Endpoint | Purpose |
|----------|---------|
| `POST .../documents/qa_test_objects` | Create a document (Create) |
| `GET .../documents/qa_test_objects/{id}` | Read the created document (Read) |
| `DELETE .../documents/qa_test_objects/{id}` | Delete it (cleanup) |
| `GET .../documents/qa_test_objects/{id}` (again) | Verify deletion — expect 404 |

## Results (executed 2026-08-19, against the live API, real responses)

| Case | Status | Result |
|------|--------|--------|
| Valid symbol price (AAPL) | 200 | Returns full quote object with `regularMarketPrice` |
| Invalid symbol price (ZZZZZ) | 404 | Clean error body: `{"error":true,"message":{...,"error":{"code":"Not Found", ...}}}` |
| Missing `symbol` param | 200 (unexpected) | API does **not** reject the request — it returned a 200 with quote data instead of a 400. Documented as a known quirk of the third-party API, not something the app can control. |
| Valid chart (AAPL, 1mo) | 200 | Returns `chart.result[0]` with timestamps + OHLC arrays |
| Valid news (AAPL) | 200 | Returns `data.main.stream` array of articles |

## Newman CLI run (executed 2026-08-21)

```
$ newman run postman-collection.json --env-var "rapidapi_key=***"

Investment Tracker - API Testing

□ Price
└ GET price - valid symbol (AAPL) [200 OK]
  √ Status code is 200
  √ Response has a regularMarketPrice
└ GET price - invalid symbol (ZZZZZ) [404 Not Found]
  √ Status code is 404 for unknown symbol
  √ Error body reports Not Found
└ GET price - missing symbol param [200 OK]
  √ Response status is documented (200 observed, not 400)

□ Historical Chart
└ GET chart - valid symbol + range (AAPL, 1mo) [200 OK]
  √ Status code is 200
  √ Response contains chart result with timestamps
└ GET chart - invalid symbol [404 Not Found]
  √ Request completes (status documented, not assumed)

□ News
└ GET news - valid symbol (AAPL) [200 OK]
  √ Status code is 200
  √ Response contains a news stream array
└ GET news - missing symbol param [200 OK]
  √ Request completes (status documented, not assumed)

  assertions   11 executed, 0 failed
  total run duration: 4.8s
```

11/11 assertions passed. Note: running the same suite repeatedly in a short window (as happened once during development, with 9 rapid-fire calls) triggered `429 Too Many Requests` from the third-party API — a reminder that this is a rate-limited free-tier API, which matters if this collection is ever wired into a CI pipeline that runs on every commit.

## Firebase Firestore CRUD test (executed 2026-08-23, against the live database, real responses)

Chained requests, run in order, against a dedicated `qa_test_objects` collection that the app itself never reads or writes — isolated from the real `watchlist`/`stock_data` data used by the live app.

```
$ newman run postman-collection.json --folder "Firebase Firestore (qa_test_objects)"

Investment Tracker - API Testing

□ Firebase Firestore (qa_test_objects)
└ 1. POST - Create Object
  POST .../documents/qa_test_objects [200 OK, 895B, 738ms]
  √ Status code is 200
  √ Response has a document name
  √ Created document has the expected name field
  'Created Firestore doc ID:', 'T0Av3cgJWui0Tt0EHRun'

└ 2. GET - Read Created Object
  GET .../documents/qa_test_objects/T0Av3cgJWui0Tt0EHRun [200 OK, 896B, 197ms]
  √ Status code is 200
  √ Returned document matches created name field
  √ Returned document id matches the created id

└ 3. DELETE - Cleanup Created Object
  DELETE .../documents/qa_test_objects/T0Av3cgJWui0Tt0EHRun [200 OK, 402B, 246ms]
  √ Status code is 200

└ 4. GET - Verify Deletion (expect 404)
  GET .../documents/qa_test_objects/T0Av3cgJWui0Tt0EHRun [404 Not Found, 612B, 223ms]
  √ Status code is 404 after deletion (document no longer exists)
  √ Error body reports NOT_FOUND

  assertions   9 executed, 0 failed
  total run duration: 1718ms
```

9/9 assertions passed. Cleanup verified two ways: the 404 on the final GET, and a direct follow-up check that the `qa_test_objects` collection is empty (`GET .../documents/qa_test_objects` → `{}`) — no test data left behind in the live database.

## Observations
The "missing required parameter returns 200 instead of 400" behavior is worth keeping an eye on: since the app's own client-side validation (`validateStockSymbol` in `watchlist.js`) relies on this API returning a usable price for a symbol to decide if it's valid, any looseness in the API's own validation could let unexpected input through the app's "invalid symbol" check in edge cases. Not filed as a bug against the app itself — it's third-party API behavior — but flagged here as a risk to watch.

**The app's Firestore database is fully open, with no authentication.** `index.html` has the Firebase Auth SDK commented out, and a direct, unauthenticated `GET` to `https://firestore.googleapis.com/v1/projects/tracking-tradings-727aa/databases/(default)/documents/watchlist` returns real production data with no token required — the same is true for writes (proven by the CRUD test above succeeding with no auth header at all). This means anyone with the project ID could read or overwrite the live `watchlist`/`stock_data` collections directly, bypassing the app entirely. Security testing is explicitly out of scope for this project (see `../test-plan/test-plan.md`), so this is documented here as a risk observation, not filed as a bug or fixed — the same treatment given to the hardcoded RapidAPI key above.