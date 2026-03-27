"""
Employees – CRUD operations (partner-authenticated)
"""

import random

from locust import HttpUser, task, between, tag

from common.config import MIN_WAIT, MAX_WAIT
from common.auth import login_partner, auth_headers
from common.data_generators import generate_doctor, generate_therapist


class EmployeeManager(HttpUser):
    weight = 2
    wait_time = between(MIN_WAIT, MAX_WAIT)

    access_token = None
    created_ids = []

    def on_start(self):
        self.access_token, _ = login_partner(self.client)
        self.created_ids = []

    # ── Tasks ─────────────────────────────────────────────────────────────

    @tag("employees", "create")
    @task(2)
    def create_doctor(self):
        """POST /employees/doctors"""
        if not self.access_token:
            return
        with self.client.post(
            "/employees/doctors",
            json=generate_doctor(),
            headers=auth_headers(self.access_token),
            name="/employees/doctors [POST]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 201:
                data = resp.json()
                eid = data.get("id")
                if eid:
                    self.created_ids.append(eid)
            else:
                resp.failure(f"Create doctor failed: {resp.status_code}")

    @tag("employees", "create")
    @task(2)
    def create_therapist(self):
        """POST /employees/therapists"""
        if not self.access_token:
            return
        with self.client.post(
            "/employees/therapists",
            json=generate_therapist(),
            headers=auth_headers(self.access_token),
            name="/employees/therapists [POST]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 201:
                data = resp.json()
                eid = data.get("id")
                if eid:
                    self.created_ids.append(eid)
            else:
                resp.failure(f"Create therapist failed: {resp.status_code}")

    @tag("employees", "read")
    @task(5)
    def list_employees(self):
        """GET /employees"""
        if not self.access_token:
            return
        role = random.choice(["DOCTOR", "THERAPIST", "RECEPTIONIST", "MANAGER", ""])
        params = {"role": role} if role else {}
        self.client.get(
            "/employees",
            params=params,
            headers=auth_headers(self.access_token),
            name="/employees [GET]",
        )

    @tag("employees", "read")
    @task(3)
    def get_employee(self):
        """GET /employees/{id}"""
        if not self.access_token or not self.created_ids:
            return
        eid = random.choice(self.created_ids)
        with self.client.get(
            f"/employees/{eid}",
            headers=auth_headers(self.access_token),
            name="/employees/[id] [GET]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Get employee failed: {resp.status_code}")

    @tag("employees", "update")
    @task(1)
    def update_employee(self):
        """PATCH /employees/{id}"""
        if not self.access_token or not self.created_ids:
            return
        eid = random.choice(self.created_ids)
        with self.client.patch(
            f"/employees/{eid}",
            json={"name": "Updated Name"},
            headers=auth_headers(self.access_token),
            name="/employees/[id] [PATCH]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (200, 404):
                resp.success()
            else:
                resp.failure(f"Update employee failed: {resp.status_code}")

    @tag("employees", "delete")
    @task(1)
    def delete_employee(self):
        """DELETE /employees/{id}"""
        if not self.access_token or not self.created_ids:
            return
        eid = self.created_ids.pop()
        with self.client.delete(
            f"/employees/{eid}",
            headers=auth_headers(self.access_token),
            name="/employees/[id] [DELETE]",
            catch_response=True,
        ) as resp:
            if resp.status_code in (204, 404):
                resp.success()
            else:
                resp.failure(f"Delete employee failed: {resp.status_code}")
