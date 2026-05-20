//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of test_backdoor_api;


class TestBackdoorApi {
  TestBackdoorApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Reset DB then seed a scenario
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [BackdoorPrepareDto] backdoorPrepareDto (required):
  Future<Response> testBackdoorControllerPrepareWithHttpInfo(BackdoorPrepareDto backdoorPrepareDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/prepare';

    // ignore: prefer_final_locals
    Object? postBody = backdoorPrepareDto;

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

  /// Reset DB then seed a scenario
  ///
  /// Parameters:
  ///
  /// * [BackdoorPrepareDto] backdoorPrepareDto (required):
  Future<SeedResponseDto?> testBackdoorControllerPrepare(BackdoorPrepareDto backdoorPrepareDto,) async {
    final response = await testBackdoorControllerPrepareWithHttpInfo(backdoorPrepareDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Truncate all non-master tables
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> testBackdoorControllerResetDbWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/reset-db';

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

  /// Truncate all non-master tables
  Future<ResetDbResponseDto?> testBackdoorControllerResetDb() async {
    final response = await testBackdoorControllerResetDbWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ResetDbResponseDto',) as ResetDbResponseDto;
    
    }
    return null;
  }

  /// Seed multiple entity types at once
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedPayloadDto] seedPayloadDto (required):
  Future<Response> testBackdoorControllerSeedWithHttpInfo(SeedPayloadDto seedPayloadDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed';

    // ignore: prefer_final_locals
    Object? postBody = seedPayloadDto;

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

  /// Seed multiple entity types at once
  ///
  /// Parameters:
  ///
  /// * [SeedPayloadDto] seedPayloadDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeed(SeedPayloadDto seedPayloadDto,) async {
    final response = await testBackdoorControllerSeedWithHttpInfo(seedPayloadDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single booking
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedBookingDto] seedBookingDto (required):
  Future<Response> testBackdoorControllerSeedBookingWithHttpInfo(SeedBookingDto seedBookingDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-booking';

    // ignore: prefer_final_locals
    Object? postBody = seedBookingDto;

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

  /// Seed a single booking
  ///
  /// Parameters:
  ///
  /// * [SeedBookingDto] seedBookingDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedBooking(SeedBookingDto seedBookingDto,) async {
    final response = await testBackdoorControllerSeedBookingWithHttpInfo(seedBookingDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single cart item
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedCartItemDto] seedCartItemDto (required):
  Future<Response> testBackdoorControllerSeedCartWithHttpInfo(SeedCartItemDto seedCartItemDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-cart';

    // ignore: prefer_final_locals
    Object? postBody = seedCartItemDto;

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

  /// Seed a single cart item
  ///
  /// Parameters:
  ///
  /// * [SeedCartItemDto] seedCartItemDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedCart(SeedCartItemDto seedCartItemDto,) async {
    final response = await testBackdoorControllerSeedCartWithHttpInfo(seedCartItemDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single category
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedCategoryDto] seedCategoryDto (required):
  Future<Response> testBackdoorControllerSeedCategoryWithHttpInfo(SeedCategoryDto seedCategoryDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-category';

    // ignore: prefer_final_locals
    Object? postBody = seedCategoryDto;

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

  /// Seed a single category
  ///
  /// Parameters:
  ///
  /// * [SeedCategoryDto] seedCategoryDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedCategory(SeedCategoryDto seedCategoryDto,) async {
    final response = await testBackdoorControllerSeedCategoryWithHttpInfo(seedCategoryDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single coupon
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedCouponDto] seedCouponDto (required):
  Future<Response> testBackdoorControllerSeedCouponWithHttpInfo(SeedCouponDto seedCouponDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-coupon';

    // ignore: prefer_final_locals
    Object? postBody = seedCouponDto;

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

  /// Seed a single coupon
  ///
  /// Parameters:
  ///
  /// * [SeedCouponDto] seedCouponDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedCoupon(SeedCouponDto seedCouponDto,) async {
    final response = await testBackdoorControllerSeedCouponWithHttpInfo(seedCouponDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedEmployeeDto] seedEmployeeDto (required):
  Future<Response> testBackdoorControllerSeedEmployeeWithHttpInfo(SeedEmployeeDto seedEmployeeDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-employee';

    // ignore: prefer_final_locals
    Object? postBody = seedEmployeeDto;

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

  /// Seed a single employee
  ///
  /// Parameters:
  ///
  /// * [SeedEmployeeDto] seedEmployeeDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedEmployee(SeedEmployeeDto seedEmployeeDto,) async {
    final response = await testBackdoorControllerSeedEmployeeWithHttpInfo(seedEmployeeDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single partner
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedPartnerDto] seedPartnerDto (required):
  Future<Response> testBackdoorControllerSeedPartnerWithHttpInfo(SeedPartnerDto seedPartnerDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-partner';

    // ignore: prefer_final_locals
    Object? postBody = seedPartnerDto;

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

  /// Seed a single partner
  ///
  /// Parameters:
  ///
  /// * [SeedPartnerDto] seedPartnerDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedPartner(SeedPartnerDto seedPartnerDto,) async {
    final response = await testBackdoorControllerSeedPartnerWithHttpInfo(seedPartnerDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single health service
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedServiceDto] seedServiceDto (required):
  Future<Response> testBackdoorControllerSeedServiceWithHttpInfo(SeedServiceDto seedServiceDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-service';

    // ignore: prefer_final_locals
    Object? postBody = seedServiceDto;

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

  /// Seed a single health service
  ///
  /// Parameters:
  ///
  /// * [SeedServiceDto] seedServiceDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedService(SeedServiceDto seedServiceDto,) async {
    final response = await testBackdoorControllerSeedServiceWithHttpInfo(seedServiceDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Seed a single user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [SeedUserDto] seedUserDto (required):
  Future<Response> testBackdoorControllerSeedUserWithHttpInfo(SeedUserDto seedUserDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/seed-user';

    // ignore: prefer_final_locals
    Object? postBody = seedUserDto;

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

  /// Seed a single user
  ///
  /// Parameters:
  ///
  /// * [SeedUserDto] seedUserDto (required):
  Future<SeedResponseDto?> testBackdoorControllerSeedUser(SeedUserDto seedUserDto,) async {
    final response = await testBackdoorControllerSeedUserWithHttpInfo(seedUserDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'SeedResponseDto',) as SeedResponseDto;
    
    }
    return null;
  }

  /// Check if backdoor is available
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> testBackdoorControllerStatusWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/test-backdoor/status';

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

  /// Check if backdoor is available
  Future<BackdoorStatusResponseDto?> testBackdoorControllerStatus() async {
    final response = await testBackdoorControllerStatusWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'BackdoorStatusResponseDto',) as BackdoorStatusResponseDto;
    
    }
    return null;
  }
}
