"""
Service Tags – CRUD + tag-product attachment (partner-authenticated)
"""

import random

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT
from common.auth import login_partner, auth_headers
from common.data_generators import generate_service_tag, generate_product


class ServiceTagManager(HttpUser):
    weight = 1
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None
    tag_ids = []
    product_ids = []

    def on_start(self):
        self.access_token, _ = login_partner(self.client)
        self.tag_ids = []
        self.product_ids = []

    # ── Helper: ensure a product exists ───────────────────────────────────

    def _ensure_product(self):
        """Create a product if we don't have any IDs yet."""
        if self.product_ids:
            return
        with self.client.post(
            "/products",
            json=generate_product(),
            headers=auth_headers(self.access_token),
            name="/products [POST] (setup)",
            catch_response=True,
        ) as resp:
            if resp.status_code == 201:
                pid = resp.json().get("id")
                if pid:
                    self.product_ids.append(pid)

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("service-tags", "create")
    @task(2)
    def create_tag(self):
        """POST /service-tags"""
        if not self.access_token:
            return
        with self.client.post(
            "/service-tags",
            json=generate_service_tag(),
            headers=auth_headers(self.access_token),
            name="/service-tags [POST]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 201:
                tid = resp.json().get("id")
                if tid:
                    self.tag_ids.append(tid)
            else:
                resp.failure(f"Create tag failed: {resp.status_code}")

    @tag("service-tags", "read")
    @task(5)
    def list_tags(self):
        """GET /service-tags"""
        if not self.access_token:
            return
        self.client.get(
            "/service-tags",
            headers=auth_headers(self.access_token),
            name="/service-tags [GET]",
        )

    @tag("service-tags", "read")
    @task(3)
    def list_active_tags(self):
        """GET /service-tags/active"""
        if not self.access_token:
            return
        self.client.get(
            "/service-tags/active",
            headers=auth_headers(self.access_token),
            name="/service-tags/active [GET]",
        )

    @tag("service-tags", "read")
    @task(2)
    def get_tag(self):
        """GET /service-tags/{id}"""
        if not self.access_token or not self.tag_ids:
            return
        tid = random.choice(self.tag_ids)
        with self.client.get(
            f"/service-tags/{tid}",
            headers=auth_headers(self.access_token),
            name="/service-tags/[id] [GET]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get tag failed: {resp.status_code}")

    @tag("service-tags", "update")
    @task(1)
    def update_tag(self):
        """PATCH /service-tags/{id}"""
        if not self.access_token or not self.tag_ids:
            return
        tid = random.choice(self.tag_ids)
        with self.client.patch(
            f"/service-tags/{tid}",
            json={"name": "Updated Tag"},
            headers=auth_headers(self.access_token),
            name="/service-tags/[id] [PATCH]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 403, 404):
                resp.success()
            else:
                resp.failure(f"Update tag failed: {resp.status_code}")

    @tag("service-tags", "attach")
    @task(2)
    def attach_tag_to_product(self):
        """POST /service-tags/{id}/products/{productId}"""
        if not self.access_token or not self.tag_ids:
            return
        self._ensure_product()
        if not self.product_ids:
            return
        tid = random.choice(self.tag_ids)
        pid = random.choice(self.product_ids)
        with self.client.post(
            f"/service-tags/{tid}/products/{pid}",
            headers=auth_headers(self.access_token),
            name="/service-tags/[id]/products/[pid] [POST]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (201, 403, 404, 409):
                resp.success()
            else:
                resp.failure(f"Attach tag failed: {resp.status_code}")

    @tag("service-tags", "read")
    @task(2)
    def get_tags_for_product(self):
        """GET /service-tags/products/{productId}"""
        if not self.access_token or not self.product_ids:
            return
        pid = random.choice(self.product_ids)
        self.client.get(
            f"/service-tags/products/{pid}",
            headers=auth_headers(self.access_token),
            name="/service-tags/products/[pid] [GET]",
        )

    @tag("service-tags", "detach")
    @task(1)
    def detach_tag_from_product(self):
        """DELETE /service-tags/{id}/products/{productId}"""
        if not self.access_token or not self.tag_ids or not self.product_ids:
            return
        tid = random.choice(self.tag_ids)
        pid = random.choice(self.product_ids)
        with self.client.delete(
            f"/service-tags/{tid}/products/{pid}",
            headers=auth_headers(self.access_token),
            name="/service-tags/[id]/products/[pid] [DELETE]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (204, 403, 404):
                resp.success()
            else:
                resp.failure(f"Detach tag failed: {resp.status_code}")

    @tag("service-tags", "delete")
    @task(1)
    def delete_tag(self):
        """DELETE /service-tags/{id}"""
        if not self.access_token or not self.tag_ids:
            return
        tid = self.tag_ids.pop()
        with self.client.delete(
            f"/service-tags/{tid}",
            headers=auth_headers(self.access_token),
            name="/service-tags/[id] [DELETE]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (204, 403, 404):
                resp.success()
            else:
                resp.failure(f"Delete tag failed: {resp.status_code}")
