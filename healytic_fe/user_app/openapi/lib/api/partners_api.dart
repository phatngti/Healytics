//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnersApi {
  PartnersApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get all business services
  ///
  /// Returns list of all business services with Vietnamese labels for dropdown selection
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnersControllerGetBusinessServicesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partners/business-services';

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

  /// Get all business services
  ///
  /// Returns list of all business services with Vietnamese labels for dropdown selection
  Future<BusinessServicesResponseDto?> partnersControllerGetBusinessServices() async {
    final response = await partnersControllerGetBusinessServicesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BusinessServicesResponseDto',) as BusinessServicesResponseDto;
    
    }
    return null;
  }

  /// Get own business profile
  ///
  /// Partner gets their own business entity information
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnersControllerGetMyProfileWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partners/me';

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
  Future<MyProfileResponseDto?> partnersControllerGetMyProfile() async {
    final response = await partnersControllerGetMyProfileWithHttpInfo();
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

  /// Update own business profile
  ///
  /// Partner updates their business information (limited fields)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [UpdatePartnerDto] updatePartnerDto (required):
  Future<Response> partnersControllerUpdateMyProfileWithHttpInfo(UpdatePartnerDto updatePartnerDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partners/me';

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
  Future<MyProfileResponseDto?> partnersControllerUpdateMyProfile(UpdatePartnerDto updatePartnerDto,) async {
    final response = await partnersControllerUpdateMyProfileWithHttpInfo(updatePartnerDto,);
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
}
