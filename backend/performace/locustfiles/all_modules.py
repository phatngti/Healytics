"""All Locust test modules entrypoint.

This file imports every active locustfiles module so Makefile targets can run
the complete test surface with a single -f argument.
"""

import common.targets  # noqa: F401

from locustfiles.auth_api import AuthApiUser  # noqa: F401
from locustfiles.booking_race_condition import BookingRaceUser, BookingVerifier  # noqa: F401
from locustfiles.current_new_api import (  # noqa: F401
    AdminDashboardCurrentApiUser,
    AdminFinanceReadApiUser,
    PartnerCurrentApiUser,
    UserCurrentNewApiUser,
)
from locustfiles.employee_api import EmployeeApiUser, EmployeeAppointmentMutationUser  # noqa: F401
from locustfiles.health_api import HealthApiUser  # noqa: F401
from locustfiles.partner_employee_analytics import PartnerEmployeeAnalyticsUser  # noqa: F401
from locustfiles.partner_finance import PartnerFinanceMutationUser, PartnerFinanceStressUser  # noqa: F401
from locustfiles.perf_headless_user import PerfHeadlessUser  # noqa: F401
from locustfiles.ws_chat_notification_user import WsChatNotificationUser  # noqa: F401
from locustfiles.ws_notification_user import WsNotificationUser  # noqa: F401
from locustfiles.ws_partner_chat import WsPartnerChatUser  # noqa: F401
from locustfiles.ws_user_chat import WsUserChatUser  # noqa: F401
