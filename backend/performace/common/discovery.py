"""
Runtime discovery helpers for seeded partner performance data.

The updated-module stress tests use existing seeded records instead of
hardcoded IDs. Discovery is intentionally read-only and degrades gracefully
when optional rows such as failed payouts or open refund cases are absent.
"""

from __future__ import annotations

import random
import threading
from dataclasses import dataclass, field
from typing import Any

from common.config import API_PREFIX, DISCOVERY_PAGE_LIMIT


PARTNER_EMPLOYEES = f"{API_PREFIX}/partner/employees"
PARTNER_TRANSACTIONS = f"{API_PREFIX}/partner/transactions"
PARTNER_PAYOUTS = f"{API_PREFIX}/partner/payouts"
PARTNER_REFUND_CASES = f"{API_PREFIX}/partner/refund-cases"

TERMINAL_TRANSACTION_STATUSES = {"failed", "canceled", "refunded"}
OPEN_REFUND_CASE_STATUSES = {"pending", "underReview"}


@dataclass(slots=True)
class PartnerDiscoverySnapshot:
    employee_ids: list[str] = field(default_factory=list)
    transaction_ids: list[str] = field(default_factory=list)
    mutable_transaction_ids: list[str] = field(default_factory=list)
    failed_payout_ids: list[str] = field(default_factory=list)
    open_refund_case_ids: list[str] = field(default_factory=list)


class PartnerDiscoveryState:
    """Thread-safe cache of seeded partner IDs used by updated-module tests."""

    def __init__(self):
        self._lock = threading.Lock()
        self._snapshot = PartnerDiscoverySnapshot()
        self._initialized = False

    def ensure_discovered(self, client, headers: dict[str, str]) -> PartnerDiscoverySnapshot:
        """Populate the cache once and return the current snapshot."""
        with self._lock:
            if self._initialized:
                return self._snapshot

            transaction_rows = _fetch_items(
                client,
                headers,
                f"{PARTNER_TRANSACTIONS}?page=1&limit={DISCOVERY_PAGE_LIMIT}",
                f"{PARTNER_TRANSACTIONS} [discovery]",
            )
            payout_rows = _fetch_items(
                client,
                headers,
                f"{PARTNER_PAYOUTS}?page=1&limit={DISCOVERY_PAGE_LIMIT}&payoutStatus=failed",
                f"{PARTNER_PAYOUTS} [discovery failed]",
            )
            if not payout_rows:
                payout_rows = _fetch_items(
                    client,
                    headers,
                    f"{PARTNER_PAYOUTS}?page=1&limit={DISCOVERY_PAGE_LIMIT}",
                    f"{PARTNER_PAYOUTS} [discovery]",
                )

            refund_case_rows = _fetch_items(
                client,
                headers,
                f"{PARTNER_REFUND_CASES}?page=1&limit={DISCOVERY_PAGE_LIMIT}",
                f"{PARTNER_REFUND_CASES} [discovery]",
            )

            self._snapshot = PartnerDiscoverySnapshot(
                employee_ids=_ids_from_rows(
                    _fetch_items(
                        client,
                        headers,
                        PARTNER_EMPLOYEES,
                        f"{PARTNER_EMPLOYEES} [discovery]",
                    )
                ),
                transaction_ids=_ids_from_rows(transaction_rows),
                mutable_transaction_ids=[
                    row["id"]
                    for row in transaction_rows
                    if row.get("id") and row.get("status") not in TERMINAL_TRANSACTION_STATUSES
                ],
                failed_payout_ids=[
                    row["id"]
                    for row in payout_rows
                    if row.get("id") and row.get("status") == "failed"
                ],
                open_refund_case_ids=[
                    row["id"]
                    for row in refund_case_rows
                    if row.get("id") and row.get("status") in OPEN_REFUND_CASE_STATUSES
                ],
            )
            self._initialized = True
            return self._snapshot

    def random_employee_id(self) -> str | None:
        return self._random_from("employee_ids")

    def random_transaction_id(self) -> str | None:
        return self._random_from("transaction_ids")

    def pop_transaction_for_mutation(self) -> str | None:
        return self._pop_from("mutable_transaction_ids")

    def pop_failed_payout_id(self) -> str | None:
        return self._pop_from("failed_payout_ids")

    def pop_open_refund_case_id(self) -> str | None:
        return self._pop_from("open_refund_case_ids")

    def _random_from(self, field_name: str) -> str | None:
        with self._lock:
            values = getattr(self._snapshot, field_name)
            return random.choice(values) if values else None

    def _pop_from(self, field_name: str) -> str | None:
        with self._lock:
            values = getattr(self._snapshot, field_name)
            if not values:
                return None
            return values.pop(0)


partner_discovery = PartnerDiscoveryState()


def _fetch_items(client, headers: dict[str, str], path: str, name: str) -> list[dict[str, Any]]:
    with client.get(path, headers=headers, name=name, catch_response=True) as resp:
        if resp.status_code != 200:
            resp.failure(f"Discovery failed: HTTP {resp.status_code}")
            return []

        try:
            payload = resp.json()
        except ValueError as exc:
            resp.failure(f"Discovery returned non-JSON response: {exc}")
            return []

        items = _extract_items(payload)
        resp.success()
        return [item for item in items if isinstance(item, dict)]


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
    return []


def _ids_from_rows(rows: list[dict[str, Any]]) -> list[str]:
    return [row["id"] for row in rows if row.get("id")]


__all__ = [
    "PARTNER_EMPLOYEES",
    "PARTNER_TRANSACTIONS",
    "PARTNER_PAYOUTS",
    "PARTNER_REFUND_CASES",
    "PartnerDiscoverySnapshot",
    "PartnerDiscoveryState",
    "partner_discovery",
]
