import 'package:admin_panel/features/common/widgets/linear_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

void main() {
  group('AppLinearPercentIndicator', () {
    testWidgets('renders step text correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLinearPercentIndicator(step: 2, maxSteps: 5)),
        ),
      );

      expect(find.text('Step 2/5'), findsOneWidget);
    });

    testWidgets('renders LinearPercentIndicator', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLinearPercentIndicator(step: 1, maxSteps: 3)),
        ),
      );

      expect(find.byType(LinearPercentIndicator), findsOneWidget);
    });

    testWidgets('calculates correct percent', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLinearPercentIndicator(step: 3, maxSteps: 4)),
        ),
      );

      final indicator = tester.widget<LinearPercentIndicator>(
        find.byType(LinearPercentIndicator),
      );
      expect(indicator.percent, equals(0.75)); // 3/4 = 0.75
    });

    testWidgets('shows 0% when step is 0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLinearPercentIndicator(step: 0, maxSteps: 5)),
        ),
      );

      final indicator = tester.widget<LinearPercentIndicator>(
        find.byType(LinearPercentIndicator),
      );
      expect(indicator.percent, equals(0.0));
      expect(find.text('Step 0/5'), findsOneWidget);
    });

    testWidgets('shows 100% when step equals maxSteps', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLinearPercentIndicator(step: 5, maxSteps: 5)),
        ),
      );

      final indicator = tester.widget<LinearPercentIndicator>(
        find.byType(LinearPercentIndicator),
      );
      expect(indicator.percent, equals(1.0));
      expect(find.text('Step 5/5'), findsOneWidget);
    });

    testWidgets('has lineHeight of 8.0', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLinearPercentIndicator(step: 1, maxSteps: 2)),
        ),
      );

      final indicator = tester.widget<LinearPercentIndicator>(
        find.byType(LinearPercentIndicator),
      );
      expect(indicator.lineHeight, equals(8.0));
    });

    testWidgets('uses theme primary color for progress', (
      WidgetTester tester,
    ) async {
      const customPrimaryColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(primary: customPrimaryColor),
          ),
          home: const Scaffold(
            body: AppLinearPercentIndicator(step: 1, maxSteps: 2),
          ),
        ),
      );

      final indicator = tester.widget<LinearPercentIndicator>(
        find.byType(LinearPercentIndicator),
      );
      expect(indicator.progressColor, equals(customPrimaryColor));
    });

    testWidgets('contains Column layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AppLinearPercentIndicator(step: 1, maxSteps: 2)),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });
  });
}
