# Investment Tracker – QA Portfolio Project

Manual QA portfolio project built around **Investment Tracker**, a live stock watchlist/charting web app.

- **Application under test (AUT):** https://rosumadalin.github.io/Investment-Tracker/
- **Source code of the app:** https://github.com/RosuMadalin/Investment-Tracker
- **Role demonstrated:** Manual/Junior QA — test planning, test case design, test execution, defect reporting, regression testing.

## Project structure

```
investment-tracker-qa/
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
├── sql-testing/                # SQL skills demo: own hypothetical schema + Chinook, since the app itself has no SQL backend
│
└── test-summary/               # final report: totals, pass/fail rate, key findings, release recommendation
```

## Status

| Stage | Status |
|-------|--------|
| Test Plan | ✅ Done |
| Test Cases (16) | ✅ Done |
| Test Execution | ✅ Done — 14 PASS / 2 FAIL |
| Bug Reports | ✅ 2 filed (BUG-001 open, BUG-002 fixed) |
| Regression Testing | ✅ Done for BUG-002 fix (TC-01, TC-04, TC-08, TC-12) — ⬜ Pending for BUG-001 |
| API Testing | ✅ Done — Postman collection (RapidAPI + Firestore CRUD), Environment file, 20/20 assertions passed via Newman CLI |
| SQL Testing | ✅ Done — 10 formal test cases + execution log, hypothetical schema (4 seeded issues, all caught) + Chinook exercise |
| Test Summary Report | ✅ Done |

## Results at a glance

- **16/16** test cases executed against the live app (TC-01 → TC-15: steps driven and evidence captured with Playwright; TC-16: manual, Firefox DevTools)
- **14 PASS**, **2 FAIL**
- 2 defects found and documented:
  - [BUG-001 — Chart range selector does not update the chart data](bug-reports/BUG-001.md) (open)
  - [BUG-002 — RapidAPI key is exposed in client-side code and in every browser request](bug-reports/BUG-002.md) (fixed and retested, 2026-09-22)

Full results: [test-execution/test-execution.md](test-execution/test-execution.md) · Full report: [test-summary/test-summary.md](test-summary/test-summary.md)

## Bug tracking

Defects found during execution are logged as markdown files in `bug-reports/`, then mirrored into a Jira project (`Investment Tracking-QA`) for workflow tracking, with a custom `Severity` field alongside the built-in `Priority`.

- Board: To Do → In Progress → Ready for Test → In Testing → Failed → Passed → Done
- BUG-001 is tracked as **ITQ-2**, currently in `Failed` — see `screenshots/jira-board.png` and `screenshots/jira-BUG-001.png`

Repo bug IDs and Jira keys are numbered independently, so each Jira ticket title starts with its repo ID (e.g. "BUG-001: ...") for easy cross-search:

| Repo ID | Jira key | Note |
|---------|----------|------|
| — | ITQ-1 | Sample ticket, not a defect |
| [BUG-001](bug-reports/BUG-001.md) | ITQ-2 | Chart range selector does not update the chart data — open |
| [BUG-002](bug-reports/BUG-002.md) | ITQ-3 | RapidAPI key exposed in client-side code — fixed and retested |

