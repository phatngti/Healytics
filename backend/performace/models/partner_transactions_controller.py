"""Generated models for partner_transactions_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import PartnerPayoutRecordDto, PartnerPayoutStatus, PartnerRefundCaseRecordDto


class PartnerCommerceSourceType(str, Enum):
    SERVICEBOOKING = 'serviceBooking'
    PRODUCTORDER = 'productOrder'


class PartnerSettlementStatus(str, Enum):
    UNSETTLED = 'unsettled'
    SCHEDULED = 'scheduled'
    SETTLED = 'settled'
    HELD = 'held'


class PartnerTransactionStatus(str, Enum):
    PENDING = 'pending'
    PAID = 'paid'
    REFUNDED = 'refunded'
    FAILED = 'failed'
    CANCELED = 'canceled'


class PartnerTransactionType(str, Enum):
    CHARGE = 'charge'
    REFUND = 'refund'
    ADJUSTMENT = 'adjustment'
    PAYOUT = 'payout'
    FEE = 'fee'


@dataclass(slots=True)
class FlagReviewDto(DtoModel):
    flaggedForReview: bool
    note: str | None = None


@dataclass(slots=True)
class MarkSettlementDto(DtoModel):
    settlementStatus: PartnerSettlementStatus
    note: str | None = None


@dataclass(slots=True)
class PartnerFinanceSummaryDto(DtoModel):
    grossVolume: float
    netSettled: float
    pendingPayout: float
    refundExposure: float
    availableBalance: float
    pendingBalance: float
    currency: str
    nextPayoutAt: str | None = None
    payoutMethod: str | None = None
    payoutStatus: PartnerPayoutStatus | None = None


@dataclass(slots=True)
class PartnerFinanceTrendPointDto(DtoModel):
    date: str
    grossAmount: float
    netAmount: float
    refundAmount: float


@dataclass(slots=True)
class PartnerTransactionDetailDto(DtoModel):
    record: PartnerTransactionRecordDto
    relatedRefundCases: list[PartnerRefundCaseRecordDto]
    sourceSummaryTitle: str
    sourceSummarySubtitle: str
    payoutRecord: PartnerPayoutRecordDto | None = None


@dataclass(slots=True)
class PartnerTransactionRecordDto(DtoModel):
    id: str
    createdAt: str
    type: PartnerTransactionType
    sourceType: PartnerCommerceSourceType
    reference: str
    customerName: str
    grossAmount: float
    feeAmount: float
    netAmount: float
    currency: str
    status: PartnerTransactionStatus
    settlementStatus: PartnerSettlementStatus
    payoutStatus: PartnerPayoutStatus
    paymentMethod: str
    sourceTitle: str
    sourceSubtitle: str
    timeline: list[PartnerTransactionTimelineEventDto]
    flaggedForReview: bool
    notes: str | None = None
    payoutId: str | None = None


@dataclass(slots=True)
class PartnerTransactionTimelineEventDto(DtoModel):
    title: str
    description: str
    occurredAt: str


PartnerTransactionsControllerGetTrendResponseDto: TypeAlias = list[PartnerFinanceTrendPointDto]  # GET /partner/transactions/finance/trend [200]


__all__ = [
    "PartnerCommerceSourceType",
    "PartnerSettlementStatus",
    "PartnerTransactionStatus",
    "PartnerTransactionType",
    "FlagReviewDto",
    "MarkSettlementDto",
    "PartnerFinanceSummaryDto",
    "PartnerFinanceTrendPointDto",
    "PartnerTransactionDetailDto",
    "PartnerTransactionRecordDto",
    "PartnerTransactionTimelineEventDto",
    "PartnerTransactionsControllerGetTrendResponseDto",
]
