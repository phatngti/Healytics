//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserBookingsApi {
  UserBookingsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Start async checkout (returns 202 with ticket ID)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AsyncCheckoutDto] asyncCheckoutDto (required):
  Future<Response> bookingControllerAsyncCheckoutWithHttpInfo(AsyncCheckoutDto asyncCheckoutDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/bookings/async-checkout';

    // ignore: prefer_final_locals
    Object? postBody = asyncCheckoutDto;

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

  /// Start async checkout (returns 202 with ticket ID)
  ///
  /// Parameters:
  ///
  /// * [AsyncCheckoutDto] asyncCheckoutDto (required):
  Future<AsyncCheckoutResponseDto?> bookingControllerAsyncCheckout(AsyncCheckoutDto asyncCheckoutDto,) async {
    final response = await bookingControllerAsyncCheckoutWithHttpInfo(asyncCheckoutDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AsyncCheckoutResponseDto',) as AsyncCheckoutResponseDto;
    
    }
    return null;
  }

  /// Get booking by ID
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> bookingControllerGetBookingWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/bookings/{id}'
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

  /// Get booking by ID
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<BookingResponseDto?> bookingControllerGetBooking(String id,) async {
    final response = await bookingControllerGetBookingWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BookingResponseDto',) as BookingResponseDto;
    
    }
    return null;
  }

  /// Get checkout ticket status
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<Response> bookingControllerGetTicketStatusWithHttpInfo(String id,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/bookings/tickets/{id}'
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

  /// Get checkout ticket status
  ///
  /// Parameters:
  ///
  /// * [String] id (required):
  Future<CheckoutTicketResponseDto?> bookingControllerGetTicketStatus(String id,) async {
    final response = await bookingControllerGetTicketStatusWithHttpInfo(id,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CheckoutTicketResponseDto',) as CheckoutTicketResponseDto;
    
    }
    return null;
  }

  /// List my bookings
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> bookingControllerListMyBookingsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/user/bookings';

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

  /// List my bookings
  Future<List<BookingResponseDto>?> bookingControllerListMyBookings() async {
    final response = await bookingControllerListMyBookingsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<BookingResponseDto>') as List)
        .cast<BookingResponseDto>()
        .toList(growable: false);

    }
    return null;
  }
}
