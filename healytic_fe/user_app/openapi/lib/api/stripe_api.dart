//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class StripeApi {
  StripeApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Stripe webhook callback (server-to-server)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] stripeSignature (required):
  Future<Response> stripeWebhookControllerHandleStripeWebhookWithHttpInfo(String stripeSignature,) async {
    // ignore: prefer_const_declarations
    final path = r'/stripe/webhook';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    headerParams[r'stripe-signature'] = parameterToString(stripeSignature);

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

  /// Stripe webhook callback (server-to-server)
  ///
  /// Parameters:
  ///
  /// * [String] stripeSignature (required):
  Future<void> stripeWebhookControllerHandleStripeWebhook(String stripeSignature,) async {
    final response = await stripeWebhookControllerHandleStripeWebhookWithHttpInfo(stripeSignature,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
