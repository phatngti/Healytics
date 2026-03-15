import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/app/app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart';
import '../patrol_test/config/test_config.dart';
import 'package:user_app/hooks/bootstrap.dart';

void main() {
  testWidgets('App hydrates without crashing', (tester) async {
    final db = Bootstrap.db;
    await Bootstrap.initDomain(db);
    await initializeDateFormatting('vi');
    initializeTimeZones();
    await TestConfig.load();

    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    expect(find.byType(App), findsOneWidget);
  });
}
