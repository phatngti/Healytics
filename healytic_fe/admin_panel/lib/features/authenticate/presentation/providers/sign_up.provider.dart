import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up.provider.g.dart';
part 'sign_up.provider.freezed.dart';

enum SignupStep { email, otp, form }

@Freezed(toJson: true)
abstract class SignUpState with _$SignUpState {
  const factory SignUpState({
    @Default(SignupStep.email) SignupStep step,
    @Default(SignUpRequestEntity()) SignUpRequestEntity request,
    @Default('') String emailToken,
    @Default('') String otpToken,
  }) = _SignUpState;

  factory SignUpState.fromJson(Map<String, dynamic> json) =>
      _$SignUpStateFromJson(json);
}

@riverpod
class SignUpProvider extends _$SignUpProvider {
  @override
  FutureOr<SignUpState> build() {
    print('sign up build');
    ref.onDispose(() {
      print('sign up dispose');
    });
    return SignUpState();
  }

  reset() {
    state = const AsyncValue.data(SignUpState());
  }

  Future<void> sendOtp(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 2));
      print('email: $email');
      return state.value!.copyWith(step: SignupStep.otp, emailToken: '123456');
    });
  }

  Future<void> verifyOtp(String emailToken, String otp) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 2));
      print('emailToken: $emailToken');
      print('otp: $otp');
      return state.value!.copyWith(step: SignupStep.form, otpToken: '123456');
    });
  }

  Future<void> signUp(String otpToken, SignUpRequestEntity request) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await Future.delayed(const Duration(seconds: 2));
      return state.value!;
    });
  }
}
