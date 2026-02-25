// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'survey.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(surveyUseCase)
const surveyUseCaseProvider = SurveyUseCaseProvider._();

final class SurveyUseCaseProvider
    extends $FunctionalProvider<SurveyUseCase, SurveyUseCase, SurveyUseCase>
    with $Provider<SurveyUseCase> {
  const SurveyUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'surveyUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$surveyUseCaseHash();

  @$internal
  @override
  $ProviderElement<SurveyUseCase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SurveyUseCase create(Ref ref) {
    return surveyUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SurveyUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SurveyUseCase>(value),
    );
  }
}

String _$surveyUseCaseHash() => r'9027d7ef6485c110b99420d453d57ba9d615cadf';
