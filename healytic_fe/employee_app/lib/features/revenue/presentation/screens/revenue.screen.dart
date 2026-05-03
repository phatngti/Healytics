import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/keys/integration_test_keys.dart';
import '../../domain/entities/revenue.entity.dart';
import '../providers/revenue.provider.dart';

class RevenueScreen extends ConsumerWidget {
  const RevenueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueAsync = ref.watch(revenueProvider);
    final notifier = ref.read(revenueProvider.notifier);
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue', style: tt.titleLarge),
        centerTitle: false,
      ),
      body: revenueAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (data) => RefreshIndicator(
          onRefresh: () async => ref.invalidate(revenueProvider),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Period selector
              Row(
                children: RevenuePeriod.values.map((p) {
                  final isSelected = data.period == p;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      key: p == RevenuePeriod.day
                          ? keys.revenuePage.dayChip
                          : p == RevenuePeriod.month
                          ? keys.revenuePage.monthChip
                          : keys.revenuePage.yearChip,
                      label: Text(p.displayLabel),
                      selected: isSelected,
                      onSelected: (_) => notifier.setPeriod(p),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              // Date navigator
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    key: keys.revenuePage.previousButton,
                    onPressed: () => notifier.navigatePrevious(),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  TextButton(
                    onPressed: () => notifier.goToToday(),
                    child: Text(
                      _periodLabel(data.period, data.selectedDate),
                      style: tt.titleSmall,
                    ),
                  ),
                  IconButton(
                    key: keys.revenuePage.nextButton,
                    onPressed: () => notifier.navigateNext(),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // KPI cards
              _KpiGrid(summary: data.summary),
              const SizedBox(height: 24),
              // Chart
              Text(
                'Trend',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: _TrendChart(data: data.trendData, color: cs.primary),
              ),
              const SizedBox(height: 24),
              // Breakdown
              Text(
                'Service Breakdown',
                style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              ...data.breakdown.map((item) => _BreakdownTile(item: item)),
            ],
          ),
        ),
      ),
    );
  }

  String _periodLabel(RevenuePeriod p, DateTime d) => switch (p) {
    RevenuePeriod.day => DateFormat('EEE, MMM d, y').format(d),
    RevenuePeriod.month => DateFormat('MMMM y').format(d),
    RevenuePeriod.year => '${d.year}',
  };
}

class _KpiGrid extends StatelessWidget {
  final RevenueSummaryEntity summary;
  const _KpiGrid({required this.summary});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.compactCurrency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.8,
      children: [
        _KpiCard(
          label: 'Total Revenue',
          value: fmt.format(summary.totalRevenue),
          icon: Icons.attach_money,
        ),
        _KpiCard(
          label: 'Net Earnings',
          value: fmt.format(summary.netEarnings),
          icon: Icons.account_balance_wallet,
        ),
        _KpiCard(
          label: 'Completed',
          value: '${summary.completedAppointments}',
          icon: Icons.check_circle_outline,
        ),
        _KpiCard(
          label: 'Canceled',
          value: '${summary.canceledAppointments}',
          icon: Icons.cancel_outlined,
        ),
      ],
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: cs.primary),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  final List<RevenueDataPoint> data;
  final Color color;
  const _TrendChart({required this.data, required this.color});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const Center(child: Text('No data'));
    final maxY =
        data.map((d) => d.amount).reduce((a, b) => a > b ? a : b) * 1.2;
    return BarChart(
      BarChartData(
        maxY: maxY,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= data.length) {
                  return const SizedBox.shrink();
                }
                return Text(
                  data[i].label,
                  style: Theme.of(context).textTheme.labelSmall,
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(),
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: false),
        barGroups: data.asMap().entries.map((e) {
          return BarChartGroupData(
            x: e.key,
            barRods: [
              BarChartRodData(
                toY: e.value.amount,
                color: color,
                width: 16,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _BreakdownTile extends StatelessWidget {
  final RevenueBreakdownItem item;
  const _BreakdownTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Text(
          '${item.count}',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        item.serviceName,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      trailing: Text(
        fmt.format(item.totalAmount),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
