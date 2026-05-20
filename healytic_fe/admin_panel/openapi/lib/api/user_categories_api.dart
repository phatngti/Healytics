//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserCategoriesApi {
  UserCategoriesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get services for a category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  ///
  /// * [num] lat:
  ///   User latitude for distance calc
  ///
  /// * [num] lng:
  ///   User longitude for distance calc
  Future<Response> userCategoriesControllerFindServicesByCategoryWithHttpInfo(String categoryId, { num? lat, num? lng, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/categories/{categoryId}/services'
      .replaceAll('{categoryId}', categoryId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (lat != null) {
      queryParams.addAll(_queryParams('', 'lat', lat));
    }
    if (lng != null) {
      queryParams.addAll(_queryParams('', 'lng', lng));
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

  /// Get services for a category
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  ///
  /// * [num] lat:
  ///   User latitude for distance calc
  ///
  /// * [num] lng:
  ///   User longitude for distance calc
  Future<List<BookingServiceResponseDto>?> userCategoriesControllerFindServicesByCategory(String categoryId, { num? lat, num? lng, }) async {
    final response = await userCategoriesControllerFindServicesByCategoryWithHttpInfo(categoryId,  lat: lat, lng: lng, );
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

  /// Get specialists for a category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<Response> userCategoriesControllerFindSpecialistsByCategoryWithHttpInfo(String categoryId,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/categories/{categoryId}/specialists'
      .replaceAll('{categoryId}', categoryId);

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

  /// Get specialists for a category
  ///
  /// Parameters:
  ///
  /// * [String] categoryId (required):
  Future<List<BookingSpecialistResponseDto>?> userCategoriesControllerFindSpecialistsByCategory(String categoryId,) async {
    final response = await userCategoriesControllerFindSpecialistsByCategoryWithHttpInfo(categoryId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<BookingSpecialistResponseDto>') as List)
        .cast<BookingSpecialistResponseDto>()
        .toList(growable: false);

    }
    return null;
  }
}
