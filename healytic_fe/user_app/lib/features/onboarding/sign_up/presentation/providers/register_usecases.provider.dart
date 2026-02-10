import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/domain/usecases/completed_registration.dart';

final completedRegistrationUseCaseProvider =
    Provider<CompletedRegistrationUseCase>((ref) {
      final repository = ref.watch(registerRepositoryProvider);
      return CompletedRegistrationUseCase(repository: repository);
    });
