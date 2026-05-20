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
class RevenueScreen extends StatelessWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _RevenueBody()));
  }
}

/// Composition shell: scrollable content with all
/// revenue dashboard sections.
class _RevenueBody extends ConsumerWidget {
  const _RevenueBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tt = Theme.of(context).textTheme;

    return RefreshIndicator(
      onRefresh: () async => ref.refresh(revenueProvider.future),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        children: [
          // Title
          Text(
            'Revenue',
            style: tt.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          // Period toggle
          const _RevenuePeriodToggle(),
          const SizedBox(height: 16),
          // Date navigator
          const _RevenueDateNavigator(),
          const _RevenueDataSections(),
        ],
      ),
    );
  }
}

class _RevenuePeriodToggle extends ConsumerWidget {
  const _RevenuePeriodToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(
      revenueFilterProvider.select((state) => state.period),
    );
    final notifier = ref.read(revenueFilterProvider.notifier);

    return RevenuePeriodToggle(
      selected: selected,
      onChanged: notifier.setPeriod,
      testKeys: {
        RevenuePeriod.day: keys.revenuePage.dayChip,
        RevenuePeriod.month: keys.revenuePage.monthChip,
        RevenuePeriod.year: keys.revenuePage.yearChip,
      },
    );
  }
}

class _RevenueDateNavigator extends ConsumerWidget {
  const _RevenueDateNavigator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(
      revenueFilterProvider.select((state) => state.period),
    );
    final selectedDate = ref.watch(
      revenueFilterProvider.select((state) => state.selectedDate),
    );
    final notifier = ref.read(revenueFilterProvider.notifier);

    return RevenueDateNavigator(
      period: period,
      selectedDate: selectedDate,
      onPrevious: notifier.navigatePrevious,
      onNext: notifier.navigateNext,
      onToday: notifier.goToToday,
      previousKey: keys.revenuePage.previousButton,
      nextKey: keys.revenuePage.nextButton,
    );
  }
}

class _RevenueDataSections extends ConsumerWidget {
  const _RevenueDataSections();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueAsync = ref.watch(revenueProvider);

    return revenueAsync.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      loading: () => const Padding(
        padding: EdgeInsets.only(top: 48),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Padding(
        padding: const EdgeInsets.only(top: 48),
        child: Center(child: Text('Error: $e')),
      ),
      data: (data) => Column(
        children: [
          const SizedBox(height: 24),
          if (revenueAsync.isLoading) ...[
            const LinearProgressIndicator(minHeight: 2),
            const SizedBox(height: 16),
          ],
          // KPI cards
          RevenueKpiGrid(summary: data.summary),
          const SizedBox(height: 24),
          // Trend chart
          RevenueTrendChart(data: data.trendData),
          const SizedBox(height: 24),
          // Service breakdown
          RevenueBreakdownSection(items: data.breakdown),
        ],
      ),
    );
  }
}
