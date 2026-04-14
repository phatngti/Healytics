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
BASE_URL = os.getenv("TARGET_HOST", "http://localhost:3000")

# ── Test Credentials ──────────────────────────────────────────────────────────
# End-user (role: USER)
USER_EMAIL = os.getenv("TEST_USER_EMAIL", "testuser@example.com")
USER_PASSWORD = os.getenv("TEST_USER_PASSWORD", "s3cureP@ssw0rd")

# Partner (role: PARTNER)
PARTNER_EMAIL = os.getenv("TEST_PARTNER_EMAIL", "partner@clinic.com")
PARTNER_PASSWORD = os.getenv("TEST_PARTNER_PASSWORD", "StrongP@ssw0rd!")

# Admin (role: ADMIN)
ADMIN_EMAIL = os.getenv("TEST_ADMIN_EMAIL", "admin@healytics.com")
ADMIN_PASSWORD = os.getenv("TEST_ADMIN_PASSWORD", "s3cureP@ssw0rd")

# ── Timing defaults ──────────────────────────────────────────────────────────
MIN_WAIT = float(os.getenv("MIN_WAIT", "1"))
MAX_WAIT = float(os.getenv("MAX_WAIT", "3"))

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
