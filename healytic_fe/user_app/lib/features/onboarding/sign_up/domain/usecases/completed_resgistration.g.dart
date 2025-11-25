// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'completed_resgistration.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(completedResgistrationUsecase)
const completedResgistrationUsecaseProvider =
    CompletedResgistrationUsecaseProvider._();

final class CompletedResgistrationUsecaseProvider
    extends
        $FunctionalProvider<
          CompletedResgistrationUsecase,
          CompletedResgistrationUsecase,
          CompletedResgistrationUsecase
        >
    with $Provider<CompletedResgistrationUsecase> {
  const CompletedResgistrationUsecaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'completedResgistrationUsecaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$completedResgistrationUsecaseHash();

  @$internal
  @override
  $ProviderElement<CompletedResgistrationUsecase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CompletedResgistrationUsecase create(Ref ref) {
    return completedResgistrationUsecase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CompletedResgistrationUsecase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CompletedResgistrationUsecase>(
        value,
      ),
    );
  }
}

String _$completedResgistrationUsecaseHash() =>
    r'049f0131dcada05494a70372c6f72277f232409b';
