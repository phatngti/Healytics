import 'package:admin_panel/features/authenticate/presentation/widgets/logo.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/sign_in.provider.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/button/selector_switch.dart';
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

class SignInScreen extends HookConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roles = [
      SelectorSwitchOption(label: 'Admin', value: 'admin'),
      SelectorSwitchOption(label: 'Provider', value: 'provider'),
    ];
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isPasswordVisible = useState(false);
    final scrollController = useScrollController();
    final signInState = ref.watch(signInProviderProvider);

    ref.listen(signInProviderProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ToastContext.showToast(context, ToastType.error, error.toString());
        },
        data: (response) {
          if (response != null) {
            ToastContext.showToast(context, ToastType.success, 'Login Success');
            // context.go(DashboardRoute().location);
          }
        },
      );
    });

    final roleController = useMemoized(() => SelectorSwitchController());
    useEffect(() => roleController.dispose, [roleController]);

    Future<void> submit() async {
      if (formKey.currentState!.saveAndValidate()) {
        final email = emailController.text;
        final password = passwordController.text;
        final role = roleController.value?.value ?? 'admin';
        await ref
            .read(signInProviderProvider.notifier)
            .signIn(email, password, role);
      }
    }

    return ResponsiveWrapper(
      desktop: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: scrollController,
            child: Container(
              padding: AppDimens.paddingAllMedium,
              width: DeviceUtils.getScreenWidth(context) * 0.3,
              decoration: BoxDecoration(
                borderRadius: AppDimens.radiusMedium,
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AdminLogo(),
                  AppDimens.verticalMedium,
                  Text(
                    'Welcome back',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppDimens.verticalSmall,
                  Text(
                    'Please select your role and enter your details to sign in',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppDimens.verticalSmall,
                  FormBuilder(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectorSwitch(
                          controller: roleController,
                          onChanged: (value) {},
                          options: roles,
                        ),
                        AppDimens.verticalExtraLarge,
                        AppTextField(
                          fieldKey: "email",
                          label: "Email",
                          controller: emailController,
                          suffixIcon: const Icon(Icons.email),
                          labelStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        AppDimens.verticalSmall,
                        AppTextField(
                          fieldKey: "password",
                          label: "Password",
                          controller: passwordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible.value
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              isPasswordVisible.value =
                                  !isPasswordVisible.value;
                            },
                          ),
                          obscureText: !isPasswordVisible.value,
                          labelStyle: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w400,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                        ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.bottomRight,
                          child: AppButton(
                            buttonType: ButtonType.text,
                            onPressed: () {
                              context.pushReplacementNamed(
                                ForgotPasswordRoute.name,
                              );
                            },

                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),

                        AppDimens.verticalLarge,
                        SizedBox(
                          width: double.infinity,
                          height: DeviceUtils.getScreenHeight(context) * 0.07,
                          child: AppButton(
                            buttonType: ButtonType.elevated,
                            onPressed: submit,
                            isLoading: signInState.isLoading,
                            child: Text(
                              'Login',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                            ),
                          ),
                        ),
                        AppDimens.verticalSmall,
                        SizedBox(
                          width: double.infinity,
                          child: AppButton(
                            buttonType: ButtonType.text,
                            onPressed: () {
                              context.go(SignUpRoute().location);
                            },
                            child: Text(
                              'Join as a Provider',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                          ),
                        ),
                      ],
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
