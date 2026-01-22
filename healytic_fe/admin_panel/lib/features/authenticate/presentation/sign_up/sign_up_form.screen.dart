import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/sign_up.provider.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/account_security_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/business_entity_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/form_section_card.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/legal_representative_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/location_section.widget.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/sign_up_header.widget.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/common/widgets/toast.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Partner Registration Form Screen.
///
/// A comprehensive multi-section form for business partner registration.
/// Sections include:
/// - Business Entity (Step 1)
/// - Location (Step 2)
/// - Legal Representative (Step 3)
/// - Account Security
class SignUpFormScreen extends HookConsumerWidget {
  const SignUpFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final scrollController = useScrollController();

    final state = ref.watch(signUpProviderProvider);

    // Listen for state changes
    ref.listen(signUpProviderProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          if (data.step == SignupStep.form &&
              previous?.value?.step == SignupStep.form) {
            ToastContext.showToast(
              context,
              ToastType.success,
              'Registration successful! Please sign in.',
            );
            context.go(const SignInRoute().location);
          }
        },
        error: (error, stackTrace) {
          ToastContext.showToast(context, ToastType.error, error.toString());
        },
      );
    });

    Future<void> submit() async {
      if (formKey.currentState!.saveAndValidate()) {
        final values = formKey.currentState!.value;

        final request = SignUpRequestEntity(
          // Business Entity
          companyName: values['company_name'] ?? '',
          taxRegistrationCode: values['tax_registration_code'] ?? '',
          businessEmail: values['business_email'] ?? '',
          businessPhone: values['business_phone'] ?? '',
          serviceCategories: List<String>.from(
            values['service_categories'] ?? [],
          ),

          // Location
          country: values['country'] ?? '',
          city: values['city'] ?? '',
          district: values['district'] ?? '',
          detailedAddress: values['detailed_address'] ?? '',

          // Legal Representative
          representativeName: values['representative_name'] ?? '',
          governmentIdNumber: values['government_id_number'] ?? '',
          // TODO: Add file upload URLs

          // Account Security
          password: values['password'] ?? '',
        );

        await ref
            .read(signUpProviderProvider.notifier)
            .signUp(state.value!.otpToken, request);
      }
    }

    return ResponsiveWrapper(
      desktop: _DesktopLayout(
        formKey: formKey,
        scrollController: scrollController,
        state: state,
        onSubmit: submit,
      ),
      mobile: _MobileLayout(
        formKey: formKey,
        scrollController: scrollController,
        state: state,
        onSubmit: submit,
      ),
    );
  }
}

/// Desktop layout for Partner Registration form.
class _DesktopLayout extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final ScrollController scrollController;
  final AsyncValue<SignUpState> state;
  final VoidCallback onSubmit;

  const _DesktopLayout({
    required this.formKey,
    required this.scrollController,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Sticky header
          const SignUpHeader(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: FormBuilder(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title section
                        _buildTitleSection(context, textTheme, colorScheme),
                        AppDimens.verticalExtraLarge,

                        // Business Entity Section (Step 1)
                        FormSectionCard(
                          title: 'Business Entity',
                          stepInfo: 'Step 1 of 3',
                          child: const BusinessEntitySection(),
                        ),
                        AppDimens.verticalLarge,

                        // Location Section (Step 2)
                        FormSectionCard(
                          title: 'Location',
                          stepInfo: 'Step 2 of 3',
                          child: const LocationSection(),
                        ),
                        AppDimens.verticalLarge,

                        // Legal Representative Section (Step 3)
                        FormSectionCard(
                          title: 'Legal Representative',
                          stepInfo: 'Step 3 of 3',
                          child: const LegalRepresentativeSection(),
                        ),
                        AppDimens.verticalLarge,

                        // Account Security Section
                        FormSectionCard(
                          title: 'Account Security',
                          child: const AccountSecuritySection(),
                        ),
                        AppDimens.verticalLarge,

                        // Submit section
                        _buildSubmitSection(
                          context,
                          textTheme,
                          colorScheme,
                          state,
                          onSubmit,
                        ),
                        AppDimens.verticalExtraLarge,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Registration',
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        AppDimens.verticalSmall,
        Text(
          'Complete the details below to register your spa business. '
          'Ensure all legal documents are ready for verification.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitSection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AsyncValue<SignUpState> state,
    VoidCallback onSubmit,
  ) {
    return Column(
      children: [
        // Submit button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: AppButton(
            onPressed: onSubmit,
            buttonType: ButtonType.elevated,
            isLoading: state.isLoading,
            child: Text(
              'Complete Registration',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        AppDimens.verticalMedium,

        // Terms and conditions
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            children: [
              const TextSpan(text: 'By registering, you agree to our '),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to Terms of Service
                  },
                  child: Text(
                    'Terms of Service',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const TextSpan(text: ' and '),
              WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: GestureDetector(
                  onTap: () {
                    // TODO: Navigate to Privacy Policy
                  },
                  child: Text(
                    'Privacy Policy',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const TextSpan(text: '.'),
            ],
          ),
        ),
      ],
    );
  }
}

/// Mobile layout for Partner Registration form.
///
/// Uses the same structure as desktop but with adjusted padding.
class _MobileLayout extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final ScrollController scrollController;
  final AsyncValue<SignUpState> state;
  final VoidCallback onSubmit;

  const _MobileLayout({
    required this.formKey,
    required this.scrollController,
    required this.state,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Column(
        children: [
          // Sticky header
          const SignUpHeader(),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: FormBuilder(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title section
                    _buildTitleSection(context, textTheme, colorScheme),
                    AppDimens.verticalLarge,

                    // Business Entity Section (Step 1)
                    FormSectionCard(
                      title: 'Business Entity',
                      stepInfo: 'Step 1 of 3',
                      child: BusinessEntitySection(
                        availableServices: {
                          'beauty_care': 'Beauty Care',
                          'hair_care': 'Hair Care',
                          'wellness': 'Wellness Programs',
                          'massage': 'Massage',
                          'spa': 'Spa',
                          'beauty_salon': 'Beauty Salon',
                          'beauty_clinic': 'Beauty Clinic',
                          'beauty_bar': 'Beauty Bar',
                          'beauty_studio': 'Beauty Studio',
                          'beauty_center': 'Beauty Center',
                          'beauty_club': 'Beauty Club',
                        },
                      ),
                    ),
                    AppDimens.verticalMedium,

                    // Location Section (Step 2)
                    FormSectionCard(
                      title: 'Location',
                      child: const LocationSection(),
                    ),
                    AppDimens.verticalMedium,

                    // Legal Representative Section (Step 3)
                    FormSectionCard(
                      title: 'Legal Representative',
                      child: const LegalRepresentativeSection(),
                    ),
                    AppDimens.verticalMedium,

                    // Account Security Section
                    FormSectionCard(
                      title: 'Account Security',
                      child: const AccountSecuritySection(),
                    ),
                    AppDimens.verticalMedium,

                    // Submit section
                    _buildSubmitSection(
                      context,
                      textTheme,
                      colorScheme,
                      state,
                      onSubmit,
                    ),
                    AppDimens.verticalLarge,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Partner Registration',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: colorScheme.onSurface,
          ),
        ),
        AppDimens.verticalSmall,
        Text(
          'Complete the details below to register your spa business.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitSection(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
    AsyncValue<SignUpState> state,
    VoidCallback onSubmit,
  ) {
    return Column(
      children: [
        // Submit button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: AppButton(
            onPressed: onSubmit,
            buttonType: ButtonType.elevated,
            isLoading: state.isLoading,
            child: Text(
              'Complete Registration',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        AppDimens.verticalMedium,

        // Terms and conditions
        Text(
          'By registering, you agree to our Terms of Service and Privacy Policy.',
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
