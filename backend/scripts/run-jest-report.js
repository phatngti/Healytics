#!/usr/bin/env node
const { spawnSync } = require('node:child_process');
const path = require('node:path');
const { archiveLatestReport } = require('./test-report-history');

const cwd = process.cwd();
const args = process.argv.slice(2);
const jestBin = path.join(cwd, 'node_modules', 'jest', 'bin', 'jest.js');
const command = ['jest', ...args].join(' ');
const runStartedAt = Date.now();

const result = spawnSync(process.execPath, [jestBin, ...args], {
  cwd,
  env: process.env,
  stdio: 'inherit',
});

const archiveResult = archiveLatestReport({
  cwd,
  command,
  minStartTime: runStartedAt,
});
if (!archiveResult.ok) {
  console.warn(`[test-report] ${archiveResult.reason}`);
} else {
  console.log(`[test-report] archived ${archiveResult.summary.id}`);
  console.log(`[test-report] history ${archiveResult.historyPath}`);
}

if (result.error) {
  console.error(result.error);
  process.exit(1);
}

process.exit(result.status ?? (result.signal ? 1 : 0));
