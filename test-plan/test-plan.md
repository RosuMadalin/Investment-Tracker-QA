# Test Plan – Investment Tracker

## Application Under Test
**Investment Tracker** – a web app for tracking stock watchlists, live prices, historical charts, and related market news.

## Objective
Verify that the core watchlist, charting, and navigation features of Investment Tracker work correctly, handle invalid input gracefully, and remain stable across basic browser usage.

## Scope

### In scope
- Functional testing (watchlist, charts, navigation, news)
- UI testing (layout, buttons, dropdowns, collapse/expand behavior)
- Validation testing (input rules for stock symbols)
- Negative testing (invalid, empty, and duplicate input)
- Regression testing (core flows after a bug fix or code change)
- Basic compatibility testing (Chrome / Edge, window resizing)

### Out of scope (for this phase)
- Performance / load testing
- Security testing (auth is not implemented in the current build). Exception added later: a single client-side check that no secret API key is exposed (TC-16)
- Test automation

## Test Approach
Manual black-box testing, executed directly in the browser against the running application. Each test case is logged with steps, expected result, and actual result. Failures are filed as bug reports with severity and priority.

## Environment
- Application under test (AUT): https://rosumadalin.github.io/Investment-Tracker/
- Browser: Chrome (latest), cross-checked on Edge/Firefox for compatibility cases
- OS: Windows 11
- Backend: Firebase Firestore (data persistence), RapidAPI Yahoo Finance (live prices, historical data, news)

## Entry Criteria
- Application is deployed and reachable at the AUT URL above
- Firebase connection is available

## Exit Criteria
- All planned test cases executed
- All High/Critical severity defects logged and triaged

## Deliverables
- Test Cases (`../test-cases/test-cases.md`)
- Test Execution results (`../test-execution/`)
- Bug Reports (`../bug-reports/`)
- Test Summary Report (`../test-summary/`)
