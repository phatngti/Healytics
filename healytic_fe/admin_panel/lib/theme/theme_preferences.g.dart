// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_preferences.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ThemePreferences)
const themePreferencesProvider = ThemePreferencesProvider._();

final class ThemePreferencesProvider
    extends $NotifierProvider<ThemePreferences, AppThemeMode> {
  const ThemePreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themePreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themePreferencesHash();

  @$internal
  @override
  ThemePreferences create() => ThemePreferences();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppThemeMode>(value),
    );
  }
}

String _$themePreferencesHash() => r'1f7ade4fa1d7599d0522e5097ca69496f498723f';

abstract class _$ThemePreferences extends $Notifier<AppThemeMode> {
  AppThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AppThemeMode, AppThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppThemeMode, AppThemeMode>,
              AppThemeMode,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
