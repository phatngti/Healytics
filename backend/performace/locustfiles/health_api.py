"""Health endpoint performance test."""

from __future__ import annotations

from locust import HttpUser, between, tag, task

from common.config import API_PREFIX, MAX_WAIT, MIN_WAIT


HEALTH = f"{API_PREFIX}/health"


@tag("health", "new-api", "target")
class HealthApiUser(HttpUser):
    """Low-cost liveness check user."""

    wait_time = between(MIN_WAIT, MAX_WAIT)

    @task(1)
    def get_health(self):
        self.client.get(HEALTH, name=HEALTH)

