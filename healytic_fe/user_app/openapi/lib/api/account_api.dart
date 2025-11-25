//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AccountApi {
  AccountApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Get current user survey
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> accountControllerGetSurveyWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/account/survey';

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

  /// Get current user survey
  Future<SurveyResponseDto?> accountControllerGetSurvey() async {
    final response = await accountControllerGetSurveyWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SurveyResponseDto',) as SurveyResponseDto;
    
    }
    return null;
  }

  /// Create one-shot survey for current user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SurveyDto] surveyDto (required):
  Future<Response> accountControllerPostSurveyWithHttpInfo(SurveyDto surveyDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/account/survey';

    // ignore: prefer_final_locals
    Object? postBody = surveyDto;

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

  /// Create one-shot survey for current user
  ///
  /// Parameters:
  ///
  /// * [SurveyDto] surveyDto (required):
  Future<SurveyResponseDto?> accountControllerPostSurvey(SurveyDto surveyDto,) async {
    final response = await accountControllerPostSurveyWithHttpInfo(surveyDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SurveyResponseDto',) as SurveyResponseDto;
    
    }
    return null;
  }
}
