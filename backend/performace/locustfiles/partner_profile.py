"""
Partners – Profile operations: business services, get/update profile
"""

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT
from common.auth import login_partner, auth_headers


class PartnerProfileUser(HttpUser):
    weight = 2
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None

    def on_start(self):
        self.access_token, _ = login_partner(self.client)

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("partners", "public")
    @task(3)
    def get_business_services(self):
        """GET /partners/business-services (public)"""
        self.client.get(
            "/partners/business-services",
            name="/partners/business-services",
        )

    @tag("partners", "profile")
    @task(5)
    def get_my_profile(self):
        """GET /partners/me"""
        if not self.access_token:
            return
        self.client.get(
            "/partners/me",
            headers=auth_headers(self.access_token),
            name="/partners/me [GET]",
        )

    @tag("partners", "profile")
    @task(1)
    def update_my_profile(self):
        """PUT /partners/me"""
        if not self.access_token:
            return
        with self.client.put(
            "/partners/me",
            json={"phoneNumber": "0901234567"},
            headers=auth_headers(self.access_token),
            name="/partners/me [PUT]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                pass
            else:
                resp.failure(f"Update profile failed: {resp.status_code}")
