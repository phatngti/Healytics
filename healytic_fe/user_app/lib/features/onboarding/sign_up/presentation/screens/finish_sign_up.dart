import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/toast.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_flow_provider.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/legal_name_section.widget.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/date_of_birth_section.widget.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/password_section.widget.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/address_section.widget.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/widgets/finish_sign_up/terms_and_submit_section.widget.dart';
import 'package:user_app/router/routes.dart';
import 'package:user_app/utils/device.dart';

/// Final step of the sign-up flow where the user provides
/// personal details (name, DOB, password, address) and
/// agrees to the terms before completing registration.
class FinishSignUpScreen extends HookConsumerWidget {
  /// Creates a [FinishSignUpScreen].
  const FinishSignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minBodyHeight =
        DeviceUtils.getMinBodyHeight(context);
    final formKey = useMemoized(
      () => GlobalKey<FormBuilderState>(),
    );
    final isFilledAll = useState(false);
    final isSubmitLoading = useState(false);
    final scrollController = useScrollController();

    ref.listen(registerFlowProvider, (previous, next) {
      _handleRegistrationState(
        context: context,
        next: next,
        isSubmitLoading: isSubmitLoading,
      );
    });

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color:
              Theme.of(context).colorScheme.onSurface,
          onPressed: () =>
              {OnboardingRoute().push(context)},
        ),
        title: Text(
          'Finish Sign Up',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: minBodyHeight,
          ),
          child: Container(
            margin: EdgeInsets.only(
              top: AppDimens.paddingAllSmall.vertical,
            ),
            child: FormBuilder(
              key: formKey,
              onChanged: () => _checkFormFilled(
                formKey: formKey,
                isFilledAll: isFilledAll,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const LegalNameSection(),
                  AppDimens.verticalLarge,
                  const DateOfBirthSection(),
                  AppDimens.verticalLarge,
                  PasswordSection(formKey: formKey),
                  AppDimens.verticalLarge,
                  const AddressSection(),
                  AppDimens.verticalLarge,
                  TermsAndSubmitSection(
                    isEnabled: isFilledAll.value,
                    isLoading: isSubmitLoading.value,
                    onSubmit: () => _submit(
                      context: context,
                      ref: ref,
                      formKey: formKey,
                      isSubmitLoading:
                          isSubmitLoading,
                    ),
                  ),
                  AppDimens.verticalExtraLarge,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Listens for registration state changes and shows
  /// appropriate toasts or navigates on success.
  void _handleRegistrationState({
    required BuildContext context,
    required AsyncValue<RegisterStateData> next,
    required ValueNotifier<bool> isSubmitLoading,
  }) {
    if (next.hasError && !next.isLoading) {
      AppToast.error(
        context,
        'Sign up failed. '
        'Please review your information.',
      );
    }

    if (next.value?.isRegistrationCompleted == true &&
        next.hasValue &&
        !next.isLoading) {
      if (context.mounted) {
        AppToast.success(
          context,
          'Registration completed successfully.',
        );
        context.pushReplacementNamed(
          SurveyScreenRoute.name,
        );
      }
    }
    isSubmitLoading.value = false;
  }

  /// Checks whether all required form fields are filled
  /// and updates [isFilledAll] accordingly.
  void _checkFormFilled({
    required GlobalKey<FormBuilderState> formKey,
    required ValueNotifier<bool> isFilledAll,
  }) {
    final formState = formKey.currentState;
    if (formState == null) return;

    // Use FormBuilder's built-in valid state which runs all field validators
    // (including age, password match, etc.) without forcibly showing errors
    // unless the user has interacted with the field.
    final isValid = formState.isValid;

    if (isFilledAll.value != isValid) {
      isFilledAll.value = isValid;
    }
  }

  /// Validates and submits the sign-up form by calling
  /// [completeRegistration] on the register flow provider.
  void _submit({
    required BuildContext context,
    required WidgetRef ref,
    required GlobalKey<FormBuilderState> formKey,
    required ValueNotifier<bool> isSubmitLoading,
  }) {
    isSubmitLoading.value = true;
    if (formKey.currentState?.saveAndValidate() ??
        false) {
      final formData =
          formKey.currentState?.value ?? {};
      if (formData.isNotEmpty) {
        final dobValue = formData['date_of_birth'];
        String dobString = '';
        if (dobValue is DateTime) {
          dobString = dobValue.toIso8601String();
        } else if (dobValue is String) {
          dobString = dobValue;
        }

        final email = ref
                .read(registerFlowProvider)
                .value
                ?.user
                ?.email ??
            '';
        ref
            .read(registerFlowProvider.notifier)
            .completeRegistration(
              UserEntity(
                email: email,
                password:
                    formData['password'] as String? ?? '',
                firstName:
                    formData['first_name'] as String,
                lastName:
                    formData['last_name'] as String,
                dateOfBirth: dobString,
                address: AddressEntity(
                  street:
                      formData['street_address'],
                  ward: formData['ward'],
                  district: formData['district'],
                  cityOrProvince:
                      formData['city_or_province'],
                ),
              ),
            );
      }
    } else {
      isSubmitLoading.value = false;
      AppToast.warning(
        context,
        'Please complete all required '
        'fields correctly.',
      );
    }
  }
}
