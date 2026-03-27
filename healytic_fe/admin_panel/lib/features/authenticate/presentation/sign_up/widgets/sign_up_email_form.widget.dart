import 'package:admin_panel/features/authenticate/presentation/widgets/logo.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

/// A form widget for the initial sign-up step where users enter their email.
///
/// This widget displays the email input form with logo, title, and action buttons.
/// It delegates the form submission and loading state to the parent widget.
class SignUpEmailForm extends StatelessWidget {
  const SignUpEmailForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.onSubmit,
    required this.isLoading,
  });

  /// The form key for form validation.
  final GlobalKey<FormBuilderState> formKey;

  /// Controller for the email text field.
  final TextEditingController emailController;

  /// Callback invoked when the continue button is pressed.
  final VoidCallback onSubmit;

  /// Whether the form is currently submitting.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimens.paddingAllMedium,
      width: DeviceUtils.getScreenWidth(context) * 0.3,
      height: DeviceUtils.getScreenHeight(context) * 0.8,
      decoration: BoxDecoration(
        borderRadius: AppDimens.radiusMedium,
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
          width: 1,
        ),
      ),
      child: FormBuilder(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AdminLogo(),
            AppDimens.verticalMedium,
            Text(
              'Create an account',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppDimens.verticalSmall,
            Text(
              'Enter your email address to continue',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w200,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            AppDimens.verticalMedium,
            FormFieldBuilders.buildTextField(
              context,
              fieldKey: "email",
              label: "Email",
              controller: emailController,
              suffixIcon: const Icon(Icons.email),
              border: OutlineInputBorder(
                borderRadius: AppDimens.radiusSmall,
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalLarge,
            _ContinueButton(onSubmit: onSubmit, isLoading: isLoading),
            AppDimens.verticalSmall,
            _BackToLoginButton(),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({required this.onSubmit, required this.isLoading});

  final VoidCallback onSubmit;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: DeviceUtils.getScreenHeight(context) * 0.07,
      child: AppButton(
        buttonType: ButtonType.elevated,
        onPressed: onSubmit,
        isLoading: isLoading,
        child: Text(
          'Continue',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}

class _BackToLoginButton extends StatelessWidget {
  const _BackToLoginButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: DeviceUtils.getScreenHeight(context) * 0.07,
      child: AppButton(
        buttonType: ButtonType.outline,
        onPressed: () {
          context.go(SignInRoute().location);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.primary,
            ),
            5.horizontalSpace,
            Text(
              'Back to Login',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
