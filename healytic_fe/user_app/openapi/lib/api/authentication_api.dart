//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AuthenticationApi {
  AuthenticationApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Check if email is already registered
  ///
  /// Public endpoint for pre-registration email uniqueness validation.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [CheckEmailDto] checkEmailDto (required):
  Future<Response> authControllerCheckEmailWithHttpInfo(CheckEmailDto checkEmailDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/check-email';

    // ignore: prefer_final_locals
    Object? postBody = checkEmailDto;

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

  /// Check if email is already registered
  ///
  /// Public endpoint for pre-registration email uniqueness validation.
  ///
  /// Parameters:
  ///
  /// * [CheckEmailDto] checkEmailDto (required):
  Future<CheckEmailResponseDto?> authControllerCheckEmail(CheckEmailDto checkEmailDto,) async {
    final response = await authControllerCheckEmailWithHttpInfo(checkEmailDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CheckEmailResponseDto',) as CheckEmailResponseDto;
    
    }
    return null;
  }

  /// Login as admin
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [AdminLoginDto] adminLoginDto (required):
  Future<Response> authControllerLoginAdminWithHttpInfo(AdminLoginDto adminLoginDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/admin/login';

    // ignore: prefer_final_locals
    Object? postBody = adminLoginDto;

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

  /// Login as admin
  ///
  /// Parameters:
  ///
  /// * [AdminLoginDto] adminLoginDto (required):
  Future<AuthTokensDto?> authControllerLoginAdmin(AdminLoginDto adminLoginDto,) async {
    final response = await authControllerLoginAdminWithHttpInfo(adminLoginDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }

  /// Login as an employee
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [EmployeeLoginDto] employeeLoginDto (required):
  Future<Response> authControllerLoginEmployeeWithHttpInfo(EmployeeLoginDto employeeLoginDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/employee/login';

    // ignore: prefer_final_locals
    Object? postBody = employeeLoginDto;

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

  /// Login as an employee
  ///
  /// Parameters:
  ///
  /// * [EmployeeLoginDto] employeeLoginDto (required):
  Future<AuthTokensDto?> authControllerLoginEmployee(EmployeeLoginDto employeeLoginDto,) async {
    final response = await authControllerLoginEmployeeWithHttpInfo(employeeLoginDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }

  /// Login as a partner
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [PartnerLoginDto] partnerLoginDto (required):
  Future<Response> authControllerLoginPartnerWithHttpInfo(PartnerLoginDto partnerLoginDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/partner/login';

    // ignore: prefer_final_locals
    Object? postBody = partnerLoginDto;

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

  /// Login as a partner
  ///
  /// Parameters:
  ///
  /// * [PartnerLoginDto] partnerLoginDto (required):
  Future<AuthTokensDto?> authControllerLoginPartner(PartnerLoginDto partnerLoginDto,) async {
    final response = await authControllerLoginPartnerWithHttpInfo(partnerLoginDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }

  /// Login as a user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [LoginDto] loginDto (required):
  Future<Response> authControllerLoginUserWithHttpInfo(LoginDto loginDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/user/login';

    // ignore: prefer_final_locals
    Object? postBody = loginDto;

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

  /// Login as a user
  ///
  /// Parameters:
  ///
  /// * [LoginDto] loginDto (required):
  Future<AuthTokensDto?> authControllerLoginUser(LoginDto loginDto,) async {
    final response = await authControllerLoginUserWithHttpInfo(loginDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }

  /// Logout current user
  ///
  /// Note: This method returns the HTTP [Response].
  Future<Response> authControllerLogoutWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/auth/logout';

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

  /// Logout current user
  Future<LogoutResponseDto?> authControllerLogout() async {
    final response = await authControllerLogoutWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'LogoutResponseDto',) as LogoutResponseDto;
    
    }
    return null;
  }

  /// Refresh authentication tokens
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RefreshTokenRequestDto] refreshTokenRequestDto (required):
  Future<Response> authControllerRefreshWithHttpInfo(RefreshTokenRequestDto refreshTokenRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/refresh';

    // ignore: prefer_final_locals
    Object? postBody = refreshTokenRequestDto;

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

  /// Refresh authentication tokens
  ///
  /// Parameters:
  ///
  /// * [RefreshTokenRequestDto] refreshTokenRequestDto (required):
  Future<AuthTokensDto?> authControllerRefresh(RefreshTokenRequestDto refreshTokenRequestDto,) async {
    final response = await authControllerRefreshWithHttpInfo(refreshTokenRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }

  /// Refresh employee tokens
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RefreshTokenRequestDto] refreshTokenRequestDto (required):
  Future<Response> authControllerRefreshEmployeeWithHttpInfo(RefreshTokenRequestDto refreshTokenRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/employee/refresh';

    // ignore: prefer_final_locals
    Object? postBody = refreshTokenRequestDto;

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

  /// Refresh employee tokens
  ///
  /// Parameters:
  ///
  /// * [RefreshTokenRequestDto] refreshTokenRequestDto (required):
  Future<AuthTokensDto?> authControllerRefreshEmployee(RefreshTokenRequestDto refreshTokenRequestDto,) async {
    final response = await authControllerRefreshEmployeeWithHttpInfo(refreshTokenRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }

  /// Refresh partner tokens with verification info
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RefreshTokenRequestDto] refreshTokenRequestDto (required):
  Future<Response> authControllerRefreshPartnerWithHttpInfo(RefreshTokenRequestDto refreshTokenRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/partner/refresh';

    // ignore: prefer_final_locals
    Object? postBody = refreshTokenRequestDto;

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

  /// Refresh partner tokens with verification info
  ///
  /// Parameters:
  ///
  /// * [RefreshTokenRequestDto] refreshTokenRequestDto (required):
  Future<AuthTokensDto?> authControllerRefreshPartner(RefreshTokenRequestDto refreshTokenRequestDto,) async {
    final response = await authControllerRefreshPartnerWithHttpInfo(refreshTokenRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }

  /// Register a new business partner
  ///
  /// Creates business entity, legal representative, and returns auth tokens immediately.
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RegisterPartnerDto] registerPartnerDto (required):
  Future<Response> authControllerRegisterPartnerWithHttpInfo(RegisterPartnerDto registerPartnerDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/partner/register';

    // ignore: prefer_final_locals
    Object? postBody = registerPartnerDto;

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

  /// Register a new business partner
  ///
  /// Creates business entity, legal representative, and returns auth tokens immediately.
  ///
  /// Parameters:
  ///
  /// * [RegisterPartnerDto] registerPartnerDto (required):
  Future<RegisterPartnerResponseDto?> authControllerRegisterPartner(RegisterPartnerDto registerPartnerDto,) async {
    final response = await authControllerRegisterPartnerWithHttpInfo(registerPartnerDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RegisterPartnerResponseDto',) as RegisterPartnerResponseDto;
    
    }
    return null;
  }

  /// Register a new user
  ///
  /// Note: This method returns the HTTP [Response].
  ///
  /// Parameters:
  ///
  /// * [RegisterDto] registerDto (required):
  Future<Response> authControllerRegisterUserWithHttpInfo(RegisterDto registerDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/auth/user/register';

    // ignore: prefer_final_locals
    Object? postBody = registerDto;

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

  /// Register a new user
  ///
  /// Parameters:
  ///
  /// * [RegisterDto] registerDto (required):
  Future<AuthTokensDto?> authControllerRegisterUser(RegisterDto registerDto,) async {
    final response = await authControllerRegisterUserWithHttpInfo(registerDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'AuthTokensDto',) as AuthTokensDto;
    
    }
    return null;
  }
}
