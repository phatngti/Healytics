"""
Authentication helpers shared across all locustfiles.
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
    USER_POOL,
    API_PREFIX,
)
from models.auth_controller import (
    AdminLoginDto,
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
        resp.failure(f"Login failed ({path}): {resp.status_code}")
    return None, None
