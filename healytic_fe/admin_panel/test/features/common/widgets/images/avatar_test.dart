import 'package:admin_panel/features/common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AvatarImage', () {
    testWidgets('displays initials when no imageUrl provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: 'John Doe')),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('displays single initial for single name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: 'Alice')),
        ),
      );

      expect(find.text('A'), findsOneWidget);
    });

    testWidgets('displays question mark for empty name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: '')),
        ),
      );

      expect(find.text('?'), findsOneWidget);
    });

    testWidgets('has CircleAvatar with default radius', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: 'Test')),
        ),
      );

      final circleAvatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(circleAvatar.radius, equals(20));
    });

    testWidgets('respects custom radius', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: 'Test', radius: 50)),
        ),
      );

      final circleAvatar = tester.widget<CircleAvatar>(
        find.byType(CircleAvatar),
      );
      expect(circleAvatar.radius, equals(50));
    });

    testWidgets('displays initials for multi-part names correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: 'Mary Jane Watson')),
        ),
      );

      // Should get first letter of first name + first letter of last name
      expect(find.text('MW'), findsOneWidget);
    });

    testWidgets('handles names with extra spaces', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: '  John   Smith  ')),
        ),
      );

      expect(find.text('JS'), findsOneWidget);
    });

    testWidgets('uses ClipOval for circular clipping', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: 'Test')),
        ),
      );

      expect(find.byType(ClipOval), findsOneWidget);
    });

    testWidgets('shows initials with empty imageUrl', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AvatarImage(name: 'Jane Doe', imageUrl: ''),
          ),
        ),
      );

      expect(find.text('JD'), findsOneWidget);
    });

    testWidgets('initials are uppercase', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: AvatarImage(name: 'lowercase name')),
        ),
      );

      expect(find.text('LN'), findsOneWidget);
    });
  });
}
