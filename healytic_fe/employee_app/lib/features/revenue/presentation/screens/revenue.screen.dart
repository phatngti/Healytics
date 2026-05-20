import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/keys/integration_test_keys.dart';
import '../../domain/entities/revenue.entity.dart';
import '../providers/revenue.provider.dart';
import '../widgets/revenue/revenue_breakdown_section.widget.dart';
import '../widgets/revenue/revenue_date_navigator.widget.dart';
import '../widgets/revenue/revenue_kpi_grid.widget.dart';
import '../widgets/revenue/revenue_period_toggle.widget.dart';
import '../widgets/revenue/revenue_trend_chart.widget.dart';

/// Revenue dashboard screen displaying KPIs, trend
/// chart, and service breakdown for the selected period.
class RevenueScreen extends ConsumerWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueAsync = ref.watch(revenueProvider);

    return Scaffold(
      body: SafeArea(
        child: revenueAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (e, _) => Center(
            child: Text('Error: $e'),
          ),
          data: (data) => _RevenueBody(data: data),
        ),
      ),
    );
  }
}

/// Composition shell: scrollable content with all
/// revenue dashboard sections.
class _RevenueBody extends ConsumerWidget {
  final RevenueState data;
  const _RevenueBody({required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier =
        ref.read(revenueProvider.notifier);
    final tt = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () async =>
          ref.invalidate(revenueProvider),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          20, 24, 20, 32,
        ),
        children: [
          // Title
          Text(
            'Revenue',
            style: tt.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 24),
          // Period toggle
          RevenuePeriodToggle(
            selected: data.period,
            onChanged: notifier.setPeriod,
            testKeys: {
              RevenuePeriod.day:
                  keys.revenuePage.dayChip,
              RevenuePeriod.month:
                  keys.revenuePage.monthChip,
              RevenuePeriod.year:
                  keys.revenuePage.yearChip,
            },
          ),
          const SizedBox(height: 16),
          // Date navigator
          RevenueDateNavigator(
            period: data.period,
            selectedDate: data.selectedDate,
            onPrevious: notifier.navigatePrevious,
            onNext: notifier.navigateNext,
            onToday: notifier.goToToday,
            previousKey:
                keys.revenuePage.previousButton,
            nextKey: keys.revenuePage.nextButton,
          ),
          const SizedBox(height: 24),
          // KPI cards
          RevenueKpiGrid(summary: data.summary),
          const SizedBox(height: 24),
          // Trend chart
          RevenueTrendChart(data: data.trendData),
          const SizedBox(height: 24),
          // Service breakdown
          RevenueBreakdownSection(
            items: data.breakdown,
          ),
        ],
      ),
    );
  }
}
