//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class PartnerProductsApi {
  PartnerProductsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreatePartnerProductDto] createPartnerProductDto (required):
  Future<Response> partnerProductsControllerCreateWithHttpInfo(CreatePartnerProductDto createPartnerProductDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/products';

    // ignore: prefer_final_locals
    Object? postBody = createPartnerProductDto;

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

  /// Create a new product
  ///
  /// Parameters:
  ///
  /// * [CreatePartnerProductDto] createPartnerProductDto (required):
  Future<PartnerProductResponseDto?> partnerProductsControllerCreate(CreatePartnerProductDto createPartnerProductDto,) async {
    final response = await partnerProductsControllerCreateWithHttpInfo(createPartnerProductDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerProductResponseDto',) as PartnerProductResponseDto;
    
    }
    return null;
  }

  /// Get all products
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> partnerProductsControllerFindAllWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/partner/products';

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

  /// Get all products
  Future<List<PartnerProductResponseDto>?> partnerProductsControllerFindAll() async {
    final response = await partnerProductsControllerFindAllWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<PartnerProductResponseDto>') as List)
        .cast<PartnerProductResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get a product by slug
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<Response> partnerProductsControllerFindBySlugWithHttpInfo(String slug,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/products/slug/{slug}'
      .replaceAll('{slug}', slug);

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

  /// Get a product by slug
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<PartnerProductResponseDto?> partnerProductsControllerFindBySlug(String slug,) async {
    final response = await partnerProductsControllerFindBySlugWithHttpInfo(slug,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerProductResponseDto',) as PartnerProductResponseDto;
    
    }
    return null;
  }

  /// Get full product details by slug
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<Response> partnerProductsControllerGetDetailsWithHttpInfo(String slug,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/products/slug/{slug}/details'
      .replaceAll('{slug}', slug);

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

  /// Get full product details by slug
  ///
  /// Parameters:
  ///
  /// * [String] slug (required):
  Future<PartnerProductDetailResponseDto?> partnerProductsControllerGetDetails(String slug,) async {
    final response = await partnerProductsControllerGetDetailsWithHttpInfo(slug,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerProductDetailResponseDto',) as PartnerProductDetailResponseDto;
    
    }
    return null;
  }

  /// Delete a product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> partnerProductsControllerRemoveWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/products/{id}'
      .replaceAll('{id}', id);

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

  /// Delete a product
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> partnerProductsControllerRemove(String id,) async {
    final response = await partnerProductsControllerRemoveWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update a product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdatePartnerProductDto] updatePartnerProductDto (required):
  Future<Response> partnerProductsControllerUpdateWithHttpInfo(String id, UpdatePartnerProductDto updatePartnerProductDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/partner/products/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updatePartnerProductDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


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

  /// Update a product
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdatePartnerProductDto] updatePartnerProductDto (required):
  Future<PartnerProductResponseDto?> partnerProductsControllerUpdate(String id, UpdatePartnerProductDto updatePartnerProductDto,) async {
    final response = await partnerProductsControllerUpdateWithHttpInfo(id, updatePartnerProductDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PartnerProductResponseDto',) as PartnerProductResponseDto;
    
    }
    return null;
  }
}
