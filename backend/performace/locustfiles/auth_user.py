"""
Auth – End-User: register → login → refresh → logout
"""

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT, USER_EMAIL, USER_PASSWORD
from common.auth import login_user, refresh_tokens, auth_headers
from common.data_generators import generate_register_user


class AuthEndUser(HttpUser):
    weight = 3
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None
    refresh_token = None

    def on_start(self):
        self.access_token, self.refresh_token = login_user(self.client)

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("auth", "register")
    @task(1)
    def register_user(self):
        """POST /auth/user/register"""
        payload = generate_register_user()
        with self.client.post(
            "/auth/user/register",
            json=payload,
            name="/auth/user/register",
            catch_response=True,
        ) as resp:
            if resp.status_code in (201, 409):
                resp.success()
            else:
                resp.failure(f"Register failed: {resp.status_code}")

    @tag("auth", "login")
    @task(5)
    def login(self):
        """POST /auth/user/login"""
        with self.client.post(
            "/auth/user/login",
            json={"email": USER_EMAIL, "password": USER_PASSWORD},
            name="/auth/user/login",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                self.access_token = data.get("access_token", self.access_token)
                self.refresh_token = data.get("refresh_token", self.refresh_token)
            else:
                resp.failure(f"Login failed: {resp.status_code}")

    @tag("auth", "refresh")
    @task(3)
    def do_refresh(self):
        """POST /auth/refresh"""
        if not self.refresh_token:
            return
        new_access, new_refresh = refresh_tokens(self.client, self.refresh_token)
        if new_access:
            self.access_token = new_access
            self.refresh_token = new_refresh

    @tag("auth", "logout")
    @task(1)
    def logout(self):
        """POST /auth/logout"""
        if not self.access_token:
            return
        with self.client.post(
            "/auth/logout",
            headers=auth_headers(self.access_token),
            name="/auth/logout",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                self.access_token = None
                self.refresh_token = None
            else:
                resp.failure(f"Logout failed: {resp.status_code}")
