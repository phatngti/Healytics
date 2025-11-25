import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/repositories/register_repo.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_flow_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'persistence.g.dart';

class SavePartialDataUseCase {
  final RegisterRepository repository;

  SavePartialDataUseCase(this.repository);

  Future<void> call(UserEntity? user, int? stepIndex) async {
    final preferenceData = await repository.loadPartialData();
    await repository.savePartialData({
      'user': {
        ...?preferenceData?['user'] as Map<String, dynamic>?,
        ...?user?.toJson(),
      },
      'stepIndex': stepIndex ?? preferenceData?['stepIndex'],
    });
  }
}

@riverpod
SavePartialDataUseCase savePartialData(Ref ref) {
  final repository = ref.watch(registerRepositoryProvider);
  return SavePartialDataUseCase(repository);
}

class LoadPartialDataUseCase {
  final RegisterRepository repository;

  LoadPartialDataUseCase(this.repository);

  Future<RegisterStateData> call() async {
    final data = await repository.loadPartialData();
    if (data != null) {
      return RegisterStateData.fromJson(data);
    }
    return RegisterStateData();
  }
}

@riverpod
LoadPartialDataUseCase loadPartialData(Ref ref) {
  final repository = ref.watch(registerRepositoryProvider);
  return LoadPartialDataUseCase(repository);
}

class ClearPartialDataUseCase {
  final RegisterRepository repository;

  ClearPartialDataUseCase(this.repository);

  Future<void> call() async {
    await repository.clearPartialData();
  }
}

@riverpod
ClearPartialDataUseCase clearPartialData(Ref ref) {
  final repository = ref.watch(registerRepositoryProvider);
  return ClearPartialDataUseCase(repository);
}
