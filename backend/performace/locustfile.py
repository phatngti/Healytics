"""
Master locustfile – imports all user classes for combined load testing.

Run:
    locust                          # uses locust.conf defaults
    locust --tags auth              # only auth tests
    locust --tags admin             # only admin tests
    locust -u 50 -r 5 --run-time 5m # custom parameters

User weights simulate realistic traffic:
    End-users  : ~40%  (AuthEndUser 3, AccountUser 2, LocationBrowser 3)
    Partners   : ~40%  (AuthPartnerUser 2, PartnerProfileUser 2,
                         EmployeeManager 2, CategoryManager 2,
                         ProductManager 2, ServiceTagManager 1)
    Admins     : ~20%  (AuthAdminUser 1, AdminUser 1)
"""

# ── Auth ──────────────────────────────────────────────────────────────────────
from locustfiles.auth_user import AuthEndUser           # noqa: F401
from locustfiles.auth_partner import AuthPartnerUser    # noqa: F401
from locustfiles.auth_admin import AuthAdminUser        # noqa: F401

# ── User domain ───────────────────────────────────────────────────────────────
from locustfiles.account_user import AccountUser        # noqa: F401

# ── Partner domain ────────────────────────────────────────────────────────────
from locustfiles.partner_profile import PartnerProfileUser  # noqa: F401
from locustfiles.employees import EmployeeManager           # noqa: F401
from locustfiles.categories import CategoryManager          # noqa: F401
from locustfiles.products import ProductManager             # noqa: F401
from locustfiles.service_tags import ServiceTagManager      # noqa: F401

# ── Public ────────────────────────────────────────────────────────────────────
from locustfiles.locations import LocationBrowser        # noqa: F401

# ── Admin domain ──────────────────────────────────────────────────────────────
from locustfiles.admin import AdminUser                  # noqa: F401
