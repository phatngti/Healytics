// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LocalePreferences)
const localePreferencesProvider = LocalePreferencesProvider._();

final class LocalePreferencesProvider
    extends $NotifierProvider<LocalePreferences, AppLocale> {
  const LocalePreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localePreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localePreferencesHash();

  @$internal
  @override
  LocalePreferences create() => LocalePreferences();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppLocale value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppLocale>(value),
    );
  }
}

String _$localePreferencesHash() => r'35b02bb3f649517790ed4889f9d768846413d7bc';

abstract class _$LocalePreferences extends $Notifier<AppLocale> {
  AppLocale build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppLocale, AppLocale>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppLocale, AppLocale>,
              AppLocale,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
