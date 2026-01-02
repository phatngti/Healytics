import 'package:admin_panel/features/common/widgets/card/statistic_card.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StatisticCard', () {
    Widget createTestWidget({
      required String label,
      required String value,
      required double change,
    }) {
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
        home: Scaffold(
          body: StatisticCard(label: label, value: value, change: change),
        ),
      );
    }

    testWidgets('renders label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(label: 'Total Users', value: '1,234', change: 5.5),
      );

      expect(find.text('Total Users'), findsOneWidget);
    });

    testWidgets('renders value text', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(label: 'Revenue', value: '\$50,000', change: 10.0),
      );

      expect(find.text('\$50,000'), findsOneWidget);
    });

    testWidgets('displays positive change with plus sign', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(label: 'Growth', value: '100', change: 15.5),
      );

      expect(find.text('+15.5%'), findsOneWidget);
    });

    testWidgets('displays negative change with minus sign', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(label: 'Decline', value: '50', change: -8.3),
      );

      expect(find.text('--8.3%'), findsOneWidget);
    });

    testWidgets('displays zero change with plus sign', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(label: 'Neutral', value: '200', change: 0.0),
      );

      expect(find.text('+0.0%'), findsOneWidget);
    });

    testWidgets('has Container with proper decoration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(label: 'Test', value: '100', change: 5.0),
      );

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders all three text sections', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(label: 'Sales', value: '500', change: 2.5),
      );

      expect(find.text('Sales'), findsOneWidget);
      expect(find.text('500'), findsOneWidget);
      expect(find.text('+2.5%'), findsOneWidget);
    });
  });
}
