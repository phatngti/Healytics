import 'package:common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDatePickField', () {
    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'date_field',
                  label: 'Select Date',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('SELECT DATE'), findsOneWidget);
    });

    testWidgets('renders FormBuilderDateTimePicker', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'date_picker_field',
                  label: 'Date Picker',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(FormBuilderDateTimePicker), findsOneWidget);
    });

    testWidgets('shows calendar icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'icon_field',
                  label: 'With Icon',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.calendar_today), findsOneWidget);
    });

    testWidgets('shows hint text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'hint_field',
                  label: 'With Hint',
                  hintText: 'DD-MM-YYYY',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('DD-MM-YYYY'), findsOneWidget);
    });

    testWidgets('renders without label when label is empty', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'no_label_field',
                  label: '',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(FormBuilderDateTimePicker), findsOneWidget);
    });

    testWidgets('uses Column as layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) => FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'layout_field',
                  label: 'Layout Test',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Column), findsWidgets);
    });
  });
}
