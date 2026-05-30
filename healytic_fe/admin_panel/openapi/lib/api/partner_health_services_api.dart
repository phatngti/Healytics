//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerHealthServicesApi {
  PartnerHealthServicesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new health service
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreatePartnerHealthServiceDto] createPartnerHealthServiceDto (required):
  Future<Response> partnerHealthServiceControllerCreateWithHttpInfo(CreatePartnerHealthServiceDto createPartnerHealthServiceDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services';

    // ignore: prefer_final_locals
    Object? postBody = createPartnerHealthServiceDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Create a new health service
  ///
  /// Parameters:
  ///
  /// * [CreatePartnerHealthServiceDto] createPartnerHealthServiceDto (required):
  Future<PartnerHealthServiceResponseDto?> partnerHealthServiceControllerCreate(CreatePartnerHealthServiceDto createPartnerHealthServiceDto,) async {
    final response = await partnerHealthServiceControllerCreateWithHttpInfo(createPartnerHealthServiceDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerHealthServiceResponseDto',) as PartnerHealthServiceResponseDto;

    }
    return null;
  }

  /// Get all health services
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerHealthServiceControllerFindAllWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services';

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

  /// Get all health services
  Future<List<PartnerHealthServiceResponseDto>?> partnerHealthServiceControllerFindAll() async {
    final response = await partnerHealthServiceControllerFindAllWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PartnerHealthServiceResponseDto>') as List)
        .cast<PartnerHealthServiceResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get a health service by slug
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<Response> partnerHealthServiceControllerFindBySlugWithHttpInfo(String slug,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services/slug/{slug}'
      .replaceAll('{slug}', slug);

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

  /// Get a health service by slug
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<PartnerHealthServiceResponseDto?> partnerHealthServiceControllerFindBySlug(String slug,) async {
    final response = await partnerHealthServiceControllerFindBySlugWithHttpInfo(slug,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerHealthServiceResponseDto',) as PartnerHealthServiceResponseDto;

    }
    return null;
  }

  /// Get per-service detail analytics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  ///
  /// * [String] period:
  ///   Time period for analytics aggregation
  Future<Response> partnerHealthServiceControllerGetDetailAnalyticsWithHttpInfo(String productId, { String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services/analytics/{productId}'
      .replaceAll('{productId}', productId);

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

  /// Get per-service detail analytics
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  ///
  /// * [String] period:
  ///   Time period for analytics aggregation
  Future<HealthServiceDetailAnalyticsResponseDto?> partnerHealthServiceControllerGetDetailAnalytics(String productId, { String? period, }) async {
    final response = await partnerHealthServiceControllerGetDetailAnalyticsWithHttpInfo(productId,  period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'HealthServiceDetailAnalyticsResponseDto',) as HealthServiceDetailAnalyticsResponseDto;

    }
    return null;
  }

  /// Get full health service details by slug
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<Response> partnerHealthServiceControllerGetDetailsWithHttpInfo(String slug,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services/slug/{slug}/details'
      .replaceAll('{slug}', slug);

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

  /// Get full health service details by slug
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<PartnerHealthServiceDetailResponseDto?> partnerHealthServiceControllerGetDetails(String slug,) async {
    final response = await partnerHealthServiceControllerGetDetailsWithHttpInfo(slug,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerHealthServiceDetailResponseDto',) as PartnerHealthServiceDetailResponseDto;

    }
    return null;
  }

  /// Get health service overview analytics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///   Time period for analytics aggregation
  Future<Response> partnerHealthServiceControllerGetOverviewAnalyticsWithHttpInfo({ String? period, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services/analytics/overview';

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

  /// Get health service overview analytics
  ///
  /// Parameters:
  ///
  /// * [String] period:
  ///   Time period for analytics aggregation
  Future<HealthServiceOverviewAnalyticsResponseDto?> partnerHealthServiceControllerGetOverviewAnalytics({ String? period, }) async {
    final response = await partnerHealthServiceControllerGetOverviewAnalyticsWithHttpInfo( period: period, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'HealthServiceOverviewAnalyticsResponseDto',) as HealthServiceOverviewAnalyticsResponseDto;

    }
    return null;
  }

  /// Delete a health service
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> partnerHealthServiceControllerRemoveWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Delete a health service
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> partnerHealthServiceControllerRemove(String id,) async {
    final response = await partnerHealthServiceControllerRemoveWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update a health service
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdatePartnerHealthServiceDto] updatePartnerHealthServiceDto (required):
  Future<Response> partnerHealthServiceControllerUpdateWithHttpInfo(String id, UpdatePartnerHealthServiceDto updatePartnerHealthServiceDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/health-services/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updatePartnerHealthServiceDto;

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

  /// Update a health service
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdatePartnerHealthServiceDto] updatePartnerHealthServiceDto (required):
  Future<PartnerHealthServiceResponseDto?> partnerHealthServiceControllerUpdate(String id, UpdatePartnerHealthServiceDto updatePartnerHealthServiceDto,) async {
    final response = await partnerHealthServiceControllerUpdateWithHttpInfo(id, updatePartnerHealthServiceDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerHealthServiceResponseDto',) as PartnerHealthServiceResponseDto;

    }
    return null;
  }
}
