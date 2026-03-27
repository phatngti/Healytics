"""
Locations – Public cascading drill-down: provinces → districts → wards
"""

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT


class LocationBrowser(HttpUser):
    weight = 3
    wait_time = between(MIN_WAIT, MAX_WAIT)

    province_ids = []
    district_ids = []

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("locations")
    @task(5)
    def get_provinces(self):
        """GET /locations/provinces"""
        with self.client.get(
            "/locations/provinces",
            name="/locations/provinces",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                if isinstance(data, list) and data:
                    self.province_ids = [p["id"] for p in data[:10] if "id" in p]
                elif isinstance(data, dict):
                    items = data.get("data", data.get("provinces", []))
                    self.province_ids = [p["id"] for p in items[:10] if "id" in p]
            else:
                resp.failure(f"Get provinces failed: {resp.status_code}")

    @tag("locations")
    @task(3)
    def get_districts(self):
        """GET /locations/provinces/{provinceId}/districts"""
        if not self.province_ids:
            return
        import random
        pid = random.choice(self.province_ids)
        with self.client.get(
            f"/locations/provinces/{pid}/districts",
            name="/locations/provinces/[id]/districts",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                data = resp.json()
                if isinstance(data, list) and data:
                    self.district_ids = [d["id"] for d in data[:10] if "id" in d]
                elif isinstance(data, dict):
                    items = data.get("data", data.get("districts", []))
                    self.district_ids = [d["id"] for d in items[:10] if "id" in d]
            elif resp.status_code == 404:
                resp.success()
            else:
                resp.failure(f"Get districts failed: {resp.status_code}")

    @tag("locations")
    @task(2)
    def get_wards(self):
        """GET /locations/districts/{districtId}/wards"""
        if not self.district_ids:
            return
        import random
        did = random.choice(self.district_ids)
        with self.client.get(
            f"/locations/districts/{did}/wards",
            name="/locations/districts/[id]/wards",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get wards failed: {resp.status_code}")
