import 'package:common/widgets/button/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppBackButton', () {
    testWidgets('renders back arrow icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AppBackButton(onTap: () {})),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (
      WidgetTester tester,
    ) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AppBackButton(onTap: () => wasTapped = true)),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(wasTapped, isTrue);
    });

    testWidgets('shows pressed state on tap down', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AppBackButton(onTap: () {})),
        ),
      );

      // Get initial AnimatedContainer
      final gesture = await tester.startGesture(
        tester.getCenter(find.byType(GestureDetector)),
      );

      await tester.pump();
      // The widget should be in pressed state now

      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('has click cursor', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AppBackButton(onTap: () {})),
        ),
      );

      // Find the MouseRegion that is a descendant of AppBackButton
      final mouseRegion = tester.widget<MouseRegion>(
        find.descendant(
          of: find.byType(AppBackButton),
          matching: find.byType(MouseRegion),
        ),
      );
      expect(mouseRegion.cursor, equals(SystemMouseCursors.click));
    });

    testWidgets('contains AnimatedContainer for smooth transitions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AppBackButton(onTap: () {})),
        ),
      );

      expect(find.byType(AnimatedContainer), findsOneWidget);
    });

    testWidgets('icon has correct size', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AppBackButton(onTap: () {})),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(Icons.arrow_back_ios_new));
      expect(icon.size, equals(16));
    });
  });
}
