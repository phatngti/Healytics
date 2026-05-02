import 'package:admin_panel/features/admin/finance_manager/datasource/admin_finance_remote.datasource.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Delegates every [AdminFinanceRepository] method
/// to [AdminFinanceRemoteDataSource].
class AdminFinanceImplRepository
    implements AdminFinanceRepository {
  AdminFinanceImplRepository({
    required this.dataSource,
  });

  final AdminFinanceRemoteDataSource dataSource;

  // ── Overview ──────────────────────────────────────

  @override
  Future<AdminFinanceOverview> getOverview(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) => dataSource.getOverview(period, filter);

  @override
  Future<List<AdminFinanceTrendPoint>> getTrend(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) => dataSource.getTrend(period, filter);

  @override
  Future<List<AdminFinanceAlert>> getAlerts(
    AdminFinancePeriod period,
  ) => dataSource.getAlerts(period);

  // ── Transactions ──────────────────────────────────

  @override
  Future<int> getTransactionTotalRows(
    AdminFinanceFilter filter,
  ) => dataSource.getTransactionTotalRows(filter);

  @override
  Future<List<AdminFinanceTransactionRecord>>
      getTransactions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) => dataSource.getTransactions(
    filter: filter,
    startingAt: startingAt,
    count: count,
  );

  @override
  Future<AdminFinanceTransactionDetail>
      getTransactionDetail(
    AdminFinanceTransactionId id,
  ) => dataSource.getTransactionDetail(id);

  // ── Payouts ───────────────────────────────────────

  @override
  Future<int> getPayoutTotalRows(
    AdminFinanceFilter filter,
  ) => dataSource.getPayoutTotalRows(filter);

  @override
  Future<List<AdminFinancePayoutRecord>> getPayouts({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) => dataSource.getPayouts(
    filter: filter,
    startingAt: startingAt,
    count: count,
  );

  @override
  Future<AdminFinancePayoutDetail> getPayoutDetail(
    AdminFinancePayoutId id,
  ) => dataSource.getPayoutDetail(id);

  // ── Refund Cases ──────────────────────────────────

  @override
  Future<int> getRefundCaseTotalRows(
    AdminFinanceFilter filter,
  ) => dataSource.getRefundCaseTotalRows(filter);

  @override
  Future<List<AdminFinanceRefundCaseRecord>>
      getRefundCases({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) => dataSource.getRefundCases(
    filter: filter,
    startingAt: startingAt,
    count: count,
  );

  @override
  Future<AdminFinanceRefundCaseDetail>
      getRefundCaseDetail(
    AdminFinanceRefundCaseId id,
  ) => dataSource.getRefundCaseDetail(id);

  // ── Reconciliation ────────────────────────────────

  @override
  Future<int> getReconciliationTotalRows(
    AdminFinanceFilter filter,
  ) => dataSource.getReconciliationTotalRows(filter);

  @override
  Future<List<AdminFinanceReconciliationException>>
      getReconciliationExceptions({
    required AdminFinanceFilter filter,
    required int startingAt,
    required int count,
  }) => dataSource.getReconciliationExceptions(
    filter: filter,
    startingAt: startingAt,
    count: count,
  );

  @override
  Future<AdminFinanceReconciliationDetail>
      getReconciliationDetail(
    AdminFinanceReconciliationId id,
  ) => dataSource.getReconciliationDetail(id);

  // ── Partner Exposure ──────────────────────────────

  @override
  Future<List<AdminFinancePartnerExposure>>
      getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  ) => dataSource.getPartnerExposure(period, filter);

  // ── Exports ───────────────────────────────────────

  @override
  Future<List<AdminFinanceExportJob>> getExports() =>
      dataSource.getExports();

  // ── Actions ───────────────────────────────────────

  @override
  Future<void> markSettlement(
    AdminFinanceTransactionId id,
    AdminFinanceSettlementStatus status, {
    required String note,
  }) => dataSource.markSettlement(
    id,
    status,
    note: note,
  );

  @override
  Future<void> flagTransaction(
    AdminFinanceTransactionId id, {
    required bool flagged,
    String? note,
  }) => dataSource.flagTransaction(
    id,
    flagged: flagged,
    note: note,
  );

  @override
  Future<void> approveRefundCase(
    AdminFinanceRefundCaseId id, {
    String? note,
  }) => dataSource.approveRefundCase(id, note: note);

  @override
  Future<void> rejectRefundCase(
    AdminFinanceRefundCaseId id, {
    required String note,
  }) => dataSource.rejectRefundCase(id, note: note);

  @override
  Future<void> retryPayout(
    AdminFinancePayoutId id, {
    String? note,
  }) => dataSource.retryPayout(id, note: note);

  @override
  Future<void> holdPayout(
    AdminFinancePayoutId id, {
    required String note,
  }) => dataSource.holdPayout(id, note: note);

  @override
  Future<void> releasePayoutHold(
    AdminFinancePayoutId id, {
    String? note,
  }) => dataSource.releasePayoutHold(id, note: note);

  @override
  Future<void> resolveReconciliation(
    AdminFinanceReconciliationId id, {
    required String note,
  }) => dataSource.resolveReconciliation(
    id,
    note: note,
  );

  @override
  Future<void> reopenReconciliation(
    AdminFinanceReconciliationId id, {
    String? note,
  }) => dataSource.reopenReconciliation(
    id,
    note: note,
  );

  @override
  Future<void> addNote({
    required String entityType,
    required String entityId,
    required String content,
  }) => dataSource.addNote(
    entityType: entityType,
    entityId: entityId,
    content: content,
  );

  @override
  Future<AdminFinanceExportJob> createExport(
    AdminFinanceExportType type,
  ) => dataSource.createExport(type);
}

final adminFinanceRepositoryProvider =
    Provider<AdminFinanceRepository>((ref) {
  final dataSource = ref.read(
    adminFinanceRemoteDataSourceProvider,
  );
  return AdminFinanceImplRepository(
    dataSource: dataSource,
  );
});
