import 'package:admin_panel/features/admin/finance_manager/datasource/admin_finance_impl.repository.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance_period.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance_state.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/providers/admin_finance.provider.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_action_dialogs.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_alerts_panel.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_filter_bar.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_header.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_kpi_grid.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_partner_exposure_panel.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_period_selector.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_status_tabs.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_trend_panel.widget.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/table/admin_finance_tables.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Desktop layout for the Finance Manager screen.
class AdminFinanceManagerDesktop extends ConsumerStatefulWidget {
  const AdminFinanceManagerDesktop({super.key});

  @override
  ConsumerState<AdminFinanceManagerDesktop> createState() =>
      _AdminFinanceManagerDesktopState();
}

class _AdminFinanceManagerDesktopState
    extends ConsumerState<AdminFinanceManagerDesktop> {
  // Table data loaded per active tab
  List<AdminFinanceTransactionRecord> _txns = [];
  int _txnTotal = 0;
  List<AdminFinancePayoutRecord> _payouts = [];
  int _payoutTotal = 0;
  List<AdminFinanceRefundCaseRecord> _refunds = [];
  int _refundTotal = 0;
  List<AdminFinanceReconciliationException> _recons = [];
  int _reconTotal = 0;

  int _lastReloadToken = -1;
  AdminFinanceWorkspaceTab? _lastTab;

  @override
  Widget build(BuildContext context) {
    final ws = ref.watch(adminFinanceWorkspaceProvider);
    final notifier = ref.read(
      adminFinanceWorkspaceProvider.notifier,
    );

    // Reload table data when tab or reloadToken changes.
    if (ws.reloadToken != _lastReloadToken ||
        ws.activeTab != _lastTab) {
      _lastReloadToken = ws.reloadToken;
      _lastTab = ws.activeTab;
      _loadTabData(ws);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminFinanceHeader(
              onExport: () =>
                  _showExportDialog(context),
            ),
            AppDimens.verticalLarge,
            AdminFinancePeriodSelector(
              selected: ws.period,
              onChanged: notifier.setPeriod,
            ),
            AppDimens.verticalMedium,
            AdminFinanceStatusTabs(
              activeTab: ws.activeTab,
              onChanged: notifier.setActiveTab,
            ),
            AppDimens.verticalMedium,
            AdminFinanceFilterBar(
              state: ws,
              onSearchChanged: notifier.setSearchQuery,
              onSourceTypeChanged: notifier.setSourceType,
              onTransactionTypeChanged:
                  notifier.setTransactionType,
              onTransactionStatusChanged:
                  notifier.setTransactionStatus,
              onSettlementStatusChanged:
                  notifier.setSettlementStatus,
              onPayoutStatusChanged:
                  notifier.setPayoutStatus,
              onRefundCaseStatusChanged:
                  notifier.setRefundCaseStatus,
              onReconciliationStatusChanged:
                  notifier.setReconciliationStatus,
              onProviderChanged: notifier.setProvider,
              onCurrencyChanged: notifier.setCurrency,
              onFlaggedChanged: notifier.setOnlyFlagged,
              onSlaBreachedChanged:
                  notifier.setOnlySlaBreached,
              onReset: notifier.resetFilters,
            ),
            AppDimens.verticalLarge,
            _buildActiveTabContent(ws),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(
    AdminFinanceWorkspaceState ws,
  ) {
    return switch (ws.activeTab) {
      AdminFinanceWorkspaceTab.overview =>
        _buildOverview(),
      AdminFinanceWorkspaceTab.ledger =>
        _buildLedger(),
      AdminFinanceWorkspaceTab.payouts =>
        _buildPayouts(),
      AdminFinanceWorkspaceTab.refunds =>
        _buildRefunds(),
      AdminFinanceWorkspaceTab.reconciliation =>
        _buildReconciliation(),
      AdminFinanceWorkspaceTab.partnerExposure =>
        _buildPartnerExposure(),
      AdminFinanceWorkspaceTab.exports =>
        _buildExports(),
    };
  }

  Widget _buildOverview() {
    final overviewAsync = ref.watch(
      adminFinanceOverviewProvider,
    );
    final trendAsync = ref.watch(
      adminFinanceTrendProvider,
    );
    final alertsAsync = ref.watch(
      adminFinanceAlertsProvider,
    );
    final exposureAsync = ref.watch(
      adminFinancePartnerExposureProvider,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        overviewAsync.when(
          data: (o) => AdminFinanceKpiGrid(overview: o),
          loading: () =>
              const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(e),
        ),
        AppDimens.verticalLarge,
        trendAsync.when(
          data: (data) => AdminFinanceTrendPanel(
            data: data,
            currency: 'VND',
          ),
          loading: () =>
              const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(e),
        ),
        AppDimens.verticalLarge,
        alertsAsync.when(
          data: (alerts) =>
              AdminFinanceAlertsPanel(alerts: alerts),
          loading: () =>
              const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(e),
        ),
        AppDimens.verticalLarge,
        exposureAsync.when(
          data: (data) =>
              AdminFinancePartnerExposurePanel(
            exposures: data,
          ),
          loading: () =>
              const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(e),
        ),
      ],
    );
  }

  Widget _buildLedger() {
    return AdminFinanceTransactionTable(
      records: _txns,
      totalRows: _txnTotal,
      onRowTap: (id) {
        AdminFinanceTransactionDetailRoute(
          transactionId: id.value,
        ).push(context);
      },
    );
  }

  Widget _buildPayouts() {
    return AdminFinancePayoutTable(
      records: _payouts,
      totalRows: _payoutTotal,
      onRowTap: (id) {
        AdminFinancePayoutDetailRoute(
          payoutId: id.value,
        ).push(context);
      },
    );
  }

  Widget _buildRefunds() {
    return AdminFinanceRefundCaseTable(
      records: _refunds,
      totalRows: _refundTotal,
      onRowTap: (id) {
        AdminFinanceRefundCaseDetailRoute(
          caseId: id.value,
        ).push(context);
      },
    );
  }

  Widget _buildReconciliation() {
    return AdminFinanceReconciliationTable(
      records: _recons,
      totalRows: _reconTotal,
      onRowTap: (id) {
        AdminFinanceReconciliationDetailRoute(
          exceptionId: id.value,
        ).push(context);
      },
    );
  }

  Widget _buildPartnerExposure() {
    final exposureAsync = ref.watch(
      adminFinancePartnerExposureProvider,
    );
    return exposureAsync.when(
      data: (data) => AdminFinancePartnerExposurePanel(
        exposures: data,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => _errorWidget(e),
    );
  }

  Widget _buildExports() {
    final exportsAsync = ref.watch(
      adminFinanceExportsProvider,
    );
    return exportsAsync.when(
      data: (data) => AdminFinanceExportTable(
        records: data,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => _errorWidget(e),
    );
  }

  Future<void> _loadTabData(
    AdminFinanceWorkspaceState ws,
  ) async {
    final repo = ref.read(
      adminFinanceRepositoryProvider,
    );
    final filter = ws.filter;
    const pageSize = 50;

    switch (ws.activeTab) {
      case AdminFinanceWorkspaceTab.ledger:
        final total = await repo
            .getTransactionTotalRows(filter);
        final rows = await repo.getTransactions(
          filter: filter,
          startingAt: 0,
          count: pageSize,
        );
        if (mounted) {
          setState(() {
            _txnTotal = total;
            _txns = rows;
          });
        }
      case AdminFinanceWorkspaceTab.payouts:
        final total = await repo
            .getPayoutTotalRows(filter);
        final rows = await repo.getPayouts(
          filter: filter,
          startingAt: 0,
          count: pageSize,
        );
        if (mounted) {
          setState(() {
            _payoutTotal = total;
            _payouts = rows;
          });
        }
      case AdminFinanceWorkspaceTab.refunds:
        final total = await repo
            .getRefundCaseTotalRows(filter);
        final rows = await repo.getRefundCases(
          filter: filter,
          startingAt: 0,
          count: pageSize,
        );
        if (mounted) {
          setState(() {
            _refundTotal = total;
            _refunds = rows;
          });
        }
      case AdminFinanceWorkspaceTab.reconciliation:
        final total = await repo
            .getReconciliationTotalRows(filter);
        final rows =
            await repo.getReconciliationExceptions(
          filter: filter,
          startingAt: 0,
          count: pageSize,
        );
        if (mounted) {
          setState(() {
            _reconTotal = total;
            _recons = rows;
          });
        }
      default:
        break;
    }
  }

  void _showExportDialog(BuildContext context) async {
    final result =
        await showAdminFinanceCreateExportDialog(
      context,
    );
    if (result != null) {
      ref
          .read(adminFinanceWorkspaceProvider.notifier)
          .bumpReload();
    }
  }

  Widget _errorWidget(Object error) {
    return Center(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 40,
              color: Theme.of(context).colorScheme.error,
            ),
            AppDimens.verticalSmall,
            Text(
              'Something went wrong. Please try again.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurfaceVariant,
                  ),
            ),
            AppDimens.verticalSmall,
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () => ref
                  .read(
                    adminFinanceWorkspaceProvider.notifier,
                  )
                  .bumpReload(),
            ),
          ],
        ),
      ),
    );
  }
}
