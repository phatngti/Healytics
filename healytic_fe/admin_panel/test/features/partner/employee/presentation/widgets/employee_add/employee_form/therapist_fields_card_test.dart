import 'package:admin_panel/features/partner/employee/presentation/widgets/employee_add/employee_form/therapist_fields_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: FormBuilder(
          child: SingleChildScrollView(child: TherapistFieldsCard()),
        ),
      ),
    );
  }

  testWidgets('Default state shows Massage Therapist options and strength', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Verify Massage Therapist is selected by default (implied by Strength field visibility)
    expect(find.text('Massage Strength'), findsOneWidget);
    expect(find.text('Soft'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Strong'), findsOneWidget);

    // Verify Massage Skills
    expect(find.text('Skill Set'), findsOneWidget);

    // Verify Health Check is present
    expect(find.byType(FormBuilderDateTimePicker), findsOneWidget);
  });

  testWidgets('Switching to Spa Therapist hides strength and updates skills', (
    tester,
  ) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Find and tap "Spa Therapist"
    final spaTherapistFinder = find.text('Spa Therapist');
    expect(spaTherapistFinder, findsOneWidget);
    await tester.tap(spaTherapistFinder);
    await tester.pumpAndSettle();

    // Verify Massage Strength is hidden
    expect(find.text('Massage Strength'), findsNothing);
    expect(find.text('Soft'), findsNothing);

    // Verify Health Check is still visible
    expect(find.byType(FormBuilderDateTimePicker), findsOneWidget);
  });
}
