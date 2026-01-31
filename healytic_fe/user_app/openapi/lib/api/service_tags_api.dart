//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ServiceTagsApi {
  ServiceTagsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Attach a tag to a product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] productId (required):
  Future<Response> serviceTagsControllerAttachToProductWithHttpInfo(String id, String productId,) async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags/{id}/products/{productId}'
      .replaceAll('{id}', id)
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

  /// Attach a tag to a product
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] productId (required):
  Future<AttachTagResponseDto?> serviceTagsControllerAttachToProduct(String id, String productId,) async {
    final response = await serviceTagsControllerAttachToProductWithHttpInfo(id, productId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AttachTagResponseDto',) as AttachTagResponseDto;
    
    }
    return null;
  }

  /// Create a new service tag
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateServiceTagDto] createServiceTagDto (required):
  Future<Response> serviceTagsControllerCreateWithHttpInfo(CreateServiceTagDto createServiceTagDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags';

    // ignore: prefer_final_locals
    Object? postBody = createServiceTagDto;

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

  /// Create a new service tag
  ///
  /// Parameters:
  ///
  /// * [CreateServiceTagDto] createServiceTagDto (required):
  Future<ServiceTagResponseDto?> serviceTagsControllerCreate(CreateServiceTagDto createServiceTagDto,) async {
    final response = await serviceTagsControllerCreateWithHttpInfo(createServiceTagDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ServiceTagResponseDto',) as ServiceTagResponseDto;
    
    }
    return null;
  }

  /// Detach a tag from a product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] productId (required):
  Future<Response> serviceTagsControllerDetachFromProductWithHttpInfo(String id, String productId,) async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags/{id}/products/{productId}'
      .replaceAll('{id}', id)
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

  /// Detach a tag from a product
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [String] productId (required):
  Future<void> serviceTagsControllerDetachFromProduct(String id, String productId,) async {
    final response = await serviceTagsControllerDetachFromProductWithHttpInfo(id, productId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Get active service tags for current user
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> serviceTagsControllerFindActiveWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags/active';

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

  /// Get active service tags for current user
  Future<List<ServiceTagResponseDto>?> serviceTagsControllerFindActive() async {
    final response = await serviceTagsControllerFindActiveWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ServiceTagResponseDto>') as List)
        .cast<ServiceTagResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get all service tags for current user
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> serviceTagsControllerFindAllWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags';

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

  /// Get all service tags for current user
  Future<List<ServiceTagResponseDto>?> serviceTagsControllerFindAll() async {
    final response = await serviceTagsControllerFindAllWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ServiceTagResponseDto>') as List)
        .cast<ServiceTagResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get a service tag by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> serviceTagsControllerFindOneWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags/{id}'
      .replaceAll('{id}', id);

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

  /// Get a service tag by ID
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<ServiceTagResponseDto?> serviceTagsControllerFindOne(String id,) async {
    final response = await serviceTagsControllerFindOneWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ServiceTagResponseDto',) as ServiceTagResponseDto;
    
    }
    return null;
  }

  /// Get all tags attached to a product
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  Future<Response> serviceTagsControllerGetTagsForProductWithHttpInfo(String productId,) async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags/products/{productId}'
      .replaceAll('{productId}', productId);

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

  /// Get all tags attached to a product
  ///
  /// Parameters:
  ///
  /// * [String] productId (required):
  Future<List<ServiceTagResponseDto>?> serviceTagsControllerGetTagsForProduct(String productId,) async {
    final response = await serviceTagsControllerGetTagsForProductWithHttpInfo(productId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ServiceTagResponseDto>') as List)
        .cast<ServiceTagResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Delete a service tag
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> serviceTagsControllerRemoveWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags/{id}'
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

  /// Delete a service tag
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> serviceTagsControllerRemove(String id,) async {
    final response = await serviceTagsControllerRemoveWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update a service tag
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateServiceTagDto] updateServiceTagDto (required):
  Future<Response> serviceTagsControllerUpdateWithHttpInfo(String id, UpdateServiceTagDto updateServiceTagDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/service-tags/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updateServiceTagDto;

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

  /// Update a service tag
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateServiceTagDto] updateServiceTagDto (required):
  Future<ServiceTagResponseDto?> serviceTagsControllerUpdate(String id, UpdateServiceTagDto updateServiceTagDto,) async {
    final response = await serviceTagsControllerUpdateWithHttpInfo(id, updateServiceTagDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ServiceTagResponseDto',) as ServiceTagResponseDto;
    
    }
    return null;
  }
}
