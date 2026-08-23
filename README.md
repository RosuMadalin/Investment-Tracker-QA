# Investment Tracker – QA Portfolio Project

Manual QA portfolio project built around **Investment Tracker**, a live stock watchlist/charting web app.

- **Application under test (AUT):** https://rosumadalin.github.io/tracking-tradings/#
- **Source code of the app:** https://github.com/RosuMadalin/tracking-tradings
- **Role demonstrated:** Manual/Junior QA — test planning, test case design, test execution, defect reporting, regression testing.

## Project structure

```
investment-tracking-qa/
│
├── README.md
│
├── test-plan/
│   └── test-plan.md            # scope, approach, environment, entry/exit criteria
│
├── test-cases/
│   └── test-cases.md           # 15 designed test cases (functional, negative, UI, regression, compatibility)
│
├── test-execution/             # results of running the test cases against the AUT (PASS/FAIL/BLOCKED)
│
├── bug-reports/                # one file per defect found, with repro steps + severity/priority
│
├── screenshots/                # evidence for bug reports (and Jira ticket screenshots, once created)
│
├── api-testing/                # Postman collection: RapidAPI (third-party) + Firestore REST (the app's own backend)
│
└── test-summary/               # final report: totals, pass/fail rate, key findings, release recommendation
```

## Status

| Stage | Status |
|-------|--------|
| Test Plan | ✅ Done |
| Test Cases (15) | ✅ Done |
| Test Execution | ✅ Done — 14 PASS / 1 FAIL |
| Bug Reports | ✅ 1 filed (BUG-001) |
| Regression Testing | ⬜ Pending (after BUG-001 is fixed) |
| API Testing | ✅ Done — Postman collection (RapidAPI + Firestore CRUD), Environment file, 20/20 assertions passed via Newman CLI |
| Test Summary Report | ✅ Done |

## Results at a glance

- **15/15** test cases executed against the live app
- **14 PASS**, **1 FAIL**
- 1 defect found and documented: [BUG-001 — Chart range selector does not update the chart data](bug-reports/BUG-001.md)

Full results: [test-execution/test-execution.md](test-execution/test-execution.md) · Full report: [test-summary/test-summary.md](test-summary/test-summary.md)

## Bug tracking

Defects found during execution are logged as markdown files in `bug-reports/`, then mirrored into a Jira project (`Investment Tracking-QA`) for workflow tracking, with a custom `Severity` field alongside the built-in `Priority`.

- Board: To Do → In Progress → Ready for Test → In Testing → Failed → Passed → Done
- BUG-001 is tracked as **ITQ-2**, currently in `Failed` — see `screenshots/jira-board.png` and `screenshots/jira-BUG-001.png`

