import 'dart:async';

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/admin/dashboard/datasource/data/admin_dashboard_mock_data.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_booking_outcome.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_category_health.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_notification.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_overview.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_partner_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_period.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_revenue_trend_point.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_service_ranking.entity.dart';
import 'package:admin_panel/features/admin/dashboard/domain/admin_dashboard_transaction_health.entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_dashboard_remote.datasource.g.dart';

abstract class AdminDashboardRemoteDataSource {
  Future<AdminDashboardOverview> getOverview(AdminDashboardPeriod period);

  Future<List<AdminDashboardRevenueTrendPoint>> getRevenueTrend(
    AdminDashboardPeriod period,
  );

  Future<AdminDashboardBookingOutcomeSummary> getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  );

  Future<AdminDashboardTransactionHealth> getTransactionHealth(
    AdminDashboardPeriod period,
  );

  Future<List<AdminPartnerRankingItem>> getTopPartners(
    AdminDashboardPeriod period,
  );

  Future<List<AdminServiceRankingItem>> getTopServices(
    AdminDashboardPeriod period,
  );

  Future<List<AdminDashboardNotificationItem>> getNotifications();

  Future<AdminCategoryHealth> getCategoryHealth();
}

class AdminDashboardRemoteDataSourceImpl
    implements AdminDashboardRemoteDataSource {
  AdminDashboardRemoteDataSourceImpl({required this.apiService});

  final ApiService apiService;

  Never _notReady() {
    throw UnimplementedError('Admin dashboard API not integrated yet');
  }

  @override
  Future<AdminCategoryHealth> getCategoryHealth() async => _notReady();

  @override
  Future<AdminDashboardBookingOutcomeSummary> getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  ) async => _notReady();

  @override
  Future<List<AdminDashboardNotificationItem>> getNotifications() async =>
      _notReady();

  @override
  Future<AdminDashboardOverview> getOverview(
    AdminDashboardPeriod period,
  ) async => _notReady();

  @override
  Future<List<AdminPartnerRankingItem>> getTopPartners(
    AdminDashboardPeriod period,
  ) async => _notReady();

  @override
  Future<List<AdminDashboardRevenueTrendPoint>> getRevenueTrend(
    AdminDashboardPeriod period,
  ) async => _notReady();

  @override
  Future<List<AdminServiceRankingItem>> getTopServices(
    AdminDashboardPeriod period,
  ) async => _notReady();

  @override
  Future<AdminDashboardTransactionHealth> getTransactionHealth(
    AdminDashboardPeriod period,
  ) async => _notReady();
}

class AdminDashboardRemoteDataSourceMock
    implements AdminDashboardRemoteDataSource {
  @override
  Future<AdminCategoryHealth> getCategoryHealth() async {
    await Future.delayed(const Duration(milliseconds: 360));
    return AdminDashboardMockData.categoryHealth();
  }

  @override
  Future<AdminDashboardBookingOutcomeSummary> getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 340));
    return AdminDashboardMockData.bookingOutcomes(period);
  }

  @override
  Future<List<AdminDashboardNotificationItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return AdminDashboardMockData.notifications();
  }

  @override
  Future<AdminDashboardOverview> getOverview(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 420));
    return AdminDashboardMockData.overview(period);
  }

  @override
  Future<List<AdminPartnerRankingItem>> getTopPartners(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 440));
    return AdminDashboardMockData.topPartners(period);
  }

  @override
  Future<List<AdminDashboardRevenueTrendPoint>> getRevenueTrend(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 520));
    return AdminDashboardMockData.revenueTrend(period);
  }

  @override
  Future<List<AdminServiceRankingItem>> getTopServices(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 460));
    return AdminDashboardMockData.topServices(period);
  }

  @override
  Future<AdminDashboardTransactionHealth> getTransactionHealth(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 380));
    return AdminDashboardMockData.transactionHealth(period);
  }
}

@riverpod
AdminDashboardRemoteDataSource adminDashboardRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return AdminDashboardRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return AdminDashboardRemoteDataSourceImpl(apiService: apiService);
}
