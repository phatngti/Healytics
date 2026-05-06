//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserDevicesApi {
  UserDevicesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Register a device token for push notifications
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RegisterDeviceDto] registerDeviceDto (required):
  Future<Response> userDeviceControllerRegisterDeviceWithHttpInfo(RegisterDeviceDto registerDeviceDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/devices';

    // ignore: prefer_final_locals
    Object? postBody = registerDeviceDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Register a device token for push notifications
  ///
  /// Parameters:
  ///
  /// * [RegisterDeviceDto] registerDeviceDto (required):
  Future<void> userDeviceControllerRegisterDevice(RegisterDeviceDto registerDeviceDto,) async {
    final response = await userDeviceControllerRegisterDeviceWithHttpInfo(registerDeviceDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Unregister a device token (e.g. on logout)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] token (required):
  Future<Response> userDeviceControllerUnregisterDeviceWithHttpInfo(String token,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/devices/{token}'
      .replaceAll('{token}', token);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Unregister a device token (e.g. on logout)
  ///
  /// Parameters:
  ///
  /// * [String] token (required):
  Future<void> userDeviceControllerUnregisterDevice(String token,) async {
    final response = await userDeviceControllerUnregisterDeviceWithHttpInfo(token,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
