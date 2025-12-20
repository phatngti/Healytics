import 'package:admin_panel/features/authenticate/presentation/providers/sign_up.provider.dart';
import 'package:admin_panel/features/authenticate/presentation/widgets/logo.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
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
import 'package:pinput/pinput.dart';

class EmailCodeVerificationScreen extends HookConsumerWidget {
  const EmailCodeVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final codeController = useTextEditingController();
    final state = ref.watch(signUpProviderProvider);

    ref.listen(signUpProviderProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          if (data.otpToken != '' &&
              data.step == SignupStep.form &&
              previous?.value?.step == SignupStep.otp) {
            ToastContext.showToast(
              context,
              ToastType.success,
              'Verify OTP successfully',
            );
            context.go(SignUpFormRoute().location);
          }
        },
        error: (error, stackTrace) {
          ToastContext.showToast(context, ToastType.error, error.toString());
        },
      );
    });

    Future<void> submit() async {
      if (formKey.currentState!.saveAndValidate()) {
        await ref
            .read(signUpProviderProvider.notifier)
            .verifyOtp(state.value!.emailToken, codeController.text);
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
                    'Check your email',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppDimens.verticalSmall,
                  Text(
                    'We\'ve sent a 5 digits verification code to your email.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w200,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  AppDimens.verticalMedium,
                  // --- PINPUT ---
                  Pinput(
                    controller: codeController,
                    length: 5,
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    // Không cần onChanged để set state nữa vì đã có useListenable
                    inputFormatters: [],
                    preFilledWidget: Text(
                      '-',
                      style: TextStyle(
                        fontSize: 24,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    separatorBuilder: (index) => const SizedBox(width: 16),
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
                        ref.invalidate(signUpProviderProvider);
                        context.go(SignUpRoute().location);
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
                            'Back',
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
