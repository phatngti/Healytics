"""
Partner employee analytics stress tests.

Targets the updated analytics endpoints added to /partner/employees:
  - GET /partner/employees/analytics/overview
  - GET /partner/employees/analytics/:employeeId
"""

from __future__ import annotations

import random
from urllib.parse import urlencode

from locust import HttpUser, between, tag, task
from locust.exception import StopUser

from common.auth import auth_headers, login_partner
from common.config import MIN_WAIT, MAX_WAIT
from common.discovery import PARTNER_EMPLOYEES, partner_discovery


EMPLOYEE_ANALYTICS_PERIODS = [
    "today",
    "this_week",
    "this_month",
    "this_quarter",
    "this_year",
]


@tag("updated", "employee-analytics", "stress")
class PartnerEmployeeAnalyticsUser(HttpUser):
    """Read-heavy stress user for partner employee analytics."""

    wait_time = between(MIN_WAIT, MAX_WAIT)

    def on_start(self):
        token = None
        for attempt in range(3):
            token, _ = login_partner(self.client)
            if token:
                break
            import time
            time.sleep(2 * (attempt + 1))

        if not token:
            raise StopUser("Partner login failed after retries")

        self.headers = auth_headers(token)
        partner_discovery.ensure_discovered(self.client, self.headers)

    @task(6)
    def get_overview_analytics(self):
        period = random.choice(EMPLOYEE_ANALYTICS_PERIODS)
        self.client.get(
            f"{PARTNER_EMPLOYEES}/analytics/overview?{urlencode({'period': period})}",
            headers=self.headers,
            name=f"{PARTNER_EMPLOYEES}/analytics/overview",
        )

    @task(4)
    def get_detail_analytics(self):
        employee_id = partner_discovery.random_employee_id()
        if not employee_id:
            return

        period = random.choice(EMPLOYEE_ANALYTICS_PERIODS)
        self.client.get(
            f"{PARTNER_EMPLOYEES}/analytics/{employee_id}?{urlencode({'period': period})}",
            headers=self.headers,
            name=f"{PARTNER_EMPLOYEES}/analytics/:employeeId",
        )
