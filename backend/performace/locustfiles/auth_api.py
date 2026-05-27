"""Current authentication API performance tests."""

from __future__ import annotations

from locust import HttpUser, between, tag, task

from common.auth import (
    login_admin,
    login_employee,
    login_partner,
    login_user,
)
from common.config import (
    ADMIN_EMAIL,
    API_PREFIX,
    EMPLOYEE_EMAIL,
    MAX_WAIT,
    MIN_WAIT,
    PARTNER_EMAIL,
    USER_EMAIL,
)
from models.auth_controller import CheckEmailDto


AUTH = f"{API_PREFIX}/auth"


@tag("auth", "new-api", "target")
class AuthApiUser(HttpUser):
    """Auth endpoint user covering the current login and email-check surface."""

    wait_time = between(MIN_WAIT, MAX_WAIT)

    @task(4)
    def check_existing_user_email(self):
        self._check_email(USER_EMAIL)

    @task(2)
    def check_existing_partner_email(self):
        self._check_email(PARTNER_EMAIL)

    @task(2)
    def check_existing_employee_email(self):
        self._check_email(EMPLOYEE_EMAIL)

    @task(3)
    def user_login(self):
        login_user(self.client)

    @task(3)
    def partner_login(self):
        login_partner(self.client)

    @task(2)
    def admin_login(self):
        login_admin(self.client)

    @task(2)
    def employee_login(self):
        login_employee(self.client)

    def _check_email(self, email: str):
        payload = CheckEmailDto(email=email)
        self.client.post(
            f"{AUTH}/check-email",
            json=payload.to_dict(),
            name=f"{AUTH}/check-email",
        )
