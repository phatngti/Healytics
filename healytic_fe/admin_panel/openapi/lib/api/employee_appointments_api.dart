//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class EmployeeAppointmentsApi {
  EmployeeAppointmentsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Cancel an appointment
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [CancelEmployeeAppointmentDto] cancelEmployeeAppointmentDto (required):
  Future<Response> employeeAppointmentsControllerCancelAppointmentWithHttpInfo(String id, CancelEmployeeAppointmentDto cancelEmployeeAppointmentDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/appointments/{id}/cancel'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = cancelEmployeeAppointmentDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Cancel an appointment
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [CancelEmployeeAppointmentDto] cancelEmployeeAppointmentDto (required):
  Future<EmployeeAppointmentResponseDto?> employeeAppointmentsControllerCancelAppointment(String id, CancelEmployeeAppointmentDto cancelEmployeeAppointmentDto,) async {
    final response = await employeeAppointmentsControllerCancelAppointmentWithHttpInfo(id, cancelEmployeeAppointmentDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeAppointmentResponseDto',) as EmployeeAppointmentResponseDto;

    }
    return null;
  }

  /// Complete service for an appointment
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> employeeAppointmentsControllerCompleteServiceWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/appointments/{id}/complete'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Complete service for an appointment
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<EmployeeAppointmentResponseDto?> employeeAppointmentsControllerCompleteService(String id,) async {
    final response = await employeeAppointmentsControllerCompleteServiceWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeAppointmentResponseDto',) as EmployeeAppointmentResponseDto;

    }
    return null;
  }

  /// Get appointment detail
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> employeeAppointmentsControllerGetAppointmentWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/appointments/{id}'
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

  /// Get appointment detail
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<EmployeeAppointmentResponseDto?> employeeAppointmentsControllerGetAppointment(String id,) async {
    final response = await employeeAppointmentsControllerGetAppointmentWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeAppointmentResponseDto',) as EmployeeAppointmentResponseDto;

    }
    return null;
  }

  /// List my appointments
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmployeeBookingStatusFilter] status:
  ///   Filter appointments by status
  ///
  /// * [num] page:
  ///   Page number
  ///
  /// * [num] limit:
  ///   Items per page
  Future<Response> employeeAppointmentsControllerListMyAppointmentsWithHttpInfo({ EmployeeBookingStatusFilter? status, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/appointments';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }
    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
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

  /// List my appointments
  ///
  /// Parameters:
  ///
  /// * [EmployeeBookingStatusFilter] status:
  ///   Filter appointments by status
  ///
  /// * [num] page:
  ///   Page number
  ///
  /// * [num] limit:
  ///   Items per page
  Future<PaginatedEmployeeAppointmentsResponseDto?> employeeAppointmentsControllerListMyAppointments({ EmployeeBookingStatusFilter? status, num? page, num? limit, }) async {
    final response = await employeeAppointmentsControllerListMyAppointmentsWithHttpInfo( status: status, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PaginatedEmployeeAppointmentsResponseDto',) as PaginatedEmployeeAppointmentsResponseDto;

    }
    return null;
  }

  /// Start service for an appointment
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> employeeAppointmentsControllerStartServiceWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/employee/appointments/{id}/start'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Start service for an appointment
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<EmployeeAppointmentResponseDto?> employeeAppointmentsControllerStartService(String id,) async {
    final response = await employeeAppointmentsControllerStartServiceWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EmployeeAppointmentResponseDto',) as EmployeeAppointmentResponseDto;

    }
    return null;
  }
}
