// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translations.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(translations)
const translationsProvider = TranslationsProvider._();

final class TranslationsProvider
    extends $FunctionalProvider<TranslationsEn, TranslationsEn, TranslationsEn>
    with $Provider<TranslationsEn> {
  const TranslationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'translationsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$translationsHash();

  @$internal
  @override
  $ProviderElement<TranslationsEn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TranslationsEn create(Ref ref) {
    return translations(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TranslationsEn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TranslationsEn>(value),
    );
  }
}

String _$translationsHash() => r'33db7b20ed97deac9cd84f9c230ae67db740ae2b';
