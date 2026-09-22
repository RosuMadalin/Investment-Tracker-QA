# Test Execution – Investment Tracker

Executed against the live app: https://rosumadalin.github.io/Investment-Tracker/
Execution date: 2026-08-19 (TC-01 → TC-15), 2026-09-19 (TC-16)
Executed with: Chrome (Chromium 129) for TC-01 → TC-14, cross-checked with Firefox 130 for TC-15; Firefox 156 for TC-16.
Tooling: for TC-01 → TC-15 the test steps were driven in the browser and the screenshots captured with [Playwright](https://playwright.dev/) (browser automation). TC-16 was executed manually with the Firefox DevTools Network tab. The test cases themselves were designed manually (see `../test-cases/test-cases.md`); this is not a maintained automated regression suite.

Note: all test data added during execution (`AAPL`, `NFLX`) was removed afterwards. The watchlist was restored to its original state (`GOOGL`, `MSFT`) — see `../screenshots/ZZ-final-cleanup-state.png`.

| ID | Test Case | Status | Bug | Evidence | Notes |
|----|-----------|--------|-----|----------|-------|
| TC-01 | Add a valid stock symbol to the watchlist | PASS | - | `TC-01-add-valid.png` | `AAPL` added successfully, price loaded |
| TC-02 | Add a stock symbol that is already in the watchlist | PASS | - | `TC-02-duplicate.png` | Alert "Stock symbol already exists in the watchlist." shown; no duplicate row added |
| TC-03 | Add a stock with an empty input field | PASS | - | `TC-03-empty.png` | Alert "Please enter a stock symbol." shown |
| TC-04 | Add an invalid / non-existent stock symbol | PASS | - | `TC-04-invalid.png` | Alert "Invalid stock symbol. Please enter a correct stock symbol." shown; symbol not added |
| TC-05 | Stock symbol input is not case-sensitive | PASS | - | `TC-05-lowercase.png` | `nflx` was normalized and added as `NFLX` |
| TC-06 | Delete a stock from the watchlist | PASS | - | `TC-06-delete.png` | `NFLX` removed from the list after clicking ❌ |
| TC-07 | Collapse and expand the watchlist panel | PASS | - | `TC-07-toggle.png` | Watchlist `display` toggled between `block`/`none`; icon updated |
| TC-08 | Charts are displayed for every watchlisted symbol | PASS | - | `TC-08-charts.png` | One chart rendered per symbol in the watchlist |
| TC-09 | Change the chart range from the range selector | **FAIL** | BUG-001 | `TC-09-range-change.png` | Dropdown value changes, but no `change` event handler is wired up in the code — chart data never refreshes for the newly selected range |
| TC-10 | Resize the browser window while charts are displayed | PASS | - | `TC-10-resized-narrow.png`, `TC-10-resized-back.png` | Chart resized correctly to the new container width in both directions, no overflow or broken layout observed |
| TC-11 | Navigate to Home after viewing Charts | PASS | - | `TC-11-home.png` | Charts and range selector hidden, news section shown |
| TC-12 | News section shows articles related to watchlist symbols | PASS | - | `TC-12-news.png` | 3 articles rendered with title, snippet and image |
| TC-13 | Watchlist persists after a page refresh | PASS | - | `TC-13-after-reload.png` | `AAPL` still present after a full page reload (loaded from Firestore) |
| TC-14 | Portfolio tab has no functional content | PASS | - | `TC-14-portfolio-click.png` | Only placeholder text shown, as expected. Additional finding: `#portfolio-btn` has no click handler at all in the code (same for News/Wallet/Settings links) — this matches the expected result of this test case, so it's not filed as a separate bug |
| TC-15 | Basic cross-browser check | PASS | - | `TC-15-firefox.png`, `TC-15-firefox-charts.png` | Layout, watchlist and charts render consistently between Chrome and Firefox |
| TC-16 | No secret API key is exposed in client-side requests | **FAIL** | BUG-002 | `BUG-002-network-request.png`, `BUG-002-key-in-request-headers.png` | The browser calls RapidAPI directly and the `x-rapidapi-key` header is readable in DevTools → Request Headers (value partially masked in the screenshot). The same key is hardcoded in the published JS |

## Summary (original run, 2026-08-19 → 2026-09-19)

- **Executed:** 16 / 16
- **Passed:** 14
- **Failed:** 2 (TC-09 → BUG-001, TC-16 → BUG-002)
- **Blocked:** 0

BUG-002 was fixed and retested on 2026-09-22 — see "Retest & Regression" below. BUG-001 is still open.

## Retest & Regression — BUG-002 fix (2026-09-22)

BUG-002 was fixed by routing RapidAPI calls through a Cloudflare Worker proxy (see `../bug-reports/BUG-002.md`). Retested manually in Firefox 156 against the live app.

| ID | Test Case | Status | Evidence | Notes |
|----|-----------|--------|----------|-------|
| TC-16 | No secret API key is exposed in client-side requests | **PASS** | `TC-16-retest-no-key.png` | Request now goes to `investment-tracker-proxy.madalinrosu.workers.dev`; Request Headers no longer contain `x-rapidapi-key` or `x-rapidapi-host` |
| TC-01 | Add a valid stock symbol to the watchlist | PASS (regression) | `BUG-002-regression-app-working.png` | `AAPL` added, live price loaded (`340.795 $`) through the proxy |
| TC-04 | Add an invalid / non-existent stock symbol | PASS (regression) | `TC-16-retest-no-key.png` | Invalid symbols (`GGGGGG`, `FFFFF`) still correctly rejected via the proxy (404 from upstream, same as before the fix) |
| TC-08 | Charts are displayed for every watchlisted symbol | PASS (regression) | `BUG-002-regression-app-working.png` | Chart data fetched through the proxy (961 candles logged for `AAPL`) |
| TC-12 | News section shows articles related to watchlist symbols | PASS (regression) | `BUG-002-regression-app-working.png` | News articles rendered normally through the proxy |

BUG-001 (chart range selector) remains unfixed and out of scope for this regression pass.
