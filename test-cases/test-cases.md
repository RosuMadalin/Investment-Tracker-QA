# Test Cases – Investment Tracker

Reference: `../test-plan/test-plan.md`
AUT: https://rosumadalin.github.io/Investment-Tracker/

| ID | Title | Type | Priority | Preconditions | Steps | Expected Result |
|----|-------|------|----------|----------------|-------|------------------|
| TC-01 | Add a valid stock symbol to the watchlist | Functional | High | App is loaded, watchlist is empty or has room | 1. Enter a valid symbol (e.g. `AAPL`) in the stock input 2. Click **+** | Symbol is added to the watchlist, price begins loading, and a chart is generated for it |
| TC-02 | Add a stock symbol that is already in the watchlist | Negative / Validation | Medium | Watchlist already contains `AAPL` | 1. Enter `AAPL` again 2. Click **+** | An alert informs the user the symbol already exists; no duplicate entry is added |
| TC-03 | Add a stock with an empty input field | Negative / Validation | Medium | Stock input is empty | Click **+** without typing anything | An alert prompts the user to enter a stock symbol; nothing is added |
| TC-04 | Add an invalid / non-existent stock symbol | Negative / Validation | High | Stock input is empty | 1. Enter a symbol that doesn't exist (e.g. `ZZZZZ`) 2. Click **+** | An alert informs the user the symbol is invalid; symbol is not added to the watchlist |
| TC-05 | Stock symbol input is not case-sensitive | Functional | Low | Stock input is empty | 1. Enter a valid symbol in lowercase (e.g. `aapl`) 2. Click **+** | Symbol is normalized to uppercase (`AAPL`) and added correctly |
| TC-06 | Delete a stock from the watchlist | Functional | High | Watchlist has at least one symbol | Click the ❌ button next to a symbol | The symbol is removed from the watchlist and its chart is no longer displayed |
| TC-07 | Collapse and expand the watchlist panel | UI | Low | Watchlist is visible | Click the ⬇️/⬆️ toggle button | Watchlist list collapses/expands and the button icon updates accordingly |
| TC-08 | Charts are displayed for every watchlisted symbol | Functional | High | Watchlist contains one or more symbols | Click **Charts** in the navbar | A candlestick chart is rendered for each symbol currently in the watchlist |
| TC-09 | Change the chart range from the range selector | Functional | Medium | Charts view is open with at least one chart displayed | Select a different range from the dropdown (e.g. 1D → 1M) | Chart data updates to reflect the newly selected range |
| TC-10 | Resize the browser window while charts are displayed | UI / Compatibility | Medium | Charts view is open | Resize the browser window (e.g. shrink and expand) | Chart(s) resize to fit the container without breaking layout or overflowing |
| TC-11 | Navigate to Home after viewing Charts | Functional | Medium | Charts view is currently open | Click **Home** in the navbar | Charts and range selector are hidden; the news section is displayed instead |
| TC-12 | News section shows articles related to watchlist symbols | Functional | Medium | Watchlist contains at least one symbol; Home view is open | Open the Home view | Up to 3 news articles related to the watchlisted symbols are displayed with title, snippet, and link |
| TC-13 | Watchlist persists after a page refresh | Regression | High | Watchlist contains one or more symbols | Refresh the page (F5) | Previously added symbols are reloaded from storage and displayed in the watchlist |
| TC-14 | Portfolio tab has no functional content | Negative / Known limitation | Low | App is loaded | Click **Portfolio** in the navbar | Only placeholder text is shown ("Statistics, charts, or widgets go here"); no real portfolio data is displayed |
| TC-15 | Basic cross-browser check | Compatibility | Low | App is loaded | Open the app in Chrome and in a second browser (Edge or Firefox) | Layout, watchlist, and charts render consistently in both browsers |
