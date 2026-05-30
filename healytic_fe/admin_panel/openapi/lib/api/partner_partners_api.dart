//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerPartnersApi {
  PartnerPartnersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get own business profile
  ///
  /// Partner gets their own business entity information
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerSelfControllerGetMyProfileWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/partners/me';

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

  /// Get own business profile
  ///
  /// Partner gets their own business entity information
  Future<MyProfileResponseDto?> partnerSelfControllerGetMyProfile() async {
    final response = await partnerSelfControllerGetMyProfileWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyProfileResponseDto',) as MyProfileResponseDto;

    }
    return null;
  }

  /// Get partner clinic profile completion data
  ///
  /// Returns verified clinic identity data and editable post-verification profile fields.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerSelfControllerGetMyProfileCompletionWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/partners/me/completion';

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

  /// Get partner clinic profile completion data
  ///
  /// Returns verified clinic identity data and editable post-verification profile fields.
  Future<MyProfileCompletionResponseDto?> partnerSelfControllerGetMyProfileCompletion() async {
    final response = await partnerSelfControllerGetMyProfileCompletionWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyProfileCompletionResponseDto',) as MyProfileCompletionResponseDto;

    }
    return null;
  }

  /// Get partner public profile edit aggregate
  ///
  /// Returns the full partner profile with read-only business context and editable storefront fields. Only available after profile completion.
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerSelfControllerGetPublicProfileWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/partners/public-profile';

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

  /// Get partner public profile edit aggregate
  ///
  /// Returns the full partner profile with read-only business context and editable storefront fields. Only available after profile completion.
  Future<PartnerPublicProfileResponseDto?> partnerSelfControllerGetPublicProfile() async {
    final response = await partnerSelfControllerGetPublicProfileWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerPublicProfileResponseDto',) as PartnerPublicProfileResponseDto;

    }
    return null;
  }

  /// Update own business profile
  ///
  /// Partner updates their business information (limited fields)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UpdatePartnerDto] updatePartnerDto (required):
  Future<Response> partnerSelfControllerUpdateMyProfileWithHttpInfo(UpdatePartnerDto updatePartnerDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/partners/me';

    // ignore: prefer_final_locals
    Object? postBody = updatePartnerDto;

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

  /// Update own business profile
  ///
  /// Partner updates their business information (limited fields)
  ///
  /// Parameters:
  ///
  /// * [UpdatePartnerDto] updatePartnerDto (required):
  Future<MyProfileResponseDto?> partnerSelfControllerUpdateMyProfile(UpdatePartnerDto updatePartnerDto,) async {
    final response = await partnerSelfControllerUpdateMyProfileWithHttpInfo(updatePartnerDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyProfileResponseDto',) as MyProfileResponseDto;

    }
    return null;
  }

  /// Update partner clinic profile completion data
  ///
  /// Immediately publishes post-verification clinic profile fields without entering admin review again.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UpdatePartnerProfileCompletionDto] updatePartnerProfileCompletionDto (required):
  Future<Response> partnerSelfControllerUpdateMyProfileCompletionWithHttpInfo(UpdatePartnerProfileCompletionDto updatePartnerProfileCompletionDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/partners/me/completion';

    // ignore: prefer_final_locals
    Object? postBody = updatePartnerProfileCompletionDto;

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

  /// Update partner clinic profile completion data
  ///
  /// Immediately publishes post-verification clinic profile fields without entering admin review again.
  ///
  /// Parameters:
  ///
  /// * [UpdatePartnerProfileCompletionDto] updatePartnerProfileCompletionDto (required):
  Future<MyProfileCompletionResponseDto?> partnerSelfControllerUpdateMyProfileCompletion(UpdatePartnerProfileCompletionDto updatePartnerProfileCompletionDto,) async {
    final response = await partnerSelfControllerUpdateMyProfileCompletionWithHttpInfo(updatePartnerProfileCompletionDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MyProfileCompletionResponseDto',) as MyProfileCompletionResponseDto;

    }
    return null;
  }

  /// Update partner public profile (storefront only)
  ///
  /// Updates public-facing clinic profile fields (cover image, logo, description, gallery, certifications). Does not affect admin-verified business data.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UpdatePartnerPublicProfileDto] updatePartnerPublicProfileDto (required):
  Future<Response> partnerSelfControllerUpdatePublicProfileWithHttpInfo(UpdatePartnerPublicProfileDto updatePartnerPublicProfileDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/partners/public-profile';

    // ignore: prefer_final_locals
    Object? postBody = updatePartnerPublicProfileDto;

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

  /// Update partner public profile (storefront only)
  ///
  /// Updates public-facing clinic profile fields (cover image, logo, description, gallery, certifications). Does not affect admin-verified business data.
  ///
  /// Parameters:
  ///
  /// * [UpdatePartnerPublicProfileDto] updatePartnerPublicProfileDto (required):
  Future<PartnerPublicProfileResponseDto?> partnerSelfControllerUpdatePublicProfile(UpdatePartnerPublicProfileDto updatePartnerPublicProfileDto,) async {
    final response = await partnerSelfControllerUpdatePublicProfileWithHttpInfo(updatePartnerPublicProfileDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerPublicProfileResponseDto',) as PartnerPublicProfileResponseDto;

    }
    return null;
  }
}
