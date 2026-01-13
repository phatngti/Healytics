import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TableFunctionButtonWidget', () {
    testWidgets('renders label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableFunctionButtonWidget(
              label: 'Filter',
              prefixIcon: Icons.filter_list,
              child: const Text('Filter content'),
            ),
          ),
        ),
      );

      expect(find.text('Filter'), findsOneWidget);
    });

    testWidgets('renders prefix icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableFunctionButtonWidget(
              label: 'Sort',
              prefixIcon: Icons.sort,
              child: const Text('Sort content'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.sort), findsOneWidget);
    });

    testWidgets('has click cursor', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableFunctionButtonWidget(
              label: 'Click Me',
              prefixIcon: Icons.touch_app,
              child: const Text('Popup content'),
            ),
          ),
        ),
      );

      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(
          of: find.byType(TableFunctionButtonWidget),
          matching: find.byType(MouseRegion),
        ),
      );
      expect(mouseRegion.cursor, equals(SystemMouseCursors.click));
    });

    testWidgets('contains Row with icon and text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableFunctionButtonWidget(
              label: 'Export',
              prefixIcon: Icons.download,
              child: const Text('Export options'),
            ),
          ),
        ),
      );

      expect(find.byType(Row), findsWidgets);
      expect(find.text('Export'), findsOneWidget);
      expect(find.byIcon(Icons.download), findsOneWidget);
    });

    testWidgets('shows popup when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableFunctionButtonWidget(
              label: 'Columns',
              prefixIcon: Icons.view_column,
              child: const Text('Select columns'),
            ),
          ),
        ),
      );

      // Tap to show popup
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();

      // Popup content should be visible
      expect(find.text('Select columns'), findsOneWidget);
    });

    testWidgets('hides popup when tapped outside', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: TableFunctionButtonWidget(
                label: 'Settings',
                prefixIcon: Icons.settings,
                child: const Text('Settings panel'),
              ),
            ),
          ),
        ),
      );

      // Open popup
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings panel'), findsOneWidget);

      // Tap outside to close
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Popup should be closed
      expect(find.text('Settings panel'), findsNothing);
    });

    testWidgets('has maxWidth constraint', (WidgetTester tester) async {
      expect(TableFunctionButtonWidget.maxWidth, equals(400));
    });

    testWidgets('uses GestureDetector for tap handling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableFunctionButtonWidget(
              label: 'Actions',
              prefixIcon: Icons.more_vert,
              child: const Text('Action list'),
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
