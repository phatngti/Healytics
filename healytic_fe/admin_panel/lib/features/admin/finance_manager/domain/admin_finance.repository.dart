import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';

/// Repository contract for the admin finance manager.
///
/// All methods return domain entities; no DTOs or
/// framework types leak into this interface.
abstract class AdminFinanceRepository {
  // ── Read: Overview ────────────────────────────────

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

  // ── Read: Transactions ────────────────────────────

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

  // ── Read: Payouts ─────────────────────────────────

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

  // ── Read: Refund Cases ────────────────────────────

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

  // ── Read: Reconciliation ──────────────────────────

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

  // ── Read: Partner Exposure ────────────────────────

  Future<List<AdminFinancePartnerExposure>>
      getPartnerExposure(
    AdminFinancePeriod period,
    AdminFinanceFilter filter,
  );

  // ── Read: Exports ─────────────────────────────────

  Future<List<AdminFinanceExportJob>> getExports();

  // ── Admin Actions ─────────────────────────────────

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
