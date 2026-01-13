import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:admin_panel/features/common/widgets/table/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TableHeaderWidget', () {
    testWidgets('renders search field when onSearchChanged is provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TableHeaderWidget(onSearchChanged: (value) {})),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows search hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TableHeaderWidget(onSearchChanged: (value) {})),
        ),
      );

      expect(find.text('Search...'), findsOneWidget);
    });

    testWidgets('calls onSearchChanged when text is entered', (
      WidgetTester tester,
    ) async {
      String? searchValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeaderWidget(
              onSearchChanged: (value) => searchValue = value,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      expect(searchValue, equals('test query'));
    });

    testWidgets('renders function buttons when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeaderWidget(
              onSearchChanged: (value) {},
              functionButtons: [
                TableFunctionButtonWidget(
                  label: 'Filter',
                  prefixIcon: Icons.filter_list,
                  child: const Text('Filter options'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Filter'), findsOneWidget);
      expect(find.byIcon(Icons.filter_list), findsOneWidget);
    });

    testWidgets('renders multiple function buttons', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeaderWidget(
              onSearchChanged: (value) {},
              functionButtons: [
                TableFunctionButtonWidget(
                  label: 'Filter',
                  prefixIcon: Icons.filter_list,
                  child: const Text('Filter'),
                ),
                TableFunctionButtonWidget(
                  label: 'Sort',
                  prefixIcon: Icons.sort,
                  child: const Text('Sort'),
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Filter'), findsOneWidget);
      expect(find.text('Sort'), findsOneWidget);
    });

    testWidgets('renders AppButton when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeaderWidget(
              onSearchChanged: (value) {},
              buttons: [
                AppButton(onPressed: () {}, child: const Text('Add New')),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Add New'), findsOneWidget);
    });

    testWidgets('uses Row layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TableHeaderWidget(onSearchChanged: (value) {})),
        ),
      );

      expect(find.byType(Row), findsWidgets);
    });

    testWidgets('search field has 300 width', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: TableHeaderWidget(onSearchChanged: (value) {})),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find
            .ancestor(
              of: find.byType(TextField),
              matching: find.byType(SizedBox),
            )
            .first,
      );
      expect(sizedBox.width, equals(300));
    });

    testWidgets('renders without search when onSearchChanged is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TableHeaderWidget(
              onSearchChanged: null,
              buttons: [
                AppButton(onPressed: () {}, child: const Text('Button Only')),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsNothing);
      expect(find.text('Button Only'), findsOneWidget);
    });
  });
}
