"""
Partner finance stress tests.

Read-heavy scenarios target the updated finance module. Mutation scenarios are
split into a separate user and require PERF_ENABLE_MUTATIONS=1 so the default
suite cannot accidentally change finance state.
"""

from __future__ import annotations

import random
from urllib.parse import urlencode

from locust import HttpUser, between, constant_pacing, tag, task
from locust.exception import StopUser

from common.auth import auth_headers, login_partner
from common.config import (
    FINANCE_STRESS_PERIODS,
    MAX_WAIT,
    MIN_WAIT,
    PERF_ENABLE_MUTATIONS,
)
from common.discovery import (
    PARTNER_PAYOUTS,
    PARTNER_REFUND_CASES,
    PARTNER_TRANSACTIONS,
    partner_discovery,
)
from models.partner_payouts_controller import RetryPayoutDto
from models.partner_refund_cases_controller import RefundCaseActionDto
from models.partner_transactions_controller import (
    FlagReviewDto,
    MarkSettlementDto,
    PartnerSettlementStatus,
)


FINANCE_PERIODS = FINANCE_STRESS_PERIODS or ["sevenDays", "thirtyDays", "ninetyDays"]
TRANSACTION_STATUSES = ["pending", "paid", "refunded", "failed", "canceled"]
SETTLEMENT_STATUSES = ["unsettled", "scheduled", "settled", "held"]
PAYOUT_STATUSES = ["notAssigned", "inPayout", "paidOut", "failed"]
TRANSACTION_TYPES = ["charge", "refund", "adjustment", "payout", "fee"]
PAGE_LIMITS = [10, 25, 50, 100]


@tag("updated", "partner-finance", "stress")
class PartnerFinanceStressUser(HttpUser):
    """Read-heavy stress user for partner finance list, detail, and aggregates."""

    wait_time = between(MIN_WAIT, MAX_WAIT)

    def on_start(self):
        token, _ = login_partner(self.client)
        if not token:
            raise StopUser("Partner login failed")

        self.headers = auth_headers(token)
        partner_discovery.ensure_discovered(self.client, self.headers)

    @task(5)
    def get_finance_summary(self):
        self.client.get(
            f"{PARTNER_TRANSACTIONS}/finance/summary?{urlencode(_period_query())}",
            headers=self.headers,
            name=f"{PARTNER_TRANSACTIONS}/finance/summary",
        )

    @task(5)
    def get_finance_trend(self):
        self.client.get(
            f"{PARTNER_TRANSACTIONS}/finance/trend?{urlencode(_period_query())}",
            headers=self.headers,
            name=f"{PARTNER_TRANSACTIONS}/finance/trend",
        )

    @task(6)
    def list_transactions(self):
        self.client.get(
            f"{PARTNER_TRANSACTIONS}?{urlencode(_transaction_page_query())}",
            headers=self.headers,
            name=PARTNER_TRANSACTIONS,
        )

    @task(4)
    def get_transaction_detail(self):
        transaction_id = partner_discovery.random_transaction_id()
        if not transaction_id:
            return

        self.client.get(
            f"{PARTNER_TRANSACTIONS}/{transaction_id}",
            headers=self.headers,
            name=f"{PARTNER_TRANSACTIONS}/:transactionId",
        )

    @task(3)
    def list_payouts(self):
        self.client.get(
            f"{PARTNER_PAYOUTS}?{urlencode(_payout_page_query())}",
            headers=self.headers,
            name=PARTNER_PAYOUTS,
        )

    @task(3)
    def list_refund_cases(self):
        self.client.get(
            f"{PARTNER_REFUND_CASES}?{urlencode(_page_query())}",
            headers=self.headers,
            name=PARTNER_REFUND_CASES,
        )


@tag("finance-mutation")
class PartnerFinanceMutationUser(HttpUser):
    """Controlled low-rate mutation user for finance operations."""

    wait_time = constant_pacing(8)
    weight = 1 if PERF_ENABLE_MUTATIONS else 0

    def on_start(self):
        if not PERF_ENABLE_MUTATIONS:
            raise StopUser("Set PERF_ENABLE_MUTATIONS=1 to run finance mutations")

        token, _ = login_partner(self.client)
        if not token:
            raise StopUser("Partner login failed")

        self.headers = auth_headers(token)
        partner_discovery.ensure_discovered(self.client, self.headers)

    @task(1)
    def mark_transaction_settled(self):
        transaction_id = partner_discovery.pop_transaction_for_mutation()
        if not transaction_id:
            return

        payload = MarkSettlementDto(
            settlementStatus=PartnerSettlementStatus.SETTLED,
            note="Performance controlled mutation: mark settled.",
        ).to_dict()
        self.client.patch(
            f"{PARTNER_TRANSACTIONS}/{transaction_id}/settlement",
            json=payload,
            headers=self.headers,
            name=f"{PARTNER_TRANSACTIONS}/:transactionId/settlement",
        )

    @task(1)
    def flag_transaction_for_review(self):
        transaction_id = partner_discovery.pop_transaction_for_mutation()
        if not transaction_id:
            return

        payload = FlagReviewDto(
            flaggedForReview=True,
            note="Performance controlled mutation: flag for review.",
        ).to_dict()
        self.client.patch(
            f"{PARTNER_TRANSACTIONS}/{transaction_id}/review-flag",
            json=payload,
            headers=self.headers,
            name=f"{PARTNER_TRANSACTIONS}/:transactionId/review-flag",
        )

    @task(1)
    def retry_failed_payout(self):
        payout_id = partner_discovery.pop_failed_payout_id()
        if not payout_id:
            return

        payload = RetryPayoutDto(
            note="Performance controlled mutation: retry failed payout.",
        ).to_dict()
        self.client.post(
            f"{PARTNER_PAYOUTS}/{payout_id}/retry",
            json=payload,
            headers=self.headers,
            name=f"{PARTNER_PAYOUTS}/:payoutId/retry",
        )

    @task(1)
    def approve_refund_case(self):
        case_id = partner_discovery.pop_open_refund_case_id()
        if not case_id:
            return

        payload = RefundCaseActionDto(
            note="Performance controlled mutation: approve refund case.",
        ).to_dict()
        self.client.post(
            f"{PARTNER_REFUND_CASES}/{case_id}/approve",
            json=payload,
            headers=self.headers,
            name=f"{PARTNER_REFUND_CASES}/:caseId/approve",
        )

    @task(1)
    def reject_refund_case(self):
        case_id = partner_discovery.pop_open_refund_case_id()
        if not case_id:
            return

        payload = RefundCaseActionDto(
            note="Performance controlled mutation: reject refund case.",
        ).to_dict()
        self.client.post(
            f"{PARTNER_REFUND_CASES}/{case_id}/reject",
            json=payload,
            headers=self.headers,
            name=f"{PARTNER_REFUND_CASES}/:caseId/reject",
        )


def _period_query() -> dict[str, str]:
    return {"period": random.choice(FINANCE_PERIODS)}


def _page_query() -> dict[str, str | int]:
    return {
        "period": random.choice(FINANCE_PERIODS),
        "page": random.randint(1, 3),
        "limit": random.choice(PAGE_LIMITS),
    }


def _transaction_page_query() -> dict[str, str | int]:
    query = _page_query()
    if random.random() < 0.35:
        query["transactionStatus"] = random.choice(TRANSACTION_STATUSES)
    if random.random() < 0.35:
        query["settlementStatus"] = random.choice(SETTLEMENT_STATUSES)
    if random.random() < 0.25:
        query["payoutStatus"] = random.choice(PAYOUT_STATUSES)
    if random.random() < 0.25:
        query["transactionType"] = random.choice(TRANSACTION_TYPES)
    return query


def _payout_page_query() -> dict[str, str | int]:
    query = _page_query()
    if random.random() < 0.5:
        query["payoutStatus"] = random.choice(PAYOUT_STATUSES)
    return query
