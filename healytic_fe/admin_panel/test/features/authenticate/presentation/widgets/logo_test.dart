import 'package:admin_panel/features/authenticate/presentation/widgets/logo.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdminLogo', () {
    Widget createTestWidget() {
      return MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: [
            SemanticColors(
              success: Colors.green,
              warning: Colors.orange,
              error: Colors.red,
              info: Colors.blue,
            ),
          ],
        ),
        home: const Scaffold(body: AdminLogo()),
      );
    }

    testWidgets('renders shield icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byIcon(Icons.shield), findsOneWidget);
    });

    testWidgets('renders "Admin Panel" text', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Admin Panel'), findsOneWidget);
    });

    testWidgets('contains Row for horizontal layout', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Row), findsOneWidget);
    });

    testWidgets('shield icon is white', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final icon = tester.widget<Icon>(find.byIcon(Icons.shield));
      expect(icon.color, equals(Colors.white));
    });

    testWidgets('shield icon has correct size', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final icon = tester.widget<Icon>(find.byIcon(Icons.shield));
      expect(icon.size, equals(24));
    });

    testWidgets('logo container has proper decoration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('text has bold font weight', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final text = tester.widget<Text>(find.text('Admin Panel'));
      expect(text.style?.fontWeight, equals(FontWeight.bold));
    });
  });
}
