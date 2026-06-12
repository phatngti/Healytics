import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:admin_panel/features/app/app.dart';
import 'package:admin_panel/hooks/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = Bootstrap.db;
  await Bootstrap.initDomain(db);
  await initApp();

  runApp(const ProviderScope(child: App()));
}

Future<void> initApp() async {
  // await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('vi');

  final log = Logger("PlayErrorLogger");

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    try {
      log.severe(
        'FlutterError - Catch all',
        '${details.toString()}\n'
            'Exception: ${details.exception}\n'
            'Library: ${details.library}\n'
            'Context: ${details.context}',
        details.stack,
      );
    } catch (e) {
      log.severe(
        'FlutterError - Catch all (fallback)',
        'Exception: ${details.exception}\n'
            'Library: ${details.library}',
        details.stack,
      );
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("FlutterError - Catch all: $error \n $stack");
    log.severe('PlatformDispatcher - Catch all', error, stack);
    return true;
  };

  initializeTimeZones();
}
