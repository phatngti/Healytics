import 'package:admin_panel/features/common/widgets/toast.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ToastType', () {
    test('has all required types', () {
      expect(ToastType.values.length, equals(4));
      expect(ToastType.values, contains(ToastType.success));
      expect(ToastType.values, contains(ToastType.error));
      expect(ToastType.values, contains(ToastType.warning));
      expect(ToastType.values, contains(ToastType.info));
    });
  });

  group('ToastContext.switchToast', () {
    Widget createTestWidget(ToastType type, String message) {
      return MaterialApp(
        theme: ThemeData.light().copyWith(
          extensions: [
            SemanticColors(
              success: Colors.green,
              onSuccess: Colors.white,
              onSuccessContainer: Colors.green.shade300,
              warning: Colors.orange,
              onWarning: Colors.black,
              onWarningContainer: Colors.orange.shade300,
              error: Colors.red,
              onError: Colors.white,
              onErrorContainer: Colors.red.shade300,
              info: Colors.blue,
              onInfo: Colors.white,
              onInfoContainer: Colors.blue.shade300,
            ),
          ],
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                ToastContext.switchToast(context, type, message),
          ),
        ),
      );
    }

    testWidgets('success toast shows check icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(ToastType.success, 'Success!'));

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Success!'), findsOneWidget);
    });

    testWidgets('error toast shows error icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(ToastType.error, 'Error occurred'),
      );

      expect(find.byIcon(Icons.error), findsOneWidget);
      expect(find.text('Error occurred'), findsOneWidget);
    });

    testWidgets('warning toast shows warning icon', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(ToastType.warning, 'Warning!'));

      expect(find.byIcon(Icons.warning), findsOneWidget);
      expect(find.text('Warning!'), findsOneWidget);
    });

    testWidgets('info toast shows info icon', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(ToastType.info, 'Info message'));

      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('Info message'), findsOneWidget);
    });

    testWidgets('toast contains Row with icon and text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(ToastType.success, 'Test'));

      final row = find.byType(Row);
      expect(row, findsWidgets);
    });

    testWidgets('toast message has max 4 lines', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(ToastType.info, 'A very long message'),
      );

      final text = tester.widget<Text>(find.text('A very long message'));
      expect(text.maxLines, equals(4));
    });

    testWidgets('toast text uses ellipsis overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createTestWidget(ToastType.info, 'Test overflow'),
      );

      final text = tester.widget<Text>(find.text('Test overflow'));
      expect(text.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('toast is wrapped in Container with decoration', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(ToastType.success, 'Test'));

      expect(find.byType(Container), findsWidgets);
    });
  });
}
