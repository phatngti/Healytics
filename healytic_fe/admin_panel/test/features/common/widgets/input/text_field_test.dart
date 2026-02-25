import 'package:common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormFieldBuilders.buildTextField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'test_field',
                  label: 'Test Label',
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
                  builder: (context) => FormFieldBuilders.buildTextField(
                    context,
                    fieldKey: 'test_field',
                    label: 'Test Label',
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
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'required_field',
                  label: 'Required',
                  isRequired: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the rich text that contains both label and asterisk
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

    testWidgets('accepts text input', (WidgetTester tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'input_field',
                  label: 'Input',
                  controller: controller,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Hello World');
      await tester.pump();

      expect(controller.text, equals('Hello World'));
    });

    testWidgets('obscures text when obscureText is true', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'password_field',
                  label: 'Password',
                  obscureText: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the EditableText and verify it's obscured
      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.obscureText, isTrue);
    });

    testWidgets('shows suffix icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'icon_field',
                  label: 'With Icon',
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.search), findsOneWidget);
    });

    testWidgets('shows prefix icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'prefix_field',
                  label: 'With Prefix',
                  prefixIcon: Icons.person,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('calls onChanged callback', (WidgetTester tester) async {
      String? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'change_field',
                  label: 'Change Test',
                  onChanged: (value) => changedValue = value as String?,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'New Value');
      await tester.pump();

      expect(changedValue, equals('New Value'));
    });

    testWidgets('disables input when enabled is false', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'disabled_field',
                  label: 'Disabled',
                  enabled: false,
                ),
              ),
            ),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.enabled, isFalse);
    });

    testWidgets('shows hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'hint_field',
                  label: 'Hint Test',
                  hintText: 'Enter text here',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Enter text here'), findsOneWidget);
    });

    testWidgets('uses initial value', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'initial_field',
                  label: 'Initial Value',
                  initialValue: 'Pre-filled',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Pre-filled'), findsOneWidget);
    });

    testWidgets('renders without label when label is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'no_label_field',
                  label: '',
                ),
              ),
            ),
          ),
        ),
      );

      // Should not find any label padding
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets('supports multiline input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'multiline_field',
                  label: 'Multiline',
                  maxLines: 5,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the EditableText to verify maxLines
      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.maxLines, equals(5));
    });

    testWidgets('validates input with validator', (WidgetTester tester) async {
      final formKey = GlobalKey<FormBuilderState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              key: formKey,
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'validation_field',
                  label: 'Validation Test',
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
      );

      formKey.currentState?.saveAndValidate();
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('sets readOnly property correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'readonly_field',
                  label: 'Read Only',
                  readOnly: true,
                ),
              ),
            ),
          ),
        ),
      );

      // Find the EditableText to verify readOnly
      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.readOnly, isTrue);
    });

    testWidgets('triggers onTap callback', (WidgetTester tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'tap_field',
                  label: 'Tap Test',
                  readOnly: true,
                  onTap: () => wasTapped = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextFormField));
      await tester.pump();

      expect(wasTapped, isTrue);
    });
  });
}
