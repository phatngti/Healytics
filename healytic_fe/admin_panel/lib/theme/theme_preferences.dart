import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/preferences/preferences_provider.dart';
import 'package:admin_panel/theme/app_theme_mode.dart';

part 'theme_preferences.g.dart';

@Riverpod(keepAlive: true)
class ThemePreferences extends _$ThemePreferences {
  @override
  AppThemeMode build() {
    final persisted = ref
        .watch(sharedPreferencesProvider)
        .requireValue
        .getString("themeMode");
    if (persisted == null) return AppThemeMode.system;
    try {
      return AppThemeMode.values.byName(persisted);
    } catch (e) {
      return AppThemeMode.system;
    }
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    await ref
        .watch(sharedPreferencesProvider)
        .requireValue
        .setString("themeMode", themeMode.name);
    state = themeMode;
  }
}
