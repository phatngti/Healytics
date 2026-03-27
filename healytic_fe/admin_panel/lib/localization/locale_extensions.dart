import 'package:admin_panel/gen/translations.g.dart';

extension AppLocaleX on AppLocale {
  String get localeName => switch (flutterLocale.toString()) {
    "en" => "English",
    _ => "Unknown",
  };
}
