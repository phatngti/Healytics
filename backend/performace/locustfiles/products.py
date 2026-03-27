"""
Products – CRUD operations (partner/admin-authenticated)
"""

import random

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT
from common.auth import login_partner, auth_headers
from common.data_generators import generate_product


class ProductManager(HttpUser):
    weight = 2
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None
    created_ids = []
    created_slugs = []

    def on_start(self):
        self.access_token, _ = login_partner(self.client)
        self.created_ids = []
        self.created_slugs = []

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("products", "create")
    @task(2)
    def create_product(self):
        """POST /products"""
        if not self.access_token:
            return
        payload = generate_product()
        with self.client.post(
            "/products",
            json=payload,
            headers=auth_headers(self.access_token),
            name="/products [POST]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 201:
                data = resp.json()
                pid = data.get("id")
                slug = data.get("slug")
                if pid:
                    self.created_ids.append(pid)
                if slug:
                    self.created_slugs.append(slug)
            else:
                resp.failure(f"Create product failed: {resp.status_code}")

    @tag("products", "read")
    @task(5)
    def list_products(self):
        """GET /products"""
        if not self.access_token:
            return
        self.client.get(
            "/products",
            headers=auth_headers(self.access_token),
            name="/products [GET]",
        )

    @tag("products", "read")
    @task(3)
    def get_product(self):
        """GET /products/{id}"""
        if not self.access_token or not self.created_ids:
            return
        pid = random.choice(self.created_ids)
        with self.client.get(
            f"/products/{pid}",
            headers=auth_headers(self.access_token),
            name="/products/[id] [GET]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get product failed: {resp.status_code}")

    @tag("products", "read")
    @task(2)
    def get_product_by_slug(self):
        """GET /products/slug/{slug}"""
        if not self.access_token or not self.created_slugs:
            return
        slug = random.choice(self.created_slugs)
        with self.client.get(
            f"/products/slug/{slug}",
            headers=auth_headers(self.access_token),
            name="/products/slug/[slug]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get product by slug failed: {resp.status_code}")

    @tag("products", "update")
    @task(1)
    def update_product(self):
        """PATCH /products/{id}"""
        if not self.access_token or not self.created_ids:
            return
        pid = random.choice(self.created_ids)
        with self.client.patch(
            f"/products/{pid}",
            json={"description": "Updated via load test"},
            headers=auth_headers(self.access_token),
            name="/products/[id] [PATCH]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Update product failed: {resp.status_code}")

    @tag("products", "delete")
    @task(1)
    def delete_product(self):
        """DELETE /products/{id}"""
        if not self.access_token or not self.created_ids:
            return
        pid = self.created_ids.pop()
        with self.client.delete(
            f"/products/{pid}",
            headers=auth_headers(self.access_token),
            name="/products/[id] [DELETE]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (204, 404):
                resp.success()
            else:
                resp.failure(f"Delete product failed: {resp.status_code}")
