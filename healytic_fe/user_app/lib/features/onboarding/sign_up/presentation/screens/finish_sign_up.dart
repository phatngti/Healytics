import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/widgets/toast.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_flow_provider.dart';
import 'package:user_app/router/routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/utils/device.dart';

class FinishSignUpScreen extends HookConsumerWidget {
  const FinishSignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minBodyHeight = DeviceUtils.getMinBodyHeight(context);
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isFilledAll = useState(false);
    final isSubmitLoading = useState(false);

    // 1. Khởi tạo ScrollController để quản lý việc cuộn
    final scrollController = useScrollController();

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

      if (next.value?.isRegistrationCompleted == true &&
          next.hasValue &&
          !next.isLoading) {
        if (context.mounted) {
          context.pushReplacementNamed(SurveyScreenRoute.name);
        }
      }
      isSubmitLoading.value = false;
    });

    // Hàm kiểm tra xem các field bắt buộc đã có giá trị chưa
    void checkFormFilled() {
      final formState = formKey.currentState;
      if (formState == null) return;

      // 1. Danh sách các trường bắt buộc kiểu chuỗi (Text)
      const requiredTextKeys = [
        'first_name',
        'last_name',
        'password',
        'confirm_password',
        'country',
        'street_address',
        'ward',
        'district',
        'city_or_province',
      ];

      // 2. Helper: Kiểm tra một key text có hợp lệ không (khác null và không rỗng)
      bool isTextValid(String key) {
        final value = formState.fields[key]?.value?.toString().trim();
        return value != null && value.isNotEmpty;
      }

      // 3. Kiểm tra riêng trường Date (Object check)
      final isDobValid = formState.fields['date_of_birth']?.value != null;

      // 4. Tổng hợp kết quả: Date valid VÀ tất cả text keys đều valid
      final isValid = isDobValid && requiredTextKeys.every(isTextValid);

      if (isFilledAll.value != isValid) {
        isFilledAll.value = isValid;
      }
    }

    submit() {
      debugPrint('submit: called');
      isSubmitLoading.value = true;
      if (formKey.currentState?.saveAndValidate() ?? false) {
        debugPrint('submit: form valid');
        final formData = formKey.currentState?.value ?? {};
        // Handle the form submission logic here
        if (formData.isNotEmpty) {
          final firstName = formData['first_name'] as String;
          final lastName = formData['last_name'] as String;
          final dateOfBirth = formData['date_of_birth'] as String? ?? '';
          final email = ref.read(registerFlowProvider).value?.user?.email ?? '';
          final password = formData['password'] as String? ?? '';
          debugPrint('submit: calling completeRegistration');
          ref
              .read(registerFlowProvider.notifier)
              .completeRegistration(
                UserEntity(
                  email: email,
                  password: password,
                  firstName: firstName,
                  lastName: lastName,
                  dateOfBirth: dateOfBirth,
                  address: AddressEntity(
                    street: formData['street_address'],
                    ward: formData['ward'],
                    district: formData['district'],
                    cityOrProvince: formData['city_or_province'],
                  ),
                ),
              );
        }
      } else {
        if (context.mounted) {
          ToastContext.showToast(
            context,
            ToastType.error,
            'Please fill in all the required fields.',
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {OnboardingRoute().push(context)},
        ),
        title: Text(
          'Finish Sign Up',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minBodyHeight),
          child: Container(
            margin: EdgeInsets.only(top: AppDimens.paddingAllSmall.vertical),
            child: FormBuilder(
              key: formKey,
              onChanged: checkFormFilled,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 1.0,
                    children: [
                      Text(
                        'Legal name',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.titleMedium?.color?.withAlpha(700),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      AppDimens.verticalSmall,
                      FormFieldBuilders.buildTextField(
                        context,
                        fieldKey: 'first_name',
                        label: 'First name',
                        uppercaseLabel: false,
                      ),
                      AppDimens.verticalSmall,
                      FormFieldBuilders.buildTextField(
                        context,
                        fieldKey: 'last_name',
                        label: 'Last name',
                        uppercaseLabel: false,
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        'Make sure the matches the name on your government ID. This is required for identity verification.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withAlpha(700),
                        ),
                      ),
                    ],
                  ),
                  AppDimens.verticalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 1.0,
                    children: [
                      Text(
                        'Date of Birth',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.titleMedium?.color?.withAlpha(700),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      AppDimens.verticalSmall,
                      FormFieldBuilders.buildDateField(
                        context,
                        fieldKey: 'date_of_birth',
                        label: 'Select your birthday',
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        'To sign up, you must be at least 16 years. Your birthday won\'t be shared with others.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withAlpha(700),
                        ),
                      ),
                    ],
                  ),
                  AppDimens.verticalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 1.0,
                    children: [
                      Text(
                        'Password',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: Theme.of(
                                context,
                              ).textTheme.titleMedium?.color?.withAlpha(700),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      AppDimens.verticalSmall,
                      FormFieldBuilders.buildTextField(
                        context,
                        fieldKey: 'password',
                        label: 'Password',
                        uppercaseLabel: false,
                        obscureText: true,
                      ),
                      AppDimens.verticalSmall,
                      FormFieldBuilders.buildTextField(
                        context,
                        fieldKey: 'confirm_password',
                        label: 'Confirm Password',
                        uppercaseLabel: false,
                        obscureText: true,
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        'Make sure your password is at least 8 characters long.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(
                            context,
                          ).textTheme.bodySmall?.color?.withAlpha(700),
                        ),
                      ),
                    ],
                  ),
                  AppDimens.verticalLarge,
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      spacing: 1.0,
                      children: [
                        Text(
                          'Address',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.color?.withAlpha(700),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        AppDimens.verticalSmall,
                        FormFieldBuilders.buildTextField(
                          context,
                          fieldKey: 'street_address',
                          label: 'Street Address',
                          uppercaseLabel: false,
                        ),

                        AppDimens.verticalSmall,
                        FormFieldBuilders.buildTextField(
                          context,
                          fieldKey: 'ward',
                          label: 'Ward',
                          uppercaseLabel: false,
                        ),
                        AppDimens.verticalSmall,

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: FormFieldBuilders.buildTextField(
                                context,
                                fieldKey: 'district',
                                label: 'District',
                                uppercaseLabel: false,
                              ),
                            ),
                            AppDimens.horizontalSmall,
                            Expanded(
                              child: FormFieldBuilders.buildTextField(
                                context,
                                fieldKey: 'city_or_province',
                                label: 'City or Province',
                                uppercaseLabel: false,
                              ),
                            ),
                          ],
                        ),
                        AppDimens.verticalSmall,
                        FormFieldBuilders.buildTextField(
                          context,
                          fieldKey: 'country',
                          label: 'Country',
                          uppercaseLabel: false,
                          enabled: false,
                          initialValue: 'Vietnam',
                        ),
                        AppDimens.verticalSmall,
                        Text(
                          'Please provide your correct address for direction purposes.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color?.withAlpha(700),
                              ),
                        ),
                      ],
                    ),
                  ),
                  AppDimens.verticalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 1.0,
                    children: [
                      Text.rich(
                        textAlign: TextAlign.left,
                        TextSpan(
                          text:
                              'By selecting "Agree & Continue", I agree to Healytic',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withAlpha(200),
                              ),
                          children: [
                            TextSpan(
                              text:
                                  'Terms of Service, Payment Terms of Service ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withAlpha(700),
                                    fontWeight: FontWeight.bold,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle Terms of Service tap
                                },
                            ),

                            TextSpan(
                              text: 'and acknowledge the ',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withAlpha(200),
                                  ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy.',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary.withAlpha(700),
                                    fontWeight: FontWeight.bold,
                                  ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  debugPrint('Privacy Policy tapped');
                                },
                            ),
                          ],
                        ),
                      ),

                      AppDimens.verticalMedium,
                      SizedBox(
                        width: double.infinity,

                        child: AppButton(
                          buttonType: ButtonType.elevated,
                          onPressed: isFilledAll.value ? submit : null,
                          isLoading: isSubmitLoading.value,
                          customStyle: ElevatedButton.styleFrom(
                            padding: AppDimens.paddingAllMedium,
                            shape: RoundedRectangleBorder(
                              borderRadius: AppDimens.radiusSmall,
                            ),
                            textStyle: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          child: const Text('Agree & Continue'),
                        ),
                      ),
                    ],
                  ),
                  AppDimens.verticalExtraLarge,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
