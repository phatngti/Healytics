//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserClinicsApi {
  UserClinicsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get public clinic profile
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userClinicControllerGetClinicInfoWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/clinics/{id}/info'
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

  /// Get public clinic profile
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<ClinicInfoResponseDto?> userClinicControllerGetClinicInfo(String id,) async {
    final response = await userClinicControllerGetClinicInfoWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ClinicInfoResponseDto',) as ClinicInfoResponseDto;
    
    }
    return null;
  }

  /// Get clinic products/services catalog
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] categoryId:
  ///   Filter by category UUID
  ///
  /// * [String] sort:
  ///   Sort order for products
  ///
  /// * [String] search:
  ///   Case-insensitive service name search
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<Response> userClinicControllerGetClinicProductsWithHttpInfo(String id, { String? categoryId, String? sort, String? search, num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/clinics/{id}/products'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (categoryId != null) {
      queryParams.addAll(_queryParams('', 'categoryId', categoryId));
    }
    if (sort != null) {
      queryParams.addAll(_queryParams('', 'sort', sort));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
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

  /// Get clinic products/services catalog
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] categoryId:
  ///   Filter by category UUID
  ///
  /// * [String] sort:
  ///   Sort order for products
  ///
  /// * [String] search:
  ///   Case-insensitive service name search
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  Future<ClinicProductsResponseDto?> userClinicControllerGetClinicProducts(String id, { String? categoryId, String? sort, String? search, num? page, num? limit, }) async {
    final response = await userClinicControllerGetClinicProductsWithHttpInfo(id,  categoryId: categoryId, sort: sort, search: search, page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ClinicProductsResponseDto',) as ClinicProductsResponseDto;
    
    }
    return null;
  }

  /// Get paginated clinic reviews
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  ///
  /// * [num] starCount:
  ///   Filter: only reviews with this rating (1–5)
  ///
  /// * [bool] hasMedia:
  ///   Filter: only reviews with photos
  Future<Response> userClinicControllerGetClinicReviewsWithHttpInfo(String id, { num? page, num? limit, num? starCount, bool? hasMedia, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/clinics/{id}/reviews'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (page != null) {
      queryParams.addAll(_queryParams('', 'page', page));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }
    if (starCount != null) {
      queryParams.addAll(_queryParams('', 'starCount', starCount));
    }
    if (hasMedia != null) {
      queryParams.addAll(_queryParams('', 'hasMedia', hasMedia));
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

  /// Get paginated clinic reviews
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [num] page:
  ///
  /// * [num] limit:
  ///
  /// * [num] starCount:
  ///   Filter: only reviews with this rating (1–5)
  ///
  /// * [bool] hasMedia:
  ///   Filter: only reviews with photos
  Future<ClinicReviewsResponseDto?> userClinicControllerGetClinicReviews(String id, { num? page, num? limit, num? starCount, bool? hasMedia, }) async {
    final response = await userClinicControllerGetClinicReviewsWithHttpInfo(id,  page: page, limit: limit, starCount: starCount, hasMedia: hasMedia, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ClinicReviewsResponseDto',) as ClinicReviewsResponseDto;
    
    }
    return null;
  }
}
