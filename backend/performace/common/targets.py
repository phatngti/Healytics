"""English performance target reporting for Locust runs."""

from __future__ import annotations

import csv
import math
import time
from dataclasses import dataclass
from pathlib import Path
from typing import Callable

try:
    import gevent
except ImportError:  # pragma: no cover - locust normally provides gevent
    gevent = None

from locust import events

from common.config import (
    PERF_API_P95_MS,
    PERF_APP_LOAD_MS,
    PERF_APP_LOAD_RESULT_MS,
    PERF_CPU_RESULT_PERCENT,
    PERF_MAX_CPU_PERCENT,
    PERF_MAX_ERROR_RATE_PERCENT,
    PERF_MAX_NETWORK_LATENCY_MS,
    PERF_MAX_RAM_PERCENT,
    PERF_NETWORK_LATENCY_RESULT_MS,
    PERF_RAM_RESULT_PERCENT,
    PERF_TARGET_TPS,
    PERF_TARGET_USERS,
    REPORTS_DIR,
    TARGET_REPORT_CSV,
    TARGET_REPORT_MARKDOWN,
)


@dataclass(slots=True)
class TargetRow:
    criterion: str
    requirement: str
    result: str
    status: str


class TargetState:
    def __init__(self) -> None:
        self.started_at = 0.0
        self.max_users = 0
        self._sampler = None
        self._running = False

    def start(self, environment) -> None:
        self.started_at = time.monotonic()
        self.max_users = _current_user_count(environment)
        self._running = True
        if gevent is not None:
            self._sampler = gevent.spawn(self._sample_users, environment)

    def stop(self) -> None:
        self._running = False
        if self._sampler is not None:
            self._sampler.kill(block=False)
            self._sampler = None

    def _sample_users(self, environment) -> None:
        while self._running:
            self.max_users = max(self.max_users, _current_user_count(environment))
            gevent.sleep(1)


_state = TargetState()


@events.test_start.add_listener
def on_target_report_start(environment, **kwargs):
    _state.start(environment)


@events.spawning_complete.add_listener
def on_target_report_spawning_complete(user_count, **kwargs):
    _state.max_users = max(_state.max_users, int(user_count or 0))


@events.test_stop.add_listener
def on_target_report_stop(environment, **kwargs):
    _state.max_users = max(_state.max_users, _current_user_count(environment))
    _state.stop()
    rows = build_target_rows(environment, _state)
    write_target_reports(rows)


def build_target_rows(environment, state: TargetState) -> list[TargetRow]:
    total = environment.stats.total
    request_count = int(getattr(total, "num_requests", 0) or 0)
    failure_count = int(getattr(total, "num_failures", 0) or 0)
    elapsed = max(time.monotonic() - state.started_at, 0.001)

    api_p95 = _percentile_ms(total, 0.95)
    throughput = _throughput(total, request_count, elapsed)
    error_rate = (failure_count / request_count * 100) if request_count else math.nan

    return [
        _measured_row(
            "API Response Time",
            f"< {_format_number(PERF_API_P95_MS)} ms",
            api_p95,
            "ms",
            lambda value: value < PERF_API_P95_MS,
        ),
        _external_row(
            "Application Page Load",
            f"< {_format_number(PERF_APP_LOAD_MS)} ms",
            PERF_APP_LOAD_RESULT_MS,
            "ms",
            lambda value: value < PERF_APP_LOAD_MS,
        ),
        _measured_row(
            "Concurrent Users",
            f">= {_format_number(PERF_TARGET_USERS)}",
            float(max(state.max_users, _current_user_count(environment))),
            "",
            lambda value: value >= PERF_TARGET_USERS,
        ),
        _measured_row(
            "Throughput",
            f">= {_format_number(PERF_TARGET_TPS)} TPS",
            throughput,
            "TPS",
            lambda value: value >= PERF_TARGET_TPS,
        ),
        _measured_row(
            "Error Rate",
            f"< {_format_number(PERF_MAX_ERROR_RATE_PERCENT)}%",
            error_rate,
            "%",
            lambda value: value < PERF_MAX_ERROR_RATE_PERCENT,
        ),
        _external_row(
            "Maximum CPU Usage",
            f"< {_format_number(PERF_MAX_CPU_PERCENT)}%",
            PERF_CPU_RESULT_PERCENT,
            "%",
            lambda value: value < PERF_MAX_CPU_PERCENT,
        ),
        _external_row(
            "Maximum RAM Usage",
            f"< {_format_number(PERF_MAX_RAM_PERCENT)}%",
            PERF_RAM_RESULT_PERCENT,
            "%",
            lambda value: value < PERF_MAX_RAM_PERCENT,
        ),
        _external_row(
            "Network Latency",
            f"< {_format_number(PERF_MAX_NETWORK_LATENCY_MS)} ms",
            PERF_NETWORK_LATENCY_RESULT_MS,
            "ms",
            lambda value: value < PERF_MAX_NETWORK_LATENCY_MS,
        ),
    ]


def write_target_reports(rows: list[TargetRow]) -> None:
    REPORTS_DIR.mkdir(parents=True, exist_ok=True)
    _write_markdown(Path(TARGET_REPORT_MARKDOWN), rows)
    _write_csv(Path(TARGET_REPORT_CSV), rows)


def _write_markdown(path: Path, rows: list[TargetRow]) -> None:
    lines = [
        "# Performance Target Report",
        "",
        "| Criterion | Requirement | Result | Pass/Fail |",
        "|---|---:|---:|---|",
    ]
    for row in rows:
        lines.append(
            f"| {row.criterion} | {row.requirement} | {row.result} | {row.status} |"
        )
    lines.append("")
    path.write_text("\n".join(lines), encoding="utf-8")


def _write_csv(path: Path, rows: list[TargetRow]) -> None:
    with path.open("w", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        writer.writerow(["Criterion", "Requirement", "Result", "Pass/Fail"])
        for row in rows:
            writer.writerow([row.criterion, row.requirement, row.result, row.status])


def _measured_row(
    criterion: str,
    requirement: str,
    value: float,
    unit: str,
    predicate: Callable[[float], bool],
) -> TargetRow:
    if math.isnan(value):
        return TargetRow(criterion, requirement, "Not measured", "-")
    suffix = f" {unit}" if unit else ""
    return TargetRow(
        criterion,
        requirement,
        f"{_format_number(value)}{suffix}",
        "Pass" if predicate(value) else "Fail",
    )


def _external_row(
    criterion: str,
    requirement: str,
    raw_value: str | None,
    unit: str,
    predicate: Callable[[float], bool],
) -> TargetRow:
    value = _optional_float(raw_value)
    if value is None:
        return TargetRow(criterion, requirement, "Not measured", "-")
    suffix = f" {unit}" if unit else ""
    return TargetRow(
        criterion,
        requirement,
        f"{_format_number(value)}{suffix}",
        "Pass" if predicate(value) else "Fail",
    )


def _percentile_ms(total, percentile: float) -> float:
    if not getattr(total, "num_requests", 0):
        return math.nan
    try:
        return float(total.get_response_time_percentile(percentile))
    except Exception:
        return math.nan


def _throughput(total, request_count: int, elapsed: float) -> float:
    total_rps = getattr(total, "total_rps", None)
    if isinstance(total_rps, (int, float)):
        return float(total_rps)
    if not request_count:
        return math.nan
    return request_count / elapsed


def _current_user_count(environment) -> int:
    runner = getattr(environment, "runner", None)
    return int(getattr(runner, "user_count", 0) or 0)


def _optional_float(raw_value: str | None) -> float | None:
    if raw_value is None or raw_value.strip() == "":
        return None
    try:
        return float(raw_value)
    except ValueError:
        return None


def _format_number(value: float | int) -> str:
    number = float(value)
    if number.is_integer():
        return f"{int(number):,}"
    return f"{number:,.2f}".rstrip("0").rstrip(".")

