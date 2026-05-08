//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminAuditLogsApi {
  AdminAuditLogsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get audit logs with optional filters
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] targetId:
  ///   Filter by Target ID
  ///
  /// * [String] actorId:
  ///   Filter by Actor ID
  ///
  /// * [String] action:
  ///   Filter by Action type
  Future<Response> auditControllerGetAuditLogsWithHttpInfo({ String? targetId, String? actorId, String? action, }) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/audit-logs';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (targetId != null) {
      queryParams.addAll(_queryParams('', 'targetId', targetId));
    }
    if (actorId != null) {
      queryParams.addAll(_queryParams('', 'actorId', actorId));
    }
    if (action != null) {
      queryParams.addAll(_queryParams('', 'action', action));
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

  /// Get audit logs with optional filters
  ///
  /// Parameters:
  ///
  /// * [String] targetId:
  ///   Filter by Target ID
  ///
  /// * [String] actorId:
  ///   Filter by Actor ID
  ///
  /// * [String] action:
  ///   Filter by Action type
  Future<List<Object>?> auditControllerGetAuditLogs({ String? targetId, String? actorId, String? action, }) async {
    final response = await auditControllerGetAuditLogsWithHttpInfo( targetId: targetId, actorId: actorId, action: action, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<Object>') as List)
        .cast<Object>()
        .toList(growable: false);

    }
    return null;
  }
}
