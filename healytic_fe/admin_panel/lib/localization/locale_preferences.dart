import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/gen/translations.g.dart';
import 'package:admin_panel/preferences/preferences_provider.dart';

part 'locale_preferences.g.dart';

@Riverpod(keepAlive: true)
class LocalePreferences extends _$LocalePreferences {
  @override
  AppLocale build() {
    final persisted = ref
        .watch(sharedPreferencesProvider)
        .requireValue
        .getString("locale");
    if (persisted == null) return AppLocaleUtils.findDeviceLocale();
    try {
      return AppLocale.values.byName(persisted);
    } catch (e) {
      return AppLocale.en;
    }
  }

  Future<void> changeLocale(AppLocale value) async {
    state = value;
    await ref
        .read(sharedPreferencesProvider)
        .requireValue
        .setString("locale", value.name);
  }
}
