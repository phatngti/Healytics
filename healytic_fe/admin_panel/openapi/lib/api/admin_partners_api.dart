//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminPartnersApi {
  AdminPartnersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get partner details including documents
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Partner ID
  Future<Response> adminPartnersControllerGetPartnerDetailWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/partners/{id}'
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

  /// Get partner details including documents
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Partner ID
  Future<AdminPartnerDetailResponseDto?> adminPartnersControllerGetPartnerDetail(String id,) async {
    final response = await adminPartnersControllerGetPartnerDetailWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminPartnerDetailResponseDto',) as AdminPartnerDetailResponseDto;
    
    }
    return null;
  }

  /// List all partners
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [String] verificationStatus:
  ///   Filter by verification status (PENDING, APPROVED, REJECTED)
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  Future<Response> adminPartnersControllerGetPartnersWithHttpInfo({ num? page, num? limit, String? verificationStatus, String? search, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/partners';

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
    if (verificationStatus != null) {
      queryParams.addAll(_queryParams('', 'verificationStatus', verificationStatus));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
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

  /// List all partners
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [String] verificationStatus:
  ///   Filter by verification status (PENDING, APPROVED, REJECTED)
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  Future<PartnersResponseDto?> adminPartnersControllerGetPartners({ num? page, num? limit, String? verificationStatus, String? search, }) async {
    final response = await adminPartnersControllerGetPartnersWithHttpInfo( page: page, limit: limit, verificationStatus: verificationStatus, search: search, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnersResponseDto',) as PartnersResponseDto;
    
    }
    return null;
  }

  /// Get total number of partners
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminPartnersControllerGetTotalPartnersWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/admin/partners/total';

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

  /// Get total number of partners
  Future<TotalPartnersResponseDto?> adminPartnersControllerGetTotalPartners() async {
    final response = await adminPartnersControllerGetTotalPartnersWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TotalPartnersResponseDto',) as TotalPartnersResponseDto;
    
    }
    return null;
  }

  /// Review partner profile
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Partner ID
  ///
  /// * [ReviewPartnerProfileDto] reviewPartnerProfileDto (required):
  Future<Response> adminPartnersControllerReviewPartnerWithHttpInfo(String id, ReviewPartnerProfileDto reviewPartnerProfileDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/partners/{id}/review'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = reviewPartnerProfileDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Review partner profile
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///   Partner ID
  ///
  /// * [ReviewPartnerProfileDto] reviewPartnerProfileDto (required):
  Future<ReviewPartnerResponseDto?> adminPartnersControllerReviewPartner(String id, ReviewPartnerProfileDto reviewPartnerProfileDto,) async {
    final response = await adminPartnersControllerReviewPartnerWithHttpInfo(id, reviewPartnerProfileDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReviewPartnerResponseDto',) as ReviewPartnerResponseDto;
    
    }
    return null;
  }
}
