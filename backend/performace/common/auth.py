"""
Authentication helpers shared across all locustfiles.

Note on retry handling
----------------------
Login endpoints are rate-limited per email (1000 req / 60s default).
During load tests, multiple Locust users share the same credentials,
so 429s are *expected* during extreme bursts. We treat them as a
non-failure in Locust metrics and pause briefly. Transient gateway
5xx responses are retried so only the final failed attempt is reported.

Multi-user support
------------------
``login_user_unique(client)``
    Round-robin across USER_POOL — each Locust instance gets a *distinct*
    user.  Ideal for concurrency tests (booking race-condition, etc.).

``login_user_random(client)``
    Random pick from USER_POOL — may duplicate, fine for generic load tests.

``login_user(client)``
    Legacy single-user login (uses USER_EMAIL / USER_PASSWORD from config).

The _login() helper retries with backoff on 429s and transient 5xx responses.
"""

import random
import threading
import time

from common.config import (
    USER_EMAIL, USER_PASSWORD,
    PARTNER_EMAIL, PARTNER_PASSWORD,
    ADMIN_EMAIL, ADMIN_PASSWORD,
    EMPLOYEE_EMAIL, EMPLOYEE_PASSWORD,
    USER_POOL,
    API_PREFIX,
)
from models.auth_controller import (
    AdminLoginDto,
    EmployeeLoginDto,
    LoginDto,
    PartnerLoginDto,
    RefreshTokenRequestDto,
)

# ── Round-robin index for unique user assignment ─────────────────────────────
_user_index = 0
_user_index_lock = threading.Lock()


def _next_user_credentials() -> tuple[str, str]:
    """Return (email, password) for the next user in the pool (round-robin)."""
    global _user_index
    with _user_index_lock:
        creds = USER_POOL[_user_index % len(USER_POOL)]
        _user_index += 1
    return creds["email"], creds["password"]


# ── Public API ───────────────────────────────────────────────────────────────

def login_user(client):
    """Login as the default end-user and return (access_token, refresh_token) or (None, None)."""
    payload = LoginDto(email=USER_EMAIL, password=USER_PASSWORD)
    return _login(client, f"{API_PREFIX}/auth/user/login", payload)


def login_user_unique(client):
    """Login as a *unique* end-user (round-robin from USER_POOL).

    Returns (access_token, refresh_token, email) or (None, None, None).
    The email is returned so callers can log which user was assigned.
    """
    email, password = _next_user_credentials()
    payload = LoginDto(email=email, password=password)
    access, refresh = _login(client, f"{API_PREFIX}/auth/user/login", payload)
    return access, refresh, email


def login_user_random(client):
    """Login as a *random* end-user from USER_POOL.

    Returns (access_token, refresh_token, email) or (None, None, None).
    """
    creds = random.choice(USER_POOL)
    payload = LoginDto(email=creds["email"], password=creds["password"])
    access, refresh = _login(client, f"{API_PREFIX}/auth/user/login", payload)
    return access, refresh, creds["email"]


def login_user_credentials(client, email: str, password: str):
    """Login with an explicit USER email/password pair."""
    payload = LoginDto(email=email, password=password)
    return _login(client, f"{API_PREFIX}/auth/user/login", payload)


def login_partner(client):
    """Login as partner and return (access_token, refresh_token) or (None, None)."""
    payload = PartnerLoginDto(email=PARTNER_EMAIL, password=PARTNER_PASSWORD)
    return _login(client, f"{API_PREFIX}/auth/partner/login", payload)


def login_admin(client):
    """Login as admin and return (access_token, refresh_token) or (None, None)."""
    payload = AdminLoginDto(email=ADMIN_EMAIL, password=ADMIN_PASSWORD)
    return _login(client, f"{API_PREFIX}/auth/admin/login", payload)


def login_employee(client):
    """Login as employee and return (access_token, refresh_token) or (None, None)."""
    payload = EmployeeLoginDto(email=EMPLOYEE_EMAIL, password=EMPLOYEE_PASSWORD)
    return _login(client, f"{API_PREFIX}/auth/employee/login", payload)


def refresh_tokens(client, refresh_token):
    """Use a USER refresh token to obtain a new token pair."""
    payload = RefreshTokenRequestDto(refresh_token=refresh_token)
    return _refresh(client, f"{API_PREFIX}/auth/refresh", payload)


def auth_headers(token: str) -> dict:
    """Return Authorization header dict."""
    return {"Authorization": f"Bearer {token}"}


# ── Private ───────────────────────────────────────────────────────────────────

_RETRYABLE_AUTH_STATUSES = {429, 500, 502, 503, 504}


def _login(client, path, payload, max_retries=3):
    """Generic login helper with automatic retry on 429.

    `payload` is a DtoModel instance.

    Retry strategy:
    - 429/5xx gateway errors: wait with jitter, retry up to max_retries
    - 401/403: immediate fail (bad credentials / wrong role)
    - Other errors: fail after the response is recorded
    """
    for attempt in range(max_retries + 1):
        with client.post(
            path,
            json=payload.to_dict(),
            name=path,
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 201):
                data = resp.json()
                return data.get("access_token"), data.get("refresh_token")
            if resp.status_code in _RETRYABLE_AUTH_STATUSES and attempt < max_retries:
                # Only the final failed attempt should count in the report.
                resp.success()
                time.sleep(_auth_backoff(attempt))
                continue
            resp.failure(f"Login failed ({path}): {resp.status_code}")
            return None, None
    return None, None


def _refresh(client, path, payload, max_retries=3):
    """Generic refresh helper with retry for transient auth edge failures."""
    for attempt in range(max_retries + 1):
        with client.post(
            path,
            json=payload.to_dict(),
            name=path,
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                return data.get("access_token"), data.get("refresh_token")
            if resp.status_code in _RETRYABLE_AUTH_STATUSES and attempt < max_retries:
                resp.success()
                time.sleep(_auth_backoff(attempt))
                continue
            resp.failure(f"Refresh failed ({path}): {resp.status_code}")
            return None, None
    return None, None


def _auth_backoff(attempt: int) -> float:
    return min(5.0, (0.5 * (attempt + 1)) + random.uniform(0, 0.5))
