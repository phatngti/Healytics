import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';

/// Repository interface for authentication operations.
///
/// Defines the contract for login and signup operations.
abstract class AuthenticateRepository {
  /// Authenticates a user with email and password.
  Future<SignInResponseEntity> login(SignInRequestEntity request, String role);

  /// Sends OTP to the specified email address.
  ///
  /// Note: This is currently mock-only as the backend doesn't have this
  /// endpoint.
  Future<SendOtpResponseEntity> sendOtp(String email);

  /// Verifies the OTP entered by the user.
  ///
  /// Note: This is currently mock-only as the backend doesn't have this
  /// endpoint.
  Future<VerifyOtpResponseEntity> verifyOtp(String emailToken, String otp);

  /// Registers a new business partner.
  ///
  /// Creates business entity, legal representative, and returns auth tokens.
  Future<RegisterPartnerResponseEntity> registerPartner(
    RegisterPartnerRequestEntity request,
  );
}
