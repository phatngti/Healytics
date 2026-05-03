import 'package:admin_panel/features/admin/dashboard/presentation/providers/admin_dashboard.provider.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/providers/admin_dashboard_state.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_booking_outcomes_panel.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_category_health_panel.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_finance_summary_panel.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_header.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_kpi_grid.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_notifications_panel.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_partial_warning.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_partner_rankings_panel.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_revenue_trend_panel.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_service_rankings_panel.widget.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/widgets/admin_dashboard_transaction_health_panel.widget.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdminDashboardContent extends HookConsumerWidget {
  const AdminDashboardContent({
    super.key,
    required this.state,
    required this.compact,
    required this.padding,
  });

  final AdminDashboardState state;
  final bool compact;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(adminDashboardProvider.notifier);

    final financeRow = compact
        ? Column(
            children: [
              AdminDashboardRevenueTrendPanel(
                points: state.revenueTrend,
                selectedPeriod: state.selectedPeriod,
                onPeriodChanged: notifier.setPeriod,
              ),
              AppDimens.verticalMedium,
              AdminDashboardFinanceSummaryPanel(overview: state.overview),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: AdminDashboardRevenueTrendPanel(
                  points: state.revenueTrend,
                  selectedPeriod: state.selectedPeriod,
                  onPeriodChanged: notifier.setPeriod,
                ),
              ),
              const SizedBox(width: AppDimens.spaceLg),
              Expanded(
                flex: 3,
                child: AdminDashboardFinanceSummaryPanel(
                  overview: state.overview,
                ),
              ),
            ],
          );

    final outcomesRow = compact
        ? Column(
            children: [
              AdminDashboardBookingOutcomesPanel(
                summary: state.bookingOutcomes,
              ),
              AppDimens.verticalMedium,
              AdminDashboardTransactionHealthPanel(
                health: state.transactionHealth,
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AdminDashboardBookingOutcomesPanel(
                  summary: state.bookingOutcomes,
                ),
              ),
              const SizedBox(width: AppDimens.spaceLg),
              Expanded(
                child: AdminDashboardTransactionHealthPanel(
                  health: state.transactionHealth,
                ),
              ),
            ],
          );

    final rankingsRow = compact
        ? Column(
            children: [
              AdminDashboardPartnerRankingsPanel(items: state.topPartners),
              AppDimens.verticalMedium,
              AdminDashboardServiceRankingsPanel(items: state.topServices),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AdminDashboardPartnerRankingsPanel(
                  items: state.topPartners,
                ),
              ),
              const SizedBox(width: AppDimens.spaceLg),
              Expanded(
                child: AdminDashboardServiceRankingsPanel(
                  items: state.topServices,
                ),
              ),
            ],
          );

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminDashboardHeader(
              selectedPeriod: state.selectedPeriod,
              lastUpdatedAt: state.lastUpdatedAt,
              isRefreshing: state.isRefreshing,
              onPeriodChanged: notifier.setPeriod,
              onRefresh: notifier.refresh,
              onOpenProviderQueue: () =>
                  context.go(const PartnerManagerRoute().location),
              onManageCategories: () =>
                  context.go(const CategoryHomeRoute().location),
            ),
            AppDimens.verticalLarge,
            AdminDashboardPartialWarning(failedSections: state.failedSections),
            if (state.failedSections.isNotEmpty) AppDimens.verticalMedium,
            AdminDashboardKpiGrid(overview: state.overview),
            AppDimens.verticalLarge,
            AppDimens.verticalLarge,
            financeRow,
            AppDimens.verticalLarge,
            outcomesRow,
            AppDimens.verticalLarge,
            rankingsRow,
            AppDimens.verticalLarge,
            if (compact)
              Column(
                children: [
                  AdminDashboardNotificationsPanel(items: state.notifications),
                  AppDimens.verticalMedium,
                  AdminDashboardCategoryHealthPanel(
                    categoryHealth: state.categoryHealth,
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: AdminDashboardNotificationsPanel(
                      items: state.notifications,
                    ),
                  ),
                  const SizedBox(width: AppDimens.spaceLg),
                  Expanded(
                    flex: 4,
                    child: AdminDashboardCategoryHealthPanel(
                      categoryHealth: state.categoryHealth,
                    ),
                  ),
                ],
              ),
            AppDimens.verticalLarge,
          ],
        ),
      ),
    );
  }
}
