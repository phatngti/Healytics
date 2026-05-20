import 'package:common/utils/demensions.dart';
import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/dashboard.provider.dart';
import '../providers/dashboard_state.dart';
import 'dashboard_constants.dart';
import 'employee_overview_chart.widget.dart';
import 'inventory_alerts.widget.dart';
import 'kpi_summary_row.widget.dart';
import 'notification_center.widget.dart';
import 'quick_actions.widget.dart';
import 'recent_reviews.widget.dart';
import 'revenue_chart.widget.dart';
import 'service_performance_chart.widget.dart';
import 'staff_schedule.widget.dart';
import 'upcoming_appointments.widget.dart';

/// Desktop layout orchestrator for the dashboard.
///
/// Arranges all 10 dashboard sections in a responsive
/// two-column grid layout with appropriate spacing.
class DashboardDesktop extends HookConsumerWidget {
  const DashboardDesktop({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(dashboardProvider);

    return asyncState.when(
      loading: () => const _LoadingState(),
      error: (error, stack) => _ErrorState(
        error: error,
        stackTrace: stack,
        onRetry: () => ref.read(dashboardProvider.notifier).refresh(),
      ),
      data: (state) => _DashboardContent(state: state),
    );
  }
}

class _DashboardContent extends ConsumerWidget {
  const _DashboardContent({required this.state});

  final DashboardState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.read(dashboardProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppDimens.paddingAllLarge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Dashboard',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: AppDimens.fontWeightBold,
              ),
            ),
            AppDimens.verticalExtraSmall,
            Text(
              'Welcome back! Here\'s your '
              'business overview.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalLarge,

            // KPI Cards Row
            KpiSummaryRow(stats: state.stats),
            AppDimens.verticalLarge,

            // Row 2: Revenue Chart + Quick Actions
            _ResponsiveRow(
              children: [
                Expanded(
                  flex: DashboardLayout.revenueChartFlex,
                  child: RevenueChart(
                    data: state.revenueData,
                    selectedPeriod: state.selectedPeriod,
                    onPeriodChanged: (p) =>
                        ref.read(dashboardProvider.notifier).setTimePeriod(p),
                  ),
                ),
                Expanded(
                  flex: DashboardLayout.quickActionsFlex,
                  child: const QuickActionsWidget(),
                ),
              ],
            ),
            AppDimens.verticalLarge,

            // Row 3: Service Performance +
            //         Employee Overview
            _ResponsiveRow(
              children: [
                Expanded(
                  flex: DashboardLayout.servicePerformanceFlex,
                  child: ServicePerformanceChart(
                    services: state.servicePerformance,
                  ),
                ),
                Expanded(
                  flex: DashboardLayout.employeeOverviewFlex,
                  child: EmployeeOverviewChart(
                    distribution: state.employeeDistribution,
                  ),
                ),
              ],
            ),
            AppDimens.verticalLarge,

            // Row 4: Upcoming Appointments
            UpcomingAppointmentsWidget(
              appointments: state.upcomingAppointments,
            ),
            AppDimens.verticalLarge,

            // Row 5: Schedule + Notifications +
            //         Inventory
            _ResponsiveRow(
              children: [
                Expanded(
                  flex: DashboardLayout.staffScheduleFlex,
                  child: StaffScheduleWidget(schedule: state.staffSchedule),
                ),
                Expanded(
                  flex: DashboardLayout.notificationFlex,
                  child: NotificationCenterWidget(
                    notifications: state.notifications,
                  ),
                ),
                Expanded(
                  flex: DashboardLayout.inventoryFlex,
                  child: InventoryAlertsWidget(alerts: state.inventoryAlerts),
                ),
              ],
            ),
            AppDimens.verticalLarge,

            // Row 6: Recent Reviews
            RecentReviewsWidget(reviews: state.recentReviews),
            AppDimens.verticalLarge,
          ],
        ),
      ),
    );
  }
}

/// Adaptive row that switches between horizontal
/// [Row] and vertical [Column] based on available
/// width against [DashboardLayout.wideBreakpoint].
class _ResponsiveRow extends StatelessWidget {
  const _ResponsiveRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > DashboardLayout.wideBreakpoint;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _interleave(children, AppDimens.horizontalMedium),
          );
        }

        return Column(
          children: _interleave(children, AppDimens.verticalMedium),
        );
      },
    );
  }

  /// Inserts [separator] between each widget in
  /// [items], preserving the original widgets.
  List<Widget> _interleave(List<Widget> items, Widget separator) {
    if (items.length <= 1) return items;
    return [
      for (int i = 0; i < items.length; i++) ...[
        if (i > 0) separator,
        items[i],
      ],
    ];
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DashboardSizes.statePadding),
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.error,
    this.stackTrace,
    required this.onRetry,
  });

  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(DashboardSizes.statePadding),
        child: ErrorCard(
          title: 'Failed to load dashboard',
          error: error,
          stackTrace: stackTrace,
          onRetry: onRetry,
        ),
      ),
    );
  }
}
