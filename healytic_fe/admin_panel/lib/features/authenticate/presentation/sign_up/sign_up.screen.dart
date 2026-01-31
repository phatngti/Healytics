import 'package:admin_panel/features/authenticate/presentation/providers/sign_up.provider.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/sign_up_email_form.widget.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/common/widgets/toast.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final emailController = useTextEditingController();

    final state = ref.watch(signUpProviderProvider);

    ref.listen(signUpProviderProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ToastContext.showToast(context, ToastType.error, error.toString());
        },
        data: (response) {
          final previousResponse = previous?.value;
          if (response.step == SignupStep.otp &&
              response.emailToken != '' &&
              previousResponse?.step == SignupStep.email) {
            ToastContext.showToast(
              context,
              ToastType.success,
              'Send OTP successfully',
            );
            context.go(EmailCodeVerificationRoute().location);
          }
        },
      );
    });

    Future<void> submit() async {
      if (formKey.currentState?.validate() ?? false) {
        await ref
            .read(signUpProviderProvider.notifier)
            .sendOtp(emailController.text);
      }
    }

    return ResponsiveWrapper(
      desktop: Scaffold(
        body: Center(
          child: SignUpEmailForm(
            formKey: formKey,
            emailController: emailController,
            onSubmit: submit,
            isLoading: state.isLoading,
          ),
        ),
      ),
    );
  }
}
