"""Read-heavy current/new API coverage.

These users exercise recently added HTTP surfaces without changing backend
state. Optional detail endpoints only run after IDs are discovered from
successful list responses so sparse seed data does not produce false failures.
"""

from __future__ import annotations

import random
import re
import time
from datetime import date
from typing import Any
from urllib.parse import urlencode

from locust import HttpUser, between, tag, task
from locust.exception import StopUser

from common.auth import auth_headers, login_admin, login_partner, login_user_unique
from common.config import API_PREFIX, MAX_WAIT, MIN_WAIT


ACCOUNT = f"{API_PREFIX}/account"
ADMIN_DASHBOARD = f"{API_PREFIX}/admin/dashboard"
ADMIN_FINANCE = f"{API_PREFIX}/admin/finance"
PARTNER_BOOKINGS = f"{API_PREFIX}/partner/bookings"
PARTNER_EMPLOYEES = f"{API_PREFIX}/partner/employees"
USER_APPOINTMENTS = f"{API_PREFIX}/user/appointments"
USER_BOOKING_SEARCH = f"{API_PREFIX}/user/booking-search"
USER_CLINICS = f"{API_PREFIX}/user/clinics"
USER_HEALTH_SERVICES = f"{API_PREFIX}/user/health-services"
USER_PAYMENTS = f"{API_PREFIX}/user/payments"
USER_PROFILE = f"{API_PREFIX}/user/profile"
USER_WISHLIST = f"{API_PREFIX}/user/wishlist"

ADMIN_DASHBOARD_PERIODS = ["7d", "30d", "90d"]
ADMIN_FINANCE_PERIODS = ["sevenDays", "thirtyDays", "ninetyDays"]
ADMIN_FINANCE_STATUSES = ["pending", "paid", "refunded", "failed", "canceled"]
APPOINTMENT_STATUSES = [
    "pending_payment",
    "upcoming",
    "processing",
    "completed",
    "canceled",
]
BOOKING_SEARCH_TERMS = ["massage", "spa", "doctor", "facial", "therapy", "clinic"]
UUID_RE = re.compile(
    r"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$"
)


@tag("current-new-api", "new-api", "user-current", "safe-read", "target")
class UserCurrentNewApiUser(HttpUser):
    """USER read mix for account, profile, search, appointments, and catalog reads."""

    wait_time = between(MIN_WAIT, MAX_WAIT)
    weight = 4

    def on_start(self):
        token = None
        for attempt in range(3):
            token, _, _ = login_user_unique(self.client)
            if token:
                break
            time.sleep(2 * (attempt + 1))

        if not token:
            raise StopUser("User login failed after retries")

        self.headers = auth_headers(token)
        self.appointment_ids: list[str] = []
        self.service_ids: list[str] = []
        self.clinic_ids: list[str] = []
        self._discover_user_read_context()

    @task(5)
    def get_account_me(self):
        self.client.get(
            f"{ACCOUNT}/me",
            headers=self.headers,
            name=f"{ACCOUNT}/me",
        )

    @task(4)
    def get_profile_summary(self):
        self.client.get(
            f"{USER_PROFILE}/summary",
            headers=self.headers,
            name=f"{USER_PROFILE}/summary",
        )

    @task(5)
    def search_bookings(self):
        query = urlencode(
            {
                "q": random.choice(BOOKING_SEARCH_TERMS),
                "limit": random.choice([5, 10, 20]),
            }
        )
        self.client.get(
            f"{USER_BOOKING_SEARCH}?{query}",
            headers=self.headers,
            name=USER_BOOKING_SEARCH,
        )

    @task(5)
    def list_appointments(self):
        self.client.get(
            f"{USER_APPOINTMENTS}?{urlencode(_appointment_query())}",
            headers=self.headers,
            name=USER_APPOINTMENTS,
        )

    @task(3)
    def list_appointment_categories(self):
        self.client.get(
            f"{USER_APPOINTMENTS}/categories",
            headers=self.headers,
            name=f"{USER_APPOINTMENTS}/categories",
        )

    @task(3)
    def list_appointment_recommendations(self):
        self.client.get(
            f"{USER_APPOINTMENTS}/recommendations",
            headers=self.headers,
            name=f"{USER_APPOINTMENTS}/recommendations",
        )

    @task(3)
    def list_recent_activity(self):
        query = urlencode({"limit": random.choice([5, 10, 20]), "offset": 0})
        self.client.get(
            f"{USER_APPOINTMENTS}/recent-activity?{query}",
            headers=self.headers,
            name=f"{USER_APPOINTMENTS}/recent-activity",
        )

    @task(2)
    def get_appointment_detail(self):
        appointment_id = _choose(self.appointment_ids)
        if not appointment_id:
            return
        self.client.get(
            f"{USER_APPOINTMENTS}/{appointment_id}",
            headers=self.headers,
            name=f"{USER_APPOINTMENTS}/:id",
        )

    @task(1)
    def get_appointment_manual(self):
        appointment_id = _choose(self.appointment_ids)
        if not appointment_id:
            return
        self.client.get(
            f"{USER_APPOINTMENTS}/{appointment_id}/manual",
            headers=self.headers,
            name=f"{USER_APPOINTMENTS}/:appointmentId/manual",
        )

    @task(3)
    def list_saved_cards(self):
        self.client.get(
            f"{USER_PAYMENTS}/cards",
            headers=self.headers,
            name=f"{USER_PAYMENTS}/cards",
        )

    @task(3)
    def list_wishlist(self):
        self.client.get(
            USER_WISHLIST,
            headers=self.headers,
            name=USER_WISHLIST,
        )

    @task(4)
    def list_home_health_services(self):
        self.client.get(
            f"{USER_HEALTH_SERVICES}/home-recommend",
            headers=self.headers,
            name=f"{USER_HEALTH_SERVICES}/home-recommend",
        )

    @task(4)
    def list_premium_treatments(self):
        self.client.get(
            f"{USER_HEALTH_SERVICES}/premium-treatments",
            headers=self.headers,
            name=f"{USER_HEALTH_SERVICES}/premium-treatments",
        )

    @task(3)
    def get_health_service_info(self):
        service_id = _choose(self.service_ids)
        if not service_id:
            return
        self.client.get(
            f"{USER_HEALTH_SERVICES}/{service_id}/info",
            headers=self.headers,
            name=f"{USER_HEALTH_SERVICES}/:id/info",
        )

    @task(2)
    def get_health_service_detail(self):
        service_id = _choose(self.service_ids)
        if not service_id:
            return
        self.client.get(
            f"{USER_HEALTH_SERVICES}/{service_id}",
            headers=self.headers,
            name=f"{USER_HEALTH_SERVICES}/:id",
        )

    @task(2)
    def get_health_service_related_reads(self):
        service_id = _choose(self.service_ids)
        if not service_id:
            return
        suffix = random.choice(["employees", "reviews", "recommended"])
        self.client.get(
            f"{USER_HEALTH_SERVICES}/{service_id}/{suffix}",
            headers=self.headers,
            name=f"{USER_HEALTH_SERVICES}/:id/{suffix}",
        )

    @task(3)
    def get_clinic_info(self):
        clinic_id = _choose(self.clinic_ids)
        if not clinic_id:
            return
        self.client.get(
            f"{USER_CLINICS}/{clinic_id}/info",
            headers=self.headers,
            name=f"{USER_CLINICS}/:id/info",
        )

    @task(2)
    def list_clinic_products(self):
        clinic_id = _choose(self.clinic_ids)
        if not clinic_id:
            return
        query = urlencode(
            {
                "page": 1,
                "limit": random.choice([10, 20, 50]),
                "sort": random.choice(["popular", "latest", "top_sales"]),
            }
        )
        self.client.get(
            f"{USER_CLINICS}/{clinic_id}/products?{query}",
            headers=self.headers,
            name=f"{USER_CLINICS}/:id/products",
        )

    @task(2)
    def list_clinic_reviews(self):
        clinic_id = _choose(self.clinic_ids)
        if not clinic_id:
            return
        query = urlencode({"page": 1, "limit": random.choice([10, 20])})
        self.client.get(
            f"{USER_CLINICS}/{clinic_id}/reviews?{query}",
            headers=self.headers,
            name=f"{USER_CLINICS}/:id/reviews",
        )

    def _discover_user_read_context(self):
        appointments = _safe_json_get(
            self.client,
            f"{USER_APPOINTMENTS}?{urlencode({'sortBy': 'newest'})}",
            self.headers,
            f"{USER_APPOINTMENTS} [discovery]",
        )
        for appointment in _extract_items(appointments):
            _append_unique(self.appointment_ids, _id_from(appointment))
            _append_unique(self.service_ids, _string_value(appointment, "serviceId"))
            _append_unique(self.clinic_ids, _string_value(appointment, "healthPartnerId"))

        for path in (
            f"{USER_HEALTH_SERVICES}/home-recommend",
            f"{USER_HEALTH_SERVICES}/premium-treatments",
        ):
            payload = _safe_json_get(self.client, path, self.headers, f"{path} [discovery]")
            for item in _extract_items(payload):
                _append_unique(self.service_ids, _id_from(item))
                _append_unique(self.clinic_ids, _first_uuid_by_key(item, ["clinicId", "partnerId", "healthPartnerId"]))

        for service_id in list(self.service_ids[:5]):
            payload = _safe_json_get(
                self.client,
                f"{USER_HEALTH_SERVICES}/{service_id}/info",
                self.headers,
                f"{USER_HEALTH_SERVICES}/:id/info [discovery]",
                optional=True,
            )
            _append_unique(self.clinic_ids, _first_uuid_by_key(payload, ["clinicId", "partnerId", "healthPartnerId"]))
            clinic = payload.get("clinic") if isinstance(payload, dict) else None
            if isinstance(clinic, dict):
                _append_unique(self.clinic_ids, _id_from(clinic))

        wishlist = _safe_json_get(
            self.client,
            USER_WISHLIST,
            self.headers,
            f"{USER_WISHLIST} [discovery]",
            optional=True,
        )
        for item in _extract_items(wishlist):
            _append_unique(self.service_ids, _string_value(item, "productId"))


@tag("current-new-api", "new-api", "admin-dashboard", "safe-read")
class AdminDashboardCurrentApiUser(HttpUser):
    """ADMIN read mix for the new admin dashboard endpoints."""

    wait_time = between(MIN_WAIT, MAX_WAIT)
    weight = 2

    def on_start(self):
        token = None
        for attempt in range(3):
            token, _ = login_admin(self.client)
            if token:
                break
            time.sleep(2 * (attempt + 1))

        if not token:
            raise StopUser("Admin login failed after retries")

        self.headers = auth_headers(token)

    @task(5)
    def get_overview(self):
        self._get_period_endpoint("overview")

    @task(4)
    def get_revenue_trend(self):
        self._get_period_endpoint("revenue-trend")

    @task(4)
    def get_booking_outcomes(self):
        self._get_period_endpoint("booking-outcomes")

    @task(4)
    def get_transaction_health(self):
        self._get_period_endpoint("transaction-health")

    @task(3)
    def get_top_partners(self):
        self._get_period_endpoint("top-partners", {"limit": random.choice([5, 10, 20])})

    @task(3)
    def get_top_services(self):
        self._get_period_endpoint("top-services", {"limit": random.choice([5, 10, 20])})

    @task(2)
    def get_notifications(self):
        query = urlencode({"limit": random.choice([5, 10, 20])})
        self.client.get(
            f"{ADMIN_DASHBOARD}/notifications?{query}",
            headers=self.headers,
            name=f"{ADMIN_DASHBOARD}/notifications",
        )

    @task(2)
    def get_category_health(self):
        self.client.get(
            f"{ADMIN_DASHBOARD}/category-health",
            headers=self.headers,
            name=f"{ADMIN_DASHBOARD}/category-health",
        )

    def _get_period_endpoint(self, endpoint: str, extra: dict[str, Any] | None = None):
        query = {"period": random.choice(ADMIN_DASHBOARD_PERIODS)}
        if extra:
            query.update(extra)
        self.client.get(
            f"{ADMIN_DASHBOARD}/{endpoint}?{urlencode(query)}",
            headers=self.headers,
            name=f"{ADMIN_DASHBOARD}/{endpoint}",
        )


@tag("current-new-api", "new-api", "admin-finance", "safe-read")
class AdminFinanceReadApiUser(HttpUser):
    """ADMIN read mix for platform finance overview, pages, and detail reads."""

    wait_time = between(MIN_WAIT, MAX_WAIT)
    weight = 2

    def on_start(self):
        token = None
        for attempt in range(3):
            token, _ = login_admin(self.client)
            if token:
                break
            time.sleep(2 * (attempt + 1))

        if not token:
            raise StopUser("Admin login failed after retries")

        self.headers = auth_headers(token)
        self.transaction_ids: list[str] = []
        self.payout_ids: list[str] = []
        self.refund_case_ids: list[str] = []
        self.reconciliation_ids: list[str] = []
        self._discover_admin_finance_ids()

    @task(5)
    def get_summary(self):
        self._get_page("summary", _finance_query())

    @task(5)
    def get_trend(self):
        self._get_page("trend", _finance_query())

    @task(4)
    def get_alerts(self):
        self._get_page("alerts", _finance_query())

    @task(6)
    def list_transactions(self):
        self._get_page("transactions", _finance_page_query())

    @task(2)
    def get_transaction_detail(self):
        transaction_id = _choose(self.transaction_ids)
        if not transaction_id:
            return
        self.client.get(
            f"{ADMIN_FINANCE}/transactions/{transaction_id}",
            headers=self.headers,
            name=f"{ADMIN_FINANCE}/transactions/:id",
        )

    @task(4)
    def list_payouts(self):
        self._get_page("payouts", _finance_page_query())

    @task(2)
    def get_payout_detail(self):
        payout_id = _choose(self.payout_ids)
        if not payout_id:
            return
        self.client.get(
            f"{ADMIN_FINANCE}/payouts/{payout_id}",
            headers=self.headers,
            name=f"{ADMIN_FINANCE}/payouts/:id",
        )

    @task(4)
    def list_refund_cases(self):
        self._get_page("refund-cases", _finance_page_query())

    @task(2)
    def get_refund_case_detail(self):
        case_id = _choose(self.refund_case_ids)
        if not case_id:
            return
        self.client.get(
            f"{ADMIN_FINANCE}/refund-cases/{case_id}",
            headers=self.headers,
            name=f"{ADMIN_FINANCE}/refund-cases/:id",
        )

    @task(4)
    def list_reconciliation(self):
        self._get_page("reconciliation", _finance_page_query())

    @task(2)
    def get_reconciliation_detail(self):
        reconciliation_id = _choose(self.reconciliation_ids)
        if not reconciliation_id:
            return
        self.client.get(
            f"{ADMIN_FINANCE}/reconciliation/{reconciliation_id}",
            headers=self.headers,
            name=f"{ADMIN_FINANCE}/reconciliation/:id",
        )

    @task(3)
    def get_partner_exposure(self):
        self._get_page("partner-exposure", _finance_page_query())

    @task(2)
    def list_exports(self):
        self.client.get(
            f"{ADMIN_FINANCE}/exports",
            headers=self.headers,
            name=f"{ADMIN_FINANCE}/exports",
        )

    def _get_page(self, endpoint: str, query: dict[str, Any]):
        self.client.get(
            f"{ADMIN_FINANCE}/{endpoint}?{urlencode(query)}",
            headers=self.headers,
            name=f"{ADMIN_FINANCE}/{endpoint}",
        )

    def _discover_admin_finance_ids(self):
        discovery_targets = [
            ("transactions", self.transaction_ids),
            ("payouts", self.payout_ids),
            ("refund-cases", self.refund_case_ids),
            ("reconciliation", self.reconciliation_ids),
        ]
        for endpoint, target in discovery_targets:
            payload = _safe_json_get(
                self.client,
                f"{ADMIN_FINANCE}/{endpoint}?{urlencode({'page': 1, 'limit': 20})}",
                self.headers,
                f"{ADMIN_FINANCE}/{endpoint} [discovery]",
                optional=True,
            )
            for item in _extract_items(payload):
                _append_unique(target, _id_from(item))


@tag("current-new-api", "new-api", "partner-current", "safe-read")
class PartnerCurrentApiUser(HttpUser):
    """PARTNER read mix for bookings, skill catalogs, and assigned services."""

    wait_time = between(MIN_WAIT, MAX_WAIT)
    weight = 2

    def on_start(self):
        token = None
        for attempt in range(3):
            token, _ = login_partner(self.client)
            if token:
                break
            time.sleep(2 * (attempt + 1))

        if not token:
            raise StopUser("Partner login failed after retries")

        self.headers = auth_headers(token)
        self.booking_ids: list[str] = []
        self.employee_ids: list[str] = []
        self._discover_partner_context()

    @task(5)
    def list_bookings(self):
        self.client.get(
            PARTNER_BOOKINGS,
            headers=self.headers,
            name=PARTNER_BOOKINGS,
        )

    @task(3)
    def get_booking_detail(self):
        booking_id = _choose(self.booking_ids)
        if not booking_id:
            return
        self.client.get(
            f"{PARTNER_BOOKINGS}/{booking_id}",
            headers=self.headers,
            name=f"{PARTNER_BOOKINGS}/:id",
        )

    @task(3)
    def list_employees(self):
        query = urlencode({"page": random.randint(1, 3), "limit": random.choice([10, 20, 50])})
        self.client.get(
            f"{PARTNER_EMPLOYEES}?{query}",
            headers=self.headers,
            name=PARTNER_EMPLOYEES,
        )

    @task(3)
    def get_employee_services(self):
        employee_id = _choose(self.employee_ids)
        if not employee_id:
            return
        self.client.get(
            f"{PARTNER_EMPLOYEES}/{employee_id}/services",
            headers=self.headers,
            name=f"{PARTNER_EMPLOYEES}/:id/services",
        )

    @task(2)
    def list_massage_skills(self):
        self.client.get(
            f"{PARTNER_EMPLOYEES}/massage-skills",
            headers=self.headers,
            name=f"{PARTNER_EMPLOYEES}/massage-skills",
        )

    @task(2)
    def list_spa_skills(self):
        self.client.get(
            f"{PARTNER_EMPLOYEES}/spa-skills",
            headers=self.headers,
            name=f"{PARTNER_EMPLOYEES}/spa-skills",
        )

    @task(2)
    def get_partner_dashboard_services(self):
        self.client.get(
            f"{API_PREFIX}/partner/dashboard/services/performance",
            headers=self.headers,
            name=f"{API_PREFIX}/partner/dashboard/services/performance",
        )

    @task(2)
    def get_partner_dashboard_schedule(self):
        query = urlencode({"date": date.today().isoformat()})
        self.client.get(
            f"{API_PREFIX}/partner/dashboard/staff/schedule?{query}",
            headers=self.headers,
            name=f"{API_PREFIX}/partner/dashboard/staff/schedule",
        )

    def _discover_partner_context(self):
        bookings = _safe_json_get(
            self.client,
            PARTNER_BOOKINGS,
            self.headers,
            f"{PARTNER_BOOKINGS} [discovery]",
            optional=True,
        )
        for item in _extract_items(bookings):
            _append_unique(self.booking_ids, _id_from(item))

        employees = _safe_json_get(
            self.client,
            f"{PARTNER_EMPLOYEES}?{urlencode({'page': 1, 'limit': 50})}",
            self.headers,
            f"{PARTNER_EMPLOYEES} [discovery]",
            optional=True,
        )
        for item in _extract_items(employees):
            _append_unique(self.employee_ids, _id_from(item))


def _appointment_query() -> dict[str, str]:
    query = {"sortBy": random.choice(["newest", "oldest"])}
    if random.random() < 0.6:
        query["status"] = random.choice(APPOINTMENT_STATUSES)
    return query


def _finance_query() -> dict[str, str]:
    return {"period": random.choice(ADMIN_FINANCE_PERIODS)}


def _finance_page_query() -> dict[str, str | int]:
    query: dict[str, str | int] = {
        "period": random.choice(ADMIN_FINANCE_PERIODS),
        "page": random.randint(1, 3),
        "limit": random.choice([10, 25, 50, 100]),
    }
    if random.random() < 0.3:
        query["transactionStatus"] = random.choice(ADMIN_FINANCE_STATUSES)
    return query


def _safe_json_get(
    client,
    path: str,
    headers: dict[str, str],
    name: str,
    *,
    optional: bool = False,
) -> Any:
    with client.get(path, headers=headers, name=name, catch_response=True) as resp:
        if resp.status_code != 200:
            if optional and resp.status_code in {204, 404}:
                resp.success()
                return None
            resp.failure(f"Discovery failed: HTTP {resp.status_code}")
            return None
        try:
            payload = resp.json()
        except ValueError as exc:
            resp.failure(f"Discovery returned non-JSON response: {exc}")
            return None
        resp.success()
        return payload


def _extract_items(payload: Any) -> list[Any]:
    if isinstance(payload, list):
        return payload
    if isinstance(payload, dict):
        data = payload.get("data")
        if isinstance(data, list):
            return data
        items = payload.get("items")
        if isinstance(items, list):
            return items
        products = payload.get("products")
        if isinstance(products, list):
            return products
        results = payload.get("results")
        if isinstance(results, list):
            return results
    return []


def _choose(values: list[str]) -> str | None:
    return random.choice(values) if values else None


def _append_unique(values: list[str], value: str | None):
    if value and UUID_RE.match(value) and value not in values:
        values.append(value)


def _id_from(item: Any) -> str | None:
    return _string_value(item, "id")


def _string_value(item: Any, key: str) -> str | None:
    if isinstance(item, dict):
        value = item.get(key)
        if isinstance(value, str) and value:
            return value
    return None


def _first_uuid_by_key(payload: Any, keys: list[str]) -> str | None:
    if isinstance(payload, dict):
        for key in keys:
            value = payload.get(key)
            if isinstance(value, str) and UUID_RE.match(value):
                return value
        for value in payload.values():
            found = _first_uuid_by_key(value, keys)
            if found:
                return found
    if isinstance(payload, list):
        for item in payload:
            found = _first_uuid_by_key(item, keys)
            if found:
                return found
    return None
