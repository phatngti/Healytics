"""
Authentication helpers shared across all locustfiles.
Handles login, token storage, and Authorization header injection.
"""

from common.config import (
    USER_EMAIL, USER_PASSWORD,
    PARTNER_EMAIL, PARTNER_PASSWORD,
    ADMIN_EMAIL, ADMIN_PASSWORD,
)


def login_user(client):
    """Login as end-user and return (access_token, refresh_token) or (None, None)."""
    return _login(client, "/auth/user/login", USER_EMAIL, USER_PASSWORD)


def login_partner(client):
    """Login as partner and return (access_token, refresh_token) or (None, None)."""
    return _login(client, "/auth/partner/login", PARTNER_EMAIL, PARTNER_PASSWORD)


def login_admin(client):
    """Login as admin and return (access_token, refresh_token) or (None, None)."""
    return _login(client, "/auth/admin/login", ADMIN_EMAIL, ADMIN_PASSWORD)


def refresh_tokens(client, refresh_token):
    """Use a refresh_token to obtain a new token pair."""
    with client.post(
        "/auth/refresh",
        json={"refresh_token": refresh_token},
        name="/auth/refresh",
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

def _login(client, path, email, password):
    """Generic login helper."""
    with client.post(
        path,
        json={"email": email, "password": password},
        name=path,
        catch_response=True,
    ) as resp:
        if resp.status_code in (200, 201):
            data = resp.json()
            return data.get("access_token"), data.get("refresh_token")
        resp.failure(f"Login failed ({path}): {resp.status_code}")
    return None, None
