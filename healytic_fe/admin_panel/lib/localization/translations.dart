import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/gen/translations.g.dart';
import 'package:admin_panel/localization/locale_preferences.dart';

part 'translations.g.dart';

@Riverpod(keepAlive: true)
TranslationsEn translations(Ref ref) =>
    ref.watch(localePreferencesProvider).buildSync();
