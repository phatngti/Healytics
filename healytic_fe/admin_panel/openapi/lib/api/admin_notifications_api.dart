//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminNotificationsApi {
  AdminNotificationsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create and send a system-wide broadcast notification
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateBroadcastDto] createBroadcastDto (required):
  Future<Response> adminNotificationControllerCreateBroadcastWithHttpInfo(CreateBroadcastDto createBroadcastDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/notifications/broadcast';

    // ignore: prefer_final_locals
    Object? postBody = createBroadcastDto;

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

  /// Create and send a system-wide broadcast notification
  ///
  /// Parameters:
  ///
  /// * [CreateBroadcastDto] createBroadcastDto (required):
  Future<NotificationResponseDto?> adminNotificationControllerCreateBroadcast(CreateBroadcastDto createBroadcastDto,) async {
    final response = await adminNotificationControllerCreateBroadcastWithHttpInfo(createBroadcastDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'NotificationResponseDto',) as NotificationResponseDto;
    
    }
    return null;
  }

  /// List sent broadcast notifications (audit)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminNotificationControllerGetBroadcastsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/admin/notifications/broadcasts';

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

  /// List sent broadcast notifications (audit)
  Future<List<NotificationResponseDto>?> adminNotificationControllerGetBroadcasts() async {
    final response = await adminNotificationControllerGetBroadcastsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<NotificationResponseDto>') as List)
        .cast<NotificationResponseDto>()
        .toList(growable: false);

    }
    return null;
  }
}
