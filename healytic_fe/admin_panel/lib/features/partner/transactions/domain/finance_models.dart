import 'package:flutter/foundation.dart';

enum FinancePeriod {
  sevenDays,
  thirtyDays,
  ninetyDays;

  String get label => switch (this) {
    FinancePeriod.sevenDays => '7D',
    FinancePeriod.thirtyDays => '30D',
    FinancePeriod.ninetyDays => '90D',
  };

  int get days => switch (this) {
    FinancePeriod.sevenDays => 7,
    FinancePeriod.thirtyDays => 30,
    FinancePeriod.ninetyDays => 90,
  };
}

enum FinanceMetric {
  gross,
  net,
  refunds;

  String get label => switch (this) {
    FinanceMetric.gross => 'Gross',
    FinanceMetric.net => 'Net',
    FinanceMetric.refunds => 'Refunds',
  };
}

enum FinanceWorkspaceTab {
  transactions,
  payouts,
  refunds;

  String get label => switch (this) {
    FinanceWorkspaceTab.transactions => 'Transactions',
    FinanceWorkspaceTab.payouts => 'Payouts',
    FinanceWorkspaceTab.refunds => 'Refunds & Disputes',
  };
}

enum CommerceSourceType {
  serviceBooking,
  productOrder;

  String get label => switch (this) {
    CommerceSourceType.serviceBooking => 'Service Booking',
    CommerceSourceType.productOrder => 'Product Order',
  };
}

enum TransactionType {
  charge,
  refund,
  adjustment,
  payout,
  fee;

  String get label => switch (this) {
    TransactionType.charge => 'Charge',
    TransactionType.refund => 'Refund',
    TransactionType.adjustment => 'Adjustment',
    TransactionType.payout => 'Payout',
    TransactionType.fee => 'Fee',
  };
}

enum TransactionStatus {
  pending,
  paid,
  refunded,
  failed,
  canceled;

  String get label => switch (this) {
    TransactionStatus.pending => 'Pending',
    TransactionStatus.paid => 'Paid',
    TransactionStatus.refunded => 'Refunded',
    TransactionStatus.failed => 'Failed',
    TransactionStatus.canceled => 'Canceled',
  };
}

enum SettlementStatus {
  unsettled,
  scheduled,
  settled,
  held;

  String get label => switch (this) {
    SettlementStatus.unsettled => 'Unsettled',
    SettlementStatus.scheduled => 'Scheduled',
    SettlementStatus.settled => 'Settled',
    SettlementStatus.held => 'Held',
  };
}

enum PayoutStatus {
  notAssigned,
  inPayout,
  paidOut,
  failed;

  String get label => switch (this) {
    PayoutStatus.notAssigned => 'Not Assigned',
    PayoutStatus.inPayout => 'In Payout',
    PayoutStatus.paidOut => 'Paid Out',
    PayoutStatus.failed => 'Failed',
  };
}

enum RefundCaseStatus {
  pending,
  underReview,
  approved,
  rejected;

  String get label => switch (this) {
    RefundCaseStatus.pending => 'Pending',
    RefundCaseStatus.underReview => 'Under Review',
    RefundCaseStatus.approved => 'Approved',
    RefundCaseStatus.rejected => 'Rejected',
  };
}

enum RefundCaseType {
  refund,
  dispute;

  String get label => switch (this) {
    RefundCaseType.refund => 'Refund',
    RefundCaseType.dispute => 'Dispute',
  };
}

extension type const TransactionRecordId(String value) implements String {
  factory TransactionRecordId.fromJson(dynamic json) =>
      TransactionRecordId(json as String);
}

extension type const PayoutRecordId(String value) implements String {
  factory PayoutRecordId.fromJson(dynamic json) =>
      PayoutRecordId(json as String);
}

extension type const RefundCaseRecordId(String value) implements String {
  factory RefundCaseRecordId.fromJson(dynamic json) =>
      RefundCaseRecordId(json as String);
}

class FinanceFilter {
  const FinanceFilter({
    this.searchQuery = '',
    this.startDate,
    this.endDate,
    this.sourceType,
    this.transactionType,
    this.transactionStatus,
    this.settlementStatus,
    this.payoutStatus,
    this.currency,
  });

  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final CommerceSourceType? sourceType;
  final TransactionType? transactionType;
  final TransactionStatus? transactionStatus;
  final SettlementStatus? settlementStatus;
  final PayoutStatus? payoutStatus;
  final String? currency;

  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      startDate != null ||
      endDate != null ||
      sourceType != null ||
      transactionType != null ||
      transactionStatus != null ||
      settlementStatus != null ||
      payoutStatus != null ||
      currency != null;

  FinanceFilter copyWith({
    String? searchQuery,
    Object? startDate = _noValue,
    Object? endDate = _noValue,
    Object? sourceType = _noValue,
    Object? transactionType = _noValue,
    Object? transactionStatus = _noValue,
    Object? settlementStatus = _noValue,
    Object? payoutStatus = _noValue,
    Object? currency = _noValue,
  }) {
    return FinanceFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate == _noValue
          ? this.startDate
          : startDate as DateTime?,
      endDate: endDate == _noValue ? this.endDate : endDate as DateTime?,
      sourceType: sourceType == _noValue
          ? this.sourceType
          : sourceType as CommerceSourceType?,
      transactionType: transactionType == _noValue
          ? this.transactionType
          : transactionType as TransactionType?,
      transactionStatus: transactionStatus == _noValue
          ? this.transactionStatus
          : transactionStatus as TransactionStatus?,
      settlementStatus: settlementStatus == _noValue
          ? this.settlementStatus
          : settlementStatus as SettlementStatus?,
      payoutStatus: payoutStatus == _noValue
          ? this.payoutStatus
          : payoutStatus as PayoutStatus?,
      currency: currency == _noValue ? this.currency : currency as String?,
    );
  }
}

class TransactionTimelineEvent {
  const TransactionTimelineEvent({
    required this.title,
    required this.description,
    required this.occurredAt,
  });

  final String title;
  final String description;
  final DateTime occurredAt;
}

@immutable
class TransactionRecord {
  const TransactionRecord({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.sourceType,
    required this.reference,
    required this.customerName,
    required this.grossAmount,
    required this.feeAmount,
    required this.currency,
    required this.status,
    required this.settlementStatus,
    required this.payoutStatus,
    required this.paymentMethod,
    required this.sourceTitle,
    required this.sourceSubtitle,
    required this.timeline,
    this.flaggedForReview = false,
    this.notes,
    this.payoutId,
  });

  final TransactionRecordId id;
  final DateTime createdAt;
  final TransactionType type;
  final CommerceSourceType sourceType;
  final String reference;
  final String customerName;
  final double grossAmount;
  final double feeAmount;
  final String currency;
  final TransactionStatus status;
  final SettlementStatus settlementStatus;
  final PayoutStatus payoutStatus;
  final String paymentMethod;
  final String sourceTitle;
  final String sourceSubtitle;
  final List<TransactionTimelineEvent> timeline;
  final bool flaggedForReview;
  final String? notes;
  final PayoutRecordId? payoutId;

  double get netAmount => grossAmount - feeAmount;

  TransactionRecord copyWith({
    DateTime? createdAt,
    TransactionType? type,
    CommerceSourceType? sourceType,
    String? reference,
    String? customerName,
    double? grossAmount,
    double? feeAmount,
    String? currency,
    TransactionStatus? status,
    SettlementStatus? settlementStatus,
    PayoutStatus? payoutStatus,
    String? paymentMethod,
    String? sourceTitle,
    String? sourceSubtitle,
    List<TransactionTimelineEvent>? timeline,
    bool? flaggedForReview,
    Object? notes = _noValue,
    Object? payoutId = _noValue,
  }) {
    return TransactionRecord(
      id: id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      sourceType: sourceType ?? this.sourceType,
      reference: reference ?? this.reference,
      customerName: customerName ?? this.customerName,
      grossAmount: grossAmount ?? this.grossAmount,
      feeAmount: feeAmount ?? this.feeAmount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      settlementStatus: settlementStatus ?? this.settlementStatus,
      payoutStatus: payoutStatus ?? this.payoutStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      sourceTitle: sourceTitle ?? this.sourceTitle,
      sourceSubtitle: sourceSubtitle ?? this.sourceSubtitle,
      timeline: timeline ?? this.timeline,
      flaggedForReview: flaggedForReview ?? this.flaggedForReview,
      notes: notes == _noValue ? this.notes : notes as String?,
      payoutId: payoutId == _noValue
          ? this.payoutId
          : payoutId as PayoutRecordId?,
    );
  }
}

@immutable
class PayoutRecord {
  const PayoutRecord({
    required this.id,
    required this.periodLabel,
    required this.includedVolume,
    required this.feesAdjustments,
    required this.netPayout,
    required this.scheduledDate,
    required this.method,
    required this.status,
    required this.currency,
    required this.includedTransactionIds,
  });

  final PayoutRecordId id;
  final String periodLabel;
  final double includedVolume;
  final double feesAdjustments;
  final double netPayout;
  final DateTime scheduledDate;
  final String method;
  final PayoutStatus status;
  final String currency;
  final List<TransactionRecordId> includedTransactionIds;

  PayoutRecord copyWith({
    String? periodLabel,
    double? includedVolume,
    double? feesAdjustments,
    double? netPayout,
    DateTime? scheduledDate,
    String? method,
    PayoutStatus? status,
    String? currency,
    List<TransactionRecordId>? includedTransactionIds,
  }) {
    return PayoutRecord(
      id: id,
      periodLabel: periodLabel ?? this.periodLabel,
      includedVolume: includedVolume ?? this.includedVolume,
      feesAdjustments: feesAdjustments ?? this.feesAdjustments,
      netPayout: netPayout ?? this.netPayout,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      method: method ?? this.method,
      status: status ?? this.status,
      currency: currency ?? this.currency,
      includedTransactionIds:
          includedTransactionIds ?? this.includedTransactionIds,
    );
  }
}

@immutable
class RefundCaseRecord {
  const RefundCaseRecord({
    required this.id,
    required this.transactionId,
    required this.caseType,
    required this.requestedAt,
    required this.amount,
    required this.currency,
    required this.reason,
    required this.owner,
    required this.status,
    required this.slaHours,
  });

  final RefundCaseRecordId id;
  final TransactionRecordId transactionId;
  final RefundCaseType caseType;
  final DateTime requestedAt;
  final double amount;
  final String currency;
  final String reason;
  final String owner;
  final RefundCaseStatus status;
  final int slaHours;

  RefundCaseRecord copyWith({
    RefundCaseType? caseType,
    DateTime? requestedAt,
    double? amount,
    String? currency,
    String? reason,
    String? owner,
    RefundCaseStatus? status,
    int? slaHours,
  }) {
    return RefundCaseRecord(
      id: id,
      transactionId: transactionId,
      caseType: caseType ?? this.caseType,
      requestedAt: requestedAt ?? this.requestedAt,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      reason: reason ?? this.reason,
      owner: owner ?? this.owner,
      status: status ?? this.status,
      slaHours: slaHours ?? this.slaHours,
    );
  }
}

@immutable
class FinanceSummary {
  const FinanceSummary({
    required this.grossVolume,
    required this.netSettled,
    required this.pendingPayout,
    required this.refundExposure,
    required this.availableBalance,
    required this.pendingBalance,
    required this.currency,
    this.nextPayoutAt,
    this.payoutMethod,
    this.payoutStatus,
  });

  final double grossVolume;
  final double netSettled;
  final double pendingPayout;
  final double refundExposure;
  final double availableBalance;
  final double pendingBalance;
  final String currency;
  final DateTime? nextPayoutAt;
  final String? payoutMethod;
  final PayoutStatus? payoutStatus;
}

@immutable
class FinanceTrendPoint {
  const FinanceTrendPoint({
    required this.date,
    required this.grossAmount,
    required this.netAmount,
    required this.refundAmount,
  });

  final DateTime date;
  final double grossAmount;
  final double netAmount;
  final double refundAmount;
}

@immutable
class TransactionDetail {
  const TransactionDetail({
    required this.record,
    required this.relatedRefundCases,
    required this.sourceSummaryTitle,
    required this.sourceSummarySubtitle,
    this.payoutRecord,
  });

  final TransactionRecord record;
  final PayoutRecord? payoutRecord;
  final List<RefundCaseRecord> relatedRefundCases;
  final String sourceSummaryTitle;
  final String sourceSummarySubtitle;
}

const Object _noValue = Object();
