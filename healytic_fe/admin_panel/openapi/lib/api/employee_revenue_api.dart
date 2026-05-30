//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class EmployeeRevenueApi {
  EmployeeRevenueApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get revenue breakdown by service
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmployeeRevenuePeriod] period:
  ///   Time period for revenue aggregation
  ///
  /// * [String] date:
  ///   Reference date for the period (defaults to today)
  Future<Response> employeeRevenueControllerGetBreakdownWithHttpInfo({ EmployeeRevenuePeriod? period, String? date, }) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/revenue/breakdown';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (date != null) {
      queryParams.addAll(_queryParams('', 'date', date));
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

  /// Get revenue breakdown by service
  ///
  /// Parameters:
  ///
  /// * [EmployeeRevenuePeriod] period:
  ///   Time period for revenue aggregation
  ///
  /// * [String] date:
  ///   Reference date for the period (defaults to today)
  Future<List<EmployeeRevenueBreakdownItemDto>?> employeeRevenueControllerGetBreakdown({ EmployeeRevenuePeriod? period, String? date, }) async {
    final response = await employeeRevenueControllerGetBreakdownWithHttpInfo( period: period, date: date, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<EmployeeRevenueBreakdownItemDto>') as List)
        .cast<EmployeeRevenueBreakdownItemDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get revenue summary
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmployeeRevenuePeriod] period:
  ///   Time period for revenue aggregation
  ///
  /// * [String] date:
  ///   Reference date for the period (defaults to today)
  Future<Response> employeeRevenueControllerGetSummaryWithHttpInfo({ EmployeeRevenuePeriod? period, String? date, }) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/revenue/summary';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (date != null) {
      queryParams.addAll(_queryParams('', 'date', date));
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

  /// Get revenue summary
  ///
  /// Parameters:
  ///
  /// * [EmployeeRevenuePeriod] period:
  ///   Time period for revenue aggregation
  ///
  /// * [String] date:
  ///   Reference date for the period (defaults to today)
  Future<EmployeeRevenueSummaryResponseDto?> employeeRevenueControllerGetSummary({ EmployeeRevenuePeriod? period, String? date, }) async {
    final response = await employeeRevenueControllerGetSummaryWithHttpInfo( period: period, date: date, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeRevenueSummaryResponseDto',) as EmployeeRevenueSummaryResponseDto;

    }
    return null;
  }

  /// Get revenue trend data
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmployeeRevenuePeriod] period:
  ///   Time period for revenue aggregation
  ///
  /// * [String] date:
  ///   Reference date for the period (defaults to today)
  Future<Response> employeeRevenueControllerGetTrendWithHttpInfo({ EmployeeRevenuePeriod? period, String? date, }) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/revenue/trend';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (period != null) {
      queryParams.addAll(_queryParams('', 'period', period));
    }
    if (date != null) {
      queryParams.addAll(_queryParams('', 'date', date));
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

  /// Get revenue trend data
  ///
  /// Parameters:
  ///
  /// * [EmployeeRevenuePeriod] period:
  ///   Time period for revenue aggregation
  ///
  /// * [String] date:
  ///   Reference date for the period (defaults to today)
  Future<List<EmployeeRevenueTrendPointDto>?> employeeRevenueControllerGetTrend({ EmployeeRevenuePeriod? period, String? date, }) async {
    final response = await employeeRevenueControllerGetTrendWithHttpInfo( period: period, date: date, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<EmployeeRevenueTrendPointDto>') as List)
        .cast<EmployeeRevenueTrendPointDto>()
        .toList(growable: false);

    }
    return null;
  }
}
