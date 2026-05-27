#!/usr/bin/env node
/**
 * Captures the host hardware/runtime configuration used for performance tests.
 */
const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");

function parseArgs(argv = process.argv.slice(2)) {
  const args = { out: null, print: false };
  for (let i = 0; i < argv.length; i += 1) {
    if (argv[i] === "--out" && argv[i + 1]) {
      args.out = argv[++i];
    } else if (argv[i] === "--print") {
      args.print = true;
    }
  }
  return args;
}

function run(command, args = []) {
  const result = spawnSync(command, args, { encoding: "utf8" });
  if (result.status !== 0) return "";
  return String(result.stdout || "").trim();
}

function firstValue(commands) {
  for (const [command, args] of commands) {
    const value = run(command, args);
    if (value) return value;
  }
  return "";
}

function parseIntValue(raw) {
  const number = Number.parseInt(String(raw).trim(), 10);
  return Number.isFinite(number) ? number : null;
}

function bytesToGiB(bytes) {
  return bytes / 1024 / 1024 / 1024;
}

function formatBytes(bytes) {
  if (!Number.isFinite(bytes)) return "unknown";
  const gib = bytesToGiB(bytes);
  if (gib >= 1) return `${gib.toFixed(gib >= 10 ? 1 : 2)} GiB`;
  return `${(bytes / 1024 / 1024).toFixed(1)} MiB`;
}

function parseDiskFreeBytes(raw) {
  const lines = String(raw).trim().split(/\r?\n/).filter(Boolean);
  const parts = (lines[1] || lines[0] || "").trim().split(/\s+/);
  const availableKiB = Number.parseInt(parts[3], 10);
  return Number.isFinite(availableKiB) ? availableKiB * 1024 : null;
}

function collectHardwareConfig(options = {}) {
  const cpus = os.cpus();
  const platform = os.platform();
  const physicalCores = parseIntValue(firstValue([
    ["sysctl", ["-n", "hw.physicalcpu"]],
    ["sh", ["-c", "lscpu 2>/dev/null | awk -F: '/^Core\\(s\\) per socket/{gsub(/ /,\"\",$2); cores=$2} /^Socket\\(s\\)/{gsub(/ /,\"\",$2); sockets=$2} END{if(cores && sockets) print cores*sockets}'"]],
  ]));
  const cpuModel = cpus[0]?.model?.replace(/\s+/g, " ").trim() || firstValue([
    ["sysctl", ["-n", "machdep.cpu.brand_string"]],
    ["sh", ["-c", "lscpu 2>/dev/null | awk -F: '/^Model name/{sub(/^ /,\"\",$2); print $2; exit}'"]],
  ]) || "unknown";
  const diskFreeBytes = parseDiskFreeBytes(run("df", ["-k", "."]));

  return {
    captured_at: new Date().toISOString(),
    source: options.source || "test-run",
    host: {
      hostname: os.hostname(),
      platform,
      release: os.release(),
      type: os.type(),
      arch: os.arch(),
      machine: typeof os.machine === "function" ? os.machine() : os.arch(),
    },
    cpu: {
      model: cpuModel,
      physical_cores: physicalCores,
      logical_cores: cpus.length,
    },
    memory: {
      total_bytes: os.totalmem(),
      free_bytes: os.freemem(),
      total: formatBytes(os.totalmem()),
      free: formatBytes(os.freemem()),
    },
    disk: {
      cwd: process.cwd(),
      free_bytes: diskFreeBytes,
      free: diskFreeBytes ? formatBytes(diskFreeBytes) : "unknown",
    },
    runtime: {
      node: process.version,
      load_average: os.loadavg().map((value) => Number(value.toFixed(2))),
    },
    performance_limits: {
      backend_limit_cpus: process.env.BACKEND_LIMIT_CPUS || "",
      backend_limit_memory: process.env.BACKEND_LIMIT_MEMORY || "",
      target_host: process.env.TARGET_HOST || "",
      perf_ccu: process.env.PERF_CCU || "",
      perf_target_users: process.env.PERF_TARGET_USERS || "",
      perf_run_time: process.env.PERF_RUN_TIME || process.env.PERF_RUN_TIME_HEADLESS || "",
    },
  };
}

function formatHardwareConsole(config) {
  const cores = config.cpu.physical_cores
    ? `${config.cpu.physical_cores} physical / ${config.cpu.logical_cores} logical`
    : `${config.cpu.logical_cores} logical`;
  const lines = [
    "Hardware configuration:",
    `  Host:     ${config.host.hostname}`,
    `  OS:       ${config.host.type} ${config.host.release} (${config.host.machine})`,
    `  CPU:      ${config.cpu.model} (${cores})`,
    `  Memory:   ${config.memory.total} total, ${config.memory.free} free at capture`,
    `  Disk:     ${config.disk.free} free at ${config.disk.cwd}`,
    `  Load avg: ${config.runtime.load_average.join(", ")}`,
  ];
  if (config.performance_limits.target_host) {
    lines.push(`  Target:   ${config.performance_limits.target_host}`);
  }
  if (config.performance_limits.backend_limit_cpus || config.performance_limits.backend_limit_memory) {
    lines.push(
      `  Backend limits: CPU ${config.performance_limits.backend_limit_cpus || "not set"}, memory ${config.performance_limits.backend_limit_memory || "not set"}`
    );
  }
  lines.push(`  Captured: ${config.captured_at}`);
  return lines.join("\n");
}

function main() {
  const args = parseArgs();
  const config = collectHardwareConfig();
  if (args.out) {
    fs.mkdirSync(path.dirname(args.out), { recursive: true });
    fs.writeFileSync(args.out, `${JSON.stringify(config, null, 2)}\n`, "utf8");
  }
  if (args.print) {
    console.log(formatHardwareConsole(config));
  }
}

if (require.main === module) {
  main();
}

module.exports = {
  collectHardwareConfig,
  formatHardwareConsole,
  formatBytes,
};
