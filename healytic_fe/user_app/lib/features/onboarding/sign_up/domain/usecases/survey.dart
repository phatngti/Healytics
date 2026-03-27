import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/repositories/register_repository.dart';

part 'survey.g.dart';

class SurveyUseCase {
  SurveyUseCase({required this.repository});

  final RegisterRepository repository;

  Future<void> completeSurvey({
    required Map<String, List<SurveyEntity>> surveys,
  }) async {
    final jsonSurveys = surveys.entries.fold<Map<String, dynamic>>(
      <String, dynamic>{},
      (acc, entry) => {
        ...acc,
        entry.key: entry.value.fold<Map<String, dynamic>>(
          <String, dynamic>{},
          (acc, survey) => {...acc, survey.question: survey.value},
        ),
      },
    );

    await repository.completeSurvey(jsonSurveys);
  }
}

@riverpod
SurveyUseCase surveyUseCase(Ref ref) {
  final repository = ref.watch(registerRepositoryProvider);
  return SurveyUseCase(repository: repository);
}
