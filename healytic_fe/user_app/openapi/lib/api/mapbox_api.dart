//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class MapboxApi {
  MapboxApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get driving directions route geometry
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] origin (required):
  ///   Origin coordinate in lat,lng format
  ///
  /// * [String] destination (required):
  ///   Destination coordinate in lat,lng format
  Future<Response> mapboxControllerDirectionsWithHttpInfo(String origin, String destination,) async {
    // ignore: prefer_const_declarations
    final path = r'/mapbox/directions';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'origin', origin));
      queryParams.addAll(_queryParams('', 'destination', destination));

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

  /// Get driving directions route geometry
  ///
  /// Parameters:
  ///
  /// * [String] origin (required):
  ///   Origin coordinate in lat,lng format
  ///
  /// * [String] destination (required):
  ///   Destination coordinate in lat,lng format
  Future<DirectionsResponseDto?> mapboxControllerDirections(String origin, String destination,) async {
    final response = await mapboxControllerDirectionsWithHttpInfo(origin, destination,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DirectionsResponseDto',) as DirectionsResponseDto;

    }
    return null;
  }

  /// Get travel distance and duration
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] origins (required):
  ///   Origins — pipe-separated coordinates or addresses (e.g. \"10.762,106.660|10.823,106.629\")
  ///
  /// * [String] destinations (required):
  ///   Destinations — pipe-separated coordinates or addresses (e.g. \"10.823,106.629|10.800,106.700\")
  Future<Response> mapboxControllerDistanceMatrixWithHttpInfo(String origins, String destinations,) async {
    // ignore: prefer_const_declarations
    final path = r'/mapbox/distance-matrix';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'origins', origins));
      queryParams.addAll(_queryParams('', 'destinations', destinations));

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

  /// Get travel distance and duration
  ///
  /// Parameters:
  ///
  /// * [String] origins (required):
  ///   Origins — pipe-separated coordinates or addresses (e.g. \"10.762,106.660|10.823,106.629\")
  ///
  /// * [String] destinations (required):
  ///   Destinations — pipe-separated coordinates or addresses (e.g. \"10.823,106.629|10.800,106.700\")
  Future<DistanceMatrixResponseDto?> mapboxControllerDistanceMatrix(String origins, String destinations,) async {
    final response = await mapboxControllerDistanceMatrixWithHttpInfo(origins, destinations,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DistanceMatrixResponseDto',) as DistanceMatrixResponseDto;

    }
    return null;
  }

  /// Geocode an address to lat/lng
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] address (required):
  ///   Address to geocode
  Future<Response> mapboxControllerGeocodeWithHttpInfo(String address,) async {
    // ignore: prefer_const_declarations
    final path = r'/mapbox/geocode';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'address', address));

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

  /// Geocode an address to lat/lng
  ///
  /// Parameters:
  ///
  /// * [String] address (required):
  ///   Address to geocode
  Future<GeocodeResponseDto?> mapboxControllerGeocode(String address,) async {
    final response = await mapboxControllerGeocodeWithHttpInfo(address,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GeocodeResponseDto',) as GeocodeResponseDto;

    }
    return null;
  }

  /// Get public access token for frontend/mobile SDKs
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> mapboxControllerGetClientKeyWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/mapbox/client-key';

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

  /// Get public access token for frontend/mobile SDKs
  Future<ClientKeyResponseDto?> mapboxControllerGetClientKey() async {
    final response = await mapboxControllerGetClientKeyWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ClientKeyResponseDto',) as ClientKeyResponseDto;

    }
    return null;
  }

  /// Reverse geocode lat/lng to address
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] lat (required):
  ///   Latitude
  ///
  /// * [num] lng (required):
  ///   Longitude
  Future<Response> mapboxControllerReverseGeocodeWithHttpInfo(num lat, num lng,) async {
    // ignore: prefer_const_declarations
    final path = r'/mapbox/reverse-geocode';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'lat', lat));
      queryParams.addAll(_queryParams('', 'lng', lng));

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

  /// Reverse geocode lat/lng to address
  ///
  /// Parameters:
  ///
  /// * [num] lat (required):
  ///   Latitude
  ///
  /// * [num] lng (required):
  ///   Longitude
  Future<GeocodeResponseDto?> mapboxControllerReverseGeocode(num lat, num lng,) async {
    final response = await mapboxControllerReverseGeocodeWithHttpInfo(lat, lng,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'GeocodeResponseDto',) as GeocodeResponseDto;

    }
    return null;
  }
}
