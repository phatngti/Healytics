import 'package:admin_panel/features/app/app.dart';
import 'package:admin_panel/hooks/bootstrap.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/utils/browser_storage.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:patrol/patrol.dart';
import 'package:timezone/data/latest_all.dart';

import 'config/test_config.dart';

/// Shared Patrol test bootstrap for admin_panel.
///
/// Mirrors [main] but adapted for Patrol:
/// - No `WidgetsFlutterBinding.ensureInitialized()`
/// - No `runApp()` - uses `$.pumpWidget()`
/// - No `FlutterError.onError` override
Future<void> pumpApp(PatrolIntegrationTester $) async {
  final db = Bootstrap.db;
  await Bootstrap.initDomain(db);
  await _resetSession();
  await initializeDateFormatting('vi');
  initializeTimeZones();
  await TestConfig.load();

  await $.pumpWidget(const ProviderScope(child: App()));
  // Use pump instead of pumpAndSettle because
  // continuous animations may prevent settling.
  await $.pump(const Duration(seconds: 3));
}

Future<void> _resetSession() async {
  await Store.delete(StoreKey.accessToken);
  await Store.delete(StoreKey.refreshToken);
  removeBrowserItem('access_token');
  await UserRoleHelper.clearSession();
}
