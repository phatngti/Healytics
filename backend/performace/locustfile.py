"""
Master locustfile – imports all user classes for combined load testing.

Run:
    locust                          # uses locust.conf defaults
    locust --tags auth              # only auth tests
    locust --tags admin             # only admin tests
    locust -u 50 -r 5 --run-time 5m # custom parameters

Add imports here as test modules are implemented in locustfiles/.
"""

# Registers English target report listeners for every Locust run.
import common.targets  # noqa: F401

# ── Auth ──────────────────────────────────────────────────────────────────────
# from locustfiles.auth_user import AuthEndUser
# from locustfiles.auth_partner import AuthPartnerUser
# from locustfiles.auth_admin import AuthAdminUser
from locustfiles.auth_api import AuthApiUser
from locustfiles.current_new_api import (
    AdminDashboardCurrentApiUser,
    AdminFinanceReadApiUser,
    PartnerCurrentApiUser,
    UserCurrentNewApiUser,
)
from locustfiles.health_api import HealthApiUser

# ── User domain ───────────────────────────────────────────────────────────────
# from locustfiles.account_user import AccountUser

# ── Booking Race Condition ────────────────────────────────────────────────────
# from locustfiles.booking_race_condition import BookingRaceUser, BookingVerifier

# ── Partner domain ────────────────────────────────────────────────────────────
# from locustfiles.partner_profile import PartnerProfileUser
# from locustfiles.employees import EmployeeManager
# from locustfiles.categories import CategoryManager
# from locustfiles.products import ProductManager
# from locustfiles.service_tags import ServiceTagManager
from locustfiles.partner_employee_analytics import PartnerEmployeeAnalyticsUser
from locustfiles.partner_finance import PartnerFinanceStressUser, PartnerFinanceMutationUser
from locustfiles.employee_api import EmployeeApiUser, EmployeeAppointmentMutationUser

# ── Public ────────────────────────────────────────────────────────────────────
# from locustfiles.locations import LocationBrowser

# ── Admin domain ──────────────────────────────────────────────────────────────
# from locustfiles.admin import AdminUser

# ── WebSocket ─────────────────────────────────────────────────────────────────
from locustfiles.ws_notification_user import WsNotificationUser
from locustfiles.ws_user_chat import WsUserChatUser
from locustfiles.ws_partner_chat import WsPartnerChatUser
from locustfiles.ws_chat_notification_user import WsChatNotificationUser
