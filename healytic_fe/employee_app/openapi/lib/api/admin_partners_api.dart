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

  /// Get partner dashboard statistics
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [AdminPartnerScope] scope:
  ///   Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
  ///
  /// * [PartnerVerificationStatus] verificationStatus:
  ///   Explicit status filter
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  ///
  /// * [AdminPartnerSortBy] sortBy:
  ///   Column to sort by
  ///
  /// * [AdminPartnerSortDirection] sortDirection:
  ///   Sort direction
  Future<Response> adminPartnersControllerGetPartnerStatsWithHttpInfo({ num? page, num? limit, AdminPartnerScope? scope, PartnerVerificationStatus? verificationStatus, String? search, AdminPartnerSortBy? sortBy, AdminPartnerSortDirection? sortDirection, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/partners/stats';

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
    if (scope != null) {
      queryParams.addAll(_queryParams('', 'scope', scope));
    }
    if (verificationStatus != null) {
      queryParams.addAll(_queryParams('', 'verificationStatus', verificationStatus));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (sortBy != null) {
      queryParams.addAll(_queryParams('', 'sortBy', sortBy));
    }
    if (sortDirection != null) {
      queryParams.addAll(_queryParams('', 'sortDirection', sortDirection));
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

  /// Get partner dashboard statistics
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [AdminPartnerScope] scope:
  ///   Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
  ///
  /// * [PartnerVerificationStatus] verificationStatus:
  ///   Explicit status filter
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  ///
  /// * [AdminPartnerSortBy] sortBy:
  ///   Column to sort by
  ///
  /// * [AdminPartnerSortDirection] sortDirection:
  ///   Sort direction
  Future<AdminPartnerStatsResponseDto?> adminPartnersControllerGetPartnerStats({ num? page, num? limit, AdminPartnerScope? scope, PartnerVerificationStatus? verificationStatus, String? search, AdminPartnerSortBy? sortBy, AdminPartnerSortDirection? sortDirection, }) async {
    final response = await adminPartnersControllerGetPartnerStatsWithHttpInfo( page: page, limit: limit, scope: scope, verificationStatus: verificationStatus, search: search, sortBy: sortBy, sortDirection: sortDirection, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminPartnerStatsResponseDto',) as AdminPartnerStatsResponseDto;
    
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
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [AdminPartnerScope] scope:
  ///   Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
  ///
  /// * [PartnerVerificationStatus] verificationStatus:
  ///   Explicit status filter
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  ///
  /// * [AdminPartnerSortBy] sortBy:
  ///   Column to sort by
  ///
  /// * [AdminPartnerSortDirection] sortDirection:
  ///   Sort direction
  Future<Response> adminPartnersControllerGetPartnersWithHttpInfo({ num? page, num? limit, AdminPartnerScope? scope, PartnerVerificationStatus? verificationStatus, String? search, AdminPartnerSortBy? sortBy, AdminPartnerSortDirection? sortDirection, }) async {
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
    if (scope != null) {
      queryParams.addAll(_queryParams('', 'scope', scope));
    }
    if (verificationStatus != null) {
      queryParams.addAll(_queryParams('', 'verificationStatus', verificationStatus));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (sortBy != null) {
      queryParams.addAll(_queryParams('', 'sortBy', sortBy));
    }
    if (sortDirection != null) {
      queryParams.addAll(_queryParams('', 'sortDirection', sortDirection));
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
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [AdminPartnerScope] scope:
  ///   Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
  ///
  /// * [PartnerVerificationStatus] verificationStatus:
  ///   Explicit status filter
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  ///
  /// * [AdminPartnerSortBy] sortBy:
  ///   Column to sort by
  ///
  /// * [AdminPartnerSortDirection] sortDirection:
  ///   Sort direction
  Future<AdminPartnersResponseDto?> adminPartnersControllerGetPartners({ num? page, num? limit, AdminPartnerScope? scope, PartnerVerificationStatus? verificationStatus, String? search, AdminPartnerSortBy? sortBy, AdminPartnerSortDirection? sortDirection, }) async {
    final response = await adminPartnersControllerGetPartnersWithHttpInfo( page: page, limit: limit, scope: scope, verificationStatus: verificationStatus, search: search, sortBy: sortBy, sortDirection: sortDirection, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminPartnersResponseDto',) as AdminPartnersResponseDto;
    
    }
    return null;
  }

  /// Get total number of partners
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [AdminPartnerScope] scope:
  ///   Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
  ///
  /// * [PartnerVerificationStatus] verificationStatus:
  ///   Explicit status filter
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  ///
  /// * [AdminPartnerSortBy] sortBy:
  ///   Column to sort by
  ///
  /// * [AdminPartnerSortDirection] sortDirection:
  ///   Sort direction
  Future<Response> adminPartnersControllerGetTotalPartnersWithHttpInfo({ num? page, num? limit, AdminPartnerScope? scope, PartnerVerificationStatus? verificationStatus, String? search, AdminPartnerSortBy? sortBy, AdminPartnerSortDirection? sortDirection, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/partners/total';

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
    if (scope != null) {
      queryParams.addAll(_queryParams('', 'scope', scope));
    }
    if (verificationStatus != null) {
      queryParams.addAll(_queryParams('', 'verificationStatus', verificationStatus));
    }
    if (search != null) {
      queryParams.addAll(_queryParams('', 'search', search));
    }
    if (sortBy != null) {
      queryParams.addAll(_queryParams('', 'sortBy', sortBy));
    }
    if (sortDirection != null) {
      queryParams.addAll(_queryParams('', 'sortDirection', sortDirection));
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

  /// Get total number of partners
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Items per page
  ///
  /// * [AdminPartnerScope] scope:
  ///   Tab scope: VERIFICATION_QUEUE or ALL_PROVIDERS
  ///
  /// * [PartnerVerificationStatus] verificationStatus:
  ///   Explicit status filter
  ///
  /// * [String] search:
  ///   Search by tax code, brand name, legal name, or email
  ///
  /// * [AdminPartnerSortBy] sortBy:
  ///   Column to sort by
  ///
  /// * [AdminPartnerSortDirection] sortDirection:
  ///   Sort direction
  Future<TotalPartnersResponseDto?> adminPartnersControllerGetTotalPartners({ num? page, num? limit, AdminPartnerScope? scope, PartnerVerificationStatus? verificationStatus, String? search, AdminPartnerSortBy? sortBy, AdminPartnerSortDirection? sortDirection, }) async {
    final response = await adminPartnersControllerGetTotalPartnersWithHttpInfo( page: page, limit: limit, scope: scope, verificationStatus: verificationStatus, search: search, sortBy: sortBy, sortDirection: sortDirection, );
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
