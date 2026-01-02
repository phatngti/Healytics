import 'package:admin_panel/features/common/widgets/button/selector_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelectorSwitchOption', () {
    test('creates option with label and value', () {
      final option = SelectorSwitchOption(label: 'Test Label', value: 'test');

      expect(option.label, equals('Test Label'));
      expect(option.value, equals('test'));
    });
  });

  group('SelectorSwitchController', () {
    test('initializes with default index 0', () {
      final controller = SelectorSwitchController();

      expect(controller.index, equals(0));
    });

    test('initializes with custom initial index', () {
      final controller = SelectorSwitchController(initialIndex: 2);

      expect(controller.index, equals(2));
    });

    test('updates index and notifies listeners', () {
      final controller = SelectorSwitchController();
      bool notified = false;
      controller.addListener(() => notified = true);

      controller.index = 1;

      expect(controller.index, equals(1));
      expect(notified, isTrue);
    });

    test('does not notify when setting same index', () {
      final controller = SelectorSwitchController();
      int notifyCount = 0;
      controller.addListener(() => notifyCount++);

      controller.index = 0; // Same as initial

      expect(notifyCount, equals(0));
    });

    test('setValue updates value and notifies', () {
      final controller = SelectorSwitchController();
      bool notified = false;
      controller.addListener(() => notified = true);

      final option = SelectorSwitchOption(label: 'Test', value: 'test');
      controller.setValue(option);

      expect(controller.value?.label, equals('Test'));
      expect(controller.value?.value, equals('test'));
      expect(notified, isTrue);
    });
  });

  group('SelectorSwitch', () {
    final testOptions = [
      SelectorSwitchOption(label: 'Option 1', value: 'opt1'),
      SelectorSwitchOption(label: 'Option 2', value: 'opt2'),
      SelectorSwitchOption(label: 'Option 3', value: 'opt3'),
    ];

    testWidgets('renders all options', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(options: testOptions, onChanged: (_) {}),
            ),
          ),
        ),
      );

      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);
      expect(find.text('Option 3'), findsOneWidget);
    });

    testWidgets('selects first option by default', (WidgetTester tester) async {
      final controller = SelectorSwitchController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(
                options: testOptions,
                onChanged: (_) {},
                controller: controller,
              ),
            ),
          ),
        ),
      );

      expect(controller.index, equals(0));
      expect(controller.value?.value, equals('opt1'));
    });

    testWidgets('calls onChanged when option is tapped', (
      WidgetTester tester,
    ) async {
      int? changedIndex;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(
                options: testOptions,
                onChanged: (index) => changedIndex = index,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option 2'));
      await tester.pump();

      expect(changedIndex, equals(1));
    });

    testWidgets('updates controller when option is tapped', (
      WidgetTester tester,
    ) async {
      final controller = SelectorSwitchController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(
                options: testOptions,
                onChanged: (_) {},
                controller: controller,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option 3'));
      await tester.pump();

      expect(controller.index, equals(2));
      expect(controller.value?.value, equals('opt3'));
    });

    testWidgets('does not call onChanged when tapping selected option', (
      WidgetTester tester,
    ) async {
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(
                options: testOptions,
                onChanged: (_) => callCount++,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Option 1')); // Already selected
      await tester.pump();

      expect(callCount, equals(0));
    });

    testWidgets('uses custom initial index from controller', (
      WidgetTester tester,
    ) async {
      final controller = SelectorSwitchController(initialIndex: 1);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(
                options: testOptions,
                onChanged: (_) {},
                controller: controller,
              ),
            ),
          ),
        ),
      );

      expect(controller.value?.value, equals('opt2'));
    });

    testWidgets('contains AnimatedContainer for smooth transitions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(options: testOptions, onChanged: (_) {}),
            ),
          ),
        ),
      );

      // Should have AnimatedContainers for each option
      expect(find.byType(AnimatedContainer), findsNWidgets(3));
    });

    testWidgets('disposes controller listener properly', (
      WidgetTester tester,
    ) async {
      final controller = SelectorSwitchController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              child: SelectorSwitch(
                options: testOptions,
                onChanged: (_) {},
                controller: controller,
              ),
            ),
          ),
        ),
      );

      // Pump a different widget to dispose the SelectorSwitch
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: SizedBox())),
      );

      // No exception means successful disposal
    });
  });
}
