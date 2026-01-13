import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FormFieldBuilders.buildMultiSelectChipField', () {
    final availableOptions = {
      'Option 1': 'Option 1',
      'Option 2': 'Option 2',
      'Option 3': 'Option 3',
      'Option 4': 'Option 4',
    };

    testWidgets('renders with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'test_field',
                      label: 'Select Tags',
                      availableOptions: availableOptions,
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Select Tags'), findsOneWidget);
    });

    testWidgets('shows search hint', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'search_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                      searchHint: 'Type to search...',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Type to search...'), findsOneWidget);
    });

    testWidgets('renders initial values as chips', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'initial_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                      initialValue: ['Option 1', 'Option 2'],
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
    });

    testWidgets('shows helper text when provided', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'helper_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                      helperText: 'Select multiple tags',
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Select multiple tags'), findsOneWidget);
    });

    testWidgets('chip has close icon for removal', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'chip_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                      initialValue: ['Option 1'],
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('removes chip when close icon is tapped', (
      WidgetTester tester,
    ) async {
      List<String>? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'remove_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                      initialValue: ['Option 1', 'Option 2'],
                      onChanged: (value) => changedValue = value,
                    ),
              ),
            ),
          ),
        ),
      );

      // Tap the close icon on Option 1
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(changedValue, isNotNull);
      expect(changedValue!.length, equals(1));
      expect(changedValue!.contains('Option 1'), isFalse);
    });

    testWidgets('filters options when searching', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'filter_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                    ),
              ),
            ),
          ),
        ),
      );

      // Enter search text
      await tester.enterText(find.byType(TextField), 'Option 1');
      await tester.pump();

      // Should show filtered options
      expect(find.text('Option 1'), findsWidgets);
    });

    testWidgets('contains TextField for search input', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'textfield_test',
                      label: 'Tags',
                      availableOptions: availableOptions,
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('calls onChanged when selection changes', (
      WidgetTester tester,
    ) async {
      List<String>? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'onChange_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                      initialValue: ['Option 1'],
                      onChanged: (value) => changedValue = value,
                    ),
              ),
            ),
          ),
        ),
      );

      // Remove an item
      await tester.tap(find.byIcon(Icons.close).first);
      await tester.pump();

      expect(changedValue, isNotNull);
    });

    testWidgets('uses Wrap for chip layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FormBuilder(
              child: Builder(
                builder: (context) =>
                    FormFieldBuilders.buildMultiSelectChipField(
                      context,
                      fieldKey: 'wrap_field',
                      label: 'Tags',
                      availableOptions: availableOptions,
                      initialValue: ['Option 1', 'Option 2'],
                    ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Wrap), findsWidgets);
    });
  });
}
