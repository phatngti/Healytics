//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminCategoriesApi {
  AdminCategoriesApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Create a new category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateCategoryDto] createCategoryDto (required):
  Future<Response> adminCategoriesControllerCreateWithHttpInfo(CreateCategoryDto createCategoryDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/categories';

    // ignore: prefer_final_locals
    Object? postBody = createCategoryDto;

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

  /// Create a new category
  ///
  /// Parameters:
  ///
  /// * [CreateCategoryDto] createCategoryDto (required):
  Future<AdminCategoryResponseDto?> adminCategoriesControllerCreate(CreateCategoryDto createCategoryDto,) async {
    final response = await adminCategoriesControllerCreateWithHttpInfo(createCategoryDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminCategoryResponseDto',) as AdminCategoryResponseDto;
    
    }
    return null;
  }

  /// List all categories (admin view)
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> adminCategoriesControllerFindAllWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/admin/categories';

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

  /// List all categories (admin view)
  Future<List<AdminCategoryResponseDto>?> adminCategoriesControllerFindAll() async {
    final response = await adminCategoriesControllerFindAllWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<AdminCategoryResponseDto>') as List)
        .cast<AdminCategoryResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Get a category by id (admin view)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminCategoriesControllerFindOneWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/categories/{id}'
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

  /// Get a category by id (admin view)
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<AdminCategoryResponseDto?> adminCategoriesControllerFindOne(String id,) async {
    final response = await adminCategoriesControllerFindOneWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminCategoryResponseDto',) as AdminCategoryResponseDto;
    
    }
    return null;
  }

  /// Delete a category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> adminCategoriesControllerRemoveWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/categories/{id}'
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

  /// Delete a category
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<void> adminCategoriesControllerRemove(String id,) async {
    final response = await adminCategoriesControllerRemoveWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Update a category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCategoryDto] updateCategoryDto (required):
  Future<Response> adminCategoriesControllerUpdateWithHttpInfo(String id, UpdateCategoryDto updateCategoryDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/admin/categories/{id}'
      .replaceAll('{id}', id);

    // ignore: prefer_final_locals
    Object? postBody = updateCategoryDto;

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

  /// Update a category
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  ///
  /// * [UpdateCategoryDto] updateCategoryDto (required):
  Future<AdminCategoryResponseDto?> adminCategoriesControllerUpdate(String id, UpdateCategoryDto updateCategoryDto,) async {
    final response = await adminCategoriesControllerUpdateWithHttpInfo(id, updateCategoryDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AdminCategoryResponseDto',) as AdminCategoryResponseDto;
    
    }
    return null;
  }
}
