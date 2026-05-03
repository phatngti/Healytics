import 'package:admin_panel/features/partner/transactions/domain/finance_models.dart';
import 'package:admin_panel/features/partner/transactions/presentation/providers/transaction.provider.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_overview_card.widget.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_trend_panel.widget.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/finance_ui_helpers.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/payouts_table.widget.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/refund_cases_table.widget.dart';
import 'package:admin_panel/features/partner/transactions/presentation/widgets/transactions_table.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/statistic_card.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionHomeDesktop extends StatelessWidget {
  const TransactionHomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction Manager',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppDimens.verticalSmall,
            Text(
              'Track revenue, payouts, refunds, and settlement activity across services and product sales.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalLarge,
            const _FinanceSummarySection(),
            AppDimens.verticalLarge,
            Text(
              'Workspace',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppDimens.verticalSmall,
            Text(
              'Switch between transaction history, payout cycles, and refund operations.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalMedium,
            const _WorkspaceTabSelector(),
            AppDimens.verticalMedium,
            _ActiveWorkspaceTable(height: screenHeight * 0.72),
          ],
        ),
      ),
    );
  }
}

class _FinanceSummarySection extends ConsumerWidget {
  const _FinanceSummarySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(financeSummaryProvider);

    return summaryAsync.when(
      data: (summary) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StatisticCard(
                  label: 'Gross Volume',
                  value: formatFinanceCurrency(
                    summary.grossVolume,
                    summary.currency,
                  ),
                  change: 14.8,
                ),
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: StatisticCard(
                  label: 'Net Settled',
                  value: formatFinanceCurrency(
                    summary.netSettled,
                    summary.currency,
                  ),
                  change: 9.6,
                ),
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: StatisticCard(
                  label: 'Pending Payout',
                  value: formatFinanceCurrency(
                    summary.pendingPayout,
                    summary.currency,
                  ),
                  change: 5.1,
                ),
              ),
              AppDimens.horizontalMedium,
              Expanded(
                child: StatisticCard(
                  label: 'Refund / Dispute Exposure',
                  value: formatFinanceCurrency(
                    summary.refundExposure,
                    summary.currency,
                  ),
                  change: -2.4,
                ),
              ),
            ],
          ),
          AppDimens.verticalLarge,
          FinanceOverviewCard(summary: summary),
          AppDimens.verticalLarge,
          _FinanceTrendSection(currency: summary.currency),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorCard(
        title: 'Failed to load finance summary',
        error: error,
        stackTrace: stack,
        onRetry: () => ref.invalidate(financeSummaryProvider),
      ),
    );
  }
}

class _FinanceTrendSection extends ConsumerWidget {
  const _FinanceTrendSection({required this.currency});

  final String currency;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendAsync = ref.watch(financeTrendProvider);
    final selectedPeriod = ref.watch(financeSelectedPeriodProvider);
    final selectedMetric = ref.watch(financeSelectedMetricProvider);
    final manager = ref.read(transactionsManagerProvider.notifier);

    return trendAsync.when(
      data: (trend) => FinanceTrendPanel(
        data: trend,
        selectedPeriod: selectedPeriod,
        selectedMetric: selectedMetric,
        onPeriodChanged: manager.setSelectedPeriod,
        onMetricChanged: manager.setSelectedMetric,
        currency: currency,
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => ErrorCard(
        title: 'Failed to load trend data',
        error: error,
        stackTrace: stack,
        onRetry: () => ref.invalidate(financeTrendProvider),
      ),
    );
  }
}

class _WorkspaceTabSelector extends ConsumerWidget {
  const _WorkspaceTabSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(financeActiveTabProvider);
    final manager = ref.read(transactionsManagerProvider.notifier);

    return SegmentedButton<FinanceWorkspaceTab>(
      segments: FinanceWorkspaceTab.values
          .map((item) => ButtonSegment(value: item, label: Text(item.label)))
          .toList(),
      selected: {activeTab},
      onSelectionChanged: (selected) => manager.setActiveTab(selected.first),
    );
  }
}

class _ActiveWorkspaceTable extends ConsumerWidget {
  const _ActiveWorkspaceTable({required this.height});

  final double height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(financeActiveTabProvider);

    return switch (activeTab) {
      FinanceWorkspaceTab.transactions => TransactionsTable(height: height),
      FinanceWorkspaceTab.payouts => PayoutsTable(height: height),
      FinanceWorkspaceTab.refunds => RefundCasesTable(height: height),
    };
  }
}
