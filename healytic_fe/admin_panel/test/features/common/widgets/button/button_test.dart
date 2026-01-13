import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppButton', () {
    testWidgets('renders child widget', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(onPressed: () {}, child: const Text('Test Button')),
          ),
        ),
      );

      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('elevated button triggers onPressed callback', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              buttonType: ButtonType.elevated,
              onPressed: () => wasPressed = true,
              child: const Text('Click Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('outline button triggers onPressed callback', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              buttonType: ButtonType.outline,
              onPressed: () => wasPressed = true,
              child: const Text('Outline Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(OutlinedButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('text button triggers onPressed callback', (
      WidgetTester tester,
    ) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              buttonType: ButtonType.text,
              onPressed: () => wasPressed = true,
              child: const Text('Text Button'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextButton));
      await tester.pump();

      expect(wasPressed, isTrue);
    });

    testWidgets('link button renders with TextButton', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              buttonType: ButtonType.link,
              onPressed: () {},
              child: const Text('Link Button'),
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Link Button'), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              isLoading: true,
              child: const Text('Loading Button'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading Button'), findsNothing);
    });

    testWidgets('shows child when isLoading is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              onPressed: () {},
              isLoading: false,
              child: const Text('Normal Button'),
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Normal Button'), findsOneWidget);
    });

    testWidgets('elevated button with icon renders ElevatedButton.icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              buttonType: ButtonType.elevated,
              onPressed: () {},
              icon: const Icon(Icons.add),
              child: const Text('Add'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('outline button with icon renders OutlinedButton.icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              buttonType: ButtonType.outline,
              onPressed: () {},
              icon: const Icon(Icons.download),
              child: const Text('Download'),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.download), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
    });

    testWidgets('button is disabled when onPressed is null', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              buttonType: ButtonType.elevated,
              onPressed: null,
              child: const Text('Disabled'),
            ),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.onPressed, isNull);
    });
  });

  group('LoadingContainer', () {
    testWidgets('renders CircularProgressIndicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingContainer())),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('has correct size constraints', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingContainer())),
      );

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.width, equals(24));
      expect(sizedBox.height, equals(24));
    });
  });
}
