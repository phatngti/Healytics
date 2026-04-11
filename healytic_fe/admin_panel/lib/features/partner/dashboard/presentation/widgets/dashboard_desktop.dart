import 'package:common/widgets/card/error_card.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/dashboard.provider.dart';
import '../providers/dashboard_state.dart';
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
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Dashboard',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Welcome back! Here\'s your '
              'business overview.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // KPI Cards Row
            KpiSummaryRow(stats: state.stats),

            const SizedBox(height: 24),

            // Row 2: Revenue Chart + Quick Actions
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 7,
                        child: RevenueChart(
                          data: state.revenueData,
                          selectedPeriod: state.selectedPeriod,
                          onPeriodChanged: (p) => ref
                              .read(dashboardProvider.notifier)
                              .setTimePeriod(p),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(flex: 3, child: const QuickActionsWidget()),
                    ],
                  );
                }
                return Column(
                  children: [
                    RevenueChart(
                      data: state.revenueData,
                      selectedPeriod: state.selectedPeriod,
                      onPeriodChanged: (p) =>
                          ref.read(dashboardProvider.notifier).setTimePeriod(p),
                    ),
                    const SizedBox(height: 16),
                    const QuickActionsWidget(),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Row 3: Service Performance +
            //         Employee Overview
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 6,
                        child: ServicePerformanceChart(
                          services: state.servicePerformance,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: EmployeeOverviewChart(
                          distribution: state.employeeDistribution,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    ServicePerformanceChart(services: state.servicePerformance),
                    const SizedBox(height: 16),
                    EmployeeOverviewChart(
                      distribution: state.employeeDistribution,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Row 4: Upcoming Appointments
            UpcomingAppointmentsWidget(
              appointments: state.upcomingAppointments,
            ),

            const SizedBox(height: 24),

            // Row 5: Schedule + Notifications +
            //         Inventory
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 900) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 4,
                        child: StaffScheduleWidget(
                          schedule: state.staffSchedule,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: NotificationCenterWidget(
                          notifications: state.notifications,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: InventoryAlertsWidget(
                          alerts: state.inventoryAlerts,
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  children: [
                    StaffScheduleWidget(schedule: state.staffSchedule),
                    const SizedBox(height: 16),
                    NotificationCenterWidget(
                      notifications: state.notifications,
                    ),
                    const SizedBox(height: 16),
                    InventoryAlertsWidget(alerts: state.inventoryAlerts),
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Row 6: Recent Reviews
            RecentReviewsWidget(reviews: state.recentReviews),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: CircularProgressIndicator(),
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
        padding: const EdgeInsets.all(48),
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
