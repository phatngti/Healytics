//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class RecommenderApi {
  RecommenderApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Recommend Chatbot
  ///
  /// Chatbot recommender (non-stream).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [ChatbotRecommenderRequest] chatbotRecommenderRequest (required):
  Future<Response> recommendChatbotRecommenderChatbotPostWithHttpInfo(ChatbotRecommenderRequest chatbotRecommenderRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/recommender/chatbot';

    // ignore: prefer_final_locals
    Object? postBody = chatbotRecommenderRequest;

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

  /// Recommend Chatbot
  ///
  /// Chatbot recommender (non-stream).
  ///
  /// Parameters:
  ///
  /// * [ChatbotRecommenderRequest] chatbotRecommenderRequest (required):
  Future<ChatbotRecommendationResponse?> recommendChatbotRecommenderChatbotPost(ChatbotRecommenderRequest chatbotRecommenderRequest,) async {
    final response = await recommendChatbotRecommenderChatbotPostWithHttpInfo(chatbotRecommenderRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ChatbotRecommendationResponse',) as ChatbotRecommendationResponse;

    }
    return null;
  }

  /// Recommend Home
  ///
  /// Home recommender (non-stream).
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [HomeRecommenderRequest] homeRecommenderRequest (required):
  Future<Response> recommendHomeRecommenderHomePostWithHttpInfo(HomeRecommenderRequest homeRecommenderRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/recommender/home';

    // ignore: prefer_final_locals
    Object? postBody = homeRecommenderRequest;

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

  /// Recommend Home
  ///
  /// Home recommender (non-stream).
  ///
  /// Parameters:
  ///
  /// * [HomeRecommenderRequest] homeRecommenderRequest (required):
  Future<RecommendationResponse?> recommendHomeRecommenderHomePost(HomeRecommenderRequest homeRecommenderRequest,) async {
    final response = await recommendHomeRecommenderHomePostWithHttpInfo(homeRecommenderRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RecommendationResponse',) as RecommendationResponse;

    }
    return null;
  }
}
