import 'package:admin_panel/features/authenticate/domain/authenticate.entity.dart';
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

class SignUpFormScreen extends HookConsumerWidget {
  const SignUpFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final scrollController = useScrollController();

    final state = ref.watch(signUpProviderProvider);

    ref.listen(signUpProviderProvider, (previous, next) {
      next.whenOrNull(
        data: (data) {
          if (data.step == SignupStep.form) {
            ToastContext.showToast(
              context,
              ToastType.success,
              'Register successfully',
            );
            context.go(SignInRoute().location);
          }
        },
        error: (error, stackTrace) {
          ToastContext.showToast(context, ToastType.error, error.toString());
        },
      );
    });

    Future<void> submit() async {
      if (formKey.currentState!.saveAndValidate()) {
        ref
            .read(signUpProviderProvider.notifier)
            .signUp(
              state.value!.otpToken,
              SignUpRequestEntity(
                password: formKey.currentState!.value['password'],
                bussinessName: formKey.currentState!.value['business_name'],
                contractPersonName:
                    formKey.currentState!.value['contract_person_name'],
                bussinessEmail: formKey.currentState!.value['bussiness_email'],
                bussinessPhone: formKey.currentState!.value['bussiness_phone'],
                address: formKey.currentState!.value['address'],
              ),
            );
      }
    }

    return ResponsiveWrapper(
      desktop: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            child: Container(
              margin: AppDimens.paddingAllMedium,
              width: DeviceUtils.getScreenWidth(context) * 0.5,
              padding: AppDimens.paddingAllMedium,

              decoration: BoxDecoration(
                borderRadius: AppDimens.radiusSmall,
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
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
                  children: [
                    AdminLogo(),
                    AppDimens.verticalMedium,
                    Text(
                      'Register your account',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AppDimens.verticalSmall,
                    Text(
                      'Join as a Provider Partner and manage your business on our platform',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w200,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppDimens.verticalMedium,
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            fieldKey: 'business_name',
                            label: 'Business Name',
                            hintText: 'Serenity Spa & Wellness',
                          ),
                        ),
                        AppDimens.horizontalSmall,
                        Expanded(
                          child: AppTextField(
                            fieldKey: 'contract_person_name',
                            label: 'Contract Person Name',
                            hintText: 'Serenity Spa & Wellness',
                          ),
                        ),
                      ],
                    ),
                    AppDimens.verticalMedium,
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            fieldKey: 'bussiness_email',
                            label: 'Business Email',
                            hintText: 'contract@serenityspa.com',
                          ),
                        ),
                        AppDimens.horizontalSmall,
                        Expanded(
                          child: AppTextField(
                            fieldKey: 'bussiness_phone',
                            label: 'Business Phone',
                            hintText: '(84) 0123456789',
                          ),
                        ),
                      ],
                    ),
                    AppDimens.verticalMedium,
                    Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            fieldKey: 'password',
                            label: 'Password',
                            hintText: '********',
                            obscureText: true,
                            suffixIcon: const Icon(Icons.visibility_off),
                          ),
                        ),
                        AppDimens.horizontalSmall,
                        Expanded(
                          child: AppTextField(
                            fieldKey: 'confirm_password',
                            label: 'Confirm Password',
                            hintText: '********',
                            obscureText: true,
                            suffixIcon: const Icon(Icons.visibility_off),
                          ),
                        ),
                      ],
                    ),
                    AppDimens.verticalMedium,
                    AppTextField(
                      fieldKey: 'address',
                      label: 'Address',
                      hintText: '123 Main St',
                    ),
                    AppDimens.verticalMedium,
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onPressed: submit,
                          buttonType: ButtonType.elevated,
                          isLoading: state.isLoading,
                          child: Text(
                            'Register business',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    AppDimens.verticalSmall,
                    Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: double.infinity,
                        child: AppButton(
                          onPressed: () {
                            context.go(SignInRoute().location);
                          },
                          buttonType: ButtonType.outline,
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
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
