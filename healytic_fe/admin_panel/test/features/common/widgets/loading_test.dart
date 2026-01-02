import 'package:admin_panel/features/common/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoadingWidget', () {
    testWidgets('renders CircularProgressIndicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingWidget())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('is centered', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingWidget())),
      );

      expect(find.byType(Center), findsOneWidget);
    });

    testWidgets('uses theme primary color', (WidgetTester tester) async {
      const customPrimaryColor = Colors.red;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            colorScheme: const ColorScheme.light(primary: customPrimaryColor),
          ),
          home: const Scaffold(body: LoadingWidget()),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(
        indicator.valueColor,
        isA<AlwaysStoppedAnimation<Color>>().having(
          (animation) => animation.value,
          'color',
          equals(customPrimaryColor),
        ),
      );
    });

    testWidgets('works with dark theme', (WidgetTester tester) async {
      const darkPrimaryColor = Colors.tealAccent;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(primary: darkPrimaryColor),
          ),
          home: const Scaffold(body: LoadingWidget()),
        ),
      );

      final indicator = tester.widget<CircularProgressIndicator>(
        find.byType(CircularProgressIndicator),
      );

      expect(
        indicator.valueColor,
        isA<AlwaysStoppedAnimation<Color>>().having(
          (animation) => animation.value,
          'color',
          equals(darkPrimaryColor),
        ),
      );
    });

    testWidgets('can be used as const widget', (WidgetTester tester) async {
      // This test verifies the widget can be used with const constructor
      const widget1 = LoadingWidget();
      const widget2 = LoadingWidget();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: Column(children: [widget1, widget2])),
        ),
      );

      expect(find.byType(LoadingWidget), findsNWidgets(2));
    });
  });
}
