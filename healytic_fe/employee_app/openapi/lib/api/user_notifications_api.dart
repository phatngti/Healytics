//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserNotificationsApi {
  UserNotificationsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get user notifications (paginated, cursor-based)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Number of notifications to return
  ///
  /// * [String] cursor:
  ///   Cursor: fetch notifications before this ID (for pagination)
  ///
  /// * [String] type:
  ///   Filter by notification type
  ///
  /// * [bool] isRead:
  ///   Filter by read status
  Future<Response> userNotificationControllerGetNotificationsWithHttpInfo({ num? limit, String? cursor, String? type, bool? isRead, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/notifications';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }
    if (cursor != null) {
      queryParams.addAll(_queryParams('', 'cursor', cursor));
    }
    if (type != null) {
      queryParams.addAll(_queryParams('', 'type', type));
    }
    if (isRead != null) {
      queryParams.addAll(_queryParams('', 'isRead', isRead));
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

  /// Get user notifications (paginated, cursor-based)
  ///
  /// Parameters:
  ///
  /// * [num] limit:
  ///   Number of notifications to return
  ///
  /// * [String] cursor:
  ///   Cursor: fetch notifications before this ID (for pagination)
  ///
  /// * [String] type:
  ///   Filter by notification type
  ///
  /// * [bool] isRead:
  ///   Filter by read status
  Future<void> userNotificationControllerGetNotifications({ num? limit, String? cursor, String? type, bool? isRead, }) async {
    final response = await userNotificationControllerGetNotificationsWithHttpInfo( limit: limit, cursor: cursor, type: type, isRead: isRead, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get unread notification count
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userNotificationControllerGetUnreadCountWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/notifications/unread-count';

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

  /// Get unread notification count
  Future<void> userNotificationControllerGetUnreadCount() async {
    final response = await userNotificationControllerGetUnreadCountWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Mark all notifications as read
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userNotificationControllerMarkAllReadWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/notifications/read-all';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Mark all notifications as read
  Future<void> userNotificationControllerMarkAllRead() async {
    final response = await userNotificationControllerMarkAllReadWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Mark a specific notification as read
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> userNotificationControllerMarkReadWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/notifications/{id}/read'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PATCH',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Mark a specific notification as read
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> userNotificationControllerMarkRead(String id,) async {
    final response = await userNotificationControllerMarkReadWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
