import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/finance_manager/datasource/data/admin_finance_mock_data.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ────────────────────────────────────────────────────
// 1. Abstract Interface
// ────────────────────────────────────────────────────

/// Contract for admin finance data access.
abstract class AdminFinanceRemoteDataSource {
  // Overview
  Future<AdminFinanceOverview> getOverview(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinanceTrendPoint>> getTrend(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinanceAlert>> getAlerts(
    AdminFinancePeriod period,
  );

  // Transactions
  Future<int> getTransactionTotalRows(
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinanceTransactionRecord>>
      getTransactions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinanceTransactionDetail>
      getTransactionDetail(
    AdminFinanceTransactionId id,
  );

  // Payouts
  Future<int> getPayoutTotalRows(
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinancePayoutRecord>> getPayouts({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinancePayoutDetail> getPayoutDetail(
    AdminFinancePayoutId id,
  );

  // Refund Cases
  Future<int> getRefundCaseTotalRows(
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinanceRefundCaseRecord>>
      getRefundCases({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinanceRefundCaseDetail>
      getRefundCaseDetail(
    AdminFinanceRefundCaseId id,
  );

  // Reconciliation
  Future<int> getReconciliationTotalRows(
    AdminFinanceFilter filter,
  );

  Future<List<AdminFinanceReconciliationException>>
      getReconciliationExceptions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  });

  Future<AdminFinanceReconciliationDetail>
      getReconciliationDetail(
    AdminFinanceReconciliationId id,
  );

  // Partner Exposure
  Future<List<AdminFinancePartnerExposure>>
      getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  );

  // Exports
  Future<List<AdminFinanceExportJob>> getExports();

  // Actions
  Future<void> markSettlement(
    AdminFinanceTransactionId id,
    AdminFinanceSettlementStatus status, {
    required String note,
  });

  Future<void> flagTransaction(
    AdminFinanceTransactionId id, {
    required bool flagged,
    String? note,
  });

  Future<void> approveRefundCase(
    AdminFinanceRefundCaseId id, {
    String? note,
  });

  Future<void> rejectRefundCase(
    AdminFinanceRefundCaseId id, {
    required String note,
  });

  Future<void> retryPayout(
    AdminFinancePayoutId id, {
    String? note,
  });

  Future<void> holdPayout(
    AdminFinancePayoutId id, {
    required String note,
  });

  Future<void> releasePayoutHold(
    AdminFinancePayoutId id, {
    String? note,
  });

  Future<void> resolveReconciliation(
    AdminFinanceReconciliationId id, {
    required String note,
  });

  Future<void> reopenReconciliation(
    AdminFinanceReconciliationId id, {
    String? note,
  });

  Future<void> addNote({
    required String entityType,
    required String entityId,
    required String content,
  });

  Future<AdminFinanceExportJob> createExport(
    AdminFinanceExportType type,
  );
}

// ────────────────────────────────────────────────────
// 2. Implementation (real API – stub until OpenAPI)
// ────────────────────────────────────────────────────

/// Placeholder real implementation.
///
/// When the backend `AdminFinanceApi` is generated via
/// OpenAPI, replace every `throw UnimplementedError()`
/// with actual API calls and DTO-to-entity mapping.
class AdminFinanceRemoteDataSourceImpl
    implements AdminFinanceRemoteDataSource {
  AdminFinanceRemoteDataSourceImpl({
    required this.apiService,
  });

  final ApiService apiService;

  @override
  Future<AdminFinanceOverview> getOverview(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<List<AdminFinanceTrendPoint>> getTrend(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<List<AdminFinanceAlert>> getAlerts(
    AdminFinancePeriod period,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<int> getTransactionTotalRows(
    AdminFinanceFilter filter,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<List<AdminFinanceTransactionRecord>>
      getTransactions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) =>
          throw UnimplementedError(
            'Awaiting AdminFinanceApi generation',
          );

  @override
  Future<AdminFinanceTransactionDetail>
      getTransactionDetail(
    AdminFinanceTransactionId id,
  ) =>
          throw UnimplementedError(
            'Awaiting AdminFinanceApi generation',
          );

  @override
  Future<int> getPayoutTotalRows(
    AdminFinanceFilter filter,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<List<AdminFinancePayoutRecord>> getPayouts({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<AdminFinancePayoutDetail> getPayoutDetail(
    AdminFinancePayoutId id,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<int> getRefundCaseTotalRows(
    AdminFinanceFilter filter,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<List<AdminFinanceRefundCaseRecord>>
      getRefundCases({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) =>
          throw UnimplementedError(
            'Awaiting AdminFinanceApi generation',
          );

  @override
  Future<AdminFinanceRefundCaseDetail>
      getRefundCaseDetail(
    AdminFinanceRefundCaseId id,
  ) =>
          throw UnimplementedError(
            'Awaiting AdminFinanceApi generation',
          );

  @override
  Future<int> getReconciliationTotalRows(
    AdminFinanceFilter filter,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<List<AdminFinanceReconciliationException>>
      getReconciliationExceptions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) =>
          throw UnimplementedError(
            'Awaiting AdminFinanceApi generation',
          );

  @override
  Future<AdminFinanceReconciliationDetail>
      getReconciliationDetail(
    AdminFinanceReconciliationId id,
  ) =>
          throw UnimplementedError(
            'Awaiting AdminFinanceApi generation',
          );

  @override
  Future<List<AdminFinancePartnerExposure>>
      getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) =>
          throw UnimplementedError(
            'Awaiting AdminFinanceApi generation',
          );

  @override
  Future<List<AdminFinanceExportJob>> getExports() =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> markSettlement(
    AdminFinanceTransactionId id,
    AdminFinanceSettlementStatus status, {
    required String note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> flagTransaction(
    AdminFinanceTransactionId id, {
    required bool flagged,
    String? note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> approveRefundCase(
    AdminFinanceRefundCaseId id, {
    String? note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> rejectRefundCase(
    AdminFinanceRefundCaseId id, {
    required String note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> retryPayout(
    AdminFinancePayoutId id, {
    String? note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> holdPayout(
    AdminFinancePayoutId id, {
    required String note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> releasePayoutHold(
    AdminFinancePayoutId id, {
    String? note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> resolveReconciliation(
    AdminFinanceReconciliationId id, {
    required String note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> reopenReconciliation(
    AdminFinanceReconciliationId id, {
    String? note,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<void> addNote({
    required String entityType,
    required String entityId,
    required String content,
  }) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );

  @override
  Future<AdminFinanceExportJob> createExport(
    AdminFinanceExportType type,
  ) =>
      throw UnimplementedError(
        'Awaiting AdminFinanceApi generation',
      );
}

// ────────────────────────────────────────────────────
// 3. Mock (for development & testing)
// ────────────────────────────────────────────────────

class AdminFinanceRemoteDataSourceMock
    implements AdminFinanceRemoteDataSource {
  static const _delay = Duration(milliseconds: 250);

  // ── Overview ──────────────────────────────────────

  @override
  Future<AdminFinanceOverview> getOverview(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceOverview;
  }

  @override
  Future<List<AdminFinanceTrendPoint>> getTrend(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceTrend;
  }

  @override
  Future<List<AdminFinanceAlert>> getAlerts(
    AdminFinancePeriod period,
  ) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceAlerts;
  }

  // ── Transactions ──────────────────────────────────

  @override
  Future<int> getTransactionTotalRows(
    AdminFinanceFilter filter,
  ) async {
    final filtered = _filterTransactions(
      mockAdminFinanceTransactions,
      filter,
    );
    return filtered.length;
  }

  @override
  Future<List<AdminFinanceTransactionRecord>>
      getTransactions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterTransactions(
      mockAdminFinanceTransactions,
      filter,
    );
    final end = (startingAt + count).clamp(
      0,
      all.length,
    );
    return all.sublist(
      startingAt.clamp(0, all.length),
      end,
    );
  }

  @override
  Future<AdminFinanceTransactionDetail>
      getTransactionDetail(
    AdminFinanceTransactionId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockTransactionDetailFor(id);
  }

  // ── Payouts ───────────────────────────────────────

  @override
  Future<int> getPayoutTotalRows(
    AdminFinanceFilter filter,
  ) async {
    final filtered = _filterPayouts(
      mockAdminFinancePayouts,
      filter,
    );
    return filtered.length;
  }

  @override
  Future<List<AdminFinancePayoutRecord>> getPayouts({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterPayouts(
      mockAdminFinancePayouts,
      filter,
    );
    final end = (startingAt + count).clamp(
      0,
      all.length,
    );
    return all.sublist(
      startingAt.clamp(0, all.length),
      end,
    );
  }

  @override
  Future<AdminFinancePayoutDetail> getPayoutDetail(
    AdminFinancePayoutId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockPayoutDetailFor(id);
  }

  // ── Refund Cases ──────────────────────────────────

  @override
  Future<int> getRefundCaseTotalRows(
    AdminFinanceFilter filter,
  ) async {
    final filtered = _filterRefundCases(
      mockAdminFinanceRefundCases,
      filter,
    );
    return filtered.length;
  }

  @override
  Future<List<AdminFinanceRefundCaseRecord>>
      getRefundCases({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterRefundCases(
      mockAdminFinanceRefundCases,
      filter,
    );
    final end = (startingAt + count).clamp(
      0,
      all.length,
    );
    return all.sublist(
      startingAt.clamp(0, all.length),
      end,
    );
  }

  @override
  Future<AdminFinanceRefundCaseDetail>
      getRefundCaseDetail(
    AdminFinanceRefundCaseId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockRefundCaseDetailFor(id);
  }

  // ── Reconciliation ────────────────────────────────

  @override
  Future<int> getReconciliationTotalRows(
    AdminFinanceFilter filter,
  ) async {
    final filtered = _filterReconciliation(
      mockAdminFinanceReconciliationExceptions,
      filter,
    );
    return filtered.length;
  }

  @override
  Future<List<AdminFinanceReconciliationException>>
      getReconciliationExceptions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) async {
    await Future<void>.delayed(_delay);
    final all = _filterReconciliation(
      mockAdminFinanceReconciliationExceptions,
      filter,
    );
    final end = (startingAt + count).clamp(
      0,
      all.length,
    );
    return all.sublist(
      startingAt.clamp(0, all.length),
      end,
    );
  }

  @override
  Future<AdminFinanceReconciliationDetail>
      getReconciliationDetail(
    AdminFinanceReconciliationId id,
  ) async {
    await Future<void>.delayed(_delay);
    return mockReconciliationDetailFor(id);
  }

  // ── Partner Exposure ──────────────────────────────

  @override
  Future<List<AdminFinancePartnerExposure>>
      getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) async {
    await Future<void>.delayed(_delay);
    return mockAdminFinancePartnerExposure;
  }

  // ── Exports ───────────────────────────────────────

  @override
  Future<List<AdminFinanceExportJob>> getExports() async {
    await Future<void>.delayed(_delay);
    return mockAdminFinanceExports;
  }

  // ── Mock Actions ──────────────────────────────────

  @override
  Future<void> markSettlement(
    AdminFinanceTransactionId id,
    AdminFinanceSettlementStatus status, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> flagTransaction(
    AdminFinanceTransactionId id, {
    required bool flagged,
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> approveRefundCase(
    AdminFinanceRefundCaseId id, {
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> rejectRefundCase(
    AdminFinanceRefundCaseId id, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> retryPayout(
    AdminFinancePayoutId id, {
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> holdPayout(
    AdminFinancePayoutId id, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> releasePayoutHold(
    AdminFinancePayoutId id, {
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> resolveReconciliation(
    AdminFinanceReconciliationId id, {
    required String note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> reopenReconciliation(
    AdminFinanceReconciliationId id, {
    String? note,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<void> addNote({
    required String entityType,
    required String entityId,
    required String content,
  }) async {
    await Future<void>.delayed(_delay);
  }

  @override
  Future<AdminFinanceExportJob> createExport(
    AdminFinanceExportType type,
  ) async {
    await Future<void>.delayed(_delay);
    return AdminFinanceExportJob(
      id: const AdminFinanceExportId(
        'admin-export-new',
      ),
      createdAt: DateTime.now(),
      type: type,
      requestedBy: 'Admin User',
      status: AdminFinanceExportStatus.queued,
      rowCount: 0,
    );
  }
}

// ────────────────────────────────────────────────────
// Filter helpers (local to mock)
// ────────────────────────────────────────────────────

List<AdminFinanceTransactionRecord>
    _filterTransactions(
  List<AdminFinanceTransactionRecord> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.reference.toLowerCase().contains(q) &&
          !r.partnerName.toLowerCase().contains(q) &&
          !r.customerName.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.transactionStatus != null &&
        r.transactionStatus != filter.transactionStatus) {
      return false;
    }
    if (filter.settlementStatus != null &&
        r.settlementStatus != filter.settlementStatus) {
      return false;
    }
    if (filter.payoutStatus != null &&
        r.payoutStatus != filter.payoutStatus) {
      return false;
    }
    if (filter.sourceType != null &&
        r.sourceType != filter.sourceType) {
      return false;
    }
    if (filter.transactionType != null &&
        r.type != filter.transactionType) {
      return false;
    }
    if (filter.provider != null &&
        r.provider != filter.provider) {
      return false;
    }
    if (filter.currency != null &&
        r.currency != filter.currency) {
      return false;
    }
    if (filter.onlyFlagged && !r.isFlagged) {
      return false;
    }
    return true;
  }).toList();
}

List<AdminFinancePayoutRecord> _filterPayouts(
  List<AdminFinancePayoutRecord> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.partnerName.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.payoutStatus != null &&
        r.status != filter.payoutStatus) {
      return false;
    }
    if (filter.currency != null &&
        r.currency != filter.currency) {
      return false;
    }
    return true;
  }).toList();
}

List<AdminFinanceRefundCaseRecord> _filterRefundCases(
  List<AdminFinanceRefundCaseRecord> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.partnerName.toLowerCase().contains(q) &&
          !r.customerName.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.refundCaseStatus != null &&
        r.status != filter.refundCaseStatus) {
      return false;
    }
    if (filter.refundCaseType != null &&
        r.caseType != filter.refundCaseType) {
      return false;
    }
    if (filter.onlySlaBreached && !r.slaBreached) {
      return false;
    }
    if (filter.currency != null &&
        r.currency != filter.currency) {
      return false;
    }
    return true;
  }).toList();
}

List<AdminFinanceReconciliationException>
    _filterReconciliation(
  List<AdminFinanceReconciliationException> items,
  AdminFinanceFilter filter,
) {
  return items.where((r) {
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      if (!r.providerEventId.toLowerCase().contains(q) &&
          !r.id.value.toLowerCase().contains(q) &&
          !r.owner.toLowerCase().contains(q)) {
        return false;
      }
    }
    if (filter.reconciliationStatus != null &&
        r.status != filter.reconciliationStatus) {
      return false;
    }
    if (filter.provider != null &&
        r.provider != filter.provider) {
      return false;
    }
    if (filter.currency != null &&
        r.currency != filter.currency) {
      return false;
    }
    return true;
  }).toList();
}

// ────────────────────────────────────────────────────
// Provider
// ────────────────────────────────────────────────────

final adminFinanceRemoteDataSourceProvider =
    Provider<AdminFinanceRemoteDataSource>((ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return AdminFinanceRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return AdminFinanceRemoteDataSourceImpl(
    apiService: apiService,
  );
});
