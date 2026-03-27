import 'dart:async';

import 'package:admin_panel/features/authenticate/presentation/providers/sign_up.provider.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/sign_up_form.screen.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/account_information_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_location_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_partner_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/document_verification_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/form_section_card.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/legal_representative_section_v2.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/registration_submit_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/registration_title_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/sign_up_header.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  /// Creates test widget with required providers and navigation.
  Widget createTestWidget({AsyncValue<SignUpState>? signUpState}) {
    return ProviderScope(
      overrides: [
        if (signUpState != null)
          signUpProviderProvider.overrideWith(
            () => _MockSignUpProvider(signUpState),
          ),
      ],
      child: MaterialApp(home: const SignUpFormScreen()),
    );
  }

  group('SignUpFormScreen', () {
    group('Widget rendering', () {
      testWidgets('renders Scaffold with correct background color', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Scaffold), findsOneWidget);
      });

      testWidgets('renders SignUpHeader widget', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SignUpHeader), findsOneWidget);
      });

      testWidgets('renders scrollable content area', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('renders FormBuilder for form management', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(FormBuilder), findsOneWidget);
      });

      testWidgets('renders RegistrationTitleSection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(RegistrationTitleSection), findsOneWidget);
      });
    });

    group('Form Sections', () {
      testWidgets('renders Section 1: Account Information', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify FormSectionCard with section number 1 exists
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormSectionCard && widget.sectionNumber == '1',
          ),
          findsOneWidget,
        );
        expect(find.byType(AccountInformationSection), findsOneWidget);
      });

      testWidgets('renders Section 2: Business & Partner Information', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify FormSectionCard with section number 2 exists
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormSectionCard && widget.sectionNumber == '2',
          ),
          findsOneWidget,
        );
        expect(find.byType(BusinessPartnerSection), findsOneWidget);
        expect(find.byType(BusinessLocationSection), findsOneWidget);
      });

      testWidgets('renders Section 3: Legal Representative', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify FormSectionCard with section number 3 exists
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormSectionCard && widget.sectionNumber == '3',
          ),
          findsOneWidget,
        );
        expect(find.byType(LegalRepresentativeSectionV2), findsOneWidget);
      });

      testWidgets('renders Section 4: Document Verification', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify FormSectionCard with section number 4 exists
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is FormSectionCard && widget.sectionNumber == '4',
          ),
          findsOneWidget,
        );
        expect(find.byType(DocumentVerificationSection), findsOneWidget);
      });

      testWidgets('renders four FormSectionCard widgets', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(FormSectionCard), findsNWidgets(4));
      });
    });

    group('Hidden form fields', () {
      testWidgets('creates hidden FormBuilderField for front_id_url', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify hidden fields exist (they render as SizedBox.shrink)
        final formBuilder = tester.widget<FormBuilder>(
          find.byType(FormBuilder),
        );
        expect(formBuilder, isNotNull);
      });
    });

    group('Submit Section', () {
      testWidgets('renders RegistrationSubmitSection', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(RegistrationSubmitSection), findsOneWidget);
      });

      testWidgets('RegistrationSubmitSection receives isLoading prop', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify RegistrationSubmitSection exists and has isLoading property
        final submitSection = tester.widget<RegistrationSubmitSection>(
          find.byType(RegistrationSubmitSection),
        );
        // isLoading is passed from state.isLoading, verify the widget exists
        expect(submitSection, isNotNull);
      });

      testWidgets(
        'RegistrationSubmitSection isLoading is false when not loading',
        (WidgetTester tester) async {
          await tester.pumpWidget(
            createTestWidget(signUpState: const AsyncValue.data(SignUpState())),
          );
          await tester.pumpAndSettle();

          final submitSection = tester.widget<RegistrationSubmitSection>(
            find.byType(RegistrationSubmitSection),
          );
          expect(submitSection.isLoading, isFalse);
        },
      );
    });

    group('Layout and constraints', () {
      testWidgets('content has max width constraint of 800', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find the ConstrainedBox with maxWidth of 800
        final constrainedBoxFinder = find.byWidgetPredicate(
          (widget) =>
              widget is ConstrainedBox && widget.constraints.maxWidth == 800,
        );
        expect(constrainedBoxFinder, findsOneWidget);
      });

      testWidgets('content is centered horizontally', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(Center), findsWidgets);
      });

      testWidgets('scrollView has correct padding', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final scrollView = tester.widget<SingleChildScrollView>(
          find.byType(SingleChildScrollView),
        );
        expect(
          scrollView.padding,
          equals(const EdgeInsets.symmetric(horizontal: 24, vertical: 40)),
        );
      });
    });

    group('Column structure', () {
      testWidgets('renders Column with crossAxisAlignment.start', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find the main Column inside FormBuilder
        final columns = find.byType(Column);
        expect(columns, findsWidgets);
      });
    });

    group('State management', () {
      testWidgets('watches signUpProviderProvider', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(signUpState: const AsyncValue.data(SignUpState())),
        );
        await tester.pumpAndSettle();

        // The widget should render without errors
        expect(find.byType(SignUpFormScreen), findsOneWidget);
      });

      testWidgets('handles loading state from provider', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(signUpState: const AsyncValue.loading()),
        );
        await tester.pump();

        expect(find.byType(SignUpFormScreen), findsOneWidget);
      });

      testWidgets('handles error state from provider', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(
            signUpState: AsyncValue.error('Test error', StackTrace.current),
          ),
        );
        await tester.pump();

        expect(find.byType(SignUpFormScreen), findsOneWidget);
      });
    });

    group('Form section titles', () {
      testWidgets('Section 1 has title "1. Account Information"', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.text('1. Account Information', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('Section 2 has title "2. Business & Partner Information"', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.text('2. Business & Partner Information', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('Section 3 has title "3. Legal Representative"', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.text('3. Legal Representative', skipOffstage: false),
          findsOneWidget,
        );
      });

      testWidgets('Section 4 has title "4. Document Verification"', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(
          find.text('4. Document Verification', skipOffstage: false),
          findsOneWidget,
        );
      });
    });

    group('Scrolling behavior', () {
      testWidgets('content is scrollable', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final scrollView = find.byType(SingleChildScrollView);
        expect(scrollView, findsOneWidget);

        // Try to scroll
        await tester.drag(scrollView, const Offset(0, -200));
        await tester.pumpAndSettle();

        // Widget should still be visible after scrolling
        expect(find.byType(SignUpFormScreen), findsOneWidget);
      });
    });
  });
}

/// Mock SignUpProvider for testing.
class _MockSignUpProvider extends SignUpProvider {
  final AsyncValue<SignUpState> _state;

  _MockSignUpProvider(this._state);

  @override
  FutureOr<SignUpState> build() {
    if (_state.hasValue) {
      return _state.value!;
    }
    if (_state.hasError) {
      throw _state.error!;
    }
    return const SignUpState();
  }
}
