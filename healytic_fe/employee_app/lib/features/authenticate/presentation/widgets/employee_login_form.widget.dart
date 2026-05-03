import 'package:logging/logging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/authenticate.provider.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/widgets/toast.dart';
import '../../../../router/routes.dart';
import 'package:common/utils/demensions.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/keys/integration_test_keys.dart';

final _log = Logger('EmployeeLoginForm');

/// Login form widget for the employee app.
///
/// Email + password, no registration link.
class EmployeeLoginForm extends HookConsumerWidget {
  const EmployeeLoginForm({super.key});

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

    ref.listen(authenticateProvider, (prev, next) {
      _log.fine('Auth state: $next');
      if (next.hasError && !next.isLoading && context.mounted) {
        AppToast.error(
          context,
          'Unable to sign in. '
          'Please check your credentials.',
        );
      }

      isLoading.value = next.isLoading;

      final hasCompletedSignIn =
          prev?.isLoading == true &&
          next.hasValue &&
          !next.isLoading &&
          next.value?.authenticate != null;

      if (hasCompletedSignIn && context.mounted) {
        AppToast.success(context, 'Signed in successfully.');
        const AppointmentsRoute().go(context);
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
      final email = (formData?['email'] as String).trim();
      final password = formData?['password'] as String;
      try {
        await ref
            .read(authenticateProvider.notifier)
            .login(email: email, password: password);
      } catch (_) {
        // The provider owns the error state; the listener above shows feedback.
      }
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
