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

class ForgotPasswordScreen extends HookConsumerWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final emailController = useTextEditingController();
    final isSubmitting = useState(false);
    final submittedEmail = useState<String?>(null);

    useListenable(emailController);

    final hasValidEmail =
        FormValidators.email(emailController.text.trim()) == null;

    Future<void> submit() async {
      final isValid = formKey.currentState?.saveAndValidate() ?? false;
      if (!isValid) {
        AppToast.warning(context, 'Please enter a valid email address.');
        return;
      }

      final email = emailController.text.trim();
      isSubmitting.value = true;
      try {
        await ref
            .read(authenticateRepositoryProvider)
            .requestPasswordReset(email: email);
        submittedEmail.value = email;
        if (context.mounted) {
          AppToast.success(context, 'Password reset email sent.');
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
                        'Reset your password',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        'Enter your account email and we will send you a link '
                        'to reset your password.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                AppDimens.verticalLarge,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'email',
                  label: 'Email',
                  hintText: 'you@example.com',
                  controller: emailController,
                  suffixIcon: const Icon(Icons.email),
                  uppercaseLabel: false,
                  keyboardType: TextInputType.emailAddress,
                  widgetKey: keys.forgotPasswordPage.emailTextField,
                  validator: FormValidators.email,
                  onChanged: (_) {
                    submittedEmail.value = null;
                  },
                ),
                AppDimens.verticalLarge,
                FractionallySizedBox(
                  widthFactor: 0.8,
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      key: keys.forgotPasswordPage.sendResetLinkButton,
                      onPressed: (isSubmitting.value || !hasValidEmail)
                          ? null
                          : submit,
                      buttonType: ButtonType.elevated,
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
                      child: const Text('Send Reset Link'),
                    ),
                  ),
                ),
                if (submittedEmail.value != null) ...[
                  AppDimens.verticalMedium,
                  _ResetEmailSentMessage(email: submittedEmail.value!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetEmailSentMessage extends StatelessWidget {
  const _ResetEmailSentMessage({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, color: colorScheme.primary, size: 20),
        AppDimens.horizontalSmall,
        Expanded(
          child: Text(
            'If $email is registered, a password reset link has been sent.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
