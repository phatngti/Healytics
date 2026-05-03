import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';

/// Sentinel object used by [AdminFinanceFilter.copyWith]
/// to distinguish "set field to null" from "leave unchanged".
const _noValue = Object();

/// Filter model for the admin finance manager workspace.
///
/// Supports nullable-clear via the `_noValue` sentinel
/// so callers can explicitly reset individual fields.
class AdminFinanceFilter {
  const AdminFinanceFilter({
    this.searchQuery = '',
    this.startDate,
    this.endDate,
    this.partnerId,
    this.customerId,
    this.sourceType,
    this.transactionType,
    this.transactionStatus,
    this.settlementStatus,
    this.payoutStatus,
    this.refundCaseStatus,
    this.refundCaseType,
    this.reconciliationStatus,
    this.provider,
    this.currency,
    this.minAmount,
    this.maxAmount,
    this.onlyFlagged = false,
    this.onlySlaBreached = false,
  });

  final String searchQuery;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? partnerId;
  final String? customerId;
  final AdminFinanceSourceType? sourceType;
  final AdminFinanceTransactionType? transactionType;
  final AdminFinanceTransactionStatus? transactionStatus;
  final AdminFinanceSettlementStatus? settlementStatus;
  final AdminFinancePayoutStatus? payoutStatus;
  final AdminFinanceRefundCaseStatus? refundCaseStatus;
  final AdminFinanceRefundCaseType? refundCaseType;
  final AdminFinanceReconciliationStatus?
      reconciliationStatus;
  final AdminFinanceProvider? provider;
  final String? currency;
  final double? minAmount;
  final double? maxAmount;
  final bool onlyFlagged;
  final bool onlySlaBreached;

  /// Returns `true` when any filter deviates from the
  /// default (empty) state.
  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      startDate != null ||
      endDate != null ||
      partnerId != null ||
      customerId != null ||
      sourceType != null ||
      transactionType != null ||
      transactionStatus != null ||
      settlementStatus != null ||
      payoutStatus != null ||
      refundCaseStatus != null ||
      refundCaseType != null ||
      reconciliationStatus != null ||
      provider != null ||
      currency != null ||
      minAmount != null ||
      maxAmount != null ||
      onlyFlagged ||
      onlySlaBreached;

  /// Creates a copy with modified fields. Pass the
  /// `_noValue` sentinel via named parameters to clear
  /// nullable fields.
  AdminFinanceFilter copyWith({
    String? searchQuery,
    Object? startDate = _noValue,
    Object? endDate = _noValue,
    Object? partnerId = _noValue,
    Object? customerId = _noValue,
    Object? sourceType = _noValue,
    Object? transactionType = _noValue,
    Object? transactionStatus = _noValue,
    Object? settlementStatus = _noValue,
    Object? payoutStatus = _noValue,
    Object? refundCaseStatus = _noValue,
    Object? refundCaseType = _noValue,
    Object? reconciliationStatus = _noValue,
    Object? provider = _noValue,
    Object? currency = _noValue,
    Object? minAmount = _noValue,
    Object? maxAmount = _noValue,
    bool? onlyFlagged,
    bool? onlySlaBreached,
  }) {
    return AdminFinanceFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      startDate: startDate == _noValue
          ? this.startDate
          : startDate as DateTime?,
      endDate: endDate == _noValue
          ? this.endDate
          : endDate as DateTime?,
      partnerId: partnerId == _noValue
          ? this.partnerId
          : partnerId as String?,
      customerId: customerId == _noValue
          ? this.customerId
          : customerId as String?,
      sourceType: sourceType == _noValue
          ? this.sourceType
          : sourceType as AdminFinanceSourceType?,
      transactionType: transactionType == _noValue
          ? this.transactionType
          : transactionType as AdminFinanceTransactionType?,
      transactionStatus: transactionStatus == _noValue
          ? this.transactionStatus
          : transactionStatus
              as AdminFinanceTransactionStatus?,
      settlementStatus: settlementStatus == _noValue
          ? this.settlementStatus
          : settlementStatus
              as AdminFinanceSettlementStatus?,
      payoutStatus: payoutStatus == _noValue
          ? this.payoutStatus
          : payoutStatus as AdminFinancePayoutStatus?,
      refundCaseStatus: refundCaseStatus == _noValue
          ? this.refundCaseStatus
          : refundCaseStatus
              as AdminFinanceRefundCaseStatus?,
      refundCaseType: refundCaseType == _noValue
          ? this.refundCaseType
          : refundCaseType as AdminFinanceRefundCaseType?,
      reconciliationStatus: reconciliationStatus ==
              _noValue
          ? this.reconciliationStatus
          : reconciliationStatus
              as AdminFinanceReconciliationStatus?,
      provider: provider == _noValue
          ? this.provider
          : provider as AdminFinanceProvider?,
      currency: currency == _noValue
          ? this.currency
          : currency as String?,
      minAmount: minAmount == _noValue
          ? this.minAmount
          : minAmount as double?,
      maxAmount: maxAmount == _noValue
          ? this.maxAmount
          : maxAmount as double?,
      onlyFlagged: onlyFlagged ?? this.onlyFlagged,
      onlySlaBreached:
          onlySlaBreached ?? this.onlySlaBreached,
    );
  }
}
