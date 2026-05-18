import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/features/authenticate/presentation/providers/authenticate.provider.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/widgets/toast.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/utils/form_validators.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/router/routes.dart';

final _log = Logger('AuthForm');

/// Login form widget responsible for input
/// validation and triggering authentication.
///
/// Error / success toasts and navigation are
/// handled by the parent screen via
/// `ref.listen(authenticateProvider, ...)`.
class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final isPasswordVisible = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    useListenable(emailController);
    useListenable(passwordController);

    final hasValidInput =
        FormValidators.email(emailController.text.trim()) == null &&
        FormValidators.password(passwordController.text) == null;

    final authState = ref.watch(authenticateProvider);
    final isLoading = authState.isLoading;

    // Derive inline error message from auth state.
    final signInError = useState<String?>(null);

    // Listen for auth errors and update inline message.
    ref.listen(authenticateProvider, (previous, next) {
      final hasCompletedWithError =
          previous?.isLoading == true && next.hasError && !next.isLoading;
      if (hasCompletedWithError) {
        final error = next.error;
        final appEx = AppException.fromError(
          error ?? 'An unknown error occurred',
        );
        signInError.value = _signInErrorMessage(appEx);
      }
    });

    // Clear error when user edits either field.
    void clearError() {
      if (signInError.value != null) {
        signInError.value = null;
      }
    }

    Future<void> signIn() async {
      final isValid = formKey.currentState?.saveAndValidate() ?? false;
      if (!isValid) {
        if (context.mounted) {
          AppToast.warning(context, 'Please fix the highlighted fields.');
        }
        return;
      }

      final formData = formKey.currentState?.value;
      final email = formData?['email'] as String;
      final password = formData?['password'] as String;

      _log.fine('Submitting sign-in for $email');
      await ref
          .read(authenticateProvider.notifier)
          .login(email: email, password: password);
    }

    return FormBuilder(
      key: formKey,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormFieldBuilders.buildTextField(
              context,
              fieldKey: 'email',
              label: 'Email',
              controller: emailController,
              suffixIcon: Icon(Icons.email),
              uppercaseLabel: false,
              widgetKey: keys.signInPage.emailTextField,
              validator: FormValidators.email,
              onChanged: (_) => clearError(),
            ),
            AppDimens.verticalSmall,
            FormFieldBuilders.buildTextField(
              context,
              fieldKey: 'password',
              label: 'Password',
              controller: passwordController,
              obscureText: !isPasswordVisible.value,
              uppercaseLabel: false,
              widgetKey: keys.signInPage.passwordTextField,
              suffixIcon: IconButton(
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
                icon: isPasswordVisible.value
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              validator: FormValidators.password,
              onChanged: (_) => clearError(),
            ),
            // Inline sign-in error message.
            if (signInError.value != null)
              _SignInErrorBanner(message: signInError.value!),
            SizedBox(
              child: AppButton(
                key: keys.signInPage.forgotPasswordButton,
                buttonType: ButtonType.text,
                onPressed: () {
                  context.pushNamed(ForgotPasswordRoute.name);
                },
                customStyle: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  foregroundColor: Theme.of(context).colorScheme.primary,
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(),
                ),
                child: Text('Forgot Password?'),
              ),
            ),
            AppDimens.verticalExtraLarge,
            SizedBox(
              width: double.infinity,
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: AppButton(
                  key: keys.signInPage.signInButton,
                  onPressed: (isLoading || !hasValidInput) ? null : signIn,
                  buttonType: ButtonType.elevated,
                  customStyle: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimens.radiusSmall,
                    ),
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  isLoading: isLoading,
                  child: Text('Sign In'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Inline error banner displayed below form fields
/// when sign-in fails.
class _SignInErrorBanner extends StatelessWidget {
  const _SignInErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 18, color: colorScheme.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Returns a login-context-aware error message from
/// the given [AppException].
String _signInErrorMessage(AppException exception) {
  return switch (exception) {
    ServerException(:final statusCode) => switch (statusCode) {
      401 =>
        'Invalid email or password. '
            'Please try again.',
      404 =>
        'Account not found. '
            'Please check your email.',
      _ => exception.userMessage,
    },
    NetworkException() => exception.userMessage,
    UnexpectedException() => exception.userMessage,
  };
}
