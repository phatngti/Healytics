//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminDashboardApi {
  AdminDashboardApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get booking outcome summary
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<Response> adminDashboardControllerGetBookingOutcomeSummaryWithHttpInfo({ String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/booking-outcomes';

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

  /// Get booking outcome summary
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<AdminDashboardBookingOutcomeSummaryDto?> adminDashboardControllerGetBookingOutcomeSummary({ String? period, }) async {
    final response = await adminDashboardControllerGetBookingOutcomeSummaryWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminDashboardBookingOutcomeSummaryDto',) as AdminDashboardBookingOutcomeSummaryDto;
    
    }
    return null;
  }

  /// Get service category health overview
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminDashboardControllerGetCategoryHealthWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/category-health';

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

  /// Get service category health overview
  Future<AdminCategoryHealthDto?> adminDashboardControllerGetCategoryHealth() async {
    final response = await adminDashboardControllerGetCategoryHealthWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminCategoryHealthDto',) as AdminCategoryHealthDto;
    
    }
    return null;
  }

  /// Get admin dashboard notifications
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  Future<Response> adminDashboardControllerGetNotificationsWithHttpInfo({ num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/notifications';

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

  /// Get admin dashboard notifications
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  Future<List<AdminDashboardNotificationItemDto>?> adminDashboardControllerGetNotifications({ num? limit, }) async {
    final response = await adminDashboardControllerGetNotificationsWithHttpInfo( limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminDashboardNotificationItemDto>') as List)
        .cast<AdminDashboardNotificationItemDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get admin dashboard overview metrics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<Response> adminDashboardControllerGetOverviewWithHttpInfo({ String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/overview';

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

  /// Get admin dashboard overview metrics
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<AdminDashboardOverviewDto?> adminDashboardControllerGetOverview({ String? period, }) async {
    final response = await adminDashboardControllerGetOverviewWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminDashboardOverviewDto',) as AdminDashboardOverviewDto;
    
    }
    return null;
  }

  /// Get admin revenue trend data points
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<Response> adminDashboardControllerGetRevenueTrendWithHttpInfo({ String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/revenue-trend';

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

  /// Get admin revenue trend data points
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<List<AdminDashboardRevenueTrendPointDto>?> adminDashboardControllerGetRevenueTrend({ String? period, }) async {
    final response = await adminDashboardControllerGetRevenueTrendWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminDashboardRevenueTrendPointDto>') as List)
        .cast<AdminDashboardRevenueTrendPointDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get top performing partners by revenue
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///
  /// * [num] limit:
  Future<Response> adminDashboardControllerGetTopPartnersWithHttpInfo({ String? period, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/top-partners';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
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

  /// Get top performing partners by revenue
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///
  /// * [num] limit:
  Future<List<AdminPartnerRankingItemDto>?> adminDashboardControllerGetTopPartners({ String? period, num? limit, }) async {
    final response = await adminDashboardControllerGetTopPartnersWithHttpInfo( period: period, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminPartnerRankingItemDto>') as List)
        .cast<AdminPartnerRankingItemDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get top performing services by revenue
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///
  /// * [num] limit:
  Future<Response> adminDashboardControllerGetTopServicesWithHttpInfo({ String? period, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/top-services';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
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

  /// Get top performing services by revenue
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///
  /// * [num] limit:
  Future<List<AdminServiceRankingItemDto>?> adminDashboardControllerGetTopServices({ String? period, num? limit, }) async {
    final response = await adminDashboardControllerGetTopServicesWithHttpInfo( period: period, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminServiceRankingItemDto>') as List)
        .cast<AdminServiceRankingItemDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get transaction health breakdown
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<Response> adminDashboardControllerGetTransactionHealthWithHttpInfo({ String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/dashboard/transaction-health';

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

  /// Get transaction health breakdown
  ///
  /// Parameters:
  ///
  /// * [String] period:
  Future<AdminDashboardTransactionHealthDto?> adminDashboardControllerGetTransactionHealth({ String? period, }) async {
    final response = await adminDashboardControllerGetTransactionHealthWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminDashboardTransactionHealthDto',) as AdminDashboardTransactionHealthDto;
    
    }
    return null;
  }
}
