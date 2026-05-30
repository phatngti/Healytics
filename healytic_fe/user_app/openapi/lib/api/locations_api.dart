//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class LocationsApi {
  LocationsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get all districts in a province
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] provinceId (required):
  Future<Response> locationsControllerGetDistrictsWithHttpInfo(String provinceId,) async {
    // ignore: prefer_const_declarations
    final path = r'/locations/provinces/{provinceId}/districts'
      .replaceAll('{provinceId}', provinceId);

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

  /// Get all districts in a province
  ///
  /// Parameters:
  ///
  /// * [String] provinceId (required):
  Future<LocationListResponseDto?> locationsControllerGetDistricts(String provinceId,) async {
    final response = await locationsControllerGetDistrictsWithHttpInfo(provinceId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LocationListResponseDto',) as LocationListResponseDto;

    }
    return null;
  }

  /// Get all provinces in Vietnam
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> locationsControllerGetProvincesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/locations/provinces';

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

  /// Get all provinces in Vietnam
  Future<LocationListResponseDto?> locationsControllerGetProvinces() async {
    final response = await locationsControllerGetProvincesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LocationListResponseDto',) as LocationListResponseDto;

    }
    return null;
  }

  /// Get all wards in a district
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] districtId (required):
  Future<Response> locationsControllerGetWardsWithHttpInfo(String districtId,) async {
    // ignore: prefer_const_declarations
    final path = r'/locations/districts/{districtId}/wards'
      .replaceAll('{districtId}', districtId);

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

  /// Get all wards in a district
  ///
  /// Parameters:
  ///
  /// * [String] districtId (required):
  Future<LocationListResponseDto?> locationsControllerGetWards(String districtId,) async {
    final response = await locationsControllerGetWardsWithHttpInfo(districtId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LocationListResponseDto',) as LocationListResponseDto;

    }
    return null;
  }
}
