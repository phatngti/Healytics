//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerDashboardApi {
  PartnerDashboardApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get employee role distribution
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerDashboardControllerGetEmployeeDistributionWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/employees/distribution';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get employee role distribution
  Future<List<EmployeeDistributionDto>?> partnerDashboardControllerGetEmployeeDistribution() async {
    final response = await partnerDashboardControllerGetEmployeeDistributionWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<EmployeeDistributionDto>') as List)
        .cast<EmployeeDistributionDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get inventory alerts
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerDashboardControllerGetInventoryAlertsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/inventory/alerts';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get inventory alerts
  Future<List<InventoryAlertDto>?> partnerDashboardControllerGetInventoryAlerts() async {
    final response = await partnerDashboardControllerGetInventoryAlertsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<InventoryAlertDto>') as List)
        .cast<InventoryAlertDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get dashboard notifications
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return
  Future<Response> partnerDashboardControllerGetNotificationsWithHttpInfo({ num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/notifications';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get dashboard notifications
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return
  Future<List<DashboardNotificationDto>?> partnerDashboardControllerGetNotifications({ num? limit, }) async {
    final response = await partnerDashboardControllerGetNotificationsWithHttpInfo( limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<DashboardNotificationDto>') as List)
        .cast<DashboardNotificationDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get recent customer reviews
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return
  Future<Response> partnerDashboardControllerGetRecentReviewsWithHttpInfo({ num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/reviews/recent';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get recent customer reviews
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return
  Future<List<DashboardReviewDto>?> partnerDashboardControllerGetRecentReviews({ num? limit, }) async {
    final response = await partnerDashboardControllerGetRecentReviewsWithHttpInfo( limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<DashboardReviewDto>') as List)
        .cast<DashboardReviewDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get revenue time-series data
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///   Time period filter for revenue and KPI aggregation
  Future<Response> partnerDashboardControllerGetRevenueWithHttpInfo({ String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/revenue';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get revenue time-series data
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///   Time period filter for revenue and KPI aggregation
  Future<List<RevenueDataPointDto>?> partnerDashboardControllerGetRevenue({ String? period, }) async {
    final response = await partnerDashboardControllerGetRevenueWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<RevenueDataPointDto>') as List)
        .cast<RevenueDataPointDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get service performance metrics
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerDashboardControllerGetServicePerformanceWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/services/performance';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get service performance metrics
  Future<List<ServicePerformanceDto>?> partnerDashboardControllerGetServicePerformance() async {
    final response = await partnerDashboardControllerGetServicePerformanceWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ServicePerformanceDto>') as List)
        .cast<ServicePerformanceDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get staff schedule for a date
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] date (required):
  ///   Target date for schedule lookup (ISO 8601 date)
  Future<Response> partnerDashboardControllerGetStaffScheduleWithHttpInfo(String date,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/staff/schedule';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'date', date));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get staff schedule for a date
  ///
  /// Parameters:
  ///
  /// * [String] date (required):
  ///   Target date for schedule lookup (ISO 8601 date)
  Future<List<StaffScheduleEntryDto>?> partnerDashboardControllerGetStaffSchedule(String date,) async {
    final response = await partnerDashboardControllerGetStaffScheduleWithHttpInfo(date,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<StaffScheduleEntryDto>') as List)
        .cast<StaffScheduleEntryDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get aggregated KPI statistics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///   Time period filter for revenue and KPI aggregation
  Future<Response> partnerDashboardControllerGetStatsWithHttpInfo({ String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/stats';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get aggregated KPI statistics
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///   Time period filter for revenue and KPI aggregation
  Future<DashboardStatsResponseDto?> partnerDashboardControllerGetStats({ String? period, }) async {
    final response = await partnerDashboardControllerGetStatsWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DashboardStatsResponseDto',) as DashboardStatsResponseDto;
    
    }
    return null;
  }

  /// Get upcoming appointments
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return
  Future<Response> partnerDashboardControllerGetUpcomingAppointmentsWithHttpInfo({ num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/dashboard/appointments/upcoming';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Get upcoming appointments
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return
  Future<List<UpcomingAppointmentDto>?> partnerDashboardControllerGetUpcomingAppointments({ num? limit, }) async {
    final response = await partnerDashboardControllerGetUpcomingAppointmentsWithHttpInfo( limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<UpcomingAppointmentDto>') as List)
        .cast<UpcomingAppointmentDto>()
        .toList(growable: false);

    }
    return null;
  }
}
