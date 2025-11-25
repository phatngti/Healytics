import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/domain/repositories/register_repo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'otp.g.dart';

class OtpUseCase {
  OtpUseCase({required RegisterRepository repository})
    : _repository = repository;

  final RegisterRepository _repository;

  // Sends a verification code to the provided email address.
  Future<void> sendOTP({required String email}) async {
    if (email.isEmpty || !email.contains('@')) {
      throw Exception("Email cannot be empty");
    }
    return await _repository.sendVerificationCode(email: email);
  }

  // Verifies the provided code for the given email address.
  Future<void> verifyCode({required String email, required String code}) async {
    if (code.isEmpty || code.length < 4) {
      throw Exception("Invalid verification code");
    }
    return await _repository.verifyCode(email: email, code: code);
  }
}

@riverpod
OtpUseCase otpUseCase(Ref ref) {
  final repository = ref.watch(registerRepositoryProvider);
  return OtpUseCase(repository: repository);
}
