"""
Authentication helpers shared across all locustfiles.

Note on 429 handling
--------------------
Login endpoints are rate-limited per email (100 req / 60s by default).
During load tests, multiple Locust users share the same credentials,
so 429s are *expected*. We treat them as a non-failure in Locust metrics
(the rate limiter is working correctly) and pause briefly so the
throttle window can reset.
Handles login, token storage, and Authorization header injection.

Multi-user support
------------------
``login_user_unique(client)``
    Round-robin across USER_POOL — each Locust instance gets a *distinct*
    user.  Ideal for concurrency tests (booking race-condition, etc.).

``login_user_random(client)``
    Random pick from USER_POOL — may duplicate, fine for generic load tests.

``login_user(client)``
    Legacy single-user login (uses USER_EMAIL / USER_PASSWORD from config).
"""

import random
import threading

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


def refresh_employee_tokens(client, refresh_token):
    """Use an employee refresh_token to obtain a new token pair.

    401 is expected when multiple Locust users share the same employee
    account: a login by one user invalidates the refresh token held by
    another. We treat 401 as success (like 429 for rate-limiting) so it
    does not pollute error metrics. Callers should re-login on (None, None).
    """
    payload = RefreshTokenRequestDto(refresh_token=refresh_token)
    with client.post(
        f"{API_PREFIX}/auth/employee/refresh",
        json=payload.to_dict(),
        name=f"{API_PREFIX}/auth/employee/refresh",
        catch_response=True,
    ) as resp:
        if resp.status_code == 200:
            data = resp.json()
            return data.get("access_token"), data.get("refresh_token")
        if resp.status_code == 401:
            # Expected race condition — another user re-logged and
            # invalidated this refresh token. Not a real failure.
            resp.success()
            return None, None
        resp.failure(f"Employee refresh failed: {resp.status_code}")
    return None, None


def refresh_tokens(client, refresh_token):
    """Use a refresh_token to obtain a new token pair."""
    payload = RefreshTokenRequestDto(refresh_token=refresh_token)
    with client.post(
        f"{API_PREFIX}/auth/refresh",
        json=payload.to_dict(),
        name=f"{API_PREFIX}/auth/refresh",
        catch_response=True,
    ) as resp:
        if resp.status_code == 200:
            data = resp.json()
            return data.get("access_token"), data.get("refresh_token")
        resp.failure(f"Refresh failed: {resp.status_code}")
    return None, None


def auth_headers(token: str) -> dict:
    """Return Authorization header dict."""
    return {"Authorization": f"Bearer {token}"}


# ── Private ───────────────────────────────────────────────────────────────────

def _login(client, path, payload):
    """Generic login helper. `payload` is a DtoModel instance."""
    with client.post(
        path,
        json=payload.to_dict(),
        name=path,
        catch_response=True,
    ) as resp:
        if resp.status_code in (200, 201):
            data = resp.json()
            return data.get("access_token"), data.get("refresh_token")
        if resp.status_code == 429:
            # Rate-limited — expected during load tests. Mark as success
            # (the throttler is working correctly) and back off briefly.
            resp.success()
            import time
            time.sleep(2)
            return None, None
        resp.failure(f"Login failed ({path}): {resp.status_code}")
    return None, None
