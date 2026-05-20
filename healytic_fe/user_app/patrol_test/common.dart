import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:patrol/patrol.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:user_app/features/app/app.dart';
import 'package:user_app/hooks/bootstrap.dart';

import 'config/test_config.dart';
import 'helpers/backend_backdoor_helper.dart';

/// Shared Patrol test bootstrap.
///
/// Mirrors [main] but adapted for Patrol:
/// - No `WidgetsFlutterBinding.ensureInitialized()`
/// - No `runApp()` — uses `$.pumpWidgetAndSettle()`
/// - No `FlutterError.onError` override
Future<void> pumpApp(PatrolIntegrationTester $, {String? scenario}) async {
  await TestConfig.load();
  await prepareBackendScenario(scenario);

  final db = Bootstrap.db;
  await Bootstrap.initDomain(db);
  await initializeDateFormatting('vi');
  initializeTimeZones();

  await $.pumpWidget(const ProviderScope(child: App()));
  // Use pump instead of pumpAndSettle because
  // the splash screen has continuous animations
  // that prevent pumpAndSettle from completing.
  await $.pump(const Duration(seconds: 3));
}
