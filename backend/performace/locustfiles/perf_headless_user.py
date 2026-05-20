"""Headless USER-account performance mix.

This entrypoint is intentionally scoped to generated USER accounts. The
repository-wide locustfile imports partner, employee, and WebSocket users that
depend on seeded non-USER credentials; this file keeps the default headless
target independent from those seed accounts.
"""

from __future__ import annotations

import random

from locust import HttpUser, between, tag, task
from locust.exception import StopUser

import common.targets  # noqa: F401
from common.auth import auth_headers, login_user_random, login_user_unique, refresh_tokens
from common.config import API_PREFIX, MAX_WAIT, MIN_WAIT, USER_POOL
from models.auth_controller import CheckEmailDto


AUTH = f"{API_PREFIX}/auth"
ACCOUNT = f"{API_PREFIX}/account"


@tag("perf-headless", "user-auth", "target")
class PerfHeadlessUser(HttpUser):
    """USER-only performance user backed by the generated perf account pool."""

    wait_time = between(MIN_WAIT, MAX_WAIT)

    def on_start(self):
        token, refresh_token, email = login_user_unique(self.client)
        if not token:
            raise StopUser(f"Perf USER login failed for {email}")

        self.email = email
        self.headers = auth_headers(token)
        self.refresh_token = refresh_token

    @task(5)
    def check_existing_perf_user_email(self):
        self._check_email(random.choice(USER_POOL)["email"])

    @task(4)
    def user_login_random(self):
        token, refresh_token, _ = login_user_random(self.client)
        if token:
            self.headers = auth_headers(token)
        if refresh_token:
            self.refresh_token = refresh_token

    @task(3)
    def get_me(self):
        self.client.get(
            f"{ACCOUNT}/me",
            headers=self.headers,
            name=f"{ACCOUNT}/me",
        )

    @task(1)
    def refresh_user_token(self):
        if not self.refresh_token:
            return

        token, refresh_token = refresh_tokens(self.client, self.refresh_token)
        if token:
            self.headers = auth_headers(token)
        if refresh_token:
            self.refresh_token = refresh_token

    def _check_email(self, email: str):
        payload = CheckEmailDto(email=email)
        self.client.post(
            f"{AUTH}/check-email",
            json=payload.to_dict(),
            name=f"{AUTH}/check-email",
        )
