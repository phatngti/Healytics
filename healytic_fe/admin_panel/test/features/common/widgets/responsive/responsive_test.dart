import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveWrapper', () {
    testWidgets('shows desktop widget on large screens', (
      WidgetTester tester,
    ) async {
      // Set a large screen size (>= 1200)
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveWrapper(
            desktop: Text('Desktop View'),
            tablet: Text('Tablet View'),
            mobile: Text('Mobile View'),
          ),
        ),
      );

      expect(find.text('Desktop View'), findsOneWidget);
      expect(find.text('Tablet View'), findsNothing);
      expect(find.text('Mobile View'), findsNothing);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows tablet widget on medium screens', (
      WidgetTester tester,
    ) async {
      // Set a medium screen size (>= 800 and < 1200)
      tester.view.physicalSize = const Size(900, 700);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveWrapper(
            desktop: Text('Desktop View'),
            tablet: Text('Tablet View'),
            mobile: Text('Mobile View'),
          ),
        ),
      );

      expect(find.text('Desktop View'), findsNothing);
      expect(find.text('Tablet View'), findsOneWidget);
      expect(find.text('Mobile View'), findsNothing);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows mobile widget on small screens', (
      WidgetTester tester,
    ) async {
      // Set a small screen size (< 800)
      tester.view.physicalSize = const Size(400, 700);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: ResponsiveWrapper(
            desktop: Text('Desktop View'),
            tablet: Text('Tablet View'),
            mobile: Text('Mobile View'),
          ),
        ),
      );

      expect(find.text('Desktop View'), findsNothing);
      expect(find.text('Tablet View'), findsNothing);
      expect(find.text('Mobile View'), findsOneWidget);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('shows SizedBox.shrink when no widget provided', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MaterialApp(home: ResponsiveWrapper()));

      // Should render without errors and show an empty widget
      expect(find.byType(SizedBox), findsWidgets);

      // Reset view
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('contains LayoutBuilder', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: ResponsiveWrapper(desktop: Text('Test'))),
      );

      expect(find.byType(LayoutBuilder), findsOneWidget);
    });
  });
}
