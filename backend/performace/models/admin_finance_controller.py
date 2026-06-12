"""Generated models for admin_finance_controller. Do not edit manually."""

from __future__ import annotations

from enum import Enum
from typing import Any, TypeAlias
from dataclasses import dataclass
from .base import DtoModel, dto_field
from .shared import PartnerCommerceSourceType, PartnerPayoutStatus, PartnerRefundCaseStatus, PartnerRefundCaseType, PartnerSettlementStatus, PartnerTransactionStatus, PartnerTransactionType


class AdminFinanceExportStatus(str, Enum):
    QUEUED = 'queued'
    PROCESSING = 'processing'
    READY = 'ready'
    FAILED = 'failed'
    EXPIRED = 'expired'


class AdminFinanceExportType(str, Enum):
    TRANSACTIONS = 'transactions'
    PAYOUTS = 'payouts'
    REFUNDCASES = 'refundCases'
    RECONCILIATION = 'reconciliation'
    PARTNEREXPOSURE = 'partnerExposure'
    MONTHLYSUMMARY = 'monthlySummary'


class AdminFinanceNoteEntityType(str, Enum):
    TRANSACTION = 'transaction'
    PAYOUT = 'payout'
    REFUNDCASE = 'refundCase'
    RECONCILIATION = 'reconciliation'


class AdminFinanceProvider(str, Enum):
    STRIPE = 'stripe'
    MOMO = 'momo'
    VNPAY = 'vnpay'
    BANKTRANSFER = 'bankTransfer'
    MANUAL = 'manual'


class AdminFinanceReconciliationStatus(str, Enum):
    OPEN = 'open'
    UNDERREVIEW = 'underReview'
    RESOLVED = 'resolved'
    REOPENED = 'reopened'


class AdminFinanceReconciliationType(str, Enum):
    MISSINGPROVIDEREVENT = 'missingProviderEvent'
    MISSINGLEDGERRECORD = 'missingLedgerRecord'
    AMOUNTMISMATCH = 'amountMismatch'
    CURRENCYMISMATCH = 'currencyMismatch'
    DUPLICATEPROVIDEREVENT = 'duplicateProviderEvent'
    PAYOUTMISMATCH = 'payoutMismatch'
    REFUNDMISMATCH = 'refundMismatch'
    STALEPENDINGPAYMENT = 'stalePendingPayment'


class AdminFinanceRiskTone(str, Enum):
    NEUTRAL = 'neutral'
    POSITIVE = 'positive'
    WARNING = 'warning'
    CRITICAL = 'critical'


@dataclass(slots=True)
class AdminFinanceAlertDto(DtoModel):
    id: str
    title: str
    description: str
    tone: AdminFinanceRiskTone
    createdAt: str


@dataclass(slots=True)
class AdminFinanceAuditEventDto(DtoModel):
    id: str
    label: str
    detail: str
    performedBy: str
    occurredAt: str
    isError: bool


@dataclass(slots=True)
class AdminFinanceCreateExportDto(DtoModel):
    type: AdminFinanceExportType


@dataclass(slots=True)
class AdminFinanceCreateNoteDto(DtoModel):
    entityType: AdminFinanceNoteEntityType
    entityId: str
    content: str


@dataclass(slots=True)
class AdminFinanceExportJobDto(DtoModel):
    id: str
    createdAt: str
    type: AdminFinanceExportType
    requestedBy: str
    status: AdminFinanceExportStatus
    rowCount: float
    downloadUrl: str | None = None
    expiresAt: str | None = None


@dataclass(slots=True)
class AdminFinanceNoteActionDto(DtoModel):
    note: str | None = None


@dataclass(slots=True)
class AdminFinanceNoteDto(DtoModel):
    id: str
    content: str
    createdBy: str
    createdAt: str


@dataclass(slots=True)
class AdminFinanceOverviewDto(DtoModel):
    grossVolume: float
    netRevenue: float
    platformFeeRevenue: float
    refundExposure: float
    failedPaymentAmount: float
    pendingPayoutAmount: float
    heldPayoutAmount: float
    unreconciledAmount: float
    currency: str


@dataclass(slots=True)
class AdminFinancePageMetaDto(DtoModel):
    total: float
    page: float
    limit: float
    totalPages: float


@dataclass(slots=True)
class AdminFinancePartnerExposureDto(DtoModel):
    partnerId: str
    partnerName: str
    totalVolume: float
    pendingPayouts: float
    refundExposure: float
    failedPayments: float
    heldFunds: float
    currency: str
    riskTone: AdminFinanceRiskTone


@dataclass(slots=True)
class AdminFinancePayoutAttemptDto(DtoModel):
    attemptNumber: float
    attemptedAt: str
    status: str
    failureReason: str | None = None


@dataclass(slots=True)
class AdminFinancePayoutDetailDto(DtoModel):
    record: AdminFinancePayoutRecordDto
    includedTransactions: list[AdminFinanceTransactionRecordDto]
    attempts: list[AdminFinancePayoutAttemptDto]
    maskedDestination: str
    auditTrail: list[AdminFinanceAuditEventDto]
    notes: list[AdminFinanceNoteDto]


@dataclass(slots=True)
class AdminFinancePayoutPageDto(DtoModel):
    data: list[AdminFinancePayoutRecordDto]
    meta: AdminFinancePageMetaDto


@dataclass(slots=True)
class AdminFinancePayoutRecordDto(DtoModel):
    id: str
    scheduledDate: str
    partnerName: str
    periodLabel: str
    includedVolume: float
    feesAndAdjustments: float
    netPayout: float
    currency: str
    method: str
    status: PartnerPayoutStatus
    attemptCount: float
    notesCount: float
    failureReason: str | None = None
    holdReason: str | None = None


@dataclass(slots=True)
class AdminFinanceProviderEventDto(DtoModel):
    id: str
    eventType: str
    provider: AdminFinanceProvider
    occurredAt: str
    detail: str
    rawPayload: str


@dataclass(slots=True)
class AdminFinanceReconciliationDetailDto(DtoModel):
    exception: AdminFinanceReconciliationExceptionDto
    providerEventContext: str
    ledgerContext: str
    resolutionNotes: str
    auditTrail: list[AdminFinanceAuditEventDto]
    notes: list[AdminFinanceNoteDto]


@dataclass(slots=True)
class AdminFinanceReconciliationExceptionDto(DtoModel):
    id: str
    detectedAt: str
    provider: AdminFinanceProvider
    providerEventId: str
    expectedAmount: float
    providerAmount: float
    difference: float
    currency: str
    type: AdminFinanceReconciliationType
    status: AdminFinanceReconciliationStatus
    owner: str
    summary: str
    relatedTransactionId: str | None = None


@dataclass(slots=True)
class AdminFinanceReconciliationPageDto(DtoModel):
    data: list[AdminFinanceReconciliationExceptionDto]
    meta: AdminFinancePageMetaDto


@dataclass(slots=True)
class AdminFinanceRefundCaseDetailDto(DtoModel):
    record: AdminFinanceRefundCaseRecordDto
    customerRequest: str
    partnerResponse: str
    evidenceLinks: list[str]
    decisionNote: str
    auditTrail: list[AdminFinanceAuditEventDto]
    notes: list[AdminFinanceNoteDto]


@dataclass(slots=True)
class AdminFinanceRefundCasePageDto(DtoModel):
    data: list[AdminFinanceRefundCaseRecordDto]
    meta: AdminFinancePageMetaDto


@dataclass(slots=True)
class AdminFinanceRefundCaseRecordDto(DtoModel):
    id: str
    requestedAt: str
    transactionId: str
    partnerName: str
    customerName: str
    caseType: PartnerRefundCaseType
    amount: float
    currency: str
    reason: str
    owner: str
    status: PartnerRefundCaseStatus
    slaHours: float
    slaBreached: bool
    riskTone: AdminFinanceRiskTone


@dataclass(slots=True)
class AdminFinanceRequiredNoteActionDto(DtoModel):
    note: str


@dataclass(slots=True)
class AdminFinanceReviewFlagActionDto(DtoModel):
    flagged: bool
    note: str | None = None


@dataclass(slots=True)
class AdminFinanceSettlementActionDto(DtoModel):
    settlementStatus: PartnerSettlementStatus
    note: str


@dataclass(slots=True)
class AdminFinanceTransactionDetailDto(DtoModel):
    record: AdminFinanceTransactionRecordDto
    providerEvents: list[AdminFinanceProviderEventDto]
    auditTrail: list[AdminFinanceAuditEventDto]
    notes: list[AdminFinanceNoteDto]
    relatedRefundCases: list[AdminFinanceRefundCaseRecordDto]


@dataclass(slots=True)
class AdminFinanceTransactionPageDto(DtoModel):
    data: list[AdminFinanceTransactionRecordDto]
    meta: AdminFinancePageMetaDto


@dataclass(slots=True)
class AdminFinanceTransactionRecordDto(DtoModel):
    id: str
    createdAt: str
    reference: str
    partnerName: str
    customerName: str
    sourceType: PartnerCommerceSourceType
    type: PartnerTransactionType
    grossAmount: float
    feeAmount: float
    netAmount: float
    currency: str
    transactionStatus: PartnerTransactionStatus
    settlementStatus: PartnerSettlementStatus
    payoutStatus: PartnerPayoutStatus
    provider: AdminFinanceProvider
    isFlagged: bool
    notesCount: float
    payoutId: str | None = None


@dataclass(slots=True)
class AdminFinanceTrendPointDto(DtoModel):
    date: str
    grossAmount: float
    netAmount: float
    refundAmount: float
    payoutAmount: float


AdminFinanceControllerGetAlertsResponseDto: TypeAlias = list[AdminFinanceAlertDto]  # GET /admin/finance/alerts [200]


AdminFinanceControllerGetExportsResponseDto: TypeAlias = list[AdminFinanceExportJobDto]  # GET /admin/finance/exports [200]


AdminFinanceControllerGetPartnerExposureResponseDto: TypeAlias = list[AdminFinancePartnerExposureDto]  # GET /admin/finance/partner-exposure [200]


AdminFinanceControllerGetTrendResponseDto: TypeAlias = list[AdminFinanceTrendPointDto]  # GET /admin/finance/trend [200]


__all__ = [
    "AdminFinanceExportStatus",
    "AdminFinanceExportType",
    "AdminFinanceNoteEntityType",
    "AdminFinanceProvider",
    "AdminFinanceReconciliationStatus",
    "AdminFinanceReconciliationType",
    "AdminFinanceRiskTone",
    "AdminFinanceAlertDto",
    "AdminFinanceAuditEventDto",
    "AdminFinanceCreateExportDto",
    "AdminFinanceCreateNoteDto",
    "AdminFinanceExportJobDto",
    "AdminFinanceNoteActionDto",
    "AdminFinanceNoteDto",
    "AdminFinanceOverviewDto",
    "AdminFinancePageMetaDto",
    "AdminFinancePartnerExposureDto",
    "AdminFinancePayoutAttemptDto",
    "AdminFinancePayoutDetailDto",
    "AdminFinancePayoutPageDto",
    "AdminFinancePayoutRecordDto",
    "AdminFinanceProviderEventDto",
    "AdminFinanceReconciliationDetailDto",
    "AdminFinanceReconciliationExceptionDto",
    "AdminFinanceReconciliationPageDto",
    "AdminFinanceRefundCaseDetailDto",
    "AdminFinanceRefundCasePageDto",
    "AdminFinanceRefundCaseRecordDto",
    "AdminFinanceRequiredNoteActionDto",
    "AdminFinanceReviewFlagActionDto",
    "AdminFinanceSettlementActionDto",
    "AdminFinanceTransactionDetailDto",
    "AdminFinanceTransactionPageDto",
    "AdminFinanceTransactionRecordDto",
    "AdminFinanceTrendPointDto",
    "AdminFinanceControllerGetAlertsResponseDto",
    "AdminFinanceControllerGetExportsResponseDto",
    "AdminFinanceControllerGetPartnerExposureResponseDto",
    "AdminFinanceControllerGetTrendResponseDto",
]
