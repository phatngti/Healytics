//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ChatbotApi {
  ChatbotApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get paginated list of conversations
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Number of items per page
  Future<Response> chatbotControllerListConversationsWithHttpInfo({ num? page, num? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/chatbot/conversations';

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

  /// Get paginated list of conversations
  ///
  /// Parameters:
  ///
  /// * [num] page:
  ///   Page number (1-indexed)
  ///
  /// * [num] limit:
  ///   Number of items per page
  Future<ConversationListResponseDto?> chatbotControllerListConversations({ num? page, num? limit, }) async {
    final response = await chatbotControllerListConversationsWithHttpInfo( page: page, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ConversationListResponseDto',) as ConversationListResponseDto;
    
    }
    return null;
  }

  /// Send a message to the chatbot
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SendMessageDto] sendMessageDto (required):
  Future<Response> chatbotControllerSendMessageWithHttpInfo(SendMessageDto sendMessageDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/chatbot/send';

    // ignore: prefer_final_locals
    Object? postBody = sendMessageDto;

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

  /// Send a message to the chatbot
  ///
  /// Parameters:
  ///
  /// * [SendMessageDto] sendMessageDto (required):
  Future<SendMessageResponseDto?> chatbotControllerSendMessage(SendMessageDto sendMessageDto,) async {
    final response = await chatbotControllerSendMessageWithHttpInfo(sendMessageDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SendMessageResponseDto',) as SendMessageResponseDto;
    
    }
    return null;
  }

  /// Stream chatbot response via SSE
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] conversationId (required):
  Future<Response> chatbotControllerStreamChatWithHttpInfo(String conversationId,) async {
    // ignore: prefer_const_declarations
    final path = r'/chatbot/stream/{conversationId}'
      .replaceAll('{conversationId}', conversationId);

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

  /// Stream chatbot response via SSE
  ///
  /// Parameters:
  ///
  /// * [String] conversationId (required):
  Future<void> chatbotControllerStreamChat(String conversationId,) async {
    final response = await chatbotControllerStreamChatWithHttpInfo(conversationId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
