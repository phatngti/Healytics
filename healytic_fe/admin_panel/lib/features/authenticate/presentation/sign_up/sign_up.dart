import 'package:admin_panel/features/authenticate/presentation/providers/sign_up.provider.dart';
import 'package:admin_panel/features/authenticate/presentation/widgets/logo.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/common/widgets/toast.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
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
          child: Container(
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
                  AdminLogo(),
                  AppDimens.verticalMedium,
                  Text(
                    'Create an account',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                  AppTextField(
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
                    labelStyle: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  AppDimens.verticalLarge,
                  SizedBox(
                    width: double.infinity,
                    height: DeviceUtils.getScreenHeight(context) * 0.07,
                    child: AppButton(
                      buttonType: ButtonType.elevated,
                      onPressed: submit,
                      isLoading: state.isLoading,
                      child: Text(
                        'Continue',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  AppDimens.verticalSmall,
                  SizedBox(
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
