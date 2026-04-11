//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class CartApi {
  CartApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add service to cart
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AddToCartDto] addToCartDto (required):
  Future<Response> cartControllerAddItemWithHttpInfo(AddToCartDto addToCartDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/cart';

    // ignore: prefer_final_locals
    Object? postBody = addToCartDto;

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

  /// Add service to cart
  ///
  /// Parameters:
  ///
  /// * [AddToCartDto] addToCartDto (required):
  Future<CartItemResponseDto?> cartControllerAddItem(AddToCartDto addToCartDto,) async {
    final response = await cartControllerAddItemWithHttpInfo(addToCartDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CartItemResponseDto',) as CartItemResponseDto;
    
    }
    return null;
  }

  /// Clear all cart items
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> cartControllerClearCartWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/cart';

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

  /// Clear all cart items
  Future<void> cartControllerClearCart() async {
    final response = await cartControllerClearCartWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get all cart items for current user
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> cartControllerGetItemsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/cart';

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

  /// Get all cart items for current user
  Future<List<CartItemResponseDto>?> cartControllerGetItems() async {
    final response = await cartControllerGetItemsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<CartItemResponseDto>') as List)
        .cast<CartItemResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Remove an item from cart
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] cartItemId (required):
  Future<Response> cartControllerRemoveItemWithHttpInfo(String cartItemId,) async {
    // ignore: prefer_const_declarations
    final path = r'/cart/{cartItemId}'
      .replaceAll('{cartItemId}', cartItemId);

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

  /// Remove an item from cart
  ///
  /// Parameters:
  ///
  /// * [String] cartItemId (required):
  Future<void> cartControllerRemoveItem(String cartItemId,) async {
    final response = await cartControllerRemoveItemWithHttpInfo(cartItemId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
