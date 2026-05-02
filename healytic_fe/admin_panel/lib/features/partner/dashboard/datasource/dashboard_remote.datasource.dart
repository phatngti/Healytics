import 'dart:developer' as developer;

import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/providers/api.provider.dart';
import 'package:admin_panel/core/services/api.service.dart';
import 'package:admin_panel/features/partner/dashboard/datasource/dashboard_mock_data.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_notification.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_review.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_stats.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/dashboard_time_period.dart';
import 'package:admin_panel/features/partner/dashboard/domain/employee_distribution.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/inventory_alert.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/revenue_data_point.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/service_performance.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/staff_schedule.entity.dart';
import 'package:admin_panel/features/partner/dashboard/domain/upcoming_appointment.entity.dart';
import 'package:admin_openapi/api.dart' hide DashboardTimePeriod;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_remote.datasource.g.dart';

// ============================================================
// 1. ABSTRACT INTERFACE
// ============================================================

/// Contract for dashboard remote data operations.
abstract class DashboardRemoteDataSource {
  /// Fetches aggregated KPI stats for [period].
  Future<DashboardStats> getDashboardStats({DashboardTimePeriod? period});

  /// Fetches revenue time-series for [period].
  Future<List<RevenueDataPoint>> getRevenueData(DashboardTimePeriod period);

  /// Fetches upcoming appointments (max [limit]).
  Future<List<UpcomingAppointment>> getUpcomingAppointments({int limit = 5});

  /// Fetches service performance metrics.
  Future<List<ServicePerformance>> getServicePerformance();

  /// Fetches employee role/status distribution.
  Future<List<EmployeeDistribution>> getEmployeeDistribution();

  /// Fetches recent customer reviews (max [limit]).
  Future<List<DashboardReview>> getRecentReviews({int limit = 5});

  /// Fetches staff schedule for [date].
  Future<List<StaffScheduleEntry>> getStaffSchedule(DateTime date);

  /// Fetches dashboard notifications (max [limit]).
  Future<List<DashboardNotification>> getNotifications({int limit = 10});

  /// Fetches inventory alerts.
  Future<List<InventoryAlert>> getInventoryAlerts();
}

// ============================================================
// 2. REAL API IMPLEMENTATION
// ============================================================

/// Real implementation using the generated
/// [PartnerDashboardApi] OpenAPI client.
class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({required ApiService apiService})
    : _api = apiService.partnerDashboardApi;

  final PartnerDashboardApi _api;

  @override
  Future<DashboardStats> getDashboardStats({
    DashboardTimePeriod? period,
  }) async {
    final dto = await _api.partnerDashboardControllerGetStats(
      period: period?.value,
    );
    if (dto == null) {
      throw DashboardDataException('Stats response was null');
    }
    return _mapStatsDto(dto);
  }

  @override
  Future<List<RevenueDataPoint>> getRevenueData(
    DashboardTimePeriod period,
  ) async {
    final dtos = await _api.partnerDashboardControllerGetRevenue(
      period: period.value,
    );
    return dtos?.map(_mapRevenueDto).toList() ?? [];
  }

  @override
  Future<List<UpcomingAppointment>> getUpcomingAppointments({
    int limit = 5,
  }) async {
    final dtos = await _api.partnerDashboardControllerGetUpcomingAppointments(
      limit: limit,
    );
    return dtos?.map(_mapAppointmentDto).toList() ?? [];
  }

  @override
  Future<List<ServicePerformance>> getServicePerformance() async {
    final dtos = await _api.partnerDashboardControllerGetServicePerformance();
    return dtos?.map(_mapServiceDto).toList() ?? [];
  }

  @override
  Future<List<EmployeeDistribution>> getEmployeeDistribution() async {
    final dtos = await _api.partnerDashboardControllerGetEmployeeDistribution();
    return dtos?.map(_mapEmployeeDto).toList() ?? [];
  }

  @override
  Future<List<DashboardReview>> getRecentReviews({int limit = 5}) async {
    final dtos = await _api.partnerDashboardControllerGetRecentReviews(
      limit: limit,
    );
    return dtos?.map(_mapReviewDto).toList() ?? [];
  }

  @override
  Future<List<StaffScheduleEntry>> getStaffSchedule(DateTime date) async {
    final dateStr =
        '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
    final dtos = await _api.partnerDashboardControllerGetStaffSchedule(dateStr);
    return dtos?.map(_mapScheduleDto).toList() ?? [];
  }

  @override
  Future<List<DashboardNotification>> getNotifications({int limit = 10}) async {
    final dtos = await _api.partnerDashboardControllerGetNotifications(
      limit: limit,
    );
    return dtos?.map(_mapNotificationDto).toList() ?? [];
  }

  @override
  Future<List<InventoryAlert>> getInventoryAlerts() async {
    final dtos = await _api.partnerDashboardControllerGetInventoryAlerts();
    return dtos?.map(_mapInventoryDto).toList() ?? [];
  }

  // ── Private DTO → Entity Mappers ──────────────

  DashboardStats _mapStatsDto(DashboardStatsResponseDto dto) {
    return DashboardStats(
      totalAppointments: dto.totalAppointments.toInt(),
      completedAppointments: dto.completedAppointments.toInt(),
      cancelledAppointments: dto.cancelledAppointments.toInt(),
      pendingAppointments: dto.pendingAppointments.toInt(),
      totalRevenue: dto.totalRevenue.toDouble(),
      revenueGrowthPercent: dto.revenueGrowthPercent.toDouble(),
      totalServices: dto.totalServices.toInt(),
      activeServices: dto.activeServices.toInt(),
      totalEmployees: dto.totalEmployees.toInt(),
      activeEmployees: dto.activeEmployees.toInt(),
      averageRating: dto.averageRating.toDouble(),
      totalReviews: dto.totalReviews.toInt(),
    );
  }

  RevenueDataPoint _mapRevenueDto(RevenueDataPointDto dto) {
    return RevenueDataPoint(
      date: DateTime.tryParse(dto.date) ?? DateTime.now(),
      revenue: dto.revenue.toDouble(),
    );
  }

  UpcomingAppointment _mapAppointmentDto(UpcomingAppointmentDto dto) {
    return UpcomingAppointment(
      id: dto.id,
      patientName: dto.patientName,
      serviceName: dto.serviceName,
      employeeName: dto.employeeName,
      scheduledAt: DateTime.tryParse(dto.scheduledAt) ?? DateTime.now(),
      status: dto.status.value,
    );
  }

  ServicePerformance _mapServiceDto(ServicePerformanceDto dto) {
    return ServicePerformance(
      serviceName: dto.serviceName,
      bookingCount: dto.bookingCount.toInt(),
      revenue: dto.revenue.toDouble(),
      averageRating: dto.averageRating.toDouble(),
    );
  }

  EmployeeDistribution _mapEmployeeDto(EmployeeDistributionDto dto) {
    return EmployeeDistribution(
      role: _mapRoleLabel(dto.role),
      count: dto.count.toInt(),
      status: dto.status,
    );
  }

  /// Maps UPPERCASE enum value to human-readable
  /// label for chart display.
  String _mapRoleLabel(String role) {
    return switch (role.toUpperCase()) {
      'DOCTOR' => 'Doctor',
      'THERAPIST' => 'Therapist',
      'RECEPTIONIST' => 'Receptionist',
      'MANAGER' => 'Manager',
      _ => role,
    };
  }

  DashboardReview _mapReviewDto(DashboardReviewDto dto) {
    return DashboardReview(
      reviewerName: dto.reviewerName,
      avatarUrl: dto.avatarUrl,
      rating: dto.rating.toInt(),
      status: dto.status.value,
      date: DateTime.tryParse(dto.date) ?? DateTime.now(),
      text: dto.text,
      imageUrls: dto.imageUrls,
    );
  }

  StaffScheduleEntry _mapScheduleDto(StaffScheduleEntryDto dto) {
    return StaffScheduleEntry(
      employeeId: dto.employeeId,
      employeeName: dto.employeeName,
      role: dto.role,
      startTime: DateTime.tryParse(dto.startTime) ?? DateTime.now(),
      endTime: DateTime.tryParse(dto.endTime) ?? DateTime.now(),
      serviceName: dto.serviceName,
      patientName: dto.patientName,
    );
  }

  DashboardNotification _mapNotificationDto(DashboardNotificationDto dto) {
    return DashboardNotification(
      id: dto.id,
      title: dto.title,
      message: dto.message,
      type: dto.type.value,
      createdAt: DateTime.tryParse(dto.createdAt) ?? DateTime.now(),
      isRead: dto.isRead,
    );
  }

  InventoryAlert _mapInventoryDto(InventoryAlertDto dto) {
    return InventoryAlert(
      id: dto.id,
      productName: dto.productName,
      alertType: dto.alertType.value,
      message: dto.message,
      createdAt: DateTime.tryParse(dto.createdAt) ?? DateTime.now(),
      severity: dto.severity.value,
    );
  }
}

// ============================================================
// 3. MOCK IMPLEMENTATION
// ============================================================

/// Full mock data source for development/testing.
class DashboardRemoteDataSourceMock implements DashboardRemoteDataSource {
  @override
  Future<DashboardStats> getDashboardStats({
    DashboardTimePeriod? period,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return mockDashboardStats;
  }

  @override
  Future<List<RevenueDataPoint>> getRevenueData(
    DashboardTimePeriod period,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return switch (period) {
      DashboardTimePeriod.today => mockTodayRevenueData,
      DashboardTimePeriod.thisWeek => mockWeeklyRevenueData,
      DashboardTimePeriod.thisMonth => mockMonthlyRevenueData,
      DashboardTimePeriod.thisQuarter => mockQuarterlyRevenueData,
      DashboardTimePeriod.thisYear => mockYearlyRevenueData,
    };
  }

  @override
  Future<List<UpcomingAppointment>> getUpcomingAppointments({
    int limit = 5,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return mockUpcomingAppointments.take(limit).toList();
  }

  @override
  Future<List<ServicePerformance>> getServicePerformance() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockServicePerformance;
  }

  @override
  Future<List<EmployeeDistribution>> getEmployeeDistribution() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockEmployeeDistribution;
  }

  @override
  Future<List<DashboardReview>> getRecentReviews({int limit = 5}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockRecentReviews.take(limit).toList();
  }

  @override
  Future<List<StaffScheduleEntry>> getStaffSchedule(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return getMockStaffSchedule(date);
  }

  @override
  Future<List<DashboardNotification>> getNotifications({int limit = 10}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockNotifications.take(limit).toList();
  }

  @override
  Future<List<InventoryAlert>> getInventoryAlerts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return mockInventoryAlerts;
  }
}

// ============================================================
// 4. PROVIDER WITH MOCK SWITCHING
// ============================================================

/// Provides the correct data source based on the
/// mock flag in persistent storage.
@riverpod
DashboardRemoteDataSource dashboardRemoteDataSource(Ref ref) {
  final isMock = Store.get(StoreKey.mockFlag, false);
  if (isMock) {
    return DashboardRemoteDataSourceMock();
  }
  final apiService = ref.read(apiServiceProvider);
  return DashboardRemoteDataSourceImpl(apiService: apiService);
}

// ============================================================
// 5. CUSTOM EXCEPTIONS
// ============================================================

/// Exception for dashboard data fetch failures.
class DashboardDataException implements Exception {
  const DashboardDataException(this.message);

  final String message;

  @override
  String toString() => 'DashboardDataException: $message';
}
