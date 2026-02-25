import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/widgets/toast.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_flow_provider.dart';
import 'package:user_app/router/routes.dart';
import 'package:user_app/utils/device.dart';

class EmailFormScreen extends HookConsumerWidget {
  const EmailFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minBodyHeight = DeviceUtils.getMinBodyHeight(context);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    // Lấy state từ Riverpod (AsyncValue)
    final asyncState = ref.watch(registerFlowProvider);

    ref.listen(registerFlowProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        if (context.mounted) {
          ToastContext.showToast(
            context,
            ToastType.success,
            next.error.toString(),
          );
        }
      }
    });

    // 2. LOGIC LOADING: Kiểm tra xem Riverpod đang load hay Data đang có cờ loading
    final submitLoading = useState(false);

    final emailController = useTextEditingController(
      text:
          (asyncState.hasValue ? asyncState.requireValue.user?.email : null) ??
          '',
    );

    // 1. QUAN TRỌNG: Dùng useListenable để rebuild UI khi user gõ phím
    // Giúp nút Button enable/disable ngay lập tức
    useListenable(emailController);

    // 2. QUAN TRỌNG: Logic sync dữ liệu từ Provider vào Controller (giữ nguyên của bạn)
    // 2. LOGIC SYNC: Removed to prevent resetting value while typing.
    // Initial value is handled by useTextEditingController.
    // useEffect(() {
    //   final newValue =
    //       (asyncState.hasValue ? asyncState.requireValue.user?.email : null) ??
    //       '';
    //   if (emailController.text != newValue) {
    //     emailController.value = emailController.value.copyWith(
    //       text: newValue,
    //       selection: TextSelection.collapsed(offset: newValue.length),
    //     );
    //   }
    //   return null;
    // }, [asyncState.hasValue ? asyncState.requireValue.user?.email : null]);

    Future<void> submit() async {
      if (formKey.currentState?.saveAndValidate() ?? false) {
        FocusScope.of(context).unfocus();

        submitLoading.value = true;
        try {
          final email = emailController.text;
          await ref.read(registerFlowProvider.notifier).sendCode(email);
          if (context.mounted) {
            // Chuyển sang màn OTP
            context.pushReplacementNamed(EmailCodeConfirmationRoute.name);
          }
        } catch (e) {
          debugPrint('Error sending code: $e');
        } finally {
          if (context.mounted) {
            submitLoading.value = false;
          }
        }
      } else {
        debugPrint('Validation failed');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {OnboardingRoute().push(context)},
        ),
        title: Text(
          'Enter your email',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimens.paddingAllMedium,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minBodyHeight),
          child: Container(
            margin: EdgeInsets.only(top: AppDimens.paddingAllSmall.vertical),

            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      right: AppDimens.paddingVerticalLarge.vertical,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Please enter your email address to continue.',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.color
                                    ?.withValues(alpha: 1),
                              ),
                        ),
                        AppDimens.verticalSmall,
                        FormFieldBuilders.buildTextField(
                          context,
                          fieldKey: 'email',
                          label: 'Email',
                          uppercaseLabel: false,
                          suffixIcon: Icon(Icons.email),
                          controller: emailController,
                        ),
                        AppDimens.verticalSmall,
                        Text.rich(
                          TextSpan(
                            text: 'By continuing, you agree to our ',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color
                                      ?.withValues(alpha: 0.7),
                                ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Terms of Service ',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.apply(fontWeightDelta: 2),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    debugPrint('Terms of Service tapped');
                                  },
                              ),
                              TextSpan(
                                text: 'and ',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color
                                          ?.withValues(alpha: 0.7),
                                    ),
                              ),
                              TextSpan(
                                text: 'Privacy Policy.',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.apply(fontWeightDelta: 2),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    debugPrint('Privacy Policy tapped');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  (minBodyHeight * 0.08).verticalSpace,

                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      // 3. Disable nút khi: Email rỗng HOẶC đang Loading
                      onPressed:
                          (emailController.text.isEmpty ||
                              submitLoading.value ||
                              asyncState.isLoading)
                          ? null
                          : submit,
                      buttonType: ButtonType.elevated,
                      customStyle: ElevatedButton.styleFrom(
                        padding: AppDimens.paddingAllMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimens.radiusSmall,
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      isLoading: submitLoading.value,
                      child: const Text('Continue'),
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
