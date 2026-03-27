"""
Centralized configuration for Locust performance tests.
All credentials and URLs are loaded from environment variables with sensible defaults.
"""

import os

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
