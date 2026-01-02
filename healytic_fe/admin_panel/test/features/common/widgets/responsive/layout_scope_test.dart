import 'package:admin_panel/features/common/widgets/responsive/layout_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LayoutScope', () {
    testWidgets('provides sidebar and header to children', (
      WidgetTester tester,
    ) async {
      const testSidebar = Text('Sidebar');
      const testHeader = Text('Header');

      await tester.pumpWidget(
        MaterialApp(
          home: LayoutScope(
            sidebar: testSidebar,
            header: testHeader,
            child: Builder(
              builder: (context) {
                final scope = LayoutScope.of(context);
                return Column(
                  children: [
                    scope?.sidebar ?? const SizedBox(),
                    scope?.header ?? const SizedBox(),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Sidebar'), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
    });

    testWidgets('LayoutScope.of returns the scope in context', (
      WidgetTester tester,
    ) async {
      LayoutScope? foundScope;

      await tester.pumpWidget(
        MaterialApp(
          home: LayoutScope(
            sidebar: const Text('Sidebar'),
            header: const Text('Header'),
            child: Builder(
              builder: (context) {
                foundScope = LayoutScope.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(foundScope, isNotNull);
    });

    testWidgets('LayoutScope.of returns null when not in scope', (
      WidgetTester tester,
    ) async {
      LayoutScope? foundScope;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              foundScope = LayoutScope.of(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(foundScope, isNull);
    });

    testWidgets('updateShouldNotify returns true when sidebar changes', (
      WidgetTester tester,
    ) async {
      const sidebar1 = Text('Sidebar 1');
      const sidebar2 = Text('Sidebar 2');
      const header = Text('Header');

      final layoutScope1 = LayoutScope(
        sidebar: sidebar1,
        header: header,
        child: const SizedBox(),
      );

      final layoutScope2 = LayoutScope(
        sidebar: sidebar2,
        header: header,
        child: const SizedBox(),
      );

      expect(layoutScope2.updateShouldNotify(layoutScope1), isTrue);
    });

    testWidgets('updateShouldNotify returns true when header changes', (
      WidgetTester tester,
    ) async {
      const sidebar = Text('Sidebar');
      const header1 = Text('Header 1');
      const header2 = Text('Header 2');

      final layoutScope1 = LayoutScope(
        sidebar: sidebar,
        header: header1,
        child: const SizedBox(),
      );

      final layoutScope2 = LayoutScope(
        sidebar: sidebar,
        header: header2,
        child: const SizedBox(),
      );

      expect(layoutScope2.updateShouldNotify(layoutScope1), isTrue);
    });

    testWidgets('updateShouldNotify returns false when nothing changes', (
      WidgetTester tester,
    ) async {
      const sidebar = Text('Sidebar');
      const header = Text('Header');

      final layoutScope1 = LayoutScope(
        sidebar: sidebar,
        header: header,
        child: const SizedBox(),
      );

      final layoutScope2 = LayoutScope(
        sidebar: sidebar,
        header: header,
        child: const SizedBox(),
      );

      expect(layoutScope2.updateShouldNotify(layoutScope1), isFalse);
    });

    testWidgets('is an InheritedWidget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: LayoutScope(
            sidebar: const Text('Sidebar'),
            header: const Text('Header'),
            child: const SizedBox(),
          ),
        ),
      );

      expect(find.byType(LayoutScope), findsOneWidget);
    });
  });
}
