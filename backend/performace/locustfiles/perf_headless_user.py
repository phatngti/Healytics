"""Headless USER-account performance mix.

This entrypoint is intentionally scoped to generated USER accounts. The
repository-wide locustfile imports partner, employee, and WebSocket users that
depend on seeded non-USER credentials; this file keeps the default headless
target independent from those seed accounts.
"""

from __future__ import annotations

import random
import time

from locust import HttpUser, between, tag, task
from locust.exception import StopUser

import common.targets  # noqa: F401
from common.auth import (
    auth_headers,
    login_user_credentials,
    login_user_unique,
    refresh_tokens,
)
from common.config import (
    API_PREFIX,
    MAX_WAIT,
    MIN_WAIT,
    PERF_HEADLESS_RETRY_BASE_SLEEP,
    PERF_HEADLESS_RETRY_MAX_ATTEMPTS,
    USER_POOL,
)
from models.auth_controller import CheckEmailDto


AUTH = f"{API_PREFIX}/auth"
ACCOUNT = f"{API_PREFIX}/account"
RETRYABLE_GATEWAY_STATUSES = {502, 503, 504}


@tag("perf-headless", "user-auth", "target")
class PerfHeadlessUser(HttpUser):
    """USER-only performance user backed by the generated perf account pool."""

    wait_time = between(MIN_WAIT, MAX_WAIT)

    def on_start(self):
        token, refresh_token, email = login_user_unique(self.client)
        if not token:
            raise StopUser(f"Perf USER login failed for {email}")

        self.email = email
        self.password = self._password_for_email(email)
        self.headers = auth_headers(token)
        self.refresh_token = refresh_token

    @task(5)
    def check_existing_perf_user_email(self):
        self._check_email(random.choice(USER_POOL)["email"])

    @task(1)
    def user_relogin(self):
        if not self.password:
            return

        token, refresh_token = login_user_credentials(
            self.client,
            self.email,
            self.password,
        )
        if token:
            self.headers = auth_headers(token)
        if refresh_token:
            self.refresh_token = refresh_token

    @task(4)
    def get_me(self):
        self._request_with_gateway_retry(
            "GET",
            f"{ACCOUNT}/me",
            headers=self.headers,
            name=f"{ACCOUNT}/me",
        )

    @task(2)
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
        self._request_with_gateway_retry(
            "POST",
            f"{AUTH}/check-email",
            json=payload.to_dict(),
            name=f"{AUTH}/check-email",
        )

    def _request_with_gateway_retry(self, method: str, path: str, **kwargs):
        max_attempts = max(1, PERF_HEADLESS_RETRY_MAX_ATTEMPTS)
        for attempt in range(max_attempts):
            with self.client.request(method, path, catch_response=True, **kwargs) as resp:
                if resp.status_code not in RETRYABLE_GATEWAY_STATUSES:
                    if resp.status_code >= 400:
                        resp.failure(f"{method} {path} failed: {resp.status_code}")
                    return
                if attempt < max_attempts - 1:
                    resp.success()
                    time.sleep(PERF_HEADLESS_RETRY_BASE_SLEEP * (attempt + 1))
                    continue
                resp.failure(f"{method} {path} gateway retry exhausted: {resp.status_code}")

    @staticmethod
    def _password_for_email(email: str) -> str | None:
        for item in USER_POOL:
            if item["email"] == email:
                return item["password"]
        return None
