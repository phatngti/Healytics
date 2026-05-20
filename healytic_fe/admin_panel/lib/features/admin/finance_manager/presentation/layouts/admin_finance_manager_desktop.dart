import 'dart:async';

import 'package:admin_panel/features/admin/finance_manager/datasource/admin_finance_impl.repository.dart';
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
  static const _searchDebounceDuration = Duration(milliseconds: 350);

  Timer? _searchDebounce;

  @override
  void dispose() {
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onTableSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!mounted) return;
      ref.read(adminFinanceWorkspaceProvider.notifier).setSearchQuery(value);
    });
  }

  void _resetFilters() {
    _searchDebounce?.cancel();
    ref.read(adminFinanceWorkspaceProvider.notifier).resetFilters();
  }

  @override
  Widget build(BuildContext context) {
    final ws = ref.watch(adminFinanceWorkspaceProvider);
    final notifier = ref.read(adminFinanceWorkspaceProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminFinanceHeader(onExport: () => _showExportDialog(context, ref)),
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
              onSourceTypeChanged: notifier.setSourceType,
              onTransactionTypeChanged: notifier.setTransactionType,
              onTransactionStatusChanged: notifier.setTransactionStatus,
              onSettlementStatusChanged: notifier.setSettlementStatus,
              onPayoutStatusChanged: notifier.setPayoutStatus,
              onRefundCaseStatusChanged: notifier.setRefundCaseStatus,
              onReconciliationStatusChanged: notifier.setReconciliationStatus,
              onProviderChanged: notifier.setProvider,
              onCurrencyChanged: notifier.setCurrency,
              onFlaggedChanged: notifier.setOnlyFlagged,
              onSlaBreachedChanged: notifier.setOnlySlaBreached,
              onReset: _resetFilters,
            ),
            AppDimens.verticalLarge,
            _buildActiveTabContent(context, ref, ws),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveTabContent(
    BuildContext context,
    WidgetRef ref,
    AdminFinanceWorkspaceState ws,
  ) {
    return switch (ws.activeTab) {
      AdminFinanceWorkspaceTab.overview => _buildOverview(context, ref),
      AdminFinanceWorkspaceTab.ledger => _buildLedger(context, ws),
      AdminFinanceWorkspaceTab.payouts => _buildPayouts(context, ws),
      AdminFinanceWorkspaceTab.refunds => _buildRefunds(context, ws),
      AdminFinanceWorkspaceTab.reconciliation => _buildReconciliation(
        context,
        ws,
      ),
      AdminFinanceWorkspaceTab.partnerExposure => _buildPartnerExposure(
        context,
        ref,
      ),
      AdminFinanceWorkspaceTab.exports => _buildExports(context, ref),
    };
  }

  Widget _buildOverview(BuildContext context, WidgetRef ref) {
    final overviewAsync = ref.watch(adminFinanceOverviewProvider);
    final trendAsync = ref.watch(adminFinanceTrendProvider);
    final alertsAsync = ref.watch(adminFinanceAlertsProvider);
    final exposureAsync = ref.watch(adminFinancePartnerExposureProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        overviewAsync.when(
          data: (o) => AdminFinanceKpiGrid(overview: o),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(context, ref, e),
        ),
        AppDimens.verticalLarge,
        trendAsync.when(
          data: (data) => AdminFinanceTrendPanel(data: data, currency: 'VND'),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(context, ref, e),
        ),
        AppDimens.verticalLarge,
        alertsAsync.when(
          data: (alerts) => AdminFinanceAlertsPanel(alerts: alerts),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(context, ref, e),
        ),
        AppDimens.verticalLarge,
        exposureAsync.when(
          data: (data) => AdminFinancePartnerExposurePanel(exposures: data),
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => _errorWidget(context, ref, e),
        ),
      ],
    );
  }

  Widget _buildLedger(BuildContext context, AdminFinanceWorkspaceState ws) {
    return AdminFinanceTransactionTable(
      filter: ws.filter,
      reloadToken: ws.reloadToken,
      height: _tableHeight(context),
      onSearchChanged: _onTableSearchChanged,
      onRowTap: (id) {
        AdminFinanceTransactionDetailRoute(
          transactionId: id.value,
        ).push(context);
      },
    );
  }

  Widget _buildPayouts(BuildContext context, AdminFinanceWorkspaceState ws) {
    return AdminFinancePayoutTable(
      filter: ws.filter,
      reloadToken: ws.reloadToken,
      height: _tableHeight(context),
      onSearchChanged: _onTableSearchChanged,
      onRowTap: (id) {
        AdminFinancePayoutDetailRoute(payoutId: id.value).push(context);
      },
    );
  }

  Widget _buildRefunds(BuildContext context, AdminFinanceWorkspaceState ws) {
    return AdminFinanceRefundCaseTable(
      filter: ws.filter,
      reloadToken: ws.reloadToken,
      height: _tableHeight(context),
      onSearchChanged: _onTableSearchChanged,
      onRowTap: (id) {
        AdminFinanceRefundCaseDetailRoute(caseId: id.value).push(context);
      },
    );
  }

  Widget _buildReconciliation(
    BuildContext context,
    AdminFinanceWorkspaceState ws,
  ) {
    return AdminFinanceReconciliationTable(
      filter: ws.filter,
      reloadToken: ws.reloadToken,
      height: _tableHeight(context),
      onSearchChanged: _onTableSearchChanged,
      onRowTap: (id) {
        AdminFinanceReconciliationDetailRoute(
          exceptionId: id.value,
        ).push(context);
      },
    );
  }

  Widget _buildPartnerExposure(BuildContext context, WidgetRef ref) {
    final exposureAsync = ref.watch(adminFinancePartnerExposureProvider);
    return exposureAsync.when(
      data: (data) => AdminFinancePartnerExposurePanel(
        exposures: data,
        onSearchChanged: _onTableSearchChanged,
      ),
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => _errorWidget(context, ref, e),
    );
  }

  Widget _buildExports(BuildContext context, WidgetRef ref) {
    final exportsAsync = ref.watch(adminFinanceExportsProvider);
    return exportsAsync.when(
      data: (data) =>
          AdminFinanceExportTable(records: data, height: _tableHeight(context)),
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => _errorWidget(context, ref, e),
    );
  }

  double _tableHeight(BuildContext context) {
    return (MediaQuery.sizeOf(context).height - 280)
        .clamp(520.0, 760.0)
        .toDouble();
  }

  void _showExportDialog(BuildContext context, WidgetRef ref) async {
    final type = await showAdminFinanceCreateExportDialog(context);
    if (type != null && context.mounted) {
      await ref.read(adminFinanceRepositoryProvider).createExport(type);
      ref.read(adminFinanceWorkspaceProvider.notifier).bumpReload();
    }
  }

  Widget _errorWidget(BuildContext context, WidgetRef ref, Object error) {
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalSmall,
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              onPressed: () =>
                  ref.read(adminFinanceWorkspaceProvider.notifier).bumpReload(),
            ),
          ],
        ),
      ),
    );
  }
}
