import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:user_app/features/app/app.dart';
import 'package:user_app/hooks/bootstrap.dart';
import 'package:easy_localization/easy_localization.dart';

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

  if (kReleaseMode && Platform.isAndroid) {
    try {
      await FlutterDisplayMode.setHighRefreshRate();
      debugPrint('High refresh rate set');
    } catch (e) {
      debugPrint('Failed to set high refresh rate: $e');
    }
  }

  final log = Logger("PlayErrorLogger");

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    log.severe(
      'FlutterError - Catch all',
      "${details.toString()}\nException: ${details.exception}\nLibrary: ${details.library}\nContext: ${details.context}",
      details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint("FlutterError - Catch all: $error \n $stack");
    log.severe('PlatformDispatcher - Catch all', error, stack);
    return true;
  };

  initializeTimeZones();
}
