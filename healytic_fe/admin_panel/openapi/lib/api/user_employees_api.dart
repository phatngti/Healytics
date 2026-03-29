//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserEmployeesApi {
  UserEmployeesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get all employees
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] role:
  Future<Response> userEmployeesControllerFindAllWithHttpInfo({ String? role, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/employees';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (role != null) {
      queryParams.addAll(_queryParams('', 'role', role));
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

  /// Get all employees
  ///
  /// Parameters:
  ///
  /// * [String] role:
  Future<List<EmployeeResponseDto>?> userEmployeesControllerFindAll({ String? role, }) async {
    final response = await userEmployeesControllerFindAllWithHttpInfo( role: role, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<EmployeeResponseDto>') as List)
        .cast<EmployeeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get an employee by id
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userEmployeesControllerFindOneWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/employees/{id}'
      .replaceAll('{id}', id);

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

  /// Get an employee by id
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<EmployeeResponseDto?> userEmployeesControllerFindOne(String id,) async {
    final response = await userEmployeesControllerFindOneWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeResponseDto',) as EmployeeResponseDto;
    
    }
    return null;
  }

  /// Get services for a specialist
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userEmployeesControllerFindServicesWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/employees/{id}/services'
      .replaceAll('{id}', id);

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

  /// Get services for a specialist
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<List<BookingServiceResponseDto>?> userEmployeesControllerFindServices(String id,) async {
    final response = await userEmployeesControllerFindServicesWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<BookingServiceResponseDto>') as List)
        .cast<BookingServiceResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get featured specialists for home page
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Max specialists to return (default 10)
  Future<Response> userEmployeesControllerGetFeaturedSpecialistsWithHttpInfo({ num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/employees/featured-specialists';

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

  /// Get featured specialists for home page
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Max specialists to return (default 10)
  Future<List<FeaturedSpecialistResponseDto>?> userEmployeesControllerGetFeaturedSpecialists({ num? limit, }) async {
    final response = await userEmployeesControllerGetFeaturedSpecialistsWithHttpInfo( limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<FeaturedSpecialistResponseDto>') as List)
        .cast<FeaturedSpecialistResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get time slots with availability for an employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] date:
  ///   Start date for the schedule range (YYYY-MM-DD). Defaults to today.
  ///
  /// * [num] days:
  ///   Number of days to return from the start date. Default 7, max 30.
  Future<Response> userEmployeesControllerGetTimeSlotsWithHttpInfo(String id, { String? date, num? days, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/employees/{id}/time-slots'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (date != null) {
      queryParams.addAll(_queryParams('', 'date', date));
    }
    if (days != null) {
      queryParams.addAll(_queryParams('', 'days', days));
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

  /// Get time slots with availability for an employee
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] date:
  ///   Start date for the schedule range (YYYY-MM-DD). Defaults to today.
  ///
  /// * [num] days:
  ///   Number of days to return from the start date. Default 7, max 30.
  Future<EmployeeTimeSlotsResponseDto?> userEmployeesControllerGetTimeSlots(String id, { String? date, num? days, }) async {
    final response = await userEmployeesControllerGetTimeSlotsWithHttpInfo(id,  date: date, days: days, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeTimeSlotsResponseDto',) as EmployeeTimeSlotsResponseDto;
    
    }
    return null;
  }
}
