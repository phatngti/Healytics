//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserHealthServicesApi {
  UserHealthServicesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get a service by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userHealthServiceControllerFindOneWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/{id}'
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

  /// Get a service by ID
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<PublicHealthServiceResponseDto?> userHealthServiceControllerFindOne(String id,) async {
    final response = await userHealthServiceControllerFindOneWithHttpInfo(id,);
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

  /// Get public clinic info by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userHealthServiceControllerGetClinicInfoWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/clinics/{id}/info'
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

  /// Get public clinic info by ID
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<PublicClinicInfoResponseDto?> userHealthServiceControllerGetClinicInfo(String id,) async {
    final response = await userHealthServiceControllerGetClinicInfoWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PublicClinicInfoResponseDto',) as PublicClinicInfoResponseDto;
    
    }
    return null;
  }

  /// Get eligibility detail by ID
  ///
  /// Returns the full eligibility record enriched with category, service, and employee information, looked up by the surrogate primary key on the product_employee_eligibility table.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userHealthServiceControllerGetEligibilityDetailWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/eligibilities/{id}'
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

  /// Get eligibility detail by ID
  ///
  /// Returns the full eligibility record enriched with category, service, and employee information, looked up by the surrogate primary key on the product_employee_eligibility table.
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<UserEligibilityDetailResponseDto?> userHealthServiceControllerGetEligibilityDetail(String id,) async {
    final response = await userHealthServiceControllerGetEligibilityDetailWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserEligibilityDetailResponseDto',) as UserEligibilityDetailResponseDto;
    
    }
    return null;
  }

  /// Get home recommendations
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userHealthServiceControllerGetHomeRecommendWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/home-recommend';

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
  Future<List<PublicHealthServiceCardResponseDto>?> userHealthServiceControllerGetHomeRecommend() async {
    final response = await userHealthServiceControllerGetHomeRecommendWithHttpInfo();
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
  Future<Response> userHealthServiceControllerGetPremiumTreatmentsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/premium-treatments';

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
  Future<List<PublicHealthServiceCardResponseDto>?> userHealthServiceControllerGetPremiumTreatments() async {
    final response = await userHealthServiceControllerGetPremiumTreatmentsWithHttpInfo();
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
  Future<Response> userHealthServiceControllerGetProductEmployeesWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/{id}/employees'
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
  Future<List<PublicHealthServiceEmployeeResponseDto>?> userHealthServiceControllerGetProductEmployees(String id,) async {
    final response = await userHealthServiceControllerGetProductEmployeesWithHttpInfo(id,);
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
  Future<Response> userHealthServiceControllerGetProductInfoWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/{id}/info'
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
  Future<PublicHealthServiceInfoResponseDto?> userHealthServiceControllerGetProductInfo(String id,) async {
    final response = await userHealthServiceControllerGetProductInfoWithHttpInfo(id,);
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
  Future<Response> userHealthServiceControllerGetProductReviewsWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/{id}/reviews'
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
  Future<List<PublicHealthServiceReviewResponseDto>?> userHealthServiceControllerGetProductReviews(String id,) async {
    final response = await userHealthServiceControllerGetProductReviewsWithHttpInfo(id,);
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
  Future<Response> userHealthServiceControllerGetRecommendedProductsWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/health-services/{id}/recommended'
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
  Future<List<PublicHealthServiceRecommendedResponseDto>?> userHealthServiceControllerGetRecommendedProducts(String id,) async {
    final response = await userHealthServiceControllerGetRecommendedProductsWithHttpInfo(id,);
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
