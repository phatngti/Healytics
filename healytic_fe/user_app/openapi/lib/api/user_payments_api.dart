//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserPaymentsApi {
  UserPaymentsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Confirm signed MoMo return payload for booking
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [Object] body (required):
  Future<Response> userPaymentControllerConfirmMoMoReturnWithHttpInfo(String bookingId, Object body,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/momo/{bookingId}/return'
      .replaceAll('{bookingId}', bookingId);

    // ignore: prefer_final_locals
    Object? postBody = body;

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

  /// Confirm signed MoMo return payload for booking
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [Object] body (required):
  Future<void> userPaymentControllerConfirmMoMoReturn(String bookingId, Object body,) async {
    final response = await userPaymentControllerConfirmMoMoReturnWithHttpInfo(bookingId, body,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Confirm and persist a saved Stripe card
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] setupIntentId (required):
  ///
  /// * [ConfirmStripeSetupIntentDto] confirmStripeSetupIntentDto (required):
  Future<Response> userPaymentControllerConfirmStripeSetupIntentWithHttpInfo(String setupIntentId, ConfirmStripeSetupIntentDto confirmStripeSetupIntentDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/stripe/setup-intents/{setupIntentId}/confirm'
      .replaceAll('{setupIntentId}', setupIntentId);

    // ignore: prefer_final_locals
    Object? postBody = confirmStripeSetupIntentDto;

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

  /// Confirm and persist a saved Stripe card
  ///
  /// Parameters:
  ///
  /// * [String] setupIntentId (required):
  ///
  /// * [ConfirmStripeSetupIntentDto] confirmStripeSetupIntentDto (required):
  Future<SavedPaymentCardDto?> userPaymentControllerConfirmStripeSetupIntent(String setupIntentId, ConfirmStripeSetupIntentDto confirmStripeSetupIntentDto,) async {
    final response = await userPaymentControllerConfirmStripeSetupIntentWithHttpInfo(setupIntentId, confirmStripeSetupIntentDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SavedPaymentCardDto',) as SavedPaymentCardDto;

    }
    return null;
  }

  /// Create MoMo payment for booking
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [CreateMoMoPaymentDto] createMoMoPaymentDto (required):
  Future<Response> userPaymentControllerCreateMoMoPaymentWithHttpInfo(String bookingId, CreateMoMoPaymentDto createMoMoPaymentDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/momo/{bookingId}'
      .replaceAll('{bookingId}', bookingId);

    // ignore: prefer_final_locals
    Object? postBody = createMoMoPaymentDto;

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

  /// Create MoMo payment for booking
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [CreateMoMoPaymentDto] createMoMoPaymentDto (required):
  Future<Object?> userPaymentControllerCreateMoMoPayment(String bookingId, CreateMoMoPaymentDto createMoMoPaymentDto,) async {
    final response = await userPaymentControllerCreateMoMoPaymentWithHttpInfo(bookingId, createMoMoPaymentDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;

    }
    return null;
  }

  /// Create Stripe payment for booking (card)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [CreateStripePaymentDto] createStripePaymentDto (required):
  Future<Response> userPaymentControllerCreateStripePaymentWithHttpInfo(String bookingId, CreateStripePaymentDto createStripePaymentDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/stripe/{bookingId}'
      .replaceAll('{bookingId}', bookingId);

    // ignore: prefer_final_locals
    Object? postBody = createStripePaymentDto;

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

  /// Create Stripe payment for booking (card)
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [CreateStripePaymentDto] createStripePaymentDto (required):
  Future<StripePaymentResponseDto?> userPaymentControllerCreateStripePayment(String bookingId, CreateStripePaymentDto createStripePaymentDto,) async {
    final response = await userPaymentControllerCreateStripePaymentWithHttpInfo(bookingId, createStripePaymentDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StripePaymentResponseDto',) as StripePaymentResponseDto;

    }
    return null;
  }

  /// Create Stripe SetupIntent for adding a card
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userPaymentControllerCreateStripeSetupIntentWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/stripe/setup-intents';

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

  /// Create Stripe SetupIntent for adding a card
  Future<CreateStripeSetupIntentResponseDto?> userPaymentControllerCreateStripeSetupIntent() async {
    final response = await userPaymentControllerCreateStripeSetupIntentWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CreateStripeSetupIntentResponseDto',) as CreateStripeSetupIntentResponseDto;

    }
    return null;
  }

  /// Delete a saved payment card
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] cardId (required):
  Future<Response> userPaymentControllerDeleteCardWithHttpInfo(String cardId,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/cards/{cardId}'
      .replaceAll('{cardId}', cardId);

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

  /// Delete a saved payment card
  ///
  /// Parameters:
  ///
  /// * [String] cardId (required):
  Future<List<SavedPaymentCardDto>?> userPaymentControllerDeleteCard(String cardId,) async {
    final response = await userPaymentControllerDeleteCardWithHttpInfo(cardId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<SavedPaymentCardDto>') as List)
        .cast<SavedPaymentCardDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// List saved payment cards
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userPaymentControllerListCardsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/cards';

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

  /// List saved payment cards
  Future<List<SavedPaymentCardDto>?> userPaymentControllerListCards() async {
    final response = await userPaymentControllerListCardsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<SavedPaymentCardDto>') as List)
        .cast<SavedPaymentCardDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Request MoMo refund for booking
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [CreateMoMoRefundDto] createMoMoRefundDto (required):
  Future<Response> userPaymentControllerRefundMoMoPaymentWithHttpInfo(String bookingId, CreateMoMoRefundDto createMoMoRefundDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/momo/{bookingId}/refund'
      .replaceAll('{bookingId}', bookingId);

    // ignore: prefer_final_locals
    Object? postBody = createMoMoRefundDto;

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

  /// Request MoMo refund for booking
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  ///
  /// * [CreateMoMoRefundDto] createMoMoRefundDto (required):
  Future<Object?> userPaymentControllerRefundMoMoPayment(String bookingId, CreateMoMoRefundDto createMoMoRefundDto,) async {
    final response = await userPaymentControllerRefundMoMoPaymentWithHttpInfo(bookingId, createMoMoRefundDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;

    }
    return null;
  }

  /// Request Stripe refund for booking
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  Future<Response> userPaymentControllerRefundStripePaymentWithHttpInfo(String bookingId,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/stripe/{bookingId}/refund'
      .replaceAll('{bookingId}', bookingId);

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

  /// Request Stripe refund for booking
  ///
  /// Parameters:
  ///
  /// * [String] bookingId (required):
  Future<StripeRefundResponseDto?> userPaymentControllerRefundStripePayment(String bookingId,) async {
    final response = await userPaymentControllerRefundStripePaymentWithHttpInfo(bookingId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StripeRefundResponseDto',) as StripeRefundResponseDto;

    }
    return null;
  }

  /// Set a saved card as the default card
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] cardId (required):
  Future<Response> userPaymentControllerSetDefaultCardWithHttpInfo(String cardId,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/payments/cards/{cardId}/default'
      .replaceAll('{cardId}', cardId);

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

  /// Set a saved card as the default card
  ///
  /// Parameters:
  ///
  /// * [String] cardId (required):
  Future<SavedPaymentCardDto?> userPaymentControllerSetDefaultCard(String cardId,) async {
    final response = await userPaymentControllerSetDefaultCardWithHttpInfo(cardId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SavedPaymentCardDto',) as SavedPaymentCardDto;

    }
    return null;
  }
}
