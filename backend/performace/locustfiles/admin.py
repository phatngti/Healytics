"""
Admin – Partner management & audit logs (admin-authenticated)
"""

import random

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT
from common.auth import login_admin, auth_headers
from common.data_generators import generate_review_decision


class AdminUser(HttpUser):
    weight = 1
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None
    partner_ids = []

    def on_start(self):
        self.access_token, _ = login_admin(self.client)
        self.partner_ids = []

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("admin", "partners")
    @task(5)
    def list_partners(self):
        """GET /admin/partners"""
        if not self.access_token:
            return
        params = {
            "page": random.randint(1, 3),
            "limit": 10,
        }
        if random.random() > 0.5:
            params["verificationStatus"] = random.choice([
                "ONBOARDING", "PENDING", "APPROVED", "REJECTED", "REQUIRED_RESUBMIT",
            ])
        with self.client.get(
            "/admin/partners",
            params=params,
            headers=auth_headers(self.access_token),
            name="/admin/partners [GET]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                items = data.get("data", data.get("partners", []))
                if isinstance(items, list):
                    self.partner_ids = [p["id"] for p in items if "id" in p]
            else:
                resp.failure(f"List partners failed: {resp.status_code}")

    @tag("admin", "partners")
    @task(3)
    def get_total_partners(self):
        """GET /admin/partners/total"""
        if not self.access_token:
            return
        self.client.get(
            "/admin/partners/total",
            headers=auth_headers(self.access_token),
            name="/admin/partners/total",
        )

    @tag("admin", "partners")
    @task(3)
    def get_partner_detail(self):
        """GET /admin/partners/{id}"""
        if not self.access_token or not self.partner_ids:
            return
        pid = random.choice(self.partner_ids)
        with self.client.get(
            f"/admin/partners/{pid}",
            headers=auth_headers(self.access_token),
            name="/admin/partners/[id] [GET]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get partner detail failed: {resp.status_code}")

    @tag("admin", "partners", "review")
    @task(1)
    def review_partner(self):
        """PUT /admin/partners/{id}/review"""
        if not self.access_token or not self.partner_ids:
            return
        pid = random.choice(self.partner_ids)
        with self.client.put(
            f"/admin/partners/{pid}/review",
            json=generate_review_decision(),
            headers=auth_headers(self.access_token),
            name="/admin/partners/[id]/review [PUT]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Review partner failed: {resp.status_code}")

    @tag("admin", "audit")
    @task(3)
    def get_audit_logs(self):
        """GET /audit-logs"""
        if not self.access_token:
            return
        params = {}
        if self.partner_ids and random.random() > 0.5:
            params["targetId"] = random.choice(self.partner_ids)
        self.client.get(
            "/audit-logs",
            params=params,
            headers=auth_headers(self.access_token),
            name="/audit-logs [GET]",
        )
