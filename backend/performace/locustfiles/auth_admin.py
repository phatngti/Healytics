"""
Auth – Admin: login → refresh → logout
"""

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT, ADMIN_EMAIL, ADMIN_PASSWORD
from common.auth import login_admin, refresh_tokens, auth_headers


class AuthAdminUser(HttpUser):
    weight = 1
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None
    refresh_token = None

    def on_start(self):
        self.access_token, self.refresh_token = login_admin(self.client)

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("auth", "admin", "login")
    @task(5)
    def login(self):
        """POST /auth/admin/login"""
        with self.client.post(
            "/auth/admin/login",
            json={"email": ADMIN_EMAIL, "password": ADMIN_PASSWORD},
            name="/auth/admin/login",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                self.access_token = data.get("access_token", self.access_token)
                self.refresh_token = data.get("refresh_token", self.refresh_token)
            else:
                resp.failure(f"Admin login failed: {resp.status_code}")

    @tag("auth", "admin", "refresh")
    @task(3)
    def do_refresh(self):
        """POST /auth/refresh"""
        if not self.refresh_token:
            return
        new_access, new_refresh = refresh_tokens(self.client, self.refresh_token)
        if new_access:
            self.access_token = new_access
            self.refresh_token = new_refresh

    @tag("auth", "admin", "logout")
    @task(1)
    def logout(self):
        """POST /auth/logout"""
        if not self.access_token:
            return
        with self.client.post(
            "/auth/logout",
            headers=auth_headers(self.access_token),
            name="/auth/logout [admin]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                self.access_token = None
                self.refresh_token = None
            else:
                resp.failure(f"Logout failed: {resp.status_code}")
