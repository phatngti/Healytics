//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class HealthServicesApi {
  HealthServicesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get a service by id
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> healthServiceControllerFindOneWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/health-services/{id}'
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

  /// Get a service by id
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<PublicHealthServiceResponseDto?> healthServiceControllerFindOne(String id,) async {
    final response = await healthServiceControllerFindOneWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PublicHealthServiceResponseDto',) as PublicHealthServiceResponseDto;
    
    }
    return null;
  }

  /// Get home recommendations
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> healthServiceControllerGetHomeRecommendWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/health-services/home-recommend';

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

  /// Get home recommendations
  Future<List<PublicHealthServiceCardResponseDto>?> healthServiceControllerGetHomeRecommend() async {
    final response = await healthServiceControllerGetHomeRecommendWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PublicHealthServiceCardResponseDto>') as List)
        .cast<PublicHealthServiceCardResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get premium treatments
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> healthServiceControllerGetPremiumTreatmentsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/health-services/premium-treatments';

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

  /// Get premium treatments
  Future<List<PublicHealthServiceCardResponseDto>?> healthServiceControllerGetPremiumTreatments() async {
    final response = await healthServiceControllerGetPremiumTreatmentsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PublicHealthServiceCardResponseDto>') as List)
        .cast<PublicHealthServiceCardResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get employees for a service
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> healthServiceControllerGetProductEmployeesWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/health-services/{id}/employees'
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

  /// Get employees for a service
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<List<PublicHealthServiceEmployeeResponseDto>?> healthServiceControllerGetProductEmployees(String id,) async {
    final response = await healthServiceControllerGetProductEmployeesWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PublicHealthServiceEmployeeResponseDto>') as List)
        .cast<PublicHealthServiceEmployeeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get service info by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> healthServiceControllerGetProductInfoWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/health-services/{id}/info'
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

  /// Get service info by ID
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<PublicHealthServiceInfoResponseDto?> healthServiceControllerGetProductInfo(String id,) async {
    final response = await healthServiceControllerGetProductInfoWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PublicHealthServiceInfoResponseDto',) as PublicHealthServiceInfoResponseDto;
    
    }
    return null;
  }

  /// Get reviews for a service
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> healthServiceControllerGetProductReviewsWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/health-services/{id}/reviews'
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

  /// Get reviews for a service
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<List<PublicHealthServiceReviewResponseDto>?> healthServiceControllerGetProductReviews(String id,) async {
    final response = await healthServiceControllerGetProductReviewsWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PublicHealthServiceReviewResponseDto>') as List)
        .cast<PublicHealthServiceReviewResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get recommended services
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> healthServiceControllerGetRecommendedProductsWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/health-services/{id}/recommended'
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

  /// Get recommended services
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<List<PublicHealthServiceRecommendedResponseDto>?> healthServiceControllerGetRecommendedProducts(String id,) async {
    final response = await healthServiceControllerGetRecommendedProductsWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PublicHealthServiceRecommendedResponseDto>') as List)
        .cast<PublicHealthServiceRecommendedResponseDto>()
        .toList(growable: false);

    }
    return null;
  }
}
