//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserWishlistApi {
  UserWishlistApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Add a product to the current user wishlist
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  Future<Response> userWishlistControllerAddItemWithHttpInfo(String productId,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/wishlist/{productId}'
      .replaceAll('{productId}', productId);

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

  /// Add a product to the current user wishlist
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  Future<WishlistItemResponseDto?> userWishlistControllerAddItem(String productId,) async {
    final response = await userWishlistControllerAddItemWithHttpInfo(productId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WishlistItemResponseDto',) as WishlistItemResponseDto;

    }
    return null;
  }

  /// List current user wishlist items
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> userWishlistControllerListWishlistWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/wishlist';

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

  /// List current user wishlist items
  Future<List<WishlistItemResponseDto>?> userWishlistControllerListWishlist() async {
    final response = await userWishlistControllerListWishlistWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<WishlistItemResponseDto>') as List)
        .cast<WishlistItemResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Remove a product from the current user wishlist
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  Future<Response> userWishlistControllerRemoveItemWithHttpInfo(String productId,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/wishlist/{productId}'
      .replaceAll('{productId}', productId);

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

  /// Remove a product from the current user wishlist
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  Future<void> userWishlistControllerRemoveItem(String productId,) async {
    final response = await userWishlistControllerRemoveItemWithHttpInfo(productId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
