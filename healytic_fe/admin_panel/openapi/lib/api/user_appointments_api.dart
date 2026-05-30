//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserAppointmentsApi {
  UserAppointmentsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get appointment details by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userAppointmentControllerGetAppointmentWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/appointments/{id}'
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

  /// Get appointment details by ID
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AppointmentResponseDto?> userAppointmentControllerGetAppointment(String id,) async {
    final response = await userAppointmentControllerGetAppointmentWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AppointmentResponseDto',) as AppointmentResponseDto;

    }
    return null;
  }

  /// Get service manual for an appointment
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] appointmentId (required):
  Future<Response> userAppointmentControllerGetServiceManualWithHttpInfo(String appointmentId,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/appointments/{appointmentId}/manual'
      .replaceAll('{appointmentId}', appointmentId);

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

  /// Get service manual for an appointment
  ///
  /// Parameters:
  ///
  /// * [String] appointmentId (required):
  Future<ServiceManualResponseDto?> userAppointmentControllerGetServiceManual(String appointmentId,) async {
    final response = await userAppointmentControllerGetServiceManualWithHttpInfo(appointmentId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ServiceManualResponseDto',) as ServiceManualResponseDto;

    }
    return null;
  }

  /// List all user appointments with optional distance calculation
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] latitude:
  ///   User latitude (-90 to 90)
  ///
  /// * [num] longitude:
  ///   User longitude (-180 to 180)
  ///
  /// * [String] status:
  ///   Filter by appointment status
  ///
  /// * [String] categoryId:
  ///   Filter by category ID
  ///
  /// * [String] sortBy:
  ///   Sort by appointment time: newest (default) or oldest first
  Future<Response> userAppointmentControllerListAppointmentsWithHttpInfo({ num? latitude, num? longitude, String? status, String? categoryId, String? sortBy, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/appointments';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (latitude != null) {
      queryParams.addAll(_queryParams('', 'latitude', latitude));
    }
    if (longitude != null) {
      queryParams.addAll(_queryParams('', 'longitude', longitude));
    }
    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }
    if (categoryId != null) {
      queryParams.addAll(_queryParams('', 'categoryId', categoryId));
    }
    if (sortBy != null) {
      queryParams.addAll(_queryParams('', 'sortBy', sortBy));
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

  /// List all user appointments with optional distance calculation
  ///
  /// Parameters:
  ///
  /// * [num] latitude:
  ///   User latitude (-90 to 90)
  ///
  /// * [num] longitude:
  ///   User longitude (-180 to 180)
  ///
  /// * [String] status:
  ///   Filter by appointment status
  ///
  /// * [String] categoryId:
  ///   Filter by category ID
  ///
  /// * [String] sortBy:
  ///   Sort by appointment time: newest (default) or oldest first
  Future<List<AppointmentResponseDto>?> userAppointmentControllerListAppointments({ num? latitude, num? longitude, String? status, String? categoryId, String? sortBy, }) async {
    final response = await userAppointmentControllerListAppointmentsWithHttpInfo( latitude: latitude, longitude: longitude, status: status, categoryId: categoryId, sortBy: sortBy, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AppointmentResponseDto>') as List)
        .cast<AppointmentResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get appointment categories for filter chips
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userAppointmentControllerListCategoriesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/appointments/categories';

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

  /// Get appointment categories for filter chips
  Future<List<AppointmentCategoryResponseDto>?> userAppointmentControllerListCategories() async {
    final response = await userAppointmentControllerListCategoriesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AppointmentCategoryResponseDto>') as List)
        .cast<AppointmentCategoryResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get recent appointment activity for home dashboard
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return (1–20)
  ///
  /// * [num] offset:
  ///   Number of items to skip
  ///
  /// * [String] status:
  ///
  /// * [String] categoryId:
  ///
  /// * [String] clinicId:
  ///
  /// * [String] fromDate:
  ///
  /// * [String] toDate:
  ///
  /// * [String] sort:
  Future<Response> userAppointmentControllerListRecentActivityWithHttpInfo({ num? limit, num? offset, String? status, String? categoryId, String? clinicId, String? fromDate, String? toDate, String? sort, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/appointments/recent-activity';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }
    if (offset != null) {
      queryParams.addAll(_queryParams('', 'offset', offset));
    }
    if (status != null) {
      queryParams.addAll(_queryParams('', 'status', status));
    }
    if (categoryId != null) {
      queryParams.addAll(_queryParams('', 'categoryId', categoryId));
    }
    if (clinicId != null) {
      queryParams.addAll(_queryParams('', 'clinicId', clinicId));
    }
    if (fromDate != null) {
      queryParams.addAll(_queryParams('', 'fromDate', fromDate));
    }
    if (toDate != null) {
      queryParams.addAll(_queryParams('', 'toDate', toDate));
    }
    if (sort != null) {
      queryParams.addAll(_queryParams('', 'sort', sort));
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

  /// Get recent appointment activity for home dashboard
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Maximum number of items to return (1–20)
  ///
  /// * [num] offset:
  ///   Number of items to skip
  ///
  /// * [String] status:
  ///
  /// * [String] categoryId:
  ///
  /// * [String] clinicId:
  ///
  /// * [String] fromDate:
  ///
  /// * [String] toDate:
  ///
  /// * [String] sort:
  Future<void> userAppointmentControllerListRecentActivity({ num? limit, num? offset, String? status, String? categoryId, String? clinicId, String? fromDate, String? toDate, String? sort, }) async {
    final response = await userAppointmentControllerListRecentActivityWithHttpInfo( limit: limit, offset: offset, status: status, categoryId: categoryId, clinicId: clinicId, fromDate: fromDate, toDate: toDate, sort: sort, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get recommended services
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userAppointmentControllerListRecommendedServicesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/appointments/recommendations';

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

  /// Get recommended services
  Future<List<RecommendedServiceResponseDto>?> userAppointmentControllerListRecommendedServices() async {
    final response = await userAppointmentControllerListRecommendedServicesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<RecommendedServiceResponseDto>') as List)
        .cast<RecommendedServiceResponseDto>()
        .toList(growable: false);

    }
    return null;
  }
}
