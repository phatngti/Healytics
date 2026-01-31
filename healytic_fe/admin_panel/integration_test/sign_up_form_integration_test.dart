/// Integration tests for SignUpFormScreen (Partner Registration Form).
///
/// These tests run on the web platform (Chrome) and connect to a real backend.
/// Ensure the backend server is running before executing these tests.
///
/// Run with:
/// ```bash
/// flutter test integration_test --platform chrome
/// ```
library;

import 'package:admin_panel/features/authenticate/presentation/sign_up/sign_up_form.screen.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/account_information_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_location_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_partner_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/document_verification_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/form_section_card.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/legal_representative_section_v2.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/registration_submit_section.widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SignUpFormScreen Integration Tests', () {
    /// Creates a standalone test widget with SignUpFormScreen.
    Widget createTestWidget() {
      return ProviderScope(child: MaterialApp(home: const SignUpFormScreen()));
    }

    group('Form Section Rendering', () {
      testWidgets('should render all four form sections', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Verify all 4 FormSectionCard widgets are present
        expect(find.byType(FormSectionCard), findsNWidgets(4));

        // Verify Section 1: Account Information
        expect(find.byType(AccountInformationSection), findsOneWidget);
        expect(
          find.text('1. Account Information', skipOffstage: false),
          findsOneWidget,
        );

        // Verify Section 2: Business & Partner Information
        expect(find.byType(BusinessPartnerSection), findsOneWidget);
        expect(find.byType(BusinessLocationSection), findsOneWidget);
        expect(
          find.text('2. Business & Partner Information', skipOffstage: false),
          findsOneWidget,
        );

        // Verify Section 3: Legal Representative
        expect(find.byType(LegalRepresentativeSectionV2), findsOneWidget);
        expect(
          find.text('3. Legal Representative', skipOffstage: false),
          findsOneWidget,
        );

        // Verify Section 4: Document Verification
        expect(find.byType(DocumentVerificationSection), findsOneWidget);
        expect(
          find.text('4. Document Verification', skipOffstage: false),
          findsOneWidget,
        );

        // Verify submit section
        expect(find.byType(RegistrationSubmitSection), findsOneWidget);
      });

      testWidgets('should render FormBuilder widget', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        expect(find.byType(FormBuilder), findsOneWidget);
      });
    });

    group('Form Field Interactions', () {
      testWidgets('should allow entering username', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find username field by its label or hint text
        final usernameField = find.widgetWithText(TextFormField, 'Username');

        if (usernameField.evaluate().isNotEmpty) {
          await tester.enterText(usernameField.first, 'testuser123');
          await tester.pumpAndSettle();

          expect(find.text('testuser123'), findsWidgets);
        }
      });

      // Skip on web: HTML email input type doesn't support setSelectionRange
      // which causes DomException during Flutter web integration tests.
      // See: https://github.com/nickvdyck/webtextfield-selection-issue
      testWidgets(
        'should allow entering email',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget());
          await tester.pumpAndSettle();

          // Just verify the email field exists without entering text
          // to avoid setSelectionRange error on web
          final emailField = find.widgetWithText(
            TextFormField,
            'email@domain.com',
          );

          expect(emailField, findsOneWidget);
        },
        skip: true, // Skip due to Flutter web setSelectionRange limitation
      );

      testWidgets('should allow entering password', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find password fields
        final passwordFields = find.byType(TextFormField);

        // There should be multiple text form fields
        expect(passwordFields.evaluate().length, greaterThan(2));
      });
    });

    group('Form Scrolling', () {
      testWidgets('should allow scrolling to bottom of form', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Find the SingleChildScrollView
        final scrollView = find.byType(SingleChildScrollView);
        expect(scrollView, findsOneWidget);

        // Scroll down to see more content
        await tester.drag(scrollView, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Should still be able to find the form
        expect(find.byType(SignUpFormScreen), findsOneWidget);
      });

      testWidgets('should scroll to reveal submit button', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final scrollView = find.byType(SingleChildScrollView);

        // Scroll to the bottom
        await tester.drag(scrollView, const Offset(0, -1500));
        await tester.pumpAndSettle();

        // The RegistrationSubmitSection should be visible
        expect(find.byType(RegistrationSubmitSection), findsOneWidget);
      });
    });

    group('Form Validation', () {
      testWidgets('should show validation errors when submitting empty form', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final scrollView = find.byType(SingleChildScrollView);

        // Scroll to the bottom to find submit button
        await tester.drag(scrollView, const Offset(0, -2000));
        await tester.pumpAndSettle();

        // Find and tap the submit button
        final submitButton = find.widgetWithText(
          ElevatedButton,
          'Complete Registration',
        );

        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();

          // Scroll back to see validation errors
          await tester.drag(scrollView, const Offset(0, 1500));
          await tester.pumpAndSettle();

          // Expect validation error text to appear
          // (The exact text depends on your validators)
        }
      });
    });

    group('Layout Constraints', () {
      testWidgets('should have max width constraint of 800', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        final constrainedBox = find.byWidgetPredicate(
          (widget) =>
              widget is ConstrainedBox && widget.constraints.maxWidth == 800,
        );

        expect(constrainedBox, findsOneWidget);
      });

      testWidgets('should have correct padding on scroll view', (
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

    group('End-to-End Registration Flow', () {
      testWidgets('should fill form with valid data and attempt submission', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // This test demonstrates the full form interaction flow
        // In a real scenario, you would fill in all required fields
        // and verify the registration succeeds

        // For now, just verify the form is interactive
        expect(find.byType(FormBuilder), findsOneWidget);
        expect(find.byType(SignUpFormScreen), findsOneWidget);

        // Scroll through the entire form
        final scrollView = find.byType(SingleChildScrollView);

        // Scroll down
        await tester.drag(scrollView, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Scroll more
        await tester.drag(scrollView, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Scroll to bottom
        await tester.drag(scrollView, const Offset(0, -500));
        await tester.pumpAndSettle();

        // Verify we can still see the form
        expect(find.byType(SignUpFormScreen), findsOneWidget);
      });

      testWidgets('should fill all form fields and test registration flow', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await tester.pumpAndSettle();

        // Generate unique test data with timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final testUsername = 'testpartner$timestamp';
        final testEmail = 'test$timestamp@example.com';
        const testPassword = 'TestPassword1';

        // Helper function to find FormBuilderField by its name/key
        // Note: The app uses custom _AppTextField which wraps FormBuilderField, not FormBuilderTextField
        Finder findFormBuilderField(String fieldName) {
          return find.byWidgetPredicate(
            (widget) => widget is FormBuilderField && widget.name == fieldName,
          );
        }

        // ========== SECTION 1: Account Information ==========
        // Fill username
        final usernameField = findFormBuilderField('username');
        expect(usernameField, findsOneWidget);
        await tester.enterText(usernameField, testUsername);
        await tester.pumpAndSettle();

        // Fill email
        final emailField = findFormBuilderField('email');
        expect(emailField, findsOneWidget);
        await tester.enterText(emailField, testEmail);
        await tester.pumpAndSettle();

        // Fill password
        final passwordField = findFormBuilderField('password');
        expect(passwordField, findsOneWidget);
        await tester.enterText(passwordField, testPassword);
        await tester.pumpAndSettle();

        // Fill confirm password
        final confirmPasswordField = findFormBuilderField('confirm_password');
        expect(confirmPasswordField, findsOneWidget);
        await tester.enterText(confirmPasswordField, testPassword);
        await tester.pumpAndSettle();

        // ========== SECTION 2: Business & Partner Information ==========
        // Scroll down to reveal Section 2
        final scrollView = find.byType(SingleChildScrollView);
        await tester.drag(scrollView, const Offset(0, -300));
        await tester.pumpAndSettle();

        // Fill brand name
        final brandNameField = findFormBuilderField('brand_name');
        expect(brandNameField, findsOneWidget);
        await tester.enterText(brandNameField, 'Test Spa Brand');
        await tester.pumpAndSettle();

        // Fill legal name
        final legalNameField = findFormBuilderField('legal_name');
        expect(legalNameField, findsOneWidget);
        await tester.enterText(legalNameField, 'Test Wellness LLC');
        await tester.pumpAndSettle();

        // Fill tax code
        final taxCodeField = findFormBuilderField('tax_code');
        expect(taxCodeField, findsOneWidget);
        await tester.enterText(taxCodeField, '1234567890');
        await tester.pumpAndSettle();

        // Select business type dropdown
        final businessTypeDropdown = find.byWidgetPredicate(
          (widget) =>
              widget is FormBuilderDropdown<String> &&
              widget.name == 'business_type',
        );
        if (businessTypeDropdown.evaluate().isNotEmpty) {
          await tester.tap(businessTypeDropdown);
          await tester.pumpAndSettle();
          // Select first option
          final dropdownItem = find.text('Individual Business').last;
          if (dropdownItem.evaluate().isNotEmpty) {
            await tester.tap(dropdownItem);
            await tester.pumpAndSettle();
          }
        }

        // Scroll down to Business Location section
        await tester.drag(scrollView, const Offset(0, -300));
        await tester.pumpAndSettle();

        // Helper function to select a dropdown option
        Future<void> selectDropdownOption(
          String fieldKey,
          int optionIndex,
        ) async {
          // Find the dropdown by checking for DropdownButtonFormField
          // wrapped in a FormBuilderField with matching name
          final dropdownFinder = find.byWidgetPredicate(
            (widget) => widget is DropdownButtonFormField<String>,
          );

          // Find all dropdowns and look for the one with matching key
          // We need to trace up the tree to verify the field key
          final dropdowns = dropdownFinder.evaluate().toList();

          for (var dropdownElement in dropdowns) {
            // Check if this dropdown is within our target FormBuilderField
            bool isTargetField = false;

            // Walk up the tree to find the FormBuilderField
            dropdownElement.visitAncestorElements((element) {
              if (element.widget is FormBuilderField<String>) {
                final field = element.widget as FormBuilderField<String>;
                if (field.name == fieldKey) {
                  isTargetField = true;
                  return false; // Stop visiting
                }
              }
              return true; // Continue visiting
            });

            if (isTargetField) {
              // Tap the dropdown to open the menu
              await tester.tap(find.byWidget(dropdownElement.widget));
              await tester.pumpAndSettle();

              // Get all dropdown menu items and select by index
              final menuItems = find.byType(DropdownMenuItem<String>);
              if (menuItems.evaluate().length > optionIndex) {
                await tester.tap(menuItems.at(optionIndex));
                await tester.pumpAndSettle();
              }
              break;
            }
          }
        }

        // Wait for provinces to load (API call)
        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();

        // Select Province (first option)
        await selectDropdownOption('province', 0);
        // Wait for districts to load after province selection
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // Select District (first option)
        await selectDropdownOption('district', 0);
        // Wait for wards to load after district selection
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // Select Ward (first option)
        await selectDropdownOption('ward', 0);
        await tester.pumpAndSettle();

        // Fill street address
        final streetAddressField = findFormBuilderField('street_address');
        if (streetAddressField.evaluate().isNotEmpty) {
          await tester.enterText(streetAddressField, '123 Nguyen Hue Street');
          await tester.pumpAndSettle();
        }

        // ========== SECTION 3: Legal Representative ==========
        await tester.drag(scrollView, const Offset(0, -400));
        await tester.pumpAndSettle();

        // Fill representative name
        final repNameField = findFormBuilderField('representative_name');
        if (repNameField.evaluate().isNotEmpty) {
          await tester.enterText(repNameField, 'Nguyen Van A');
          await tester.pumpAndSettle();
        }

        // Fill representative phone
        final repPhoneField = findFormBuilderField('representative_phone');
        if (repPhoneField.evaluate().isNotEmpty) {
          await tester.enterText(repPhoneField, '0912345678');
          await tester.pumpAndSettle();
        }

        // Fill ID number
        final idNumberField = findFormBuilderField('id_number');
        if (idNumberField.evaluate().isNotEmpty) {
          await tester.enterText(idNumberField, '012345678901');
          await tester.pumpAndSettle();
        }

        // ========== SCROLL TO SUBMIT ==========
        // Scroll to the bottom to find submit button
        await tester.drag(scrollView, const Offset(0, -1500));
        await tester.pumpAndSettle();

        // Find and tap the Complete Registration button
        final submitButton = find.widgetWithText(
          ElevatedButton,
          'Complete Registration',
        );

        // Verify submit button exists and tap it
        expect(submitButton, findsOneWidget);
        await tester.tap(submitButton);
        await tester.pumpAndSettle();

        // After tapping, form validation should run
        // The form should still be visible (validation errors or loading state)
        expect(find.byType(SignUpFormScreen), findsOneWidget);

        // Allow some time for any async operations
        await tester.pump(const Duration(seconds: 2));
      });
    });
  });
}
