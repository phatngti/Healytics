//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

import 'package:employee_openapi/api.dart';
import 'package:test/test.dart';


/// tests for AuthenticationApi
void main() {
  // final instance = AuthenticationApi();

  group('tests for AuthenticationApi', () {
    // Check if email is already registered
    //
    // Public endpoint for pre-registration email uniqueness validation.
    //
    //Future<CheckEmailResponseDto> authControllerCheckEmail(CheckEmailDto checkEmailDto) async
    test('test authControllerCheckEmail', () async {
      // TODO
    });

    // Request a user password reset code
    //
    // Returns a generic success response to avoid exposing whether an email is registered.
    //
    //Future<PasswordResetResponseDto> authControllerForgotUserPassword(ForgotPasswordDto forgotPasswordDto) async
    test('test authControllerForgotUserPassword', () async {
      // TODO
    });

    // Login as admin
    //
    //Future<AuthTokensDto> authControllerLoginAdmin(AdminLoginDto adminLoginDto) async
    test('test authControllerLoginAdmin', () async {
      // TODO
    });

    // Login as an employee
    //
    //Future<AuthTokensDto> authControllerLoginEmployee(EmployeeLoginDto employeeLoginDto) async
    test('test authControllerLoginEmployee', () async {
      // TODO
    });

    // Login as a partner
    //
    //Future<AuthTokensDto> authControllerLoginPartner(PartnerLoginDto partnerLoginDto) async
    test('test authControllerLoginPartner', () async {
      // TODO
    });

    // Login as a user
    //
    //Future<AuthTokensDto> authControllerLoginUser(LoginDto loginDto) async
    test('test authControllerLoginUser', () async {
      // TODO
    });

    // Logout current user
    //
    //Future<LogoutResponseDto> authControllerLogout() async
    test('test authControllerLogout', () async {
      // TODO
    });

    // Refresh authentication tokens
    //
    //Future<AuthTokensDto> authControllerRefresh(RefreshTokenRequestDto refreshTokenRequestDto) async
    test('test authControllerRefresh', () async {
      // TODO
    });

    // Refresh employee tokens
    //
    //Future<AuthTokensDto> authControllerRefreshEmployee(RefreshTokenRequestDto refreshTokenRequestDto) async
    test('test authControllerRefreshEmployee', () async {
      // TODO
    });

    // Refresh partner tokens with verification info
    //
    //Future<AuthTokensDto> authControllerRefreshPartner(RefreshTokenRequestDto refreshTokenRequestDto) async
    test('test authControllerRefreshPartner', () async {
      // TODO
    });

    // Register a new business partner
    //
    // Creates business entity, legal representative, and returns auth tokens immediately.
    //
    //Future<RegisterPartnerResponseDto> authControllerRegisterPartner(RegisterPartnerDto registerPartnerDto) async
    test('test authControllerRegisterPartner', () async {
      // TODO
    });

    // Register a new user
    //
    //Future<AuthTokensDto> authControllerRegisterUser(RegisterDto registerDto) async
    test('test authControllerRegisterUser', () async {
      // TODO
    });

    // Reset a user password with validated reset token
    //
    //Future<PasswordResetResponseDto> authControllerResetUserPassword(ResetPasswordDto resetPasswordDto) async
    test('test authControllerResetUserPassword', () async {
      // TODO
    });

    // Validate a user password reset code
    //
    //Future<ValidatePasswordResetCodeResponseDto> authControllerValidateUserPasswordResetCode(ValidatePasswordResetCodeDto validatePasswordResetCodeDto) async
    test('test authControllerValidateUserPasswordResetCode', () async {
      // TODO
    });

  });
}
