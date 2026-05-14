import 'package:common/widgets/table/table.dart';

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

    testWidgets('search field accepts visible text and calls callback', (
      WidgetTester tester,
    ) async {
      var searchValue = '';
      const searchKey = Key('app_table_search_field');

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
                searchFieldKey: searchKey,
                onSearchChanged: (value) => searchValue = value,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(searchKey), findsOneWidget);

      await tester.enterText(find.byKey(searchKey), 'therapy');
      await tester.pump();

      expect(searchValue, 'therapy');
      expect(find.text('therapy'), findsOneWidget);
    });

    testWidgets('search field keeps text when parent rebuilds', (
      WidgetTester tester,
    ) async {
      var searchValue = '';
      const searchKey = Key('app_table_refreshing_search_field');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AppTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Description')),
                    ],
                    getTotalRows: mockGetTotalRows,
                    getData: mockGetData,
                    searchFieldKey: searchKey,
                    onSearchChanged: (value) {
                      setState(() {
                        searchValue = value;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(searchKey), 'therapy');
      await tester.pump();
      await tester.enterText(find.byKey(searchKey), 'therapy care');
      await tester.pump();

      expect(searchValue, 'therapy care');
      expect(find.text('therapy care'), findsOneWidget);
    });

    testWidgets('select-all toggles every selectable row callback', (
      WidgetTester tester,
    ) async {
      final selectedIds = <int>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: AppTable(
                columns: const [DataColumn(label: Text('Name'))],
                getTotalRows: () async => 3,
                getData: (setRowSelection, startingAt, count) async {
                  return List.generate(3, (index) {
                    final key = ValueKey<int>(index);
                    return DataRow(
                      key: key,
                      selected: selectedIds.contains(index),
                      onSelectChanged: (selected) {
                        if (selected == null) return;
                        setRowSelection(key, selected);
                        if (selected) {
                          selectedIds.add(index);
                        } else {
                          selectedIds.remove(index);
                        }
                      },
                      cells: [DataCell(Text('Selectable $index'))],
                    );
                  });
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).first);
      await tester.pumpAndSettle();

      expect(selectedIds, {0, 1, 2});
    });

    testWidgets('selected row stays checked after parent rebuild', (
      WidgetTester tester,
    ) async {
      final selectedIds = <int>{};
      var getDataCalls = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return AppTable(
                    columns: const [DataColumn(label: Text('Name'))],
                    getTotalRows: () async => 2,
                    getData: (setRowSelection, startingAt, count) async {
                      getDataCalls += 1;
                      return List.generate(2, (index) {
                        final key = ValueKey<int>(index);
                        return DataRow(
                          key: key,
                          selected: selectedIds.contains(index),
                          onSelectChanged: (selected) {
                            if (selected == null) return;
                            setRowSelection(key, selected);
                            setState(() {
                              if (selected) {
                                selectedIds.add(index);
                              } else {
                                selectedIds.remove(index);
                              }
                            });
                          },
                          cells: [DataCell(Text('Rebuild row $index'))],
                        );
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pumpAndSettle();

      expect(selectedIds, {0});
      expect(getDataCalls, 1);
      expect(tester.widget<Checkbox>(find.byType(Checkbox).at(1)).value, true);
    });

    testWidgets('refreshToken change refetches rows', (
      WidgetTester tester,
    ) async {
      var getDataCalls = 0;
      var refreshToken = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 1000,
              height: 800,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      TextButton(
                        onPressed: () => setState(() => refreshToken += 1),
                        child: const Text('Refresh'),
                      ),
                      Expanded(
                        child: AppTable(
                          refreshToken: refreshToken,
                          columns: const [DataColumn(label: Text('Name'))],
                          getTotalRows: () async => 1,
                          getData: (setRowSelection, startingAt, count) async {
                            getDataCalls += 1;
                            return const [
                              DataRow(cells: [DataCell(Text('Refetch row'))]),
                            ];
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(getDataCalls, 1);

      await tester.tap(find.text('Refresh'));
      await tester.pumpAndSettle();

      expect(getDataCalls, 2);
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
