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
import 'package:user_app/router/routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/core/utils/form_validators.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

final _log = Logger('AuthForm');

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final isLoading = useState(false);
    final isPasswordVisible = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    useListenable(emailController);
    useListenable(passwordController);

    final hasValidInput =
        FormValidators.email(emailController.text.trim()) == null &&
        FormValidators.password(passwordController.text) == null;

    ref.listen(authenticateProvider, (previous, next) {
      _log.fine('Auth state: $next');
      if (next.hasError && !next.isLoading && context.mounted) {
        final error = next.error;
        final appEx = AppException.fromError(
          error ?? 'An unknown error occurred',
        );
        _showSignInError(context, appEx);
      }

      isLoading.value = next.isLoading;

      final hasCompletedSignIn =
          previous?.isLoading == true &&
          next.hasValue &&
          !next.isLoading &&
          next.value?.authenticate != null;

      if (hasCompletedSignIn && context.mounted) {
        AppToast.success(context, 'Signed in successfully.');
        context.pushReplacementNamed(HomeRoute.name);
      }
    });

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
            ),
            // AppDimens.verticalSmall,
            SizedBox(
              child: AppButton(
                key: keys.signInPage.forgotPasswordButton,
                buttonType: ButtonType.text,
                onPressed: () {
                  // Handle forgot password action
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
                  onPressed: (isLoading.value || !hasValidInput)
                      ? null
                      : signIn,
                  buttonType: ButtonType.elevated,
                  customStyle: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    // Changed maximumSize to minimumSize to force expansion
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppDimens.radiusSmall,
                    ),
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  isLoading: isLoading.value,
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

/// Shows the appropriate [AppToast] based on the
/// [AppException] subtype and HTTP status code.
///
/// - 401/403 → [AppToast.warning] (auth issue).
/// - 5xx / network → [AppToast.error] (server issue).
/// - Other → [AppToast.error] (generic).
void _showSignInError(BuildContext context, AppException exception) {
  switch (exception) {
    case ServerException(:final statusCode):
      if (statusCode == 401 || statusCode == 403) {
        AppToast.warning(context, exception.userMessage);
      } else {
        AppToast.error(context, exception.userMessage);
      }
    case NetworkException():
      AppToast.error(context, exception.userMessage);
    case UnexpectedException():
      AppToast.error(context, exception.userMessage);
  }
}
