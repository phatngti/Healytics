//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerChatApi {
  PartnerChatApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new conversation with a user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateConversationDto] createConversationDto (required):
  Future<Response> partnerChatControllerCreateConversationWithHttpInfo(CreateConversationDto createConversationDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/chat/conversations';

    // ignore: prefer_final_locals
    Object? postBody = createConversationDto;

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

  /// Create a new conversation with a user
  ///
  /// Parameters:
  ///
  /// * [CreateConversationDto] createConversationDto (required):
  Future<ConversationResponseDto?> partnerChatControllerCreateConversation(CreateConversationDto createConversationDto,) async {
    final response = await partnerChatControllerCreateConversationWithHttpInfo(createConversationDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConversationResponseDto',) as ConversationResponseDto;

    }
    return null;
  }

  /// List all conversations for the current partner
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerChatControllerGetConversationsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/chat/conversations';

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

  /// List all conversations for the current partner
  Future<List<ConversationResponseDto>?> partnerChatControllerGetConversations() async {
    final response = await partnerChatControllerGetConversationsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ConversationResponseDto>') as List)
        .cast<ConversationResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get message history for a conversation (cursor-paginated)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] beforeId:
  ///   Fetch messages older than this message ID (cursor)
  ///
  /// * [num] limit:
  ///   Number of messages to return (max 50)
  Future<Response> partnerChatControllerGetMessagesWithHttpInfo(String id, { String? beforeId, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/chat/conversations/{id}/messages'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (beforeId != null) {
      queryParams.addAll(_queryParams('', 'beforeId', beforeId));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
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

  /// Get message history for a conversation (cursor-paginated)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] beforeId:
  ///   Fetch messages older than this message ID (cursor)
  ///
  /// * [num] limit:
  ///   Number of messages to return (max 50)
  Future<void> partnerChatControllerGetMessages(String id, { String? beforeId, num? limit, }) async {
    final response = await partnerChatControllerGetMessagesWithHttpInfo(id,  beforeId: beforeId, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Mark all messages in a conversation as read
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> partnerChatControllerMarkReadWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/chat/conversations/{id}/read'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


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

  /// Mark all messages in a conversation as read
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> partnerChatControllerMarkRead(String id,) async {
    final response = await partnerChatControllerMarkReadWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
