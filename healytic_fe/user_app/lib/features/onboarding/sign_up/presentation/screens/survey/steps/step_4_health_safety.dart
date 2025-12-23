import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/common/button/button.dart';
import 'package:user_app/features/common/indicator/linear_indicator.dart';
import 'package:user_app/features/common/toast.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_flow_provider.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/widgets/survey_field.dart';
import 'package:user_app/router/routes.dart';
import 'package:user_app/utils/demensions.dart';
import 'package:user_app/utils/device.dart';

class HealthSafetyStep extends HookConsumerWidget {
  const HealthSafetyStep({super.key});

  final List<Map<String, dynamic>> questions = const [
    {
      "key": "blood_pressure",
      "question": "12. What is your current blood pressure status?",
      "options": [
        {"value": "normal", "text": "Normal/Stable"},
        {"value": "low", "text": "Low blood pressure"},
        {"value": "high", "text": "High blood pressure"},
        {"value": "unknown", "text": "I don't know"},
      ],
    },
    {
      "key": "women_condition",
      "question": "13. Are you currently in any of these conditions?",
      "options": [
        {"value": "none", "text": "None"},
        {"value": "pregnant", "text": "Pregnant"},
        {"value": "menstruating", "text": "Menstruating"},
        {"value": "postpartum", "text": "Postpartum (< 6 months)"},
      ],
    },
    {
      "key": "injury_history",
      "question": "14. Have you had any surgery/injuries in the last 6 months?",
      "options": [
        {"value": "no", "text": "No"},
        {"value": "healed", "text": "Yes, but fully healed"},
        {"value": "recent", "text": "Recent surgery (< 3 months)"},
        {"value": "open_wound", "text": "Currently have an open wound"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isLoading = useState(false);
    final scrollController = useScrollController();

    ref.listen(registerFlowProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        if (context.mounted) {
          ToastContext.showToast(
            context,
            ToastType.error,
            next.error.toString(),
          );
        }
      }

      if (next.value?.isSurveyCompleted == true &&
          next.hasValue &&
          !next.isLoading) {
        // if (context.mounted) {
        //   // Navigate to the next screen or show success message
        //   SignInRoute().push(context);
        // }
      }
      isLoading.value = false;
    });

    submit() async {
      // Implement your submit logic here
      if (formKey.currentState?.saveAndValidate() ?? false) {
        FocusScope.of(context).unfocus();

        isLoading.value = true;

        await ref
            .read(registerFlowProvider.notifier)
            .updateSurvey(
              "health_safety",
              formKey.currentState!.value.entries.map((q) {
                return SurveyEntity(question: q.key, value: q.value);
              }).toList(),
            );
        await ref.read(registerFlowProvider.notifier).completeSurvey();

        if (context.mounted) {
          context.goNamed(SignInRoute.name);
        }
      }
    }

    // Your implementation here
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {BodyEnergyStepRoute().push(context)},
        ),
        title: Text(
          'Completed your status',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimens.paddingHorizontalMedium,
        controller: scrollController,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: DeviceUtils.getMinBodyHeight(context),
          ),
          child: Container(
            margin: EdgeInsets.only(top: AppDimens.paddingAllSmall.vertical),
            child: FormBuilder(
              key: formKey,
              child: Column(
                children: [
                  AppLinearPercentIndicator(step: 5, maxSteps: 5),
                  AppDimens.verticalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Part 4: Safety & Background Health',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).textTheme.titleLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppDimens.verticalSmall,
                      ...questions.map(
                        (q) => Column(
                          children: [
                            SurveyField(
                              fieldKey: q['key'] as String,
                              label: q['question'] as String,
                              enabled: true,
                              // Truyền thẳng List Map vào, ép kiểu cho an toàn
                              options: (q['options'] as List)
                                  .cast<Map<String, dynamic>>(),

                              // Không cần logic mapping value thủ công nữa
                              // Dropdown tự xử lý việc chọn Text -> lưu Value
                            ),
                            AppDimens.verticalMedium,
                          ],
                        ),
                      ),
                    ],
                  ),
                  AppDimens.verticalExtraLarge,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      // 3. Disable nút khi: Email rỗng HOẶC đang Loading
                      onPressed: submit,
                      buttonType: ButtonType.elevated,
                      customStyle: ElevatedButton.styleFrom(
                        padding: AppDimens.paddingAllMedium,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppDimens.radiusSmall,
                        ),
                        textStyle: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      isLoading: isLoading.value,
                      child: const Text('Finish'),
                    ),
                  ),
                  AppDimens.verticalLarge,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
