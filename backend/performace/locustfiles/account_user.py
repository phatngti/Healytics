"""
Account – Authenticated user: get & create survey
"""

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT
from common.auth import login_user, auth_headers
from common.data_generators import generate_survey


class AccountUser(HttpUser):
    weight = 2
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None

    def on_start(self):
        self.access_token, _ = login_user(self.client)

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("account", "survey")
    @task(3)
    def get_survey(self):
        """GET /account/survey"""
        if not self.access_token:
            return
        self.client.get(
            "/account/survey",
            headers=auth_headers(self.access_token),
            name="/account/survey [GET]",
        )

    @tag("account", "survey")
    @task(1)
    def create_survey(self):
        """POST /account/survey"""
        if not self.access_token:
            return
        payload = generate_survey()
        with self.client.post(
            "/account/survey",
            json=payload,
            headers=auth_headers(self.access_token),
            name="/account/survey [POST]",
            catch_response=True,
        ) as resp:
            # 409 = survey already exists → treat as success
            if resp.status_code in (201, 409):
                resp.success()
            else:
                resp.failure(f"Create survey failed: {resp.status_code}")
