import 'package:admin_panel/features/common/widgets/table/table.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppTable', () {
    // Helper to create test data
    Future<int> mockGetTotalRows() async {
      return 10;
    }

    Future<List<DataRow>> mockGetData(
      void Function(LocalKey, bool) setRowSelection,
      int startingAt,
      int count,
    ) async {
      final rows = List.generate(
        count,
        (index) => DataRow(
          cells: [
            DataCell(Text('Row ${startingAt + index}')),
            DataCell(Text('Value ${startingAt + index}')),
          ],
        ),
      );
      // Ensure we don't return more than available
      if (startingAt + count > 10) {
        return rows.sublist(0, 10 - startingAt);
      }
      return rows;
    }

    testWidgets('renders table with columns', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: AppTable(
                columns: const [
                  DataColumn(label: Text('Column 1')),
                  DataColumn(label: Text('Column 2')),
                ],
                getTotalRows: mockGetTotalRows,
                getData: mockGetData,
              ),
            ),
          ),
        ),
      );

      // Allow async initial load
      await tester.pumpAndSettle();

      expect(find.text('Column 1'), findsOneWidget);
      expect(find.text('Column 2'), findsOneWidget);
    });

    testWidgets('renders data rows', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: AppTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Description')),
                ],
                getTotalRows: mockGetTotalRows,
                getData: mockGetData,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Row 0'), findsOneWidget);
      expect(find.text('Value 0'), findsOneWidget);
    });

    testWidgets('shows action column when actionButtons is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: AppTable(
                columns: [DataColumn(label: Text('Col 1'))],
                getTotalRows: mockGetTotalRows,
                getData: mockGetData,
                actionButtons: true,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Action'), findsOneWidget);
    });

    testWidgets('empty state displays "No data"', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: AppTable(
                columns: const [DataColumn(label: Text('Col 1'))],
                getTotalRows: () async => 0,
                getData: (setRowSelection, startingAt, count) async => [],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('No data'), findsOneWidget);
    });

    testWidgets('displays error message on failure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: AppTable(
                columns: const [DataColumn(label: Text('Col 1'))],
                getTotalRows: () async => throw Exception('Fetch failed'),
                getData: (setRowSelection, startingAt, count) async => [],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Oops! Exception: Fetch failed'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
