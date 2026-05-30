//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserBookingSearchApi {
  UserBookingSearchApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Search booking services and specialists
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] q (required):
  ///   Search text. Minimum 2 characters.
  ///
  /// * [String] limit:
  ///   Maximum results per group. Default 5, max 20.
  Future<Response> bookingSearchControllerSearchWithHttpInfo(String q, { String? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/user/booking-search';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'q', q));
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

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

  /// Search booking services and specialists
  ///
  /// Parameters:
  ///
  /// * [String] q (required):
  ///   Search text. Minimum 2 characters.
  ///
  /// * [String] limit:
  ///   Maximum results per group. Default 5, max 20.
  Future<BookingSearchResponseDto?> bookingSearchControllerSearch(String q, { String? limit, }) async {
    final response = await bookingSearchControllerSearchWithHttpInfo(q,  limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BookingSearchResponseDto',) as BookingSearchResponseDto;

    }
    return null;
  }
}
