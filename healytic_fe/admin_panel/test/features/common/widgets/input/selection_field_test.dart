import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormFieldBuilders.buildCustomSelectionField', () {
    final testItems = [
      const DropdownMenuItem<String>(value: 'option1', child: Text('Option 1')),
      const DropdownMenuItem<String>(value: 'option2', child: Text('Option 2')),
      const DropdownMenuItem<String>(value: 'option3', child: Text('Option 3')),
    ];

    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'test_field',
                      label: 'Test Label',
                      items: testItems,
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('TEST LABEL'), findsOneWidget);
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
                      FormFieldBuilders.buildCustomSelectionField<String>(
                        context,
                        fieldKey: 'test_field',
                        label: 'Test Label',
                        items: testItems,
                        uppercaseLabel: false,
                      ),
                ),
              ),
            ),
          ),
        );

        expect(find.text('Test Label'), findsOneWidget);
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
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'required_field',
                      label: 'Required',
                      items: testItems,
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

    testWidgets('renders DropdownButtonFormField', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'dropdown_field',
                      label: 'Dropdown',
                      items: testItems,
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
    });

    testWidgets('shows initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'initial_field',
                      label: 'With Initial',
                      items: testItems,
                      initialValue: 'option2',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('shows hint text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'hint_field',
                      label: 'With Hint',
                      items: testItems,
                      hintText: 'Select an option',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Select an option'), findsOneWidget);
    });

    // Removed testcase: 'renders without label when label is null' as FormFieldBuilders usually requires label.
    // buildCustomSelectionField requires label String.

    testWidgets('has dropdown icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'icon_field',
                      label: 'With Icon',
                      items: testItems,
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.keyboard_arrow_down_rounded), findsOneWidget);
    });

    testWidgets('custom icon is displayed when provided', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'custom_icon_field',
                      label: 'Custom Icon',
                      items: testItems,
                      icon: const Icon(Icons.arrow_drop_down_circle),
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_drop_down_circle), findsOneWidget);
    });

    testWidgets('calls onChanged when selection changes', (
      WidgetTester tester,
    ) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildCustomSelectionField<String>(
                      context,
                      fieldKey: 'change_field',
                      label: 'Change Test',
                      items: testItems,
                      onChanged: (value) => selectedValue = value,
                    ),
              ),
            ),
          ),
        ),
      );

      // Tap to open dropdown
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();

      // Select option 2
      await tester.tap(find.text('Option 2').last);
      await tester.pumpAndSettle();

      expect(selectedValue, equals('option2'));
    });
  });
}
