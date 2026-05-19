import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/core/utils/form_validators.dart';
import 'package:user_app/features/authenticate/data/repositories/authenticate_repository_impl.dart';
import 'package:user_app/router/routes.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  const ResetPasswordScreen({super.key, required this.token});

  final String? token;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final isConfirmPasswordVisible = useState(false);
    final isSubmitting = useState(false);
    final hasResetPassword = useState(false);

    useListenable(passwordController);
    useListenable(confirmPasswordController);

    final hasValidInput =
        FormValidators.password(passwordController.text) == null &&
        FormValidators.confirmPassword(
              confirmPasswordController.text,
              password: passwordController.text,
            ) ==
            null;
    final hasToken = token != null && token!.trim().isNotEmpty;

    Future<void> submit() async {
      if (!hasToken) {
        AppToast.error(
          context,
          'Password reset session is invalid or expired.',
        );
        return;
      }

      final isValid = formKey.currentState?.saveAndValidate() ?? false;
      if (!isValid) {
        AppToast.warning(context, 'Please fix the highlighted fields.');
        return;
      }

      isSubmitting.value = true;
      try {
        await ref
            .read(authenticateRepositoryProvider)
            .resetPassword(
              token: token!.trim(),
              password: passwordController.text.trim(),
            );
        hasResetPassword.value = true;
        if (context.mounted) {
          AppToast.success(context, 'Password reset successfully.');
        }
      } catch (error) {
        final message = AppException.fromError(error).userMessage;
        if (context.mounted) {
          AppToast.error(context, message);
        }
      } finally {
        isSubmitting.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () {
            context.pushReplacementNamed(SignInRoute.name);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppDimens.paddingAllMedium,
          child: FormBuilder(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/signin_image.png',
                        height: 150,
                      ),
                      AppDimens.verticalMedium,
                      Text(
                        'Create new password',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        'Choose a new password for your Healytics account.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                AppDimens.verticalLarge,
                if (!hasToken)
                  _ResetPasswordMessage(
                    icon: Icons.error_outline,
                    message: 'Password reset session is invalid or expired.',
                    color: Theme.of(context).colorScheme.error,
                  )
                else if (hasResetPassword.value)
                  _ResetPasswordMessage(
                    icon: Icons.check_circle_outline,
                    message:
                        'Your password has been reset. You can sign in now.',
                    color: Theme.of(context).colorScheme.primary,
                  )
                else ...[
                  FormFieldBuilders.buildTextField(
                    context,
                    fieldKey: 'password',
                    label: 'New Password',
                    controller: passwordController,
                    obscureText: !isPasswordVisible.value,
                    uppercaseLabel: false,
                    widgetKey: keys.resetPasswordPage.passwordTextField,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isPasswordVisible.value = !isPasswordVisible.value;
                      },
                      icon: Icon(
                        isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: FormValidators.password,
                  ),
                  AppDimens.verticalSmall,
                  FormFieldBuilders.buildTextField(
                    context,
                    fieldKey: 'confirm_password',
                    label: 'Confirm Password',
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible.value,
                    uppercaseLabel: false,
                    widgetKey: keys.resetPasswordPage.confirmPasswordTextField,
                    suffixIcon: IconButton(
                      onPressed: () {
                        isConfirmPasswordVisible.value =
                            !isConfirmPasswordVisible.value;
                      },
                      icon: Icon(
                        isConfirmPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                    ),
                    validator: (value) => FormValidators.confirmPassword(
                      value,
                      password: passwordController.text,
                    ),
                  ),
                  AppDimens.verticalMedium,
                  Text(
                    'Use at least 8 characters with a lowercase letter and a number.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                AppDimens.verticalLarge,
                FractionallySizedBox(
                  widthFactor: 0.8,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      key: keys.resetPasswordPage.submitButton,
                      onPressed: hasResetPassword.value
                          ? () {
                              context.pushReplacementNamed(SignInRoute.name);
                            }
                          : (isSubmitting.value || !hasValidInput || !hasToken)
                          ? null
                          : submit,
                      buttonType: hasResetPassword.value
                          ? ButtonType.outline
                          : ButtonType.elevated,
                      customStyle: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimens.radiusSmall,
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      isLoading: isSubmitting.value,
                      child: Text(
                        hasResetPassword.value
                            ? 'Back to Sign In'
                            : 'Reset Password',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetPasswordMessage extends StatelessWidget {
  const _ResetPasswordMessage({
    required this.icon,
    required this.message,
    required this.color,
  });

  final IconData icon;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 20),
        AppDimens.horizontalSmall,
        Expanded(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
