import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/repositories/register_repository.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';

class CompletedRegistrationUseCase {
  CompletedRegistrationUseCase({required this.repository});

  final RegisterRepository repository;

  Future<AuthTokensEntity> call({required UserEntity user}) async {
    return repository.completeRegistration(user: user);
  }
}
