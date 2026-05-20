//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class S3Api {
  S3Api([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Delete file
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] key (required):
  ///   File key
  Future<Response> s3ControllerDeleteFileWithHttpInfo(String key,) async {
    // ignore: prefer_const_declarations
    final path = r'/s3/{key}'
      .replaceAll('{key}', key);

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

  /// Delete file
  ///
  /// Parameters:
  ///
  /// * [String] key (required):
  ///   File key
  Future<DeleteFileResponseDto?> s3ControllerDeleteFile(String key,) async {
    final response = await s3ControllerDeleteFileWithHttpInfo(key,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DeleteFileResponseDto',) as DeleteFileResponseDto;
    
    }
    return null;
  }

  /// Get file URL
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] key (required):
  ///   File key
  Future<Response> s3ControllerGetFileUrlWithHttpInfo(String key,) async {
    // ignore: prefer_const_declarations
    final path = r'/s3/{key}'
      .replaceAll('{key}', key);

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

  /// Get file URL
  ///
  /// Parameters:
  ///
  /// * [String] key (required):
  ///   File key
  Future<FileUrlResponseDto?> s3ControllerGetFileUrl(String key,) async {
    final response = await s3ControllerGetFileUrlWithHttpInfo(key,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FileUrlResponseDto',) as FileUrlResponseDto;
    
    }
    return null;
  }

  /// Get presigned upload URL
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [PresignRequestDto] presignRequestDto (required):
  Future<Response> s3ControllerPreSignWithHttpInfo(PresignRequestDto presignRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/s3/presign';

    // ignore: prefer_final_locals
    Object? postBody = presignRequestDto;

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

  /// Get presigned upload URL
  ///
  /// Parameters:
  ///
  /// * [PresignRequestDto] presignRequestDto (required):
  Future<PresignResponseDto?> s3ControllerPreSign(PresignRequestDto presignRequestDto,) async {
    final response = await s3ControllerPreSignWithHttpInfo(presignRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PresignResponseDto',) as PresignResponseDto;
    
    }
    return null;
  }
}
