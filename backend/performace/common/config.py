"""
Centralized configuration for Locust performance tests.
All credentials and URLs are loaded from environment variables with sensible defaults.
"""

import os
from pathlib import Path
from datetime import datetime

# ── Paths ─────────────────────────────────────────────────────────────────────
PROJECT_ROOT = Path(__file__).resolve().parent.parent
REPORTS_DIR = PROJECT_ROOT / "reports"

# ── Base URL ──────────────────────────────────────────────────────────────────
BASE_URL = os.getenv("TARGET_HOST", "http://localhost:8080")
API_PREFIX = ""

# ── Test Credentials ──────────────────────────────────────────────────────────
# End-user (role: USER)
USER_EMAIL = os.getenv("TEST_USER_EMAIL", "user@healytics.vn")
USER_PASSWORD = os.getenv("TEST_USER_PASSWORD", "user@123")

# Partner (role: PARTNER)
PARTNER_EMAIL = os.getenv("TEST_PARTNER_EMAIL", "partner@healytics.vn")
PARTNER_PASSWORD = os.getenv("TEST_PARTNER_PASSWORD", "partner@123")

# Admin (role: ADMIN)
ADMIN_EMAIL = os.getenv("TEST_ADMIN_EMAIL", "admin@healytics.vn")
ADMIN_PASSWORD = os.getenv("TEST_ADMIN_PASSWORD", "admin@123")

# ── Multi-user pool (role: USER) ─────────────────────────────────────────────
# Mirror of SEED_USERS from src/database/seeds/users/user.seeder.ts
# All share the default password "user@123".
_DEFAULT_USER_PASSWORD = "user@123"

USER_POOL = [
    {"email": "user@healytics.vn",       "password": _DEFAULT_USER_PASSWORD},
    {"email": "nguyenvana@healytics.vn",  "password": _DEFAULT_USER_PASSWORD},
    {"email": "tranthib@healytics.vn",    "password": _DEFAULT_USER_PASSWORD},
    {"email": "levanc@healytics.vn",      "password": _DEFAULT_USER_PASSWORD},
    {"email": "phamthid@healytics.vn",    "password": _DEFAULT_USER_PASSWORD},
    {"email": "hoangvane@healytics.vn",   "password": _DEFAULT_USER_PASSWORD},
    {"email": "vuthif@healytics.vn",      "password": _DEFAULT_USER_PASSWORD},
    {"email": "dangvang@healytics.vn",    "password": _DEFAULT_USER_PASSWORD},
    {"email": "buithih@healytics.vn",     "password": _DEFAULT_USER_PASSWORD},
    {"email": "ngothii@healytics.vn",     "password": _DEFAULT_USER_PASSWORD},
    {"email": "dovank@healytics.vn",      "password": _DEFAULT_USER_PASSWORD},
]

# ── Timing defaults ──────────────────────────────────────────────────────────
MIN_WAIT = float(os.getenv("MIN_WAIT", "1"))
MAX_WAIT = float(os.getenv("MAX_WAIT", "3"))

# ── Updated-module stress settings ───────────────────────────────────────────
PERF_ENABLE_MUTATIONS = os.getenv("PERF_ENABLE_MUTATIONS", "0").strip().lower() in {
    "1",
    "true",
    "yes",
    "on",
}
DISCOVERY_PAGE_LIMIT = int(os.getenv("DISCOVERY_PAGE_LIMIT", "100"))
FINANCE_STRESS_PERIODS = [
    period.strip()
    for period in os.getenv(
        "FINANCE_STRESS_PERIODS",
        "sevenDays,thirtyDays,ninetyDays",
    ).split(",")
    if period.strip()
]

# ── Report Settings ──────────────────────────────────────────────────────────
REPORT_HTML = str(REPORTS_DIR / "report.html")
REPORT_CSV_PREFIX = str(REPORTS_DIR / "stats")


def get_timestamped_report_path(prefix: str = "report") -> str:
    """Generate a timestamped report path for archival runs.

    Usage (CLI):
        locust --html $(python -c "from common.config import get_timestamped_report_path; print(get_timestamped_report_path())")

    Returns:
        str: e.g. 'reports/report_2026-04-13_23-20-00.html'
    """
    ts = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    return str(REPORTS_DIR / f"{prefix}_{ts}.html")
