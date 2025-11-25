import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/authenticate/presentation/provider/authenticate.provider.dart';
import 'package:user_app/features/common/button/button.dart';
import 'package:user_app/features/common/field/text_field.dart';
import 'package:user_app/features/common/toast.dart';
import 'package:user_app/router/routes.dart';
import 'package:user_app/utils/demensions.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());

    final isLoading = useState(false);
    final isPasswordVisible = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    ref.listen(authenticateProvider, (previous, next) {
      print('next: ${next}');
      if (next.hasError && !next.isLoading) {
        if (context.mounted) {
          ToastContext.showToast(
            context,
            ToastType.error,
            next.error.toString(),
          );
        }
      }

      isLoading.value = false;

      if (next.hasValue && !next.isLoading) {
        if (next.value?.authenticate != null) {
          if (context.mounted) {
            context.pushReplacementNamed(HomeRoute.name);
          }
        }
      }
    });

    Future<void> signIn() async {
      isLoading.value = true;
      if (formKey.currentState?.saveAndValidate() ?? false) {
        final formData = formKey.currentState?.value;

        final email = formData?['email'] as String;
        final password = formData?['password'] as String;

        await ref
            .read(authenticateProvider.notifier)
            .login(email: email, password: password);
      } else {
        debugPrint('Validation failed');
      }
    }

    return FormBuilder(
      key: formKey,
      child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              fieldKey: 'email',
              label: 'Email',
              controller: emailController,
              suffixIcon: Icon(Icons.email),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email address';
                }
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                if (!emailRegex.hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            AppDimens.verticalSmall,
            AppTextField(
              fieldKey: 'password',
              label: 'Password',
              controller: passwordController,
              obscureText: !isPasswordVisible.value,
              suffixIcon: IconButton(
                onPressed: () {
                  isPasswordVisible.value = !isPasswordVisible.value;
                },
                icon: isPasswordVisible.value
                    ? Icon(Icons.visibility_off)
                    : Icon(Icons.visibility),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
              // formKey: formKey,
            ),
            // AppDimens.verticalSmall,
            SizedBox(
              child: AppButton(
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
                  onPressed: isLoading.value ? null : signIn,
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
