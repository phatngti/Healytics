import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';

abstract class RegisterRepository {
  /// Checks whether an email is already registered.
  Future<bool> checkEmailExists({required String email});

  Future<void> sendVerificationCode({required String email});

  Future<void> verifyCode({required String email, required String code});

  Future<AuthTokensEntity> completeRegistration({required UserEntity user});

  Future<void> savePartialData(Map<String, dynamic> data);

  Future<Map<String, dynamic>?> loadPartialData();

  Future<void> clearPartialData();

  Future<void> completeSurvey(Map<String, dynamic> jsonSurveys);

  /// Completes the authenticated user's profile.
  ///
  /// Returns a fresh [AuthTokensEntity] when the backend issues new tokens
  /// in the success body. Returns `null` when no tokens are present so the
  /// caller can fall back to `/v1/auth/refresh`.
  Future<AuthTokensEntity?> completeProfile(UserEntity profile);
}
