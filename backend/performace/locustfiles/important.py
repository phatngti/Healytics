"""Focused important API performance entrypoint.

This module intentionally imports only the default important, read-heavy Locust
users. Avoid using ``--tags`` over ``all_modules.py`` for this path: Locust still
instantiates every imported User class, then tag filtering can remove all tasks
from non-matching classes and produce "No tasks defined" runtime errors.
"""

import common.targets  # noqa: F401

from locustfiles.auth_api import AuthApiUser  # noqa: F401
from locustfiles.current_new_api import (  # noqa: F401
    AdminDashboardCurrentApiUser,
    AdminFinanceReadApiUser,
    AdminOperationsReadApiUser,
    PartnerCurrentApiUser,
    PublicCatalogCurrentApiUser,
    UserCurrentNewApiUser,
)
from locustfiles.employee_api import EmployeeApiUser  # noqa: F401
from locustfiles.health_api import HealthApiUser  # noqa: F401
