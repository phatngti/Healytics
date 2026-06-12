import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;

import 'package:admin_openapi/api.dart' as openapi;
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

// ============================================================
// 1. ABSTRACT INTERFACE
// ============================================================

/// Abstract interface for admin dashboard data
/// operations.
abstract class AdminDashboardRemoteDataSource {
  /// Get overall dashboard KPIs for a given period.
  Future<AdminDashboardOverview> getOverview(
    AdminDashboardPeriod period,
  );

  /// Get daily revenue trend data points.
  Future<List<AdminDashboardRevenueTrendPoint>>
      getRevenueTrend(
    AdminDashboardPeriod period,
  );

  /// Get booking outcome summary (success/fail/cancel).
  Future<AdminDashboardBookingOutcomeSummary>
      getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  );

  /// Get transaction health breakdown.
  Future<AdminDashboardTransactionHealth>
      getTransactionHealth(
    AdminDashboardPeriod period,
  );

  /// Get top-performing partners ranked by revenue.
  Future<List<AdminPartnerRankingItem>> getTopPartners(
    AdminDashboardPeriod period,
  );

  /// Get top-performing services ranked by revenue.
  Future<List<AdminServiceRankingItem>> getTopServices(
    AdminDashboardPeriod period,
  );

  /// Get recent dashboard notifications/alerts.
  Future<List<AdminDashboardNotificationItem>>
      getNotifications();

  /// Get category health overview.
  Future<AdminCategoryHealth> getCategoryHealth();
}

// ============================================================
// 2. IMPLEMENTATION (Real API)
// ============================================================

/// Real implementation calling the NestJS admin
/// dashboard endpoints via [ApiClient.invokeAPI].
///
/// Once the OpenAPI client is regenerated with the
/// AdminDashboardApi class, this can be refactored
/// to use the typed API methods directly.
class AdminDashboardRemoteDataSourceImpl
    implements AdminDashboardRemoteDataSource {
  AdminDashboardRemoteDataSourceImpl({
    required this.apiService,
  });

  final ApiService apiService;

  static const _logName = 'AdminDashboardDataSource';

  // HTTP helpers.

  /// Performs a GET request against the admin
  /// dashboard API and returns the decoded JSON.
  Future<dynamic> _get(
    String path, {
    List<openapi.QueryParam> queryParams = const [],
  }) async {
    final response = await apiService.apiClient
        .invokeAPI(
      path,
      'GET',
      queryParams,
      null,
      <String, String>{},
      <String, String>{},
      'application/json',
    );

    if (response.statusCode >= 200 &&
        response.statusCode < 300) {
      return json.decode(response.body);
    }

    throw openapi.ApiException(
      response.statusCode,
      'Admin dashboard GET $path failed: '
      '${response.statusCode}',
    );
  }

  List<openapi.QueryParam> _periodParams(
    AdminDashboardPeriod period,
  ) => [openapi.QueryParam('period', period.apiValue)];

  // Safe numeric parsing.

  static double _toDouble(dynamic v) =>
      (v is num) ? v.toDouble() : double.tryParse('$v') ?? 0;

  static int _toInt(dynamic v) =>
      (v is num) ? v.toInt() : int.tryParse('$v') ?? 0;

  // Overview.

  @override
  Future<AdminDashboardOverview> getOverview(
    AdminDashboardPeriod period,
  ) async {
    try {
      final data = await _get(
        '/admin/dashboard/overview',
        queryParams: _periodParams(period),
      ) as Map<String, dynamic>;
      return _mapOverview(data);
    } catch (e, st) {
      developer.log(
        'getOverview failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminDashboardOverview _mapOverview(
    Map<String, dynamic> d,
  ) {
    return AdminDashboardOverview(
      grossRevenue: _toDouble(d['grossRevenue']),
      netRevenue: _toDouble(d['netRevenue']),
      refundAmount: _toDouble(d['refundAmount']),
      failedPaymentAmount:
          _toDouble(d['failedPaymentAmount']),
      averageBookingValue:
          _toDouble(d['averageBookingValue']),
      successfulTransactions:
          _toInt(d['successfulTransactions']),
      pendingTransactions:
          _toInt(d['pendingTransactions']),
      refundedTransactions:
          _toInt(d['refundedTransactions']),
      failedTransactions:
          _toInt(d['failedTransactions']),
      canceledTransactions:
          _toInt(d['canceledTransactions']),
      totalPartners: _toInt(d['totalPartners']),
      pendingPartnerReviews:
          _toInt(d['pendingPartnerReviews']),
      bookingSuccessRate:
          _toDouble(d['bookingSuccessRate']),
      bookingFailedRate:
          _toDouble(d['bookingFailedRate']),
      bookingCanceledRate:
          _toDouble(d['bookingCanceledRate']),
      notificationVolume:
          _toInt(d['notificationVolume']),
    );
  }

  // Revenue trend.

  @override
  Future<List<AdminDashboardRevenueTrendPoint>>
      getRevenueTrend(
    AdminDashboardPeriod period,
  ) async {
    try {
      final data = await _get(
        '/admin/dashboard/revenue-trend',
        queryParams: _periodParams(period),
      ) as List<dynamic>;
      return data
          .cast<Map<String, dynamic>>()
          .map(_mapRevenueTrendPoint)
          .toList();
    } catch (e, st) {
      developer.log(
        'getRevenueTrend failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminDashboardRevenueTrendPoint _mapRevenueTrendPoint(
    Map<String, dynamic> d,
  ) {
    return AdminDashboardRevenueTrendPoint(
      date: DateTime.tryParse('${d['date']}') ??
          DateTime.now(),
      grossRevenue: _toDouble(d['grossRevenue']),
      netRevenue: _toDouble(d['netRevenue']),
      refundAmount: _toDouble(d['refundAmount']),
      transactionCount:
          _toInt(d['transactionCount']),
      successfulBookingCount:
          _toInt(d['successfulBookingCount']),
    );
  }

  // Booking outcome.

  @override
  Future<AdminDashboardBookingOutcomeSummary>
      getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  ) async {
    try {
      final data = await _get(
        '/admin/dashboard/booking-outcomes',
        queryParams: _periodParams(period),
      ) as Map<String, dynamic>;
      return _mapBookingOutcome(data);
    } catch (e, st) {
      developer.log(
        'getBookingOutcomeSummary failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminDashboardBookingOutcomeSummary _mapBookingOutcome(
    Map<String, dynamic> d,
  ) {
    return AdminDashboardBookingOutcomeSummary(
      totalBookings: _toInt(d['totalBookings']),
      success: _mapOutcomeMetric(
        d['success'] as Map<String, dynamic>? ?? {},
      ),
      failed: _mapOutcomeMetric(
        d['failed'] as Map<String, dynamic>? ?? {},
      ),
      canceled: _mapOutcomeMetric(
        d['canceled'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  AdminOutcomeMetric _mapOutcomeMetric(
    Map<String, dynamic> d,
  ) {
    return AdminOutcomeMetric(
      count: _toInt(d['count']),
      rate: _toDouble(d['rate']),
    );
  }

  // Transaction health.

  @override
  Future<AdminDashboardTransactionHealth>
      getTransactionHealth(
    AdminDashboardPeriod period,
  ) async {
    try {
      final data = await _get(
        '/admin/dashboard/transaction-health',
        queryParams: _periodParams(period),
      ) as Map<String, dynamic>;
      return _mapTransactionHealth(data);
    } catch (e, st) {
      developer.log(
        'getTransactionHealth failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminDashboardTransactionHealth
      _mapTransactionHealth(
    Map<String, dynamic> d,
  ) {
    return AdminDashboardTransactionHealth(
      totalTransactions:
          _toInt(d['totalTransactions']),
      paid: _toInt(d['paid']),
      pending: _toInt(d['pending']),
      refunded: _toInt(d['refunded']),
      failed: _toInt(d['failed']),
      canceled: _toInt(d['canceled']),
      grossRevenue: _toDouble(d['grossRevenue']),
      refundAmount: _toDouble(d['refundAmount']),
      failedAmount: _toDouble(d['failedAmount']),
    );
  }

  // Top partners.

  @override
  Future<List<AdminPartnerRankingItem>> getTopPartners(
    AdminDashboardPeriod period,
  ) async {
    try {
      final data = await _get(
        '/admin/dashboard/top-partners',
        queryParams: _periodParams(period),
      ) as List<dynamic>;
      return data
          .cast<Map<String, dynamic>>()
          .map(_mapPartnerRanking)
          .toList();
    } catch (e, st) {
      developer.log(
        'getTopPartners failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminPartnerRankingItem _mapPartnerRanking(
    Map<String, dynamic> d,
  ) {
    return AdminPartnerRankingItem(
      partnerId: '${d['partnerId'] ?? ''}',
      partnerName: '${d['partnerName'] ?? 'Unknown'}',
      rank: _toInt(d['rank']),
      grossRevenue: _toDouble(d['grossRevenue']),
      bookingCount: _toInt(d['bookingCount']),
      successfulBookingRate:
          _toDouble(d['successfulBookingRate']),
      verificationStatus: _mapVerificationStatus(
        '${d['verificationStatus'] ?? 'approved'}',
      ),
    );
  }

  AdminPartnerVerificationStatus
      _mapVerificationStatus(String value) {
    return switch (value) {
      'pending' =>
        AdminPartnerVerificationStatus.pending,
      'changesRequired' =>
        AdminPartnerVerificationStatus
            .changesRequired,
      'rejected' =>
        AdminPartnerVerificationStatus.rejected,
      _ => AdminPartnerVerificationStatus.approved,
    };
  }

  // Top services.

  @override
  Future<List<AdminServiceRankingItem>> getTopServices(
    AdminDashboardPeriod period,
  ) async {
    try {
      final data = await _get(
        '/admin/dashboard/top-services',
        queryParams: _periodParams(period),
      ) as List<dynamic>;
      return data
          .cast<Map<String, dynamic>>()
          .map(_mapServiceRanking)
          .toList();
    } catch (e, st) {
      developer.log(
        'getTopServices failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminServiceRankingItem _mapServiceRanking(
    Map<String, dynamic> d,
  ) {
    return AdminServiceRankingItem(
      serviceId: '${d['serviceId'] ?? ''}',
      serviceName:
          '${d['serviceName'] ?? 'Unknown'}',
      categoryName:
          '${d['categoryName'] ?? 'General'}',
      partnerName:
          '${d['partnerName'] ?? 'Unknown'}',
      rank: _toInt(d['rank']),
      grossRevenue: _toDouble(d['grossRevenue']),
      bookingCount: _toInt(d['bookingCount']),
    );
  }

  // Notifications.

  @override
  Future<List<AdminDashboardNotificationItem>>
      getNotifications() async {
    try {
      final data = await _get(
        '/admin/dashboard/notifications',
      ) as List<dynamic>;
      return data
          .cast<Map<String, dynamic>>()
          .map(_mapNotification)
          .toList();
    } catch (e, st) {
      developer.log(
        'getNotifications failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminDashboardNotificationItem _mapNotification(
    Map<String, dynamic> d,
  ) {
    return AdminDashboardNotificationItem(
      id: '${d['id'] ?? ''}',
      title: '${d['title'] ?? ''}',
      body: '${d['body'] ?? ''}',
      createdAt:
          DateTime.tryParse('${d['createdAt']}') ??
              DateTime.now(),
      type: _mapNotificationType(
        '${d['type'] ?? 'operations'}',
      ),
      priority: _mapNotificationPriority(
        '${d['priority'] ?? 'medium'}',
      ),
      isRead: d['isRead'] == true,
      isBroadcast: d['isBroadcast'] == true,
    );
  }

  AdminDashboardNotificationType
      _mapNotificationType(String value) {
    return switch (value) {
      'broadcast' =>
        AdminDashboardNotificationType.broadcast,
      'payment' =>
        AdminDashboardNotificationType.payment,
      'review' =>
        AdminDashboardNotificationType.review,
      'category' =>
        AdminDashboardNotificationType.category,
      _ => AdminDashboardNotificationType.operations,
    };
  }

  AdminDashboardNotificationPriority
      _mapNotificationPriority(String value) {
    return switch (value) {
      'low' => AdminDashboardNotificationPriority.low,
      'high' =>
        AdminDashboardNotificationPriority.high,
      'critical' =>
        AdminDashboardNotificationPriority.critical,
      _ => AdminDashboardNotificationPriority.medium,
    };
  }

  // Category health.

  @override
  Future<AdminCategoryHealth>
      getCategoryHealth() async {
    try {
      final data = await _get(
        '/admin/dashboard/category-health',
      ) as Map<String, dynamic>;
      return _mapCategoryHealth(data);
    } catch (e, st) {
      developer.log(
        'getCategoryHealth failed',
        name: _logName,
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  AdminCategoryHealth _mapCategoryHealth(
    Map<String, dynamic> d,
  ) {
    final rawCategories =
        d['topCategories'] as List<dynamic>? ?? [];

    return AdminCategoryHealth(
      totalCategories:
          _toInt(d['totalCategories']),
      activeCategories:
          _toInt(d['activeCategories']),
      inactiveCategories:
          _toInt(d['inactiveCategories']),
      rootCategories:
          _toInt(d['rootCategories']),
      subCategories:
          _toInt(d['subCategories']),
      emptyCategories:
          _toInt(d['emptyCategories']),
      totalMappedServices:
          _toInt(d['totalMappedServices']),
      topCategories: rawCategories
          .cast<Map<String, dynamic>>()
          .map(_mapCategorySnapshot)
          .toList(),
    );
  }

  AdminCategorySnapshot _mapCategorySnapshot(
    Map<String, dynamic> d,
  ) {
    return AdminCategorySnapshot(
      id: '${d['id'] ?? ''}',
      name: '${d['name'] ?? ''}',
      serviceCount: _toInt(d['serviceCount']),
      subCategoryCount: _toInt(d['subCategoryCount']),
      isRoot: d['isRoot'] != false,
      isActive: d['isActive'] != false,
    );
  }
}

// ============================================================
// 3. MOCK IMPLEMENTATION
// ============================================================

/// Mock implementation with rich static data for
/// UI development and testing.
class AdminDashboardRemoteDataSourceMock
    implements AdminDashboardRemoteDataSource {
  @override
  Future<AdminCategoryHealth>
      getCategoryHealth() async {
    await Future.delayed(
      const Duration(milliseconds: 360),
    );
    return AdminDashboardMockData.categoryHealth();
  }

  @override
  Future<AdminDashboardBookingOutcomeSummary>
      getBookingOutcomeSummary(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 340),
    );
    return AdminDashboardMockData.bookingOutcomes(
      period,
    );
  }

  @override
  Future<List<AdminDashboardNotificationItem>>
      getNotifications() async {
    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    return AdminDashboardMockData.notifications();
  }

  @override
  Future<AdminDashboardOverview> getOverview(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 420),
    );
    return AdminDashboardMockData.overview(period);
  }

  @override
  Future<List<AdminPartnerRankingItem>>
      getTopPartners(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 440),
    );
    return AdminDashboardMockData.topPartners(
      period,
    );
  }

  @override
  Future<List<AdminDashboardRevenueTrendPoint>>
      getRevenueTrend(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 520),
    );
    return AdminDashboardMockData.revenueTrend(
      period,
    );
  }

  @override
  Future<List<AdminServiceRankingItem>>
      getTopServices(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 460),
    );
    return AdminDashboardMockData.topServices(
      period,
    );
  }

  @override
  Future<AdminDashboardTransactionHealth>
      getTransactionHealth(
    AdminDashboardPeriod period,
  ) async {
    await Future.delayed(
      const Duration(milliseconds: 380),
    );
    return AdminDashboardMockData
        .transactionHealth(period);
  }
}

// ============================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================

@riverpod
AdminDashboardRemoteDataSource
    adminDashboardRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return AdminDashboardRemoteDataSourceMock();
  }

  final apiService = ref.read(apiServiceProvider);
  return AdminDashboardRemoteDataSourceImpl(
    apiService: apiService,
  );
}
