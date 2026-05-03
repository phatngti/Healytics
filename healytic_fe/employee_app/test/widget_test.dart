// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:employee_app/features/app/app.dart';
import 'package:employee_app/core/database/repositories/drift.repository.dart';
import 'package:employee_app/core/repositories/store.repository.dart';
import 'package:employee_app/core/services/store.service.dart';
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  testWidgets('App renders smoke test', (WidgetTester tester) async {
    final db = Drift(NativeDatabase.memory());
    await StoreService.init(storeRepository: DriftStoreRepository(db));
    addTearDown(db.close);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: App()));

    await tester.pump();

    expect(find.text('Healytics Employee'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
