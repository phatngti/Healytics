import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';

// ── Extension-type IDs ──────────────────────────────

extension type const AdminFinanceTransactionId(String value) implements String {
  factory AdminFinanceTransactionId.fromJson(dynamic json) =>
      AdminFinanceTransactionId(json as String);
  String toJson() => value;
}

extension type const AdminFinancePayoutId(String value) implements String {
  factory AdminFinancePayoutId.fromJson(dynamic json) =>
      AdminFinancePayoutId(json as String);
  String toJson() => value;
}

extension type const AdminFinanceRefundCaseId(String value) implements String {
  factory AdminFinanceRefundCaseId.fromJson(dynamic json) =>
      AdminFinanceRefundCaseId(json as String);
  String toJson() => value;
}

extension type const AdminFinanceReconciliationId(String value)
    implements String {
  factory AdminFinanceReconciliationId.fromJson(dynamic json) =>
      AdminFinanceReconciliationId(json as String);
  String toJson() => value;
}

extension type const AdminFinanceExportId(String value) implements String {
  factory AdminFinanceExportId.fromJson(dynamic json) =>
      AdminFinanceExportId(json as String);
  String toJson() => value;
}

extension type const AdminFinanceNoteId(String value) implements String {
  factory AdminFinanceNoteId.fromJson(dynamic json) =>
      AdminFinanceNoteId(json as String);
  String toJson() => value;
}

extension type const AdminFinanceAuditEventId(String value) implements String {
  factory AdminFinanceAuditEventId.fromJson(dynamic json) =>
      AdminFinanceAuditEventId(json as String);
  String toJson() => value;
}

extension type const AdminFinancePartnerId(String value) implements String {
  factory AdminFinancePartnerId.fromJson(dynamic json) =>
      AdminFinancePartnerId(json as String);
  String toJson() => value;
}

extension type const AdminFinanceCustomerId(String value) implements String {
  factory AdminFinanceCustomerId.fromJson(dynamic json) =>
      AdminFinanceCustomerId(json as String);
  String toJson() => value;
}

// ── Overview & KPI ──────────────────────────────────

/// Top-level overview data shown on the dashboard tab.
class AdminFinanceOverview {
  const AdminFinanceOverview({
    required this.grossVolume,
    required this.netRevenue,
    required this.platformFeeRevenue,
    required this.refundExposure,
    required this.failedPaymentAmount,
    required this.pendingPayoutAmount,
    required this.heldPayoutAmount,
    required this.unreconciledAmount,
    required this.currency,
  });

  final double grossVolume;
  final double netRevenue;
  final double platformFeeRevenue;
  final double refundExposure;
  final double failedPaymentAmount;
  final double pendingPayoutAmount;
  final double heldPayoutAmount;
  final double unreconciledAmount;
  final String currency;
}

/// Single KPI card data point.
class AdminFinanceKpi {
  const AdminFinanceKpi({
    required this.label,
    required this.value,
    required this.changePercent,
    required this.tone,
  });

  final String label;
  final double value;
  final double changePercent;
  final AdminFinanceRiskTone tone;
}

/// A data point in the trend chart.
class AdminFinanceTrendPoint {
  const AdminFinanceTrendPoint({
    required this.date,
    required this.grossAmount,
    required this.netAmount,
    required this.refundAmount,
    required this.payoutAmount,
  });

  final DateTime date;
  final double grossAmount;
  final double netAmount;
  final double refundAmount;
  final double payoutAmount;
}

/// Alert surfaced on the overview dashboard.
class AdminFinanceAlert {
  const AdminFinanceAlert({
    required this.id,
    required this.title,
    required this.description,
    required this.tone,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final AdminFinanceRiskTone tone;
  final DateTime createdAt;
}

// ── Transaction ─────────────────────────────────────

/// A single row in the admin ledger table.
class AdminFinanceTransactionRecord {
  const AdminFinanceTransactionRecord({
    required this.id,
    required this.createdAt,
    required this.reference,
    required this.partnerName,
    required this.customerName,
    required this.sourceType,
    required this.type,
    required this.grossAmount,
    required this.feeAmount,
    required this.netAmount,
    required this.currency,
    required this.transactionStatus,
    required this.settlementStatus,
    required this.payoutStatus,
    required this.provider,
    required this.isFlagged,
    required this.notesCount,
    this.payoutId,
  });

  final AdminFinanceTransactionId id;
  final DateTime createdAt;
  final String reference;
  final String partnerName;
  final String customerName;
  final AdminFinanceSourceType sourceType;
  final AdminFinanceTransactionType type;
  final double grossAmount;
  final double feeAmount;
  final double netAmount;
  final String currency;
  final AdminFinanceTransactionStatus transactionStatus;
  final AdminFinanceSettlementStatus settlementStatus;
  final AdminFinancePayoutStatus payoutStatus;
  final AdminFinanceProvider provider;
  final bool isFlagged;
  final int notesCount;
  final AdminFinancePayoutId? payoutId;
}

/// Detailed view of a single transaction.
class AdminFinanceTransactionDetail {
  const AdminFinanceTransactionDetail({
    required this.record,
    required this.providerEvents,
    required this.auditTrail,
    required this.notes,
    required this.relatedRefundCases,
  });

  final AdminFinanceTransactionRecord record;
  final List<AdminFinanceProviderEvent> providerEvents;
  final List<AdminFinanceAuditEvent> auditTrail;
  final List<AdminFinanceNote> notes;
  final List<AdminFinanceRefundCaseRecord> relatedRefundCases;
}

// ── Payout ──────────────────────────────────────────

/// A single row in the admin payouts table.
class AdminFinancePayoutRecord {
  const AdminFinancePayoutRecord({
    required this.id,
    required this.scheduledDate,
    required this.partnerName,
    required this.periodLabel,
    required this.includedVolume,
    required this.feesAndAdjustments,
    required this.netPayout,
    required this.currency,
    required this.method,
    required this.status,
    required this.attemptCount,
    required this.notesCount,
    this.failureReason,
    this.holdReason,
  });

  final AdminFinancePayoutId id;
  final DateTime scheduledDate;
  final String partnerName;
  final String periodLabel;
  final double includedVolume;
  final double feesAndAdjustments;
  final double netPayout;
  final String currency;
  final String method;
  final AdminFinancePayoutStatus status;
  final int attemptCount;
  final int notesCount;
  final String? failureReason;
  final String? holdReason;
}

/// Detailed view of a payout batch.
class AdminFinancePayoutDetail {
  const AdminFinancePayoutDetail({
    required this.record,
    required this.includedTransactions,
    required this.attempts,
    required this.maskedDestination,
    required this.auditTrail,
    required this.notes,
  });

  final AdminFinancePayoutRecord record;
  final List<AdminFinanceTransactionRecord> includedTransactions;
  final List<AdminFinancePayoutAttempt> attempts;
  final String maskedDestination;
  final List<AdminFinanceAuditEvent> auditTrail;
  final List<AdminFinanceNote> notes;
}

/// Represents a single payout attempt.
class AdminFinancePayoutAttempt {
  const AdminFinancePayoutAttempt({
    required this.attemptNumber,
    required this.attemptedAt,
    required this.status,
    this.failureReason,
  });

  final int attemptNumber;
  final DateTime attemptedAt;
  final String status;
  final String? failureReason;
}

// ── Refund Case ─────────────────────────────────────

/// A single row in the refund/dispute cases table.
class AdminFinanceRefundCaseRecord {
  const AdminFinanceRefundCaseRecord({
    required this.id,
    required this.requestedAt,
    required this.transactionId,
    required this.partnerName,
    required this.customerName,
    required this.caseType,
    required this.amount,
    required this.currency,
    required this.reason,
    required this.owner,
    required this.status,
    required this.slaHours,
    required this.slaBreached,
    required this.riskTone,
  });

  final AdminFinanceRefundCaseId id;
  final DateTime requestedAt;
  final AdminFinanceTransactionId transactionId;
  final String partnerName;
  final String customerName;
  final AdminFinanceRefundCaseType caseType;
  final double amount;
  final String currency;
  final String reason;
  final String owner;
  final AdminFinanceRefundCaseStatus status;
  final int slaHours;
  final bool slaBreached;
  final AdminFinanceRiskTone riskTone;
}

/// Detailed view of a refund case.
class AdminFinanceRefundCaseDetail {
  const AdminFinanceRefundCaseDetail({
    required this.record,
    required this.customerRequest,
    required this.partnerResponse,
    required this.evidenceLinks,
    required this.decisionNote,
    required this.auditTrail,
    required this.notes,
  });

  final AdminFinanceRefundCaseRecord record;
  final String customerRequest;
  final String partnerResponse;
  final List<String> evidenceLinks;
  final String decisionNote;
  final List<AdminFinanceAuditEvent> auditTrail;
  final List<AdminFinanceNote> notes;
}

// ── Reconciliation ──────────────────────────────────

/// A single row in the reconciliation exceptions table.
class AdminFinanceReconciliationException {
  const AdminFinanceReconciliationException({
    required this.id,
    required this.detectedAt,
    required this.provider,
    required this.providerEventId,
    required this.relatedTransactionId,
    required this.expectedAmount,
    required this.providerAmount,
    required this.difference,
    required this.currency,
    required this.type,
    required this.status,
    required this.owner,
    required this.summary,
  });

  final AdminFinanceReconciliationId id;
  final DateTime detectedAt;
  final AdminFinanceProvider provider;
  final String providerEventId;
  final AdminFinanceTransactionId? relatedTransactionId;
  final double expectedAmount;
  final double providerAmount;
  final double difference;
  final String currency;
  final AdminFinanceReconciliationType type;
  final AdminFinanceReconciliationStatus status;
  final String owner;
  final String summary;
}

/// Detailed view of a reconciliation exception.
class AdminFinanceReconciliationDetail {
  const AdminFinanceReconciliationDetail({
    required this.exception,
    required this.providerEventContext,
    required this.ledgerContext,
    required this.resolutionNotes,
    required this.auditTrail,
    required this.notes,
  });

  final AdminFinanceReconciliationException exception;
  final String providerEventContext;
  final String ledgerContext;
  final String resolutionNotes;
  final List<AdminFinanceAuditEvent> auditTrail;
  final List<AdminFinanceNote> notes;
}

// ── Partner Exposure ────────────────────────────────

/// Ranks financial risk by partner.
class AdminFinancePartnerExposure {
  const AdminFinancePartnerExposure({
    required this.partnerId,
    required this.partnerName,
    required this.totalVolume,
    required this.pendingPayouts,
    required this.refundExposure,
    required this.failedPayments,
    required this.heldFunds,
    required this.currency,
    required this.riskTone,
  });

  final AdminFinancePartnerId partnerId;
  final String partnerName;
  final double totalVolume;
  final double pendingPayouts;
  final double refundExposure;
  final double failedPayments;
  final double heldFunds;
  final String currency;
  final AdminFinanceRiskTone riskTone;
}

// ── Export Job ───────────────────────────────────────

/// A single row in the export jobs table.
class AdminFinanceExportJob {
  const AdminFinanceExportJob({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.requestedBy,
    required this.status,
    required this.rowCount,
    this.downloadUrl,
    this.expiresAt,
  });

  final AdminFinanceExportId id;
  final DateTime createdAt;
  final AdminFinanceExportType type;
  final String requestedBy;
  final AdminFinanceExportStatus status;
  final int rowCount;
  final String? downloadUrl;
  final DateTime? expiresAt;
}

// ── Shared detail components ────────────────────────

/// A single event logged by the payment provider.
class AdminFinanceProviderEvent {
  const AdminFinanceProviderEvent({
    required this.id,
    required this.eventType,
    required this.provider,
    required this.occurredAt,
    required this.detail,
    required this.rawPayload,
  });

  final String id;
  final String eventType;
  final AdminFinanceProvider provider;
  final DateTime occurredAt;
  final String detail;
  final String rawPayload;
}

/// An entry in the audit trail timeline.
class AdminFinanceAuditEvent {
  const AdminFinanceAuditEvent({
    required this.id,
    required this.label,
    required this.detail,
    required this.performedBy,
    required this.occurredAt,
    this.isError = false,
  });

  final AdminFinanceAuditEventId id;
  final String label;
  final String detail;
  final String performedBy;
  final DateTime occurredAt;
  final bool isError;
}

/// A note attached to a finance entity.
class AdminFinanceNote {
  const AdminFinanceNote({
    required this.id,
    required this.content,
    required this.createdBy,
    required this.createdAt,
  });

  final AdminFinanceNoteId id;
  final String content;
  final String createdBy;
  final DateTime createdAt;
}
