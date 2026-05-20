//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserSlotsApi {
  UserSlotsApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Check if the user already has a booking at the same datetime
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CheckDuplicateSlotDto] checkDuplicateSlotDto (required):
  Future<Response> slotsControllerCheckDuplicateSlotWithHttpInfo(CheckDuplicateSlotDto checkDuplicateSlotDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/slots/check-duplicate';

    // ignore: prefer_final_locals
    Object? postBody = checkDuplicateSlotDto;

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

  /// Check if the user already has a booking at the same datetime
  ///
  /// Parameters:
  ///
  /// * [CheckDuplicateSlotDto] checkDuplicateSlotDto (required):
  Future<CheckDuplicateSlotResponseDto?> slotsControllerCheckDuplicateSlot(CheckDuplicateSlotDto checkDuplicateSlotDto,) async {
    final response = await slotsControllerCheckDuplicateSlotWithHttpInfo(checkDuplicateSlotDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CheckDuplicateSlotResponseDto',) as CheckDuplicateSlotResponseDto;
    
    }
    return null;
  }

  /// Acquire a micro-lock on a time slot (120s TTL)
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [MicroLockDto] microLockDto (required):
  Future<Response> slotsControllerMicroLockWithHttpInfo(MicroLockDto microLockDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/user/slots/micro-lock';

    // ignore: prefer_final_locals
    Object? postBody = microLockDto;

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

  /// Acquire a micro-lock on a time slot (120s TTL)
  ///
  /// Parameters:
  ///
  /// * [MicroLockDto] microLockDto (required):
  Future<MicroLockResponseDto?> slotsControllerMicroLock(MicroLockDto microLockDto,) async {
    final response = await slotsControllerMicroLockWithHttpInfo(microLockDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MicroLockResponseDto',) as MicroLockResponseDto;
    
    }
    return null;
  }
}
