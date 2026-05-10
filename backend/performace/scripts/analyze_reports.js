#!/usr/bin/env node
/**
 * Performance Report Analyzer — HTML Edition
 * Parses Locust HTML reports and generates a self-contained HTML analysis dashboard.
 *
 * Usage: node scripts/analyze_reports.js [--out reports/analysis_report.html]
 */
const fs = require("fs");
const path = require("path");

const REPORTS_DIR = path.join(__dirname, "..", "reports");
const TEMPLATE = path.join(__dirname, "report_template.html");
const DEFAULT_OUT = path.join(REPORTS_DIR, "analysis_report.html");
const TARGETS = {
  avg_response_time_ms: 200, p95_response_time_ms: 500, p99_response_time_ms: 1000,
  error_rate_pct: 0.01, min_throughput_rps: 500, min_concurrent_users: 1000,
};
const MEANINGFUL_RUN = {
  minDurationSeconds: 10,
  minRequests: 10,
  minPeakUsers: 1,
};

// ── Helpers ────────────────────────────────────────────────────────────────
function parseArgs() {
  const a = process.argv.slice(2); let out = DEFAULT_OUT;
  for (let i = 0; i < a.length; i++) if (a[i] === "--out" && a[i+1]) out = a[++i];
  return { out };
}
function extractReportData(fp) {
  const c = fs.readFileSync(fp, "utf8");
  const m = c.match(/window\.templateArgs\s*=\s*(\{[\s\S]*?\});?\s*\n/);
  if (!m) return null;
  try { return JSON.parse(m[1]); } catch { return null; }
}
function parseDuration(s) {
  let sec = 0;
  const mi = s.match(/(\d+)\s*minute/), se = s.match(/(\d+)\s*second/);
  if (mi) sec += +mi[1]*60; if (se) sec += +se[1]; return sec || 1;
}
const f1 = (n,d=1) => n==null?"N/A":Number(n).toFixed(d);
const fPct = n => n==null?"N/A":Number(n).toFixed(3)+"%";
const esc = s => String(s).replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;");
function isMeaningfulRun(r) {
  return r.duration_secs >= MEANINGFUL_RUN.minDurationSeconds &&
    r.agg.requests >= MEANINGFUL_RUN.minRequests &&
    r.peak_users >= MEANINGFUL_RUN.minPeakUsers;
}
function runExclusionReasons(r) {
  const reasons = [];
  if (r.duration_secs < MEANINGFUL_RUN.minDurationSeconds) {
    reasons.push(`duration ${r.duration_secs}s < ${MEANINGFUL_RUN.minDurationSeconds}s`);
  }
  if (r.agg.requests < MEANINGFUL_RUN.minRequests) {
    reasons.push(`requests ${r.agg.requests} < ${MEANINGFUL_RUN.minRequests}`);
  }
  if (r.peak_users < MEANINGFUL_RUN.minPeakUsers) {
    reasons.push(`peak users ${r.peak_users} < ${MEANINGFUL_RUN.minPeakUsers}`);
  }
  return reasons;
}
function runShape(r) {
  return `${r.duration_secs}s, ${r.peak_users} users, ${r.agg.requests} requests, ${fPct(r.agg.error_rate)} errors`;
}
function latestMeaningfulRun(runs) {
  const meaningful = runs.filter(isMeaningfulRun);
  return meaningful.length ? meaningful[meaningful.length - 1] : runs[runs.length - 1];
}
function trendInfo(vals) {
  if (vals.length<2) return {text:"—",cls:"trend-stable"};
  const first=vals[0], last=vals[vals.length-1];
  if (first===0) return last===0?{text:"→ Stable",cls:"trend-stable"}:{text:"↑",cls:"trend-up"};
  const ch=((last-first)/Math.abs(first))*100;
  if (Math.abs(ch)<5) return {text:"→ Stable",cls:"trend-stable"};
  return ch>0?{text:`↑ +${ch.toFixed(1)}%`,cls:"trend-up"}:{text:`↓ ${ch.toFixed(1)}%`,cls:"trend-down"};
}
// For metrics where lower is better (RT, error), down=good, up=bad
function trendClass(vals, lowerIsBetter) {
  const t = trendInfo(vals);
  if (t.cls === "trend-stable") return t;
  if (lowerIsBetter) { t.cls = t.cls === "trend-down" ? "trend-good-down" : "trend-bad-up"; }
  else { t.cls = t.cls === "trend-up" ? "trend-up" : "trend-down"; }
  return t;
}

// ── Main ───────────────────────────────────────────────────────────────────
function main() {
  const { out } = parseArgs();
  const files = fs.readdirSync(REPORTS_DIR).filter(f => f.endsWith(".html") && !f.startsWith("analysis")).sort();
  if (!files.length) { console.error("No HTML reports found."); process.exit(1); }

  // Parse reports
  const reports = [];
  for (const f of files) {
    const data = extractReportData(path.join(REPORTS_DIR, f));
    if (!data) continue;
    const agg = data.requests_statistics?.find(s => s.name === "Aggregated");
    if (!agg) continue;
    const errorRate = agg.num_requests > 0 ? (agg.num_failures/agg.num_requests)*100 : 0;
    const peakUsers = data.history?.reduce((m,h) => Math.max(m, h.user_count?.[1]||0), 0) || 0;
    reports.push({
      file: f, start_time: data.start_time, end_time: data.end_time,
      duration: data.duration, duration_secs: parseDuration(data.duration||"0"), host: data.host,
      locustfile: data.locustfile, peak_users: peakUsers,
      agg: { requests:agg.num_requests, failures:agg.num_failures, error_rate:errorRate,
        avg_rt:agg.avg_response_time, median_rt:agg.median_response_time,
        p95:agg["response_time_percentile_0.95"], p99:agg["response_time_percentile_0.99"],
        min_rt:agg.min_response_time, max_rt:agg.max_response_time,
        rps:agg.total_rps, fail_rps:agg.total_fail_per_sec },
      endpoints: data.requests_statistics?.filter(s=>s.name!=="Aggregated").map(s=>({
        method:s.method, name:s.name, requests:s.num_requests, failures:s.num_failures,
        avg_rt:s.avg_response_time, median_rt:s.median_response_time,
        p95:s["response_time_percentile_0.95"], p99:s["response_time_percentile_0.99"], rps:s.total_rps })),
      failures_detail: data.failures_statistics||[], exceptions: data.exceptions_statistics||[],
    });
  }
  if (!reports.length) { console.error("No valid reports parsed."); process.exit(1); }

  // Group by suite
  const suites = {};
  for (const r of reports) { const k=r.locustfile||"unknown"; (suites[k]=suites[k]||[]).push(r); }

  const meaningful = reports.filter(isMeaningfulRun);
  const latestRaw = reports[reports.length-1];
  const latest = meaningful.length ? meaningful[meaningful.length-1] : latestRaw;
  const la = latest.agg;
  const excludedReports = reports.filter(r => !isMeaningfulRun(r));
  const now = new Date().toISOString().replace("T"," ").substring(0,19);

  // Pass/fail
  const checks = [
    { name:"Avg Response Time", target:`≤ ${TARGETS.avg_response_time_ms} ms`, result:`${f1(la.avg_rt)} ms`, pass: la.avg_rt<=TARGETS.avg_response_time_ms },
    { name:"P95 Response Time", target:`≤ ${TARGETS.p95_response_time_ms} ms`, result:`${la.p95} ms`, pass: la.p95<=TARGETS.p95_response_time_ms },
    { name:"Error Rate", target:`< ${TARGETS.error_rate_pct}%`, result:fPct(la.error_rate), pass: la.error_rate<=TARGETS.error_rate_pct },
    { name:"Throughput (RPS)", target:`≥ ${TARGETS.min_throughput_rps}`, result:f1(la.rps,2), pass: la.rps>=TARGETS.min_throughput_rps },
    { name:"Concurrent Users", target:`≥ ${TARGETS.min_concurrent_users}`, result:`${latest.peak_users}`, pass: latest.peak_users>=TARGETS.min_concurrent_users },
  ];
  const totalPass = checks.filter(c=>c.pass).length;

  // ── Build HTML fragments ──────────────────────────────────────────

  const meaningfulCriteria = `≥${MEANINGFUL_RUN.minDurationSeconds}s, ≥${MEANINGFUL_RUN.minRequests} requests, ≥${MEANINGFUL_RUN.minPeakUsers} user`;
  const scoreContext = `<p>${meaningful.length ? "Scored run" : "Scored run (fallback; no meaningful runs found)"}: <code>${esc(latest.file)}</code><br>
    Scope: latest meaningful run (${meaningfulCriteria}) from ${meaningful.length || reports.length} eligible report(s).</p>`;
  const runScopeNotice = latest.file !== latestRaw.file
    ? `<div class="notice notice-warn"><strong>Latest parsed report excluded from KPI:</strong> <code>${esc(latestRaw.file)}</code> (${esc(runShape(latestRaw))}). Reasons: ${esc(runExclusionReasons(latestRaw).join(", "))}. The run remains visible in the timeline and suite breakdown.</div>`
    : `<div class="notice"><strong>KPI source:</strong> latest parsed report is also the latest meaningful run. ${excludedReports.length ? `${excludedReports.length} earlier report(s) are excluded from KPI and trend scoring.` : "No reports were excluded from KPI scoring."}</div>`;

  // KPI cards
  const kpiCards = checks.map(c => `
    <div class="kpi">
      <div class="kpi-label">${esc(c.name)}</div>
      <div class="kpi-value ${c.pass?'pass':'fail'}">${esc(c.result)}</div>
      <div class="kpi-sub">Target: ${esc(c.target)} <span class="badge ${c.pass?'badge-pass':'badge-fail'}">${c.pass?'PASS':'FAIL'}</span></div>
    </div>`).join("\n");

  let trendTable = "";
  if (meaningful.length >= 2) {
    const avgRts=meaningful.map(r=>r.agg.avg_rt), p95s=meaningful.map(r=>r.agg.p95);
    const errs=meaningful.map(r=>r.agg.error_rate), rpss=meaningful.map(r=>r.agg.rps);
    const rows = [
      {label:"Avg RT (ms)",first:f1(avgRts[0]),last:f1(avgRts[avgRts.length-1]),best:f1(Math.min(...avgRts)),worst:f1(Math.max(...avgRts)),...trendClass(avgRts,true)},
      {label:"P95 RT (ms)",first:p95s[0],last:p95s[p95s.length-1],best:Math.min(...p95s),worst:Math.max(...p95s),...trendClass(p95s,true)},
      {label:"Error Rate (%)",first:fPct(errs[0]),last:fPct(errs[errs.length-1]),best:fPct(Math.min(...errs)),worst:fPct(Math.max(...errs)),...trendClass(errs,true)},
      {label:"Throughput (RPS)",first:f1(rpss[0],2),last:f1(rpss[rpss.length-1],2),best:f1(Math.max(...rpss),2),worst:f1(Math.min(...rpss),2),...trendClass(rpss,false)},
    ];
    trendTable = `<h3>Key Metric Trends (meaningful runs: ${meaningfulCriteria})</h3>
    <table><thead><tr><th>Metric</th><th>First Run</th><th>Latest Run</th><th>Best</th><th>Worst</th><th>Trend</th></tr></thead><tbody>
    ${rows.map(r=>`<tr><td>${r.label}</td><td class="num">${r.first}</td><td class="num">${r.last}</td><td class="num pass">${r.best}</td><td class="num fail">${r.worst}</td><td class="${r.cls}">${r.text}</td></tr>`).join("\n")}</tbody></table>`;
  }

  // Sparkline chart builder
  function buildChart(title, data, colorFn) {
    if (data.length < 2) return "";
    const max = Math.max(...data.map(d=>d.val), 1);
    const bars = data.map((d,i) => {
      const h = Math.max((d.val/max)*100, 2);
      const cls = colorFn(d.val);
      return `<div class="spark-bar ${cls}" style="height:${h}%;opacity:${i===data.length-1?1:0.7}" data-tip="${d.label}: ${d.tip}"></div>`;
    }).join("");
    const yMax = max > 1000 ? (max/1000).toFixed(1)+"k" : f1(max,0);
    return `<h3>${title}</h3>
    <div class="chart-container">
      <div class="y-labels"><span>${yMax}</span><span>${max>1000?(max/2000).toFixed(1)+'k':f1(max/2,0)}</span><span>0</span></div>
      <div class="sparkline">${bars}</div>
      <div class="x-labels"><span>${data[0].label}</span><span>${data[data.length-1].label}</span></div>
    </div>`;
  }

  const chartData = meaningful.map(r => ({
    label: (r.start_time||"").substring(5,16).replace("T"," "),
    val: r.agg.avg_rt, tip: f1(r.agg.avg_rt)+"ms"
  }));
  const chartAvgRt = buildChart("Avg Response Time (ms) Over Runs", chartData,
    v => v<=TARGETS.avg_response_time_ms?"bar-ok":v<=500?"bar-warn":"bar-danger");
  const rpsData = meaningful.map(r => ({
    label: (r.start_time||"").substring(5,16).replace("T"," "),
    val: r.agg.rps, tip: f1(r.agg.rps,2)+" RPS"
  }));
  const chartRps = buildChart("Throughput (RPS) Over Runs", rpsData,
    v => v>=TARGETS.min_throughput_rps?"bar-ok":v>=100?"bar-warn":"bar-danger");

  // Timeline table
  const timelineRows = reports.map((r,i) => {
    const date = (r.start_time||"").substring(0,16).replace("T"," ");
    const suite = (r.locustfile||"").replace(".py","");
    const errCls = r.agg.error_rate<=0.01?"pass":r.agg.error_rate<5?"warn":"fail";
    const quality = r.file === latest.file ? "SCORED" : isMeaningfulRun(r) ? "VALID" : "EXCLUDED";
    const qualityCls = r.file === latest.file ? "badge-pass" : isMeaningfulRun(r) ? "badge-suite" : "badge-warn";
    return `<tr>
      <td class="num">${i+1}</td><td>${esc(date)}</td><td><span class="badge badge-suite">${esc(suite)}</span></td>
      <td><span class="badge ${qualityCls}">${quality}</span></td>
      <td class="num">${r.duration_secs}s</td><td class="num">${r.peak_users}</td>
      <td class="num">${r.agg.requests}</td><td class="num ${r.agg.failures?'fail':''}">${r.agg.failures}</td>
      <td class="num ${errCls}">${fPct(r.agg.error_rate)}</td>
      <td class="num">${f1(r.agg.avg_rt)}</td><td class="num">${r.agg.p95}</td><td class="num">${f1(r.agg.rps,2)}</td></tr>`;
  }).join("\n");
  const timelineTable = `<table><thead><tr>
    <th>#</th><th>Date</th><th>Suite</th><th>Quality</th><th>Duration</th><th>Users</th>
    <th>Requests</th><th>Failures</th><th>Error%</th><th>Avg RT</th><th>P95</th><th>RPS</th>
    </tr></thead><tbody>${timelineRows}</tbody></table>`;

  // Suite tabs + content
  const suiteKeys = Object.keys(suites);
  const suiteTabs = suiteKeys.map((k,i) =>
    `<div class="tab ${i===0?'active':''}" data-target="suite-${i}">${esc(k.replace(".py",""))}</div>`
  ).join("");

  const suiteContents = suiteKeys.map((k,i) => {
    const runs = suites[k], suiteMeaningful = runs.filter(isMeaningfulRun), lr = suiteMeaningful.length ? suiteMeaningful[suiteMeaningful.length-1] : runs[runs.length-1], rawLatest = runs[runs.length-1];
    let info = `<p><strong>Runs:</strong> ${runs.length} · <strong>Meaningful:</strong> ${suiteMeaningful.length} · <strong>Date range:</strong> ${runs[0].start_time} → ${runs[runs.length-1].end_time}</p>
      <p><strong>Endpoint table source:</strong> <code>${esc(lr.file)}</code> (${esc(runShape(lr))})</p>`;
    if (rawLatest.file !== lr.file) {
      info += `<div class="notice notice-warn"><strong>Latest suite report excluded:</strong> <code>${esc(rawLatest.file)}</code> (${esc(runShape(rawLatest))}). Reasons: ${esc(runExclusionReasons(rawLatest).join(", "))}.</div>`;
    }
    if (runs.length >= 2) {
      const baseline = suiteMeaningful.length ? suiteMeaningful[0] : runs[0];
      const fa=baseline.agg, la2=lr.agg;
      const rtI = fa.avg_rt>0?((fa.avg_rt-la2.avg_rt)/fa.avg_rt*100).toFixed(1):"N/A";
      const erI = fa.error_rate>0?((fa.error_rate-la2.error_rate)/fa.error_rate*100).toFixed(1):la2.error_rate===0?"100.0":"N/A";
      info += `<p>Avg RT improvement: <strong class="${Number(rtI)>0?'pass':'fail'}">${rtI}%</strong> (${f1(fa.avg_rt)}ms → ${f1(la2.avg_rt)}ms)
        · Error rate improvement: <strong class="${Number(erI)>0?'pass':'fail'}">${erI}%</strong> (${fPct(fa.error_rate)} → ${fPct(la2.error_rate)})</p>`;
    }
    let epTable = "";
    if (lr.endpoints?.length) {
      const epRows = lr.endpoints.map(ep => {
        const rtCls = ep.avg_rt<=TARGETS.avg_response_time_ms?"pass":"fail";
        const barW = Math.min((ep.avg_rt/(TARGETS.avg_response_time_ms*5))*100, 100);
        const barCls = ep.avg_rt<=TARGETS.avg_response_time_ms?"bar-ok":ep.avg_rt<=500?"bar-warn":"bar-danger";
        return `<tr><td>${esc(ep.method)}</td><td>${esc(ep.name)}</td><td class="num">${ep.requests}</td>
          <td class="num ${ep.failures?'fail':''}">${ep.failures}</td><td class="num ${rtCls}">${f1(ep.avg_rt)}</td>
          <td class="num">${ep.p95}</td><td class="num">${f1(ep.rps,2)}</td>
          <td class="bar-cell"><div class="bar ${barCls}" style="width:${barW}%"></div></td></tr>`;
      }).join("\n");
      epTable = `<h3>Latest Run Endpoints (${esc(lr.file)})</h3>
        <table><thead><tr><th>Method</th><th>Endpoint</th><th>Reqs</th><th>Fails</th><th>Avg RT</th><th>P95</th><th>RPS</th><th>RT Bar</th></tr></thead>
        <tbody>${epRows}</tbody></table>`;
    }
    let failHtml = "";
    if (lr.failures_detail.length) {
      failHtml = `<h3>Failure Details</h3><ul class="rec-list">${lr.failures_detail.map(f =>
        `<li><strong>${esc(f.method)} ${esc(f.name)}</strong>: ${esc(f.error)} (${f.occurrences} occurrences)</li>`
      ).join("")}</ul>`;
    }
    return `<div class="tab-content ${i===0?'active':''}" id="suite-${i}"><div class="section-card">${info}${epTable}${failHtml}</div></div>`;
  }).join("\n");

  // Endpoint ranking
  const allEps = [];
  for (const runs of Object.values(suites)) {
    const lr = latestMeaningfulRun(runs);
    if (lr.endpoints) for (const ep of lr.endpoints) if (ep.requests>=5) allEps.push({...ep, suite:lr.locustfile});
  }
  let epRanking = "";
  if (allEps.length) {
    allEps.sort((a,b)=>b.avg_rt-a.avg_rt);
    const slowRows = allEps.slice(0,10).map((ep,i) => {
      const st = ep.avg_rt<=TARGETS.avg_response_time_ms;
      return `<tr><td class="num">${i+1}</td><td>${esc(ep.method)} ${esc(ep.name)}</td>
        <td class="num ${st?'pass':'fail'}">${f1(ep.avg_rt)}</td><td class="num">${ep.p95}</td>
        <td><span class="badge ${st?'badge-pass':'badge-fail'}">${st?'OK':'SLOW'}</span></td></tr>`;
    }).join("\n");
    const fastEps = allEps.slice().sort((a,b)=>a.avg_rt-b.avg_rt).slice(0,5);
    const fastRows = fastEps.map((ep,i) =>
      `<tr><td class="num">${i+1}</td><td>${esc(ep.method)} ${esc(ep.name)}</td><td class="num pass">${f1(ep.avg_rt)}</td><td class="num">${ep.p95}</td></tr>`
    ).join("\n");
    epRanking = `<div style="display:grid;grid-template-columns:1fr 1fr;gap:16px">
      <div><h3>🐌 Slowest Endpoints</h3><table><thead><tr><th>#</th><th>Endpoint</th><th>Avg RT</th><th>P95</th><th>Status</th></tr></thead><tbody>${slowRows}</tbody></table></div>
      <div><h3>🚀 Fastest Endpoints</h3><table><thead><tr><th>#</th><th>Endpoint</th><th>Avg RT</th><th>P95</th></tr></thead><tbody>${fastRows}</tbody></table></div></div>`;
  }

  // Recommendations
  const recs = [];
  if (latest.file !== latestRaw.file) recs.push(`<li><strong>Keep invalid/smoke runs out of KPI scoring</strong>: latest parsed file <code>${esc(latestRaw.file)}</code> is excluded because ${esc(runExclusionReasons(latestRaw).join(", "))}. Store smoke tests separately or keep the current analyzer filter enabled.</li>`);
  if (!checks[0].pass) recs.push(`<li><strong>Reduce avg response time</strong>: Currently ${f1(la.avg_rt)}ms (target: ≤${TARGETS.avg_response_time_ms}ms). Consider query optimization, caching, or connection pooling.</li>`);
  if (!checks[1].pass) recs.push(`<li><strong>Reduce P95 latency</strong>: Currently ${la.p95}ms (target: ≤${TARGETS.p95_response_time_ms}ms). Investigate tail-latency outliers.</li>`);
  if (!checks[2].pass) recs.push(`<li><strong>Reduce error rate</strong>: Currently ${fPct(la.error_rate)} (target: &lt;${TARGETS.error_rate_pct}%). Check rate limiting, auth failures, and connection drops.</li>`);
  if (!checks[3].pass) recs.push(`<li><strong>Increase throughput</strong>: Currently ${f1(la.rps,2)} RPS (target: ≥${TARGETS.min_throughput_rps}). Scale horizontally or optimize bottleneck endpoints.</li>`);
  if (!checks[4].pass) recs.push(`<li><strong>Increase concurrent users</strong>: Peak ${latest.peak_users} (target: ≥${TARGETS.min_concurrent_users}). Run longer tests with higher CCU settings.</li>`);
  const slowEps = allEps.filter(e=>e.avg_rt>TARGETS.avg_response_time_ms);
  if (slowEps.length) recs.push(`<li><strong>Optimize ${slowEps.length} slow endpoints</strong>: ${slowEps.slice(0,3).map(e=>`<code>${esc(e.method)} ${esc(e.name)}</code> (${f1(e.avg_rt)}ms)`).join(", ")}</li>`);
  const slowNames = new Set(slowEps.map(e => e.name));
  if (slowNames.has("/auth/check-email")) recs.push(`<li><strong>Prioritize email-check cache validation</strong>: warm <code>/auth/check-email</code> should be Redis/index-bound. Confirm cache hit rate and verify the lower-email index is used on misses.</li>`);
  if (slowNames.has("/auth/refresh")) recs.push(`<li><strong>Validate Redis refresh sessions</strong>: <code>/auth/refresh</code> should avoid PostgreSQL reads/writes on the hot path. Confirm Redis compare-and-set rotation is the primary path during Locust.</li>`);
  if (slowNames.has("/auth/user/login")) recs.push(`<li><strong>Separate password cost from API overhead</strong>: <code>/auth/user/login</code> will stay slower than reads because bcrypt is intentional. Measure bcrypt timing, DB lookup timing, and JWT signing independently.</li>`);
  if (slowNames.has("/account/me")) recs.push(`<li><strong>Confirm account cache invalidation coverage</strong>: <code>/account/me</code> should be served from Redis after the first request. Add invalidation to every profile/account mutation before raising TTL.</li>`);
  const recsHtml = recs.length ? `<ul class="rec-list">${recs.join("\n")}</ul>` : `<div class="section-card"><p class="pass" style="font-size:1.2rem;text-align:center">✅ All performance targets met!</p></div>`;

  // ── Assemble ──────────────────────────────────────────────────────
  let html = fs.readFileSync(TEMPLATE, "utf8");
  const replacements = {
    "{{GENERATED}}": now,
    "{{REPORT_COUNT}}": reports.length,
    "{{DATE_RANGE}}": `${reports[0].start_time} → ${reports[reports.length-1].end_time}`,
    "{{SUITE_COUNT}}": suiteKeys.length,
    "{{RING_CLASS}}": totalPass>=4?"ring-pass":"ring-fail",
    "{{SCORE_PCT}}": (totalPass/5*100),
    "{{SCORE}}": totalPass,
    "{{SCORE_CONTEXT}}": scoreContext,
    "{{RUN_SCOPE_NOTICE}}": runScopeNotice,
    "{{KPI_CARDS}}": kpiCards,
    "{{TREND_TABLE}}": trendTable,
    "{{CHART_AVG_RT}}": chartAvgRt,
    "{{CHART_RPS}}": chartRps,
    "{{TIMELINE_TABLE}}": timelineTable,
    "{{SUITE_TABS}}": suiteTabs,
    "{{SUITE_CONTENTS}}": suiteContents,
    "{{ENDPOINT_RANKING}}": epRanking,
    "{{RECOMMENDATIONS}}": recsHtml,
  };
  for (const [k,v] of Object.entries(replacements)) html = html.split(k).join(String(v));

  fs.writeFileSync(out, html, "utf8");
  console.log(`✅ Analysis report written to: ${out}`);
  console.log(`   ${reports.length} reports analyzed across ${suiteKeys.length} test suite(s)`);
  console.log(`   Overall: ${totalPass}/5 criteria passed`);
  process.exit(totalPass === 5 ? 0 : 1);
}
main();
