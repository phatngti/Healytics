const fs = require('node:fs');
const path = require('node:path');

const REPORT_DIR = 'test-report';
const RESULT_RELATIVE_PATH = path.join(
  'jest-html-reporters-attach',
  'index',
  'result.js',
);

function readJsonCallback(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  const match = content.match(
    /window\.jest_html_reporters_callback__\(([\s\S]*)\)\s*;?\s*$/,
  );

  if (!match) {
    throw new Error(`Could not parse Jest HTML reporter data at ${filePath}`);
  }

  return JSON.parse(match[1]);
}

function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

function copyDir(source, target) {
  if (!fs.existsSync(source)) {
    return;
  }

  fs.cpSync(source, target, { recursive: true });
}

function readCoverageSummary(cwd, result) {
  if (!result.config?.collectCoverage) {
    return null;
  }

  const coverageDirectory =
    result.config.coverageDirectory || path.join(cwd, 'coverage');
  const summaryPath = path.join(coverageDirectory, 'coverage-summary.json');

  if (!fs.existsSync(summaryPath)) {
    return null;
  }

  const summary = JSON.parse(fs.readFileSync(summaryPath, 'utf8'));
  return normalizeCoverage(summary.total);
}

function normalizeCoverage(coverage) {
  if (!coverage) {
    return null;
  }

  return Object.fromEntries(
    Object.entries(coverage).map(([key, value]) => {
      const rawPct = value?.pct;
      const pct =
        typeof rawPct === 'number'
          ? rawPct
          : typeof rawPct === 'string' &&
              rawPct.trim() !== '' &&
              rawPct !== 'Unknown' &&
              Number.isFinite(Number(rawPct))
            ? Number(rawPct)
            : null;

      return [
        key,
        {
          ...value,
          pct,
        },
      ];
    }),
  );
}

function safePercent(numerator, denominator) {
  if (!denominator) {
    return 0;
  }

  return Number(((numerator / denominator) * 100).toFixed(2));
}

function makeRunId(startTime, status) {
  const stamp = new Date(startTime || Date.now())
    .toISOString()
    .replace(/[:.]/g, '-');

  return `${stamp}-${status}`;
}

function getFailedTests(result) {
  return (result.testResults || []).flatMap((suite) =>
    (suite.testResults || [])
      .filter((test) => test.status === 'failed')
      .map((test) => ({
        file: suite.testFilePath,
        fullName: test.fullName,
        durationMs: test.duration ?? 0,
        failureMessages: test.failureMessages || [],
      })),
  );
}

function getSlowestSuites(result) {
  return (result.testResults || [])
    .map((suite) => ({
      file: suite.testFilePath,
      durationMs:
        suite.perfStats?.runtime ??
        Math.max(
          0,
          (suite.perfStats?.end || 0) - (suite.perfStats?.start || 0),
        ),
      tests:
        (suite.numPassingTests || 0) +
        (suite.numFailingTests || 0) +
        (suite.numPendingTests || 0) +
        (suite.numTodoTests || 0),
    }))
    .sort((a, b) => b.durationMs - a.durationMs)
    .slice(0, 10);
}

function summarizeResult(cwd, result, command) {
  const failedTests = result.numFailedTests || 0;
  const failedSuites =
    (result.numFailedTestSuites || 0) + (result.numRuntimeErrorTestSuites || 0);
  const status = failedTests === 0 && failedSuites === 0 ? 'passed' : 'failed';
  const startTime = result.startTime || Date.now();
  const endTime = result.endTime || Date.now();
  const totalTests = result.numTotalTests || 0;
  const passedTests = result.numPassedTests || 0;
  const coverage = readCoverageSummary(cwd, result);
  const id = makeRunId(startTime, status);

  return {
    id,
    status,
    command,
    startedAt: new Date(startTime).toISOString(),
    finishedAt: new Date(endTime).toISOString(),
    durationMs: Math.max(0, endTime - startTime),
    rootDir: result.config?.rootDir || null,
    reportPath: `runs/${id}/index.html`,
    summaryPath: `runs/${id}/summary.json`,
    totals: {
      tests: totalTests,
      passedTests,
      failedTests,
      pendingTests: result.numPendingTests || 0,
      todoTests: result.numTodoTests || 0,
      passRate: safePercent(passedTests, totalTests),
      suites: result.numTotalTestSuites || 0,
      passedSuites: result.numPassedTestSuites || 0,
      failedSuites,
    },
    coverage,
    failedTests: getFailedTests(result),
    slowestSuites: getSlowestSuites(result),
  };
}

function readHistory(historyPath) {
  if (!fs.existsSync(historyPath)) {
    return { version: 1, updatedAt: null, runs: [] };
  }

  return JSON.parse(fs.readFileSync(historyPath, 'utf8'));
}

function writeHistory(historyPath, history, summary) {
  const existing = history.runs
    .filter((run) => run.id !== summary.id)
    .map(normalizeRun);
  history.runs = [summary, ...existing].sort(
    (a, b) => new Date(b.startedAt).getTime() - new Date(a.startedAt).getTime(),
  );
  history.updatedAt = new Date().toISOString();

  fs.writeFileSync(historyPath, `${JSON.stringify(history, null, 2)}\n`);
}

function normalizeRun(run) {
  const { jestSuccess, ...normalized } = run;
  normalized.coverage = normalizeCoverage(run.coverage);
  return normalized;
}

function escapeHtml(value) {
  return String(value ?? '')
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#39;');
}

function formatDuration(ms) {
  if (!Number.isFinite(ms)) {
    return '0s';
  }

  if (ms < 1000) {
    return `${ms}ms`;
  }

  const seconds = ms / 1000;
  if (seconds < 60) {
    return `${seconds.toFixed(1)}s`;
  }

  return `${Math.floor(seconds / 60)}m ${Math.round(seconds % 60)}s`;
}

function coveragePct(run, key) {
  const pct = run.coverage?.[key]?.pct;
  return Number.isFinite(pct) ? Number(pct) : null;
}

function average(values) {
  const valid = values.filter((value) => Number.isFinite(value));
  if (valid.length === 0) {
    return null;
  }

  return valid.reduce((sum, value) => sum + value, 0) / valid.length;
}

function renderMetricCard(label, value, hint) {
  return `
    <section class="metric">
      <span>${escapeHtml(label)}</span>
      <strong>${escapeHtml(value)}</strong>
      <small>${escapeHtml(hint)}</small>
    </section>`;
}

function renderRows(runs) {
  return runs
    .map((run) => {
      const lines = coveragePct(run, 'lines');
      const branches = coveragePct(run, 'branches');
      const statusClass = run.status === 'passed' ? 'passed' : 'failed';

      return `
        <tr>
          <td><a href="${escapeHtml(run.reportPath)}">${escapeHtml(run.startedAt)}</a></td>
          <td><span class="pill ${statusClass}">${escapeHtml(run.status)}</span></td>
          <td>${escapeHtml(run.totals.passedTests)} / ${escapeHtml(run.totals.tests)}</td>
          <td>${escapeHtml(run.totals.failedTests)}</td>
          <td>${escapeHtml(run.totals.passRate)}%</td>
          <td>${lines === null ? '-' : `${lines}%`}</td>
          <td>${branches === null ? '-' : `${branches}%`}</td>
          <td>${escapeHtml(formatDuration(run.durationMs))}</td>
          <td><code>${escapeHtml(run.command || 'jest')}</code></td>
        </tr>`;
    })
    .join('');
}

function formatRunDateLabel(value) {
  if (!value) {
    return '-';
  }

  const date = new Date(value);
  if (Number.isNaN(date.getTime())) {
    return value;
  }

  return `${date.toISOString().slice(0, 10)} ${date
    .toISOString()
    .slice(11, 16)}`;
}

function renderDotChart(runs) {
  const chartRuns = runs.slice(0, 20).reverse();
  if (chartRuns.length === 0) {
    return '<p class="empty">No test run data recorded yet.</p>';
  }

  const width = 760;
  const height = 300;
  const margin = { top: 24, right: 24, bottom: 84, left: 56 };
  const plotWidth = width - margin.left - margin.right;
  const plotHeight = height - margin.top - margin.bottom;
  const maxCount = Math.max(
    1,
    ...chartRuns.flatMap((run) => [
      run.totals?.passedTests || 0,
      run.totals?.failedTests || 0,
    ]),
  );
  const yMax = Math.max(1, Math.ceil(maxCount / 5) * 5);
  const tickCount = Math.min(5, yMax);
  const ticks = Array.from({ length: tickCount + 1 }, (_, index) =>
    Math.round((yMax / tickCount) * index),
  );

  const xFor = (index) =>
    chartRuns.length === 1
      ? margin.left + plotWidth / 2
      : margin.left + (index / (chartRuns.length - 1)) * plotWidth;
  const yFor = (value) =>
    margin.top + plotHeight - (Math.min(value, yMax) / yMax) * plotHeight;

  const gridLines = ticks
    .map((tick) => {
      const y = yFor(tick);
      return `
        <g>
          <line x1="${margin.left}" y1="${y.toFixed(2)}" x2="${width - margin.right}" y2="${y.toFixed(2)}" stroke="#e6eaf0"></line>
          <text x="${margin.left - 10}" y="${(y + 4).toFixed(2)}" text-anchor="end" class="axis-label">${escapeHtml(tick)}</text>
        </g>`;
    })
    .join('');

  const labels = chartRuns
    .map((run, index) => {
      const x = xFor(index);
      const label = formatRunDateLabel(run.startedAt);

      return `
        <text x="${x.toFixed(2)}" y="${height - 42}" transform="rotate(-35 ${x.toFixed(2)} ${height - 42})" text-anchor="end" class="axis-label">${escapeHtml(label)}</text>`;
    })
    .join('');

  const dots = chartRuns
    .map((run, index) => {
      const x = xFor(index);
      const passed = run.totals?.passedTests || 0;
      const failed = run.totals?.failedTests || 0;
      const label = formatRunDateLabel(run.startedAt);
      const passedY = yFor(passed);
      const failedY = yFor(failed);

      return `
        <g>
          <circle cx="${x.toFixed(2)}" cy="${passedY.toFixed(2)}" r="6" fill="#16803c">
            <title>${escapeHtml(label)} passed: ${escapeHtml(passed)}</title>
          </circle>
          <text x="${(x + 8).toFixed(2)}" y="${(passedY - 8).toFixed(2)}" class="dot-value">${escapeHtml(passed)}</text>
          <circle cx="${x.toFixed(2)}" cy="${failedY.toFixed(2)}" r="6" fill="#b42318">
            <title>${escapeHtml(label)} failed: ${escapeHtml(failed)}</title>
          </circle>
          <text x="${(x + 8).toFixed(2)}" y="${(failedY + 16).toFixed(2)}" class="dot-value failed-value">${escapeHtml(failed)}</text>
        </g>`;
    })
    .join('');

  return `
    <svg viewBox="0 0 ${width} ${height}" role="img" aria-label="Passed and failed test cases by run date">
      ${gridLines}
      <line x1="${margin.left}" y1="${margin.top}" x2="${margin.left}" y2="${margin.top + plotHeight}" stroke="#d9dee7"></line>
      <line x1="${margin.left}" y1="${margin.top + plotHeight}" x2="${width - margin.right}" y2="${margin.top + plotHeight}" stroke="#d9dee7"></line>
      <text x="${margin.left}" y="14" class="axis-title">Test cases</text>
      ${labels}
      ${dots}
    </svg>`;
}

function renderFailures(run) {
  if (!run?.failedTests?.length) {
    return '<p class="empty">No failed tests in the latest run.</p>';
  }

  return `
    <ul class="failures">
      ${run.failedTests
        .slice(0, 12)
        .map(
          (test) => `
            <li>
              <strong>${escapeHtml(test.fullName)}</strong>
              <span>${escapeHtml(test.file)}</span>
            </li>`,
        )
        .join('')}
    </ul>`;
}

function renderHistoryHtml(history) {
  const runs = history.runs || [];
  const latest = runs[0];
  const passedRuns = runs.filter((run) => run.status === 'passed').length;
  const avgPassRate = average(runs.map((run) => run.totals.passRate));
  const avgLineCoverage = average(runs.map((run) => coveragePct(run, 'lines')));
  const chartRunCount = Math.min(runs.length, 20);

  return `<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Healytics Test Report History</title>
  <style>
    :root {
      color-scheme: light;
      --bg: #f7f8fa;
      --panel: #ffffff;
      --border: #d9dee7;
      --text: #1d2430;
      --muted: #667085;
      --green: #16803c;
      --red: #b42318;
      --blue: #2563eb;
      --amber: #b7791f;
    }
    * { box-sizing: border-box; }
    body {
      margin: 0;
      background: var(--bg);
      color: var(--text);
      font: 14px/1.5 -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
    }
    header, main { max-width: 1200px; margin: 0 auto; padding: 24px; }
    header { padding-bottom: 8px; }
    h1 { margin: 0 0 6px; font-size: 28px; letter-spacing: 0; }
    h2 { margin: 0 0 14px; font-size: 18px; letter-spacing: 0; }
    p { margin: 0; color: var(--muted); }
    a { color: var(--blue); text-decoration: none; }
    a:hover { text-decoration: underline; }
    .metrics {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
      gap: 12px;
      margin: 20px 0;
    }
    .metric, .panel {
      background: var(--panel);
      border: 1px solid var(--border);
      border-radius: 8px;
      box-shadow: 0 1px 2px rgba(16, 24, 40, 0.04);
    }
    .metric { padding: 16px; }
    .metric span, .metric small { display: block; color: var(--muted); }
    .metric strong { display: block; margin: 6px 0 2px; font-size: 24px; }
    .grid { display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 16px; }
    .panel { padding: 18px; overflow: auto; }
    svg { display: block; width: 100%; height: auto; border: 1px solid var(--border); border-radius: 6px; background: #fbfcfe; }
    .trend-labels { display: flex; gap: 16px; margin-top: 10px; color: var(--muted); }
    .key { display: inline-flex; align-items: center; gap: 6px; }
    .key::before { content: ""; width: 10px; height: 10px; border-radius: 999px; background: var(--green); }
    .key.failed::before { background: var(--red); }
    .axis-label { fill: var(--muted); font-size: 11px; }
    .axis-title { fill: var(--muted); font-size: 12px; font-weight: 700; }
    .dot-value { fill: var(--green); font-size: 11px; font-weight: 700; }
    .failed-value { fill: var(--red); }
    table { width: 100%; border-collapse: collapse; min-width: 900px; }
    th, td { padding: 10px 12px; border-bottom: 1px solid var(--border); text-align: left; vertical-align: top; }
    th { color: var(--muted); font-size: 12px; font-weight: 600; text-transform: uppercase; }
    code { white-space: nowrap; color: #344054; }
    .pill { display: inline-flex; min-width: 64px; justify-content: center; border-radius: 999px; padding: 2px 8px; font-size: 12px; font-weight: 700; }
    .pill.passed { background: #dcfce7; color: var(--green); }
    .pill.failed { background: #fee4e2; color: var(--red); }
    .failures { list-style: none; margin: 0; padding: 0; }
    .failures li { padding: 10px 0; border-bottom: 1px solid var(--border); }
    .failures strong, .failures span { display: block; }
    .failures span { color: var(--muted); font-size: 12px; overflow-wrap: anywhere; }
    .empty { color: var(--muted); }
    @media (max-width: 800px) {
      header, main { padding: 18px; }
      .grid { grid-template-columns: 1fr; }
    }
  </style>
</head>
<body>
  <header>
    <h1>Healytics Test Report History</h1>
    <p>Updated ${escapeHtml(history.updatedAt || 'never')}. Latest detailed report: ${
      latest
        ? `<a href="${escapeHtml(latest.reportPath)}">${escapeHtml(latest.id)}</a>`
        : 'not available'
    }.</p>
  </header>
  <main>
    <div class="metrics">
      ${renderMetricCard('Runs recorded', runs.length, `${passedRuns} passed`)}
      ${renderMetricCard('Latest status', latest?.status || '-', latest?.startedAt || '-')}
      ${renderMetricCard(
        'Average pass rate',
        avgPassRate === null ? '-' : `${avgPassRate.toFixed(2)}%`,
        'Across recorded runs',
      )}
      ${renderMetricCard(
        'Average line coverage',
        avgLineCoverage === null ? '-' : `${avgLineCoverage.toFixed(2)}%`,
        'Coverage runs only',
      )}
    </div>

    <div class="grid">
      <section class="panel">
        <h2>Test Case Dot Chart</h2>
        ${renderDotChart(runs)}
        <div class="trend-labels">
          <span class="key">Passed test cases</span>
          <span class="key failed">Failed test cases</span>
          <span>${escapeHtml(chartRunCount)} latest runs by date</span>
        </div>
      </section>

      <section class="panel">
        <h2>Latest Failures</h2>
        ${renderFailures(latest)}
      </section>
    </div>

    <section class="panel" style="margin-top:16px">
      <h2>Runs</h2>
      <table>
        <thead>
          <tr>
            <th>Started</th>
            <th>Status</th>
            <th>Passed</th>
            <th>Failed</th>
            <th>Pass rate</th>
            <th>Line cov.</th>
            <th>Branch cov.</th>
            <th>Duration</th>
            <th>Command</th>
          </tr>
        </thead>
        <tbody>${renderRows(runs)}</tbody>
      </table>
    </section>
  </main>
</body>
</html>
`;
}

function archiveLatestReport(options = {}) {
  const cwd = options.cwd || process.cwd();
  const command = options.command || 'jest';
  const reportDir = path.join(cwd, REPORT_DIR);
  const resultPath = path.join(reportDir, RESULT_RELATIVE_PATH);
  const latestHtmlPath = path.join(reportDir, 'index.html');

  if (!fs.existsSync(resultPath) || !fs.existsSync(latestHtmlPath)) {
    return {
      ok: false,
      reason: `Missing latest Jest HTML report at ${reportDir}`,
    };
  }

  const result = readJsonCallback(resultPath);
  if (options.minStartTime && result.startTime < options.minStartTime) {
    return {
      ok: false,
      reason: `Latest Jest HTML report is stale at ${reportDir}`,
    };
  }

  const summary = summarizeResult(cwd, result, command);
  const runDir = path.join(reportDir, 'runs', summary.id);

  ensureDir(runDir);
  fs.copyFileSync(latestHtmlPath, path.join(runDir, 'index.html'));
  copyDir(
    path.join(reportDir, 'jest-html-reporters-attach'),
    path.join(runDir, 'jest-html-reporters-attach'),
  );
  fs.writeFileSync(
    path.join(runDir, 'summary.json'),
    `${JSON.stringify(summary, null, 2)}\n`,
  );

  const historyPath = path.join(reportDir, 'history.json');
  const history = readHistory(historyPath);
  writeHistory(historyPath, history, summary);
  fs.writeFileSync(
    path.join(reportDir, 'history.html'),
    renderHistoryHtml(history),
  );

  return {
    ok: true,
    summary,
    historyPath,
    reportPath: path.join(runDir, 'index.html'),
  };
}

if (require.main === module) {
  const result = archiveLatestReport({
    command: process.argv.slice(2).join(' ') || 'jest',
  });

  if (!result.ok) {
    console.warn(`[test-report] ${result.reason}`);
    process.exitCode = 1;
  } else {
    console.log(`[test-report] archived ${result.summary.id}`);
    console.log(`[test-report] history ${result.historyPath}`);
  }
}

module.exports = { archiveLatestReport };
