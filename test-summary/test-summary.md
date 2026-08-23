# Test Summary Report

**Project:** Investment Tracker – QA Testing Project
**Application under test:** https://rosumadalin.github.io/tracking-tradings/#
**Testing period:** August 2026
**Tester:** Madalin Rosu

## Scope
Manual functional, UI, validation, negative, regression and basic compatibility testing of the watchlist, charting, navigation and news features, per `../test-plan/test-plan.md`. Performance, security and test automation were explicitly out of scope for this phase.

## Results

| Metric | Count |
|--------|-------|
| Test cases designed | 15 |
| Test cases executed | 15 |
| Passed | 14 |
| Failed | 1 |
| Blocked | 0 |

| Bugs found | Count |
|------------|-------|
| Critical | 0 |
| Major | 1 |
| Minor | 0 |

Full case-by-case results: `../test-execution/test-execution.md`

## Key Findings
- The "Select range" dropdown on the Charts view is not wired to any event handler — selecting a different range never reloads the chart with new data ([BUG-001](../bug-reports/BUG-001.md)).
- Core watchlist operations (add, duplicate/empty/invalid validation, delete, persistence after refresh) all behave correctly.
- Chart rendering and browser resizing behave correctly and consistently between Chrome and Firefox.
- Navigation between Home and Charts correctly shows/hides the relevant sections.
- The Portfolio, News, Wallet and Settings navbar links (besides the dedicated Home/Charts flows) have no click behavior implemented — acceptable for this stage, since these areas are not yet built out, but worth tracking as scope grows.
- API-level testing (`../api-testing/`) confirmed the RapidAPI dependency behaves as expected (with one documented quirk on missing params), and a CRUD test against the app's own Firestore backend revealed the database has **no authentication at all** — a real risk, documented as an observation since security testing is out of scope for this phase.

## Recommendation
No blocking defects were found. **BUG-001** should be fixed before the range selector is presented to real users, since it is a visible control that currently does nothing — but it does not affect the core watchlist/chart/news functionality, which is otherwise stable.

## Next Steps
- Fix BUG-001, retest TC-09, run a regression pass on the directly related cases (TC-08, TC-09)
- Expand test-cases as Portfolio/Wallet/Settings become functional
- API-level testing done (`../api-testing/`): RapidAPI endpoints and a Firestore CRUD test, 20/20 assertions via Newman
- Consider a dedicated security-testing phase to address the unauthenticated Firestore access noted above, once this phase's scope is closed out
