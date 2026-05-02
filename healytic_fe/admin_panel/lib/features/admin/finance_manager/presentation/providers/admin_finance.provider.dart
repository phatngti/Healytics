import 'package:admin_panel/features/admin/finance_manager/datasource/admin_finance_impl.repository.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_filter.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ────────────────────────────────────────────────────
// Workspace Notifier
// ────────────────────────────────────────────────────

class AdminFinanceWorkspaceNotifier
    extends Notifier<AdminFinanceWorkspaceState> {
  @override
  AdminFinanceWorkspaceState build() {
    return const AdminFinanceWorkspaceState();
  }

  void setActiveTab(AdminFinanceWorkspaceTab tab) {
    state = state.copyWith(activeTab: tab);
  }

  void setPeriod(AdminFinancePeriod period) {
    state = state.copyWith(
      period: period,
      reloadToken: state.reloadToken + 1,
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        searchQuery: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setPartner(String? partnerId) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        partnerId: partnerId,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setCustomer(String? customerId) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        customerId: customerId,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setDateRange(DateTime? start, DateTime? end) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        startDate: start,
        endDate: end,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setSourceType(AdminFinanceSourceType? value) {
    state = state.copyWith(
      filter: state.filter.copyWith(sourceType: value),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setTransactionType(
    AdminFinanceTransactionType? value,
  ) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        transactionType: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setTransactionStatus(
    AdminFinanceTransactionStatus? value,
  ) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        transactionStatus: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setSettlementStatus(
    AdminFinanceSettlementStatus? value,
  ) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        settlementStatus: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setPayoutStatus(
    AdminFinancePayoutStatus? value,
  ) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        payoutStatus: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setRefundCaseStatus(
    AdminFinanceRefundCaseStatus? value,
  ) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        refundCaseStatus: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setReconciliationStatus(
    AdminFinanceReconciliationStatus? value,
  ) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        reconciliationStatus: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setProvider(AdminFinanceProvider? value) {
    state = state.copyWith(
      filter: state.filter.copyWith(provider: value),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setCurrency(String? value) {
    state = state.copyWith(
      filter: state.filter.copyWith(currency: value),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setAmountRange(double? min, double? max) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        minAmount: min,
        maxAmount: max,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setOnlyFlagged(bool value) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        onlyFlagged: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void setOnlySlaBreached(bool value) {
    state = state.copyWith(
      filter: state.filter.copyWith(
        onlySlaBreached: value,
      ),
      reloadToken: state.reloadToken + 1,
    );
  }

  void resetFilters() {
    state = AdminFinanceWorkspaceState(
      activeTab: state.activeTab,
      period: state.period,
      reloadToken: state.reloadToken + 1,
    );
  }

  void bumpReload() {
    state = state.copyWith(
      reloadToken: state.reloadToken + 1,
    );
  }
}

final adminFinanceWorkspaceProvider = NotifierProvider<
    AdminFinanceWorkspaceNotifier,
    AdminFinanceWorkspaceState>(
  AdminFinanceWorkspaceNotifier.new,
);

// ────────────────────────────────────────────────────
// Async Data Providers
// ────────────────────────────────────────────────────

/// Overview metrics for the dashboard tab.
final adminFinanceOverviewProvider =
    FutureProvider<AdminFinanceOverview>((ref) async {
  final ws = ref.watch(adminFinanceWorkspaceProvider);
  return ref
      .read(adminFinanceRepositoryProvider)
      .getOverview(ws.period, ws.filter);
});

/// Trend points for the dashboard chart.
final adminFinanceTrendProvider =
    FutureProvider<List<AdminFinanceTrendPoint>>(
  (ref) async {
    final ws = ref.watch(adminFinanceWorkspaceProvider);
    return ref
        .read(adminFinanceRepositoryProvider)
        .getTrend(ws.period, ws.filter);
  },
);

/// Alerts for the overview panel.
final adminFinanceAlertsProvider =
    FutureProvider<List<AdminFinanceAlert>>((ref) async {
  final ws = ref.watch(adminFinanceWorkspaceProvider);
  return ref
      .read(adminFinanceRepositoryProvider)
      .getAlerts(ws.period);
});

/// Partner exposure panel data.
final adminFinancePartnerExposureProvider =
    FutureProvider<List<AdminFinancePartnerExposure>>(
  (ref) async {
    final ws = ref.watch(adminFinanceWorkspaceProvider);
    return ref
        .read(adminFinanceRepositoryProvider)
        .getPartnerExposure(ws.period, ws.filter);
  },
);

/// Finance export jobs.
final adminFinanceExportsProvider =
    FutureProvider<List<AdminFinanceExportJob>>(
  (ref) async {
    ref.watch(
      adminFinanceWorkspaceProvider.select(
        (s) => s.reloadToken,
      ),
    );
    return ref
        .read(adminFinanceRepositoryProvider)
        .getExports();
  },
);

// ── Detail Family Providers ─────────────────────────

/// Single transaction detail.
final adminFinanceTransactionDetailProvider =
    FutureProvider.family<AdminFinanceTransactionDetail,
        AdminFinanceTransactionId>(
  (ref, id) async {
    ref.watch(
      adminFinanceWorkspaceProvider.select(
        (s) => s.reloadToken,
      ),
    );
    return ref
        .read(adminFinanceRepositoryProvider)
        .getTransactionDetail(id);
  },
);

/// Single payout detail.
final adminFinancePayoutDetailProvider =
    FutureProvider.family<AdminFinancePayoutDetail,
        AdminFinancePayoutId>(
  (ref, id) async {
    ref.watch(
      adminFinanceWorkspaceProvider.select(
        (s) => s.reloadToken,
      ),
    );
    return ref
        .read(adminFinanceRepositoryProvider)
        .getPayoutDetail(id);
  },
);

/// Single refund case detail.
final adminFinanceRefundCaseDetailProvider =
    FutureProvider.family<AdminFinanceRefundCaseDetail,
        AdminFinanceRefundCaseId>(
  (ref, id) async {
    ref.watch(
      adminFinanceWorkspaceProvider.select(
        (s) => s.reloadToken,
      ),
    );
    return ref
        .read(adminFinanceRepositoryProvider)
        .getRefundCaseDetail(id);
  },
);

/// Single reconciliation exception detail.
final adminFinanceReconciliationDetailProvider =
    FutureProvider.family<
        AdminFinanceReconciliationDetail,
        AdminFinanceReconciliationId>(
  (ref, id) async {
    ref.watch(
      adminFinanceWorkspaceProvider.select(
        (s) => s.reloadToken,
      ),
    );
    return ref
        .read(adminFinanceRepositoryProvider)
        .getReconciliationDetail(id);
  },
);
