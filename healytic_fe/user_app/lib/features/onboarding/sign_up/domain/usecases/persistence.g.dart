// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'persistence.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(savePartialData)
const savePartialDataProvider = SavePartialDataProvider._();

final class SavePartialDataProvider
    extends
        $FunctionalProvider<
          SavePartialDataUseCase,
          SavePartialDataUseCase,
          SavePartialDataUseCase
        >
    with $Provider<SavePartialDataUseCase> {
  const SavePartialDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savePartialDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savePartialDataHash();

  @$internal
  @override
  $ProviderElement<SavePartialDataUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SavePartialDataUseCase create(Ref ref) {
    return savePartialData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SavePartialDataUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SavePartialDataUseCase>(value),
    );
  }
}

String _$savePartialDataHash() => r'04e48a72f1413d03520edbeb2bcd00e8e6dac27b';

@ProviderFor(loadPartialData)
const loadPartialDataProvider = LoadPartialDataProvider._();

final class LoadPartialDataProvider
    extends
        $FunctionalProvider<
          LoadPartialDataUseCase,
          LoadPartialDataUseCase,
          LoadPartialDataUseCase
        >
    with $Provider<LoadPartialDataUseCase> {
  const LoadPartialDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadPartialDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadPartialDataHash();

  @$internal
  @override
  $ProviderElement<LoadPartialDataUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LoadPartialDataUseCase create(Ref ref) {
    return loadPartialData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadPartialDataUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadPartialDataUseCase>(value),
    );
  }
}

String _$loadPartialDataHash() => r'8570b08b684b6ef7accb62c6345169d84b6ec79a';

@ProviderFor(clearPartialData)
const clearPartialDataProvider = ClearPartialDataProvider._();

final class ClearPartialDataProvider
    extends
        $FunctionalProvider<
          ClearPartialDataUseCase,
          ClearPartialDataUseCase,
          ClearPartialDataUseCase
        >
    with $Provider<ClearPartialDataUseCase> {
  const ClearPartialDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clearPartialDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clearPartialDataHash();

  @$internal
  @override
  $ProviderElement<ClearPartialDataUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ClearPartialDataUseCase create(Ref ref) {
    return clearPartialData(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ClearPartialDataUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ClearPartialDataUseCase>(value),
    );
  }
}

String _$clearPartialDataHash() => r'a53eff28d37250f28203e63c61a0a37aff96b471';
