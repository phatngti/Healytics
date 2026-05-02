import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'core/providers/error_observer.dart';
import 'features/app/app.dart';
import 'hooks/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = Bootstrap.db;
  await Bootstrap.initDomain(db);
  await initApp();

  runApp(ProviderScope(observers: [ErrorObserver()], child: const App()));
}

Future<void> initApp() async {
  await initializeDateFormatting('vi');

  if (kReleaseMode && Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
      debugPrint('High refresh rate set');
    } catch (e) {
      debugPrint('Failed to set high refresh rate: $e');
    }
  }

  final log = Logger('EmployeeAppErrorLogger');

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(
      'FlutterError - Catch all',
      '${details.toString()}\n'
          'Exception: ${details.exception}\n'
          'Library: ${details.library}\n'
          'Context: ${details.context}',
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log.severe('PlatformDispatcher - Catch all', error, stack);
    return true;
  };
}
