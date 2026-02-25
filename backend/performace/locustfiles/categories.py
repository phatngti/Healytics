"""
Categories – CRUD operations (partner/admin-authenticated)
"""

import random

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT
from common.auth import login_partner, auth_headers
from common.data_generators import generate_category


class CategoryManager(HttpUser):
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

    @tag("categories", "create")
    @task(2)
    def create_category(self):
        """POST /categories"""
        if not self.access_token:
            return
        payload = generate_category()
        with self.client.post(
            "/categories",
            json=payload,
            headers=auth_headers(self.access_token),
            name="/categories [POST]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 201:
                data = resp.json()
                cid = data.get("id")
                slug = data.get("slug")
                if cid:
                    self.created_ids.append(cid)
                if slug:
                    self.created_slugs.append(slug)
            else:
                resp.failure(f"Create category failed: {resp.status_code}")

    @tag("categories", "read")
    @task(5)
    def list_categories(self):
        """GET /categories"""
        if not self.access_token:
            return
        params = {}
        if random.random() > 0.5:
            params["rootsOnly"] = "true"
        self.client.get(
            "/categories",
            params=params,
            headers=auth_headers(self.access_token),
            name="/categories [GET]",
        )

    @tag("categories", "read")
    @task(3)
    def get_category(self):
        """GET /categories/{id}"""
        if not self.access_token or not self.created_ids:
            return
        cid = random.choice(self.created_ids)
        with self.client.get(
            f"/categories/{cid}",
            headers=auth_headers(self.access_token),
            name="/categories/[id] [GET]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get category failed: {resp.status_code}")

    @tag("categories", "read")
    @task(2)
    def get_category_by_slug(self):
        """GET /categories/slug/{slug}"""
        if not self.access_token or not self.created_slugs:
            return
        slug = random.choice(self.created_slugs)
        with self.client.get(
            f"/categories/slug/{slug}",
            headers=auth_headers(self.access_token),
            name="/categories/slug/[slug]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get category by slug failed: {resp.status_code}")

    @tag("categories", "update")
    @task(1)
    def update_category(self):
        """PATCH /categories/{id}"""
        if not self.access_token or not self.created_ids:
            return
        cid = random.choice(self.created_ids)
        with self.client.patch(
            f"/categories/{cid}",
            json={"description": "Updated description"},
            headers=auth_headers(self.access_token),
            name="/categories/[id] [PATCH]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Update category failed: {resp.status_code}")

    @tag("categories", "delete")
    @task(1)
    def delete_category(self):
        """DELETE /categories/{id}"""
        if not self.access_token or not self.created_ids:
            return
        cid = self.created_ids.pop()
        with self.client.delete(
            f"/categories/{cid}",
            headers=auth_headers(self.access_token),
            name="/categories/[id] [DELETE]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (204, 404):
                resp.success()
            else:
                resp.failure(f"Delete category failed: {resp.status_code}")
