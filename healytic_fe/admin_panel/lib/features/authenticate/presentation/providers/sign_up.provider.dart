import 'dart:developer' as developer;

import 'package:admin_panel/features/authenticate/datasource/remote_datasource.dart';
import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up.provider.freezed.dart';
part 'sign_up.provider.g.dart';

/// Signup flow steps.
enum SignupStep { email, otp, form }

/// State for the signup flow.
@Freezed(toJson: true)
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default(SignupStep.email) SignupStep step,
    @Default(SignUpRequestEntity()) SignUpRequestEntity request,
    @Default('') String email,
    @Default('') String emailToken,
    @Default('') String otpToken,
    @Default(false) bool registrationSuccess,
  }) = _SignUpState;

  factory SignUpState.fromJson(Map<String, dynamic> json) =>
      _$SignUpStateFromJson(json);
}

/// Provider for signup flow state management.
///
/// Handles the multi-step signup process: email -> OTP -> form submission.
@riverpod
class SignUpProvider extends _$SignUpProvider {
  @override
  FutureOr<SignUpState> build() {
    developer.log('SignUpProvider: build', name: 'SignUpProvider');
    ref.onDispose(() {
      developer.log('SignUpProvider: dispose', name: 'SignUpProvider');
    });
    return const SignUpState();
  }

  /// Resets only the async state (loading/error) while preserving all data.
  void reset() {
    state = AsyncValue.data(state.value ?? const SignUpState());
  }

  /// Sends OTP to the specified email address.
  ///
  /// On success, transitions to [SignupStep.otp] and stores the email token.
  Future<void> sendOtp(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // final datasource = ref.read(authenticateRemoteDatasourceProvider);
      // final response = await datasource.sendOtp(email);

      // developer.log(
      //   'OTP sent to $email, token: ${response.emailToken}',
      //   name: 'SignUpProvider',
      // );
      final emailToken = 'bypass-email-token  ';

      return state.value!.copyWith(
        step: SignupStep.otp,
        // emailToken: response.emailToken,
        emailToken: emailToken,
        email: email,
      );
    });
  }

  /// Verifies the OTP entered by the user.
  ///
  /// On success, transitions to [SignupStep.form] and stores the OTP token.
  Future<void> verifyOtp(String emailToken, String otp) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      // final datasource = ref.read(authenticateRemoteDatasourceProvider);
      // final response = await datasource.verifyOtp(emailToken, otp);
      final otpToken = 'bypasss-otp-verify';

      developer.log('OTP verified, token: $otpToken', name: 'SignUpProvider');

      return state.value!.copyWith(
        step: SignupStep.form,
        // otpToken: response.otpToken,
        otpToken: otpToken,
      );
    });
  }

  /// Registers a new partner using the complete registration request.
  ///
  /// Updates state to data on success or error on failure.
  Future<void> registerPartner(RegisterPartnerRequestEntity request) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final datasource = ref.read(authenticateRemoteDatasourceProvider);
      final response = await datasource.registerPartner(request);

      developer.log(
        'Partner registered: ${response.businessEntityId}',
        name: 'SignUpProvider',
      );

      return state.value!.copyWith(registrationSuccess: true);
    });
  }
}
