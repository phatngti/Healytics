import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/repositories/register_repo.dart';

part 'completed_resgistration.g.dart';

class CompletedResgistrationUsecase {
  CompletedResgistrationUsecase({required this.repository});

  final RegisterRepository repository;

  Future<AuthTokensEntity> call({required UserEntity user}) async {
    return await repository.completeRegistration(user: user);
  }
}

@riverpod
CompletedResgistrationUsecase completedResgistrationUsecase(Ref ref) {
  final repository = ref.watch(registerRepositoryProvider);
  return CompletedResgistrationUsecase(repository: repository);
}
