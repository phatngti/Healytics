import 'dart:developer' as developer;

import 'package:admin_panel/features/admin/dashboard/datasource/admin_dashboard_impl.repository.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_alert.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_booking_outcome.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_category_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_revenue_trend_point.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_section.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_service_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_transaction_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/presentation/providers/admin_dashboard_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_dashboard.provider.g.dart';

@riverpod
class AdminDashboardNotifier extends _$AdminDashboardNotifier {
  @override
  FutureOr<AdminDashboardState> build() =>
      _fetchAll(AdminDashboardPeriod.thirtyDays);

  Future<AdminDashboardState> _fetchAll(AdminDashboardPeriod period) async {
    final repo = ref.read(adminDashboardRepositoryProvider);

    final results = await Future.wait([
      _safeCall(AdminDashboardSection.overview, () => repo.getOverview(period)),
      _safeCall(
        AdminDashboardSection.revenueTrend,
        () => repo.getRevenueTrend(period),
      ),
      _safeCall(
        AdminDashboardSection.bookingOutcomes,
        () => repo.getBookingOutcomeSummary(period),
      ),
      _safeCall(
        AdminDashboardSection.transactionHealth,
        () => repo.getTransactionHealth(period),
      ),
      _safeCall(
        AdminDashboardSection.topPartners,
        () => repo.getTopPartners(period),
      ),
      _safeCall(
        AdminDashboardSection.topServices,
        () => repo.getTopServices(period),
      ),
      _safeCall(AdminDashboardSection.notifications, repo.getNotifications),
      _safeCall(AdminDashboardSection.categoryHealth, repo.getCategoryHealth),
    ]);

    final failedSections = results
        .where((result) => result.value == null)
        .map((result) => result.section)
        .toList();

    final overview =
        _pick<AdminDashboardOverview>(results, 0) ??
        const AdminDashboardOverview();
    final bookingOutcomes =
        _pick<AdminDashboardBookingOutcomeSummary>(results, 2) ??
        const AdminDashboardBookingOutcomeSummary();
    final transactionHealth =
        _pick<AdminDashboardTransactionHealth>(results, 3) ??
        const AdminDashboardTransactionHealth();
    final notifications =
        _pick<List<AdminDashboardNotificationItem>>(results, 6) ?? [];
    final categoryHealth =
        _pick<AdminCategoryHealth>(results, 7) ?? const AdminCategoryHealth();

    return AdminDashboardState(
      overview: overview,
      revenueTrend:
          _pick<List<AdminDashboardRevenueTrendPoint>>(results, 1) ?? [],
      bookingOutcomes: bookingOutcomes,
      transactionHealth: transactionHealth,
      topPartners: _pick<List<AdminPartnerRankingItem>>(results, 4) ?? [],
      topServices: _pick<List<AdminServiceRankingItem>>(results, 5) ?? [],
      notifications: notifications,
      categoryHealth: categoryHealth,
      alerts: _buildAlerts(
        overview: overview,
        bookingOutcomes: bookingOutcomes,
        transactionHealth: transactionHealth,
        notifications: notifications,
        categoryHealth: categoryHealth,
      ),
      selectedPeriod: period,
      failedSections: failedSections,
      lastUpdatedAt: DateTime.now(),
    );
  }

  T? _pick<T>(List<_SectionResult<dynamic>> results, int index) {
    final value = results[index].value;
    if (value is T) {
      return value;
    }
    return null;
  }

  Future<_SectionResult<T>> _safeCall<T>(
    AdminDashboardSection section,
    Future<T> Function() call,
  ) async {
    try {
      return _SectionResult(section: section, value: await call());
    } catch (error, stackTrace) {
      developer.log(
        'Admin dashboard section failed',
        name: 'AdminDashboardNotifier',
        error: error,
        stackTrace: stackTrace,
      );
      return _SectionResult(section: section);
    }
  }

  Future<void> refresh() async {
    final current = state.value;
    final period = current?.selectedPeriod ?? AdminDashboardPeriod.thirtyDays;

    if (current != null) {
      state = AsyncData(current.copyWith(isRefreshing: true));
    } else {
      state = const AsyncLoading<AdminDashboardState>();
    }
    state = await AsyncValue.guard(() => _fetchAll(period));
  }

  Future<void> setPeriod(AdminDashboardPeriod period) async {
    final current = state.value;
    if (current == null || current.selectedPeriod == period) {
      return;
    }

    state = AsyncData(
      current.copyWith(selectedPeriod: period, isRefreshing: true),
    );

    final repo = ref.read(adminDashboardRepositoryProvider);
    final results = await Future.wait([
      _safeCall(AdminDashboardSection.overview, () => repo.getOverview(period)),
      _safeCall(
        AdminDashboardSection.revenueTrend,
        () => repo.getRevenueTrend(period),
      ),
      _safeCall(
        AdminDashboardSection.bookingOutcomes,
        () => repo.getBookingOutcomeSummary(period),
      ),
      _safeCall(
        AdminDashboardSection.transactionHealth,
        () => repo.getTransactionHealth(period),
      ),
      _safeCall(
        AdminDashboardSection.topPartners,
        () => repo.getTopPartners(period),
      ),
      _safeCall(
        AdminDashboardSection.topServices,
        () => repo.getTopServices(period),
      ),
    ]);

    final overview =
        _pick<AdminDashboardOverview>(results, 0) ?? current.overview;
    final bookingOutcomes =
        _pick<AdminDashboardBookingOutcomeSummary>(results, 2) ??
        current.bookingOutcomes;
    final transactionHealth =
        _pick<AdminDashboardTransactionHealth>(results, 3) ??
        current.transactionHealth;

    state = AsyncData(
      current.copyWith(
        overview: overview,
        revenueTrend:
            _pick<List<AdminDashboardRevenueTrendPoint>>(results, 1) ??
            current.revenueTrend,
        bookingOutcomes: bookingOutcomes,
        transactionHealth: transactionHealth,
        topPartners:
            _pick<List<AdminPartnerRankingItem>>(results, 4) ??
            current.topPartners,
        topServices:
            _pick<List<AdminServiceRankingItem>>(results, 5) ??
            current.topServices,
        alerts: _buildAlerts(
          overview: overview,
          bookingOutcomes: bookingOutcomes,
          transactionHealth: transactionHealth,
          notifications: current.notifications,
          categoryHealth: current.categoryHealth,
        ),
        selectedPeriod: period,
        failedSections: {
          ...current.failedSections.where(
            (section) => !results.any((item) => item.section == section),
          ),
          ...results
              .where((result) => result.value == null)
              .map((result) => result.section),
        }.toList(),
        lastUpdatedAt: DateTime.now(),
        isRefreshing: false,
      ),
    );
  }

  List<AdminDashboardAlert> _buildAlerts({
    required AdminDashboardOverview overview,
    required AdminDashboardBookingOutcomeSummary bookingOutcomes,
    required AdminDashboardTransactionHealth transactionHealth,
    required List<AdminDashboardNotificationItem> notifications,
    required AdminCategoryHealth categoryHealth,
  }) {
    final alerts = <AdminDashboardAlert>[];

    if (overview.pendingPartnerReviews >= 20) {
      alerts.add(
        AdminDashboardAlert(
          id: 'partner-review-backlog',
          title: 'Partner review backlog',
          description:
              '${overview.pendingPartnerReviews} partner applications are still waiting for admin review.',
          severity: AdminDashboardAlertSeverity.warning,
          section: AdminDashboardSection.overview,
        ),
      );
    }

    if (bookingOutcomes.failed.rate >= 2.5) {
      alerts.add(
        AdminDashboardAlert(
          id: 'booking-failure-rate',
          title: 'Booking failure rate elevated',
          description:
              'Failed bookings account for ${bookingOutcomes.failed.rate.toStringAsFixed(2)}% of the selected period.',
          severity: AdminDashboardAlertSeverity.critical,
          section: AdminDashboardSection.bookingOutcomes,
        ),
      );
    }

    if (bookingOutcomes.canceled.rate >= 5) {
      alerts.add(
        AdminDashboardAlert(
          id: 'booking-cancel-rate',
          title: 'Cancellation pressure increasing',
          description:
              'Canceled bookings reached ${bookingOutcomes.canceled.rate.toStringAsFixed(2)}% of all bookings.',
          severity: AdminDashboardAlertSeverity.warning,
          section: AdminDashboardSection.bookingOutcomes,
        ),
      );
    }

    final refundRatio = overview.grossRevenue == 0
        ? 0.0
        : transactionHealth.refundAmount / overview.grossRevenue;
    if (refundRatio >= 0.02) {
      alerts.add(
        AdminDashboardAlert(
          id: 'refund-ratio',
          title: 'Refund exposure above baseline',
          description:
              'Refund volume is ${(refundRatio * 100).toStringAsFixed(2)}% of gross revenue.',
          severity: AdminDashboardAlertSeverity.info,
          section: AdminDashboardSection.transactionHealth,
        ),
      );
    }

    if (categoryHealth.emptyCategories > 0) {
      alerts.add(
        AdminDashboardAlert(
          id: 'empty-categories',
          title: 'Empty categories need cleanup',
          description:
              '${categoryHealth.emptyCategories} categories currently have no mapped services.',
          severity: AdminDashboardAlertSeverity.info,
          section: AdminDashboardSection.categoryHealth,
        ),
      );
    }

    final urgentNotifications = notifications
        .where(
          (item) =>
              !item.isRead &&
              (item.priority == AdminDashboardNotificationPriority.high ||
                  item.priority == AdminDashboardNotificationPriority.critical),
        )
        .length;
    if (urgentNotifications > 0) {
      alerts.add(
        AdminDashboardAlert(
          id: 'urgent-notifications',
          title: 'Unread high-priority notifications',
          description:
              '$urgentNotifications high-priority notification items still need attention.',
          severity: AdminDashboardAlertSeverity.warning,
          section: AdminDashboardSection.notifications,
        ),
      );
    }

    if (alerts.isEmpty) {
      alerts.add(
        const AdminDashboardAlert(
          id: 'stable-operations',
          title: 'Operations stable',
          description:
              'Core marketplace metrics are within the expected operating range.',
          severity: AdminDashboardAlertSeverity.success,
          section: AdminDashboardSection.overview,
        ),
      );
    }

    return alerts;
  }
}

class _SectionResult<T> {
  const _SectionResult({required this.section, this.value});

  final AdminDashboardSection section;
  final T? value;
}
