import 'dart:collection';

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/features/partner/transactions/data/data/transaction_mock_data.dart';
import 'package:admin_panel/features/partner/transactions/data/transactions_real.datasource.dart';
import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class TransactionsRemoteDataSource {
  Future<FinanceSummary> getFinanceSummary(
    FinanceFilter filter,
    FinancePeriod period,
  );

  Future<List<FinanceTrendPoint>> getFinanceTrend(
    FinanceFilter filter,
    FinancePeriod period,
  );

  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  });

  Future<List<PayoutRecord>> getPayouts({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  });

  Future<List<RefundCaseRecord>> getRefundCases({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  });

  Future<TransactionDetail> getTransactionById(TransactionRecordId id);

  Future<void> markTransactionSettled(TransactionRecordId id);

  Future<void> flagTransactionForReview(TransactionRecordId id);

  Future<void> approveRefundCase(String caseId);

  Future<void> rejectRefundCase(String caseId);

  Future<void> retryPayout(String payoutId);
}

// ============================================================
// 3. MOCK IMPLEMENTATION
// ============================================================

/// Mock data source for development and testing.
/// Uses synthetic data built from
/// [TransactionMockData].
class TransactionsRemoteDataSourceMock
    implements TransactionsRemoteDataSource {
  TransactionsRemoteDataSourceMock();

  final List<TransactionRecord> _transactions =
      TransactionMockData.buildTransactions();
  final List<PayoutRecord> _payouts = TransactionMockData.buildPayouts();
  final List<RefundCaseRecord> _refundCases =
      TransactionMockData.buildRefundCases();

  DateTime get _anchorDate => TransactionMockData.anchorDate;

  @override
  Future<FinanceSummary> getFinanceSummary(
    FinanceFilter filter,
    FinancePeriod period,
  ) async {
    final transactions = _filteredTransactions(filter, period);
    final refundCases = _filteredRefundCases(filter, period);

    final grossVolume = transactions.fold<double>(
      0,
      (total, item) => item.type == TransactionType.charge
          ? total + item.grossAmount
          : total,
    );
    final netSettled = transactions.fold<double>(
      0,
      (total, item) => item.settlementStatus == SettlementStatus.settled
          ? total + item.netAmount
          : total,
    );
    final pendingPayout = transactions.fold<double>(
      0,
      (total, item) =>
          item.payoutStatus == PayoutStatus.notAssigned ||
              item.payoutStatus == PayoutStatus.inPayout
          ? total + item.netAmount
          : total,
    );
    final refundExposure = refundCases.fold<double>(
      0,
      (total, item) =>
          item.status == RefundCaseStatus.approved ||
              item.status == RefundCaseStatus.rejected
          ? total
          : total + item.amount,
    );

    final nextPayout =
        _filteredPayouts(filter, period)
            .where(
              (item) =>
                  item.status == PayoutStatus.inPayout ||
                  item.status == PayoutStatus.notAssigned ||
                  item.status == PayoutStatus.failed,
            )
            .toList()
          ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));

    return FinanceSummary(
      grossVolume: grossVolume,
      netSettled: netSettled,
      pendingPayout: pendingPayout,
      refundExposure: refundExposure,
      availableBalance: netSettled - refundExposure,
      pendingBalance: pendingPayout,
      currency: filter.currency ?? 'VND',
      nextPayoutAt: nextPayout.isEmpty ? null : nextPayout.first.scheduledDate,
      payoutMethod: nextPayout.isEmpty
          ? 'Primary settlement account'
          : nextPayout.first.method,
      payoutStatus: nextPayout.isEmpty
          ? PayoutStatus.paidOut
          : nextPayout.first.status,
    );
  }

  @override
  Future<List<FinanceTrendPoint>> getFinanceTrend(
    FinanceFilter filter,
    FinancePeriod period,
  ) async {
    final grouped = SplayTreeMap<DateTime, FinanceTrendPoint>(
      (a, b) => a.compareTo(b),
    );
    final transactions = _filteredTransactions(filter, period);

    for (final transaction in transactions) {
      final date = DateTime(
        transaction.createdAt.year,
        transaction.createdAt.month,
        transaction.createdAt.day,
      );
      final previous = grouped[date];
      grouped[date] = FinanceTrendPoint(
        date: date,
        grossAmount:
            (previous?.grossAmount ?? 0) +
            (transaction.type == TransactionType.charge
                ? transaction.grossAmount
                : 0),
        netAmount: (previous?.netAmount ?? 0) + transaction.netAmount,
        refundAmount:
            (previous?.refundAmount ?? 0) +
            (transaction.type == TransactionType.refund
                ? transaction.grossAmount
                : 0),
      );
    }

    return grouped.values.toList();
  }

  @override
  Future<List<TransactionRecord>> getTransactions({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) async {
    final transactions = _filteredTransactions(
      filter,
      FinancePeriod.ninetyDays,
    );
    return _paginate(transactions, startingAt, count);
  }

  @override
  Future<List<PayoutRecord>> getPayouts({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) async {
    final payouts = _filteredPayouts(filter, FinancePeriod.ninetyDays);
    return _paginate(payouts, startingAt, count);
  }

  @override
  Future<List<RefundCaseRecord>> getRefundCases({
    required int startingAt,
    required int count,
    required FinanceFilter filter,
  }) async {
    final refundCases = _filteredRefundCases(filter, FinancePeriod.ninetyDays);
    return _paginate(refundCases, startingAt, count);
  }

  @override
  Future<TransactionDetail> getTransactionById(TransactionRecordId id) async {
    final record = _transactions.firstWhere((item) => item.id == id);
    final payout = record.payoutId == null
        ? null
        : _payouts.where((item) => item.id == record.payoutId).isEmpty
        ? null
        : _payouts.firstWhere((item) => item.id == record.payoutId);
    final refunds = _refundCases
        .where((item) => item.transactionId == id)
        .toList();

    return TransactionDetail(
      record: record,
      payoutRecord: payout,
      relatedRefundCases: refunds,
      sourceSummaryTitle: record.sourceTitle,
      sourceSummarySubtitle: record.sourceSubtitle,
    );
  }

  @override
  Future<void> markTransactionSettled(TransactionRecordId id) async {
    final index = _transactions.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final transaction = _transactions[index];
    _transactions[index] = transaction.copyWith(
      settlementStatus: SettlementStatus.settled,
      payoutStatus: transaction.payoutStatus == PayoutStatus.notAssigned
          ? PayoutStatus.inPayout
          : transaction.payoutStatus,
      timeline: [
        ...transaction.timeline,
        TransactionTimelineEvent(
          title: 'Marked settled',
          description: 'Finance manager moved this record to settled.',
          occurredAt: _anchorDate,
        ),
      ],
    );
  }

  @override
  Future<void> flagTransactionForReview(TransactionRecordId id) async {
    final index = _transactions.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final transaction = _transactions[index];
    _transactions[index] = transaction.copyWith(
      flaggedForReview: true,
      notes: 'Flagged for finance review.',
      timeline: [
        ...transaction.timeline,
        TransactionTimelineEvent(
          title: 'Flagged for review',
          description: 'Record requires manual finance follow-up.',
          occurredAt: _anchorDate,
        ),
      ],
    );
  }

  @override
  Future<void> approveRefundCase(String caseId) async {
    final index = _refundCases.indexWhere((item) => item.id.value == caseId);
    if (index == -1) return;

    final refund = _refundCases[index];
    _refundCases[index] = refund.copyWith(status: RefundCaseStatus.approved);

    final transactionIndex = _transactions.indexWhere(
      (item) => item.id == refund.transactionId,
    );
    if (transactionIndex != -1) {
      final transaction = _transactions[transactionIndex];
      _transactions[transactionIndex] = transaction.copyWith(
        status: TransactionStatus.refunded,
        settlementStatus: SettlementStatus.held,
        timeline: [
          ...transaction.timeline,
          TransactionTimelineEvent(
            title: 'Refund approved',
            description:
                'Associated refund case ${refund.id.value} was approved.',
            occurredAt: _anchorDate,
          ),
        ],
      );
    }
  }

  @override
  Future<void> rejectRefundCase(String caseId) async {
    final index = _refundCases.indexWhere((item) => item.id.value == caseId);
    if (index == -1) return;

    final refund = _refundCases[index];
    _refundCases[index] = refund.copyWith(status: RefundCaseStatus.rejected);
  }

  @override
  Future<void> retryPayout(String payoutId) async {
    final index = _payouts.indexWhere((item) => item.id.value == payoutId);
    if (index == -1) return;

    final payout = _payouts[index];
    _payouts[index] = payout.copyWith(
      status: PayoutStatus.inPayout,
      scheduledDate: _anchorDate.add(const Duration(days: 1)),
    );
  }

  List<TransactionRecord> _filteredTransactions(
    FinanceFilter filter,
    FinancePeriod period,
  ) {
    final cutoff = _anchorDate.subtract(Duration(days: period.days));
    final query = filter.searchQuery.trim().toLowerCase();

    final filtered = _transactions.where((item) {
      if (item.createdAt.isBefore(cutoff)) return false;
      if (filter.startDate != null &&
          item.createdAt.isBefore(_startOfDay(filter.startDate!))) {
        return false;
      }
      if (filter.endDate != null &&
          item.createdAt.isAfter(_endOfDay(filter.endDate!))) {
        return false;
      }
      if (filter.sourceType != null && item.sourceType != filter.sourceType) {
        return false;
      }
      if (filter.transactionType != null &&
          item.type != filter.transactionType) {
        return false;
      }
      if (filter.transactionStatus != null &&
          item.status != filter.transactionStatus) {
        return false;
      }
      if (filter.settlementStatus != null &&
          item.settlementStatus != filter.settlementStatus) {
        return false;
      }
      if (filter.payoutStatus != null &&
          item.payoutStatus != filter.payoutStatus) {
        return false;
      }
      if (filter.currency != null && item.currency != filter.currency) {
        return false;
      }
      if (query.isEmpty) return true;

      return item.id.value.toLowerCase().contains(query) ||
          item.reference.toLowerCase().contains(query) ||
          item.customerName.toLowerCase().contains(query) ||
          item.sourceTitle.toLowerCase().contains(query);
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return filtered;
  }

  List<PayoutRecord> _filteredPayouts(
    FinanceFilter filter,
    FinancePeriod period,
  ) {
    final cutoff = _anchorDate.subtract(Duration(days: period.days));
    final query = filter.searchQuery.trim().toLowerCase();

    final filtered = _payouts.where((item) {
      if (item.scheduledDate.isBefore(cutoff)) return false;
      if (filter.startDate != null &&
          item.scheduledDate.isBefore(_startOfDay(filter.startDate!))) {
        return false;
      }
      if (filter.endDate != null &&
          item.scheduledDate.isAfter(_endOfDay(filter.endDate!))) {
        return false;
      }
      if (filter.payoutStatus != null && item.status != filter.payoutStatus) {
        return false;
      }
      if (filter.currency != null && item.currency != filter.currency) {
        return false;
      }
      if (query.isEmpty) return true;
      return item.id.value.toLowerCase().contains(query) ||
          item.method.toLowerCase().contains(query) ||
          item.periodLabel.toLowerCase().contains(query);
    }).toList()..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));

    return filtered;
  }

  List<RefundCaseRecord> _filteredRefundCases(
    FinanceFilter filter,
    FinancePeriod period,
  ) {
    final cutoff = _anchorDate.subtract(Duration(days: period.days));
    final query = filter.searchQuery.trim().toLowerCase();

    final filtered = _refundCases.where((item) {
      if (item.requestedAt.isBefore(cutoff)) return false;
      if (filter.startDate != null &&
          item.requestedAt.isBefore(_startOfDay(filter.startDate!))) {
        return false;
      }
      if (filter.endDate != null &&
          item.requestedAt.isAfter(_endOfDay(filter.endDate!))) {
        return false;
      }
      if (filter.currency != null && item.currency != filter.currency) {
        return false;
      }
      if (query.isEmpty) return true;
      return item.id.value.toLowerCase().contains(query) ||
          item.reason.toLowerCase().contains(query) ||
          item.owner.toLowerCase().contains(query) ||
          item.transactionId.value.toLowerCase().contains(query);
    }).toList()..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));

    return filtered;
  }

  List<T> _paginate<T>(List<T> items, int startingAt, int count) {
    if (startingAt >= items.length) return [];
    final end = startingAt + count > items.length
        ? items.length
        : startingAt + count;
    return items.sublist(startingAt, end);
  }

  DateTime _startOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  DateTime _endOfDay(DateTime value) =>
      DateTime(value.year, value.month, value.day, 23, 59, 59);
}

// ============================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================

/// Provides the correct data source based on the
/// mock flag in persistent storage.
final transactionsRemoteDataSourceProvider =
    Provider<TransactionsRemoteDataSource>((ref) {
  final isMock =
      Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return TransactionsRemoteDataSourceMock();
  }
  final apiService =
      ref.read(apiServiceProvider);
  return TransactionsRemoteDataSourceImpl(
    apiService: apiService,
  );
});
