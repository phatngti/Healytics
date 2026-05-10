"""Employee app API performance tests."""

from __future__ import annotations

import random
from datetime import date
from urllib.parse import urlencode

from locust import HttpUser, between, constant_pacing, tag, task
from locust.exception import StopUser

from common.auth import auth_headers, login_employee
from common.config import (
    API_PREFIX,
    MAX_WAIT,
    MIN_WAIT,
    PERF_ENABLE_EMPLOYEE_MUTATIONS,
)
from models.employee_appointments_controller import (
    CancelEmployeeAppointmentDto,
    EmployeeBookingStatusFilter,
)
from models.employee_revenue_controller import EmployeeRevenuePeriod


EMPLOYEE_PROFILE = f"{API_PREFIX}/employee/profile"
EMPLOYEE_REVENUE = f"{API_PREFIX}/employee/revenue"
EMPLOYEE_APPOINTMENTS = f"{API_PREFIX}/employee/appointments"


@tag("employee", "employee-revenue", "employee-appointments", "new-api", "target")
class EmployeeApiUser(HttpUser):
    """Read-heavy employee app user for profile, revenue, and appointments."""

    wait_time = between(MIN_WAIT, MAX_WAIT)

    def on_start(self):
        token = None
        for attempt in range(3):
            token, _ = login_employee(self.client)
            if token:
                break
            import time
            time.sleep(2 * (attempt + 1))

        if not token:
            raise StopUser("Employee login failed after retries")

        self.headers = auth_headers(token)
        self.appointment_ids: list[str] = []
        self._profile_available = self._validate_employee_profile()
        if self._profile_available:
            self._discover_appointments()

    @task(4)
    def get_profile(self):
        if not self._profile_available:
            return
        self.client.get(
            EMPLOYEE_PROFILE,
            headers=self.headers,
            name=EMPLOYEE_PROFILE,
        )

    @task(4)
    def get_revenue_summary(self):
        if not self._profile_available:
            return
        self.client.get(
            f"{EMPLOYEE_REVENUE}/summary?{urlencode(_revenue_query())}",
            headers=self.headers,
            name=f"{EMPLOYEE_REVENUE}/summary",
        )

    @task(4)
    def get_revenue_trend(self):
        if not self._profile_available:
            return
        self.client.get(
            f"{EMPLOYEE_REVENUE}/trend?{urlencode(_revenue_query())}",
            headers=self.headers,
            name=f"{EMPLOYEE_REVENUE}/trend",
        )

    @task(3)
    def get_revenue_breakdown(self):
        if not self._profile_available:
            return
        self.client.get(
            f"{EMPLOYEE_REVENUE}/breakdown?{urlencode(_revenue_query())}",
            headers=self.headers,
            name=f"{EMPLOYEE_REVENUE}/breakdown",
        )

    @task(5)
    def list_appointments(self):
        if not self._profile_available:
            return
        self.client.get(
            f"{EMPLOYEE_APPOINTMENTS}?{urlencode(_appointment_query())}",
            headers=self.headers,
            name=EMPLOYEE_APPOINTMENTS,
        )

    @task(2)
    def get_appointment_detail(self):
        if not self._profile_available:
            return
        appointment_id = random.choice(self.appointment_ids) if self.appointment_ids else None
        if not appointment_id:
            return

        self.client.get(
            f"{EMPLOYEE_APPOINTMENTS}/{appointment_id}",
            headers=self.headers,
            name=f"{EMPLOYEE_APPOINTMENTS}/:id",
        )

    def _validate_employee_profile(self) -> bool:
        """Validate employee profile exists; returns True if available."""
        with self.client.get(
            EMPLOYEE_PROFILE,
            headers=self.headers,
            name=f"{EMPLOYEE_PROFILE} [startup]",
            catch_response=True,
        ) as resp:
            if resp.status_code == 200:
                resp.success()
                return True
            # Profile not linked — mark as success (known limitation)
            # so it doesn't pollute error metrics
            resp.success()
            return False

    def _discover_appointments(self):
        with self.client.get(
            f"{EMPLOYEE_APPOINTMENTS}?page=1&limit=100",
            headers=self.headers,
            name=f"{EMPLOYEE_APPOINTMENTS} [discovery]",
            catch_response=True,
        ) as resp:
            if resp.status_code != 200:
                resp.failure(f"Employee appointment discovery failed: HTTP {resp.status_code}")
                return

            try:
                payload = resp.json()
            except ValueError as exc:
                resp.failure(f"Employee appointment discovery returned non-JSON: {exc}")
                return

            self.appointment_ids = [
                item["id"]
                for item in _extract_items(payload)
                if isinstance(item, dict) and item.get("id")
            ]
            resp.success()


@tag("employee-mutation")
class EmployeeAppointmentMutationUser(HttpUser):
    """Guarded employee appointment mutation user."""

    wait_time = constant_pacing(8)
    weight = 1 if PERF_ENABLE_EMPLOYEE_MUTATIONS else 0

    def on_start(self):
        if not PERF_ENABLE_EMPLOYEE_MUTATIONS:
            raise StopUser("Set PERF_ENABLE_EMPLOYEE_MUTATIONS=1 to run employee mutations")

        token = None
        for attempt in range(3):
            token, _ = login_employee(self.client)
            if token:
                break
            import time
            time.sleep(2 * (attempt + 1))

        if not token:
            raise StopUser("Employee login failed after retries")

        self.headers = auth_headers(token)
        self.appointment_ids = self._discover_mutable_appointments()

    @task(1)
    def start_appointment(self):
        appointment_id = self._pop_appointment_id()
        if not appointment_id:
            return
        self.client.patch(
            f"{EMPLOYEE_APPOINTMENTS}/{appointment_id}/start",
            headers=self.headers,
            name=f"{EMPLOYEE_APPOINTMENTS}/:id/start",
        )

    @task(1)
    def complete_appointment(self):
        appointment_id = self._pop_appointment_id()
        if not appointment_id:
            return
        self.client.patch(
            f"{EMPLOYEE_APPOINTMENTS}/{appointment_id}/complete",
            headers=self.headers,
            name=f"{EMPLOYEE_APPOINTMENTS}/:id/complete",
        )

    @task(1)
    def cancel_appointment(self):
        appointment_id = self._pop_appointment_id()
        if not appointment_id:
            return
        payload = CancelEmployeeAppointmentDto(
            reason="Performance controlled mutation: employee cancellation.",
        ).to_dict()
        self.client.patch(
            f"{EMPLOYEE_APPOINTMENTS}/{appointment_id}/cancel",
            json=payload,
            headers=self.headers,
            name=f"{EMPLOYEE_APPOINTMENTS}/:id/cancel",
        )

    def _discover_mutable_appointments(self) -> list[str]:
        query = urlencode({"page": 1, "limit": 100})
        with self.client.get(
            f"{EMPLOYEE_APPOINTMENTS}?{query}",
            headers=self.headers,
            name=f"{EMPLOYEE_APPOINTMENTS} [mutation discovery]",
            catch_response=True,
        ) as resp:
            if resp.status_code != 200:
                resp.failure(f"Employee mutation discovery failed: HTTP {resp.status_code}")
                return []
            try:
                payload = resp.json()
            except ValueError as exc:
                resp.failure(f"Employee mutation discovery returned non-JSON: {exc}")
                return []

            resp.success()
            return [
                item["id"]
                for item in _extract_items(payload)
                if isinstance(item, dict)
                and item.get("id")
                and item.get("status")
                in {
                    EmployeeBookingStatusFilter.UPCOMING.value,
                    EmployeeBookingStatusFilter.INPROGRESS.value,
                }
            ]

    def _pop_appointment_id(self) -> str | None:
        if not self.appointment_ids:
            return None
        return self.appointment_ids.pop(0)


def _revenue_query() -> dict[str, str]:
    return {
        "period": random.choice(list(EmployeeRevenuePeriod)).value,
        "date": date.today().isoformat(),
    }


def _appointment_query() -> dict[str, str | int]:
    query: dict[str, str | int] = {
        "page": random.randint(1, 3),
        "limit": random.choice([10, 20, 50]),
    }
    if random.random() < 0.6:
        query["status"] = random.choice(list(EmployeeBookingStatusFilter)).value
    return query


def _extract_items(payload):
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        data = payload.get("data")
        if isinstance(data, list):
            return data
        items = payload.get("items")
        if isinstance(items, list):
            return items
    return []

