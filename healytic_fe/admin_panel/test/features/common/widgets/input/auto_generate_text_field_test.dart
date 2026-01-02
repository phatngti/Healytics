import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormFieldBuilders.buildAutoGenerateTextField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'test_field',
                      label: 'Employee ID',
                      onGenerate: () async => 'GENERATED',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('EMPLOYEE ID'), findsOneWidget);
    });

    testWidgets(
      'renders label without uppercase when uppercaseLabel is false',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FormBuilder(
                child: Builder(
                  builder: (context) =>
                      FormFieldBuilders.buildAutoGenerateTextField(
                        context,
                        fieldKey: 'test_field',
                        label: 'Custom ID',
                        onGenerate: () async => 'GENERATED',
                        uppercaseLabel: false,
                      ),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Custom ID'), findsOneWidget);
      },
    );

    testWidgets('displays required indicator when isRequired is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'required_field',
                      label: 'Required',
                      onGenerate: () async => 'GENERATED',
                      isRequired: true,
                    ),
              ),
            ),
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((widget) {
          if (widget is Text && widget.textSpan != null) {
            final text = widget.textSpan!.toPlainText();
            return text.contains('REQUIRED') && text.contains('*');
          }
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('shows auto-generate button with default text', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'button_field',
                      label: 'Test',
                      onGenerate: () async => 'GENERATED',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Auto-Generate'), findsOneWidget);
    });

    testWidgets('shows custom button text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'custom_button_field',
                      label: 'Test',
                      onGenerate: () async => 'GENERATED',
                      buttonText: 'Generate Now',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Generate Now'), findsOneWidget);
    });

    testWidgets('has AppButton as suffix icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'button_test',
                      label: 'Test',
                      onGenerate: () async => 'GENERATED',
                    ),
              ),
            ),
          ),
        ),
      );

      // Verify TextButton exists (AppButton with type text uses TextButton)
      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('Auto-Generate'), findsOneWidget);
    });

    testWidgets('shows hint text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'hint_field',
                      label: 'With Hint',
                      onGenerate: () async => 'GENERATED',
                      hintText: 'Enter or generate',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Enter or generate'), findsOneWidget);
    });

    testWidgets('uses initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'initial_field',
                      label: 'Initial',
                      onGenerate: () async => 'GENERATED',
                      initialValue: 'EMP-001',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('EMP-001'), findsOneWidget);
    });

    testWidgets('renders TextFormField', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'text_field',
                      label: 'Test',
                      onGenerate: () async => 'GENERATED',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('field is disabled by default', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'disabled_field',
                      label: 'Disabled',
                      onGenerate: () async => 'GENERATED',
                    ),
              ),
            ),
          ),
        ),
      );

      final textFormField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textFormField.enabled, isFalse);
    });

    testWidgets('field is enabled when enabled is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildAutoGenerateTextField(
                      context,
                      fieldKey: 'enabled_field',
                      label: 'Enabled',
                      onGenerate: () async => 'GENERATED',
                      enabled: true,
                    ),
              ),
            ),
          ),
        ),
      );

      final textFormField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textFormField.enabled, isTrue);
    });
  });
}
