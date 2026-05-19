//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserReviewsApi {
  UserReviewsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Submit a facility review for a completed appointment
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateFacilityReviewDto] createFacilityReviewDto (required):
  Future<Response> userReviewControllerSubmitFacilityReviewWithHttpInfo(CreateFacilityReviewDto createFacilityReviewDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/reviews/facility';

    // ignore: prefer_final_locals
    Object? postBody = createFacilityReviewDto;

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

  /// Submit a facility review for a completed appointment
  ///
  /// Parameters:
  ///
  /// * [CreateFacilityReviewDto] createFacilityReviewDto (required):
  Future<FacilityReviewResponseDto?> userReviewControllerSubmitFacilityReview(CreateFacilityReviewDto createFacilityReviewDto,) async {
    final response = await userReviewControllerSubmitFacilityReviewWithHttpInfo(createFacilityReviewDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'FacilityReviewResponseDto',) as FacilityReviewResponseDto;
    
    }
    return null;
  }

  /// Submit a specialist review for a completed appointment
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateSpecialistReviewDto] createSpecialistReviewDto (required):
  Future<Response> userReviewControllerSubmitSpecialistReviewWithHttpInfo(CreateSpecialistReviewDto createSpecialistReviewDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/reviews/specialist';

    // ignore: prefer_final_locals
    Object? postBody = createSpecialistReviewDto;

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

  /// Submit a specialist review for a completed appointment
  ///
  /// Parameters:
  ///
  /// * [CreateSpecialistReviewDto] createSpecialistReviewDto (required):
  Future<SpecialistReviewResponseDto?> userReviewControllerSubmitSpecialistReview(CreateSpecialistReviewDto createSpecialistReviewDto,) async {
    final response = await userReviewControllerSubmitSpecialistReviewWithHttpInfo(createSpecialistReviewDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SpecialistReviewResponseDto',) as SpecialistReviewResponseDto;
    
    }
    return null;
  }

  /// Submit a treatment review for a completed appointment
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CreateTreatmentReviewDto] createTreatmentReviewDto (required):
  Future<Response> userReviewControllerSubmitTreatmentReviewWithHttpInfo(CreateTreatmentReviewDto createTreatmentReviewDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/reviews/treatment';

    // ignore: prefer_final_locals
    Object? postBody = createTreatmentReviewDto;

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

  /// Submit a treatment review for a completed appointment
  ///
  /// Parameters:
  ///
  /// * [CreateTreatmentReviewDto] createTreatmentReviewDto (required):
  Future<TreatmentReviewResponseDto?> userReviewControllerSubmitTreatmentReview(CreateTreatmentReviewDto createTreatmentReviewDto,) async {
    final response = await userReviewControllerSubmitTreatmentReviewWithHttpInfo(createTreatmentReviewDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'TreatmentReviewResponseDto',) as TreatmentReviewResponseDto;
    
    }
    return null;
  }
}
