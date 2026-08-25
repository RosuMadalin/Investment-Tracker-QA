// Runs the .sql files in this folder for real against node:sqlite and prints labeled results.
// Requires Node 22.5+ with the --experimental-sqlite flag:
//
//   node --experimental-sqlite run-queries.js
//   node --experimental-sqlite run-queries.js /path/to/Chinook_Sqlite.sql   (also runs the Chinook section)
//
// The .sql files are the real deliverable (readable/runnable in any SQLite tool); this script
// is just the runner used to execute them and capture genuine output for README.md.

const { DatabaseSync } = require('node:sqlite');
const fs = require('fs');
const path = require('path');

function parseQueries(sql) {
  const blocks = sql.split(/\n(?=-- QUERY: )/);
  return blocks
    .filter((b) => b.trim().startsWith('-- QUERY:'))
    .map((b) => {
      const lines = b.split('\n');
      const title = lines[0].replace('-- QUERY:', '').trim();
      const query = lines.slice(1).join('\n').trim();
      return { title, query };
    });
}

function printRows(rows) {
  if (rows.length === 0) {
    console.log('  (0 rows)');
    return;
  }
  const columns = Object.keys(rows[0]);
  console.log('  ' + columns.join(' | '));
  for (const row of rows) {
    console.log('  ' + columns.map((c) => String(row[c])).join(' | '));
  }
}

function runSuite(label, setupSqlFiles, queriesFile) {
  console.log(`\n=== ${label} ===`);
  const db = new DatabaseSync(':memory:');
  for (const file of setupSqlFiles) {
    db.exec(fs.readFileSync(file, 'utf8'));
  }
  const queries = parseQueries(fs.readFileSync(queriesFile, 'utf8'));
  for (const { title, query } of queries) {
    console.log(`\n-- ${title}`);
    const rows = db.prepare(query).all();
    printRows(rows);
  }
  db.close();
}

const dir = __dirname;

runSuite(
  'Own schema (hypothetical relational Investment Tracker)',
  [path.join(dir, 'schema.sql'), path.join(dir, 'seed-data.sql')],
  path.join(dir, 'qa-validation-queries.sql')
);

const chinookScriptPath = process.argv[2];
if (chinookScriptPath && fs.existsSync(chinookScriptPath)) {
  runSuite('Chinook sample database', [chinookScriptPath], path.join(dir, 'chinook-qa-queries.sql'));
} else {
  console.log(
    '\n(Chinook section skipped - pass the path to a downloaded Chinook_Sqlite.sql as an argument to include it. See README.md.)'
  );
}