import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/error_observer.dart';
import 'package:user_app/core/services/push_notification_flutter.service.dart';
import 'package:user_app/features/app/app.dart';
import 'package:user_app/hooks/bootstrap.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = Bootstrap.db;
  await Bootstrap.initDomain(db);
  await initApp();
  await configureFirebaseMessagingBackgroundHandler();

  runApp(ProviderScope(observers: [ErrorObserver()], child: const App()));
}

Future<void> initApp() async {
  // await EasyLocalization.ensureInitialized();
  await initializeDateFormatting('vi');

  // ── Stripe SDK initialisation ──────────────────
  const stripePk = String.fromEnvironment('STRIPE_PK');
  final configuredStripePk = stripePk.isNotEmpty
      ? stripePk
      : Store.tryGet(StoreKey.stripePublishableKey) ?? '';
  if (configuredStripePk.isNotEmpty) {
    Stripe.publishableKey = configuredStripePk;
    await Stripe.instance.applySettings();
  }

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
