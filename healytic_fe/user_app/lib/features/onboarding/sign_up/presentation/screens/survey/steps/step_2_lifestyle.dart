import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/linear_indicator.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/register_flow_provider.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/screens/survey/widgets/survey_field.dart';
import 'package:user_app/router/routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/utils/device.dart';

class LifestyleActivityStep extends HookConsumerWidget {
  const LifestyleActivityStep({super.key});

  final List<Map<String, dynamic>> questions = const [
    {
      "key": "screen_time",
      "question": "5. What is your average daily screen time?",
      "options": [
        {"value": "low", "text": "Under 3 hours"},
        {"value": "medium", "text": "4 to 7 hours"},
        {"value": "high", "text": "Over 8 hours"},
        {"value": "extreme", "text": "Almost all day"},
      ],
    },
    {
      "key": "exercise_frequency",
      "question":
          "6. How often do you exercise or engage in physical activity?",
      "options": [
        {"value": "none", "text": "No exercise habits"},
        {"value": "occasional", "text": "Occasionally (1-2 times/week)"},
        {"value": "regular", "text": "Regularly (3-4 times/week)"},
        {"value": "athlete", "text": "High intensity (Athlete/Heavy gym)"},
      ],
    },
    {
      "key": "work_posture",
      "question": "7. What is your most common working posture?",
      "options": [
        {"value": "good", "text": "Upright, with good back support"},
        {"value": "slouching", "text": "Slouching or hunched over"},
        {"value": "crossed_legs", "text": "Sitting cross-legged"},
        {"value": "bad_standing", "text": "Prolonged standing or bending"},
      ],
    },
    {
      "key": "hydration_habit",
      "question": "8. What are your daily water intake habits?",
      "options": [
        {"value": "low", "text": "Very little (< 1 liter)"},
        {"value": "normal", "text": "Normal (1.5 - 2 liters)"},
        {"value": "high", "text": "A lot (> 2.5 liters)"},
        {"value": "caffeine", "text": "Mostly tea/coffee instead of water"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isLoading = useState(false);
    final scrollController = useScrollController();

    submit() {
      // Implement your submit logic here
      if (formKey.currentState?.saveAndValidate() ?? false) {
        FocusScope.of(context).unfocus();

        isLoading.value = true;

        ref
            .read(registerFlowProvider.notifier)
            .updateSurvey(
              "lifestyle_activity",
              formKey.currentState!.value.entries.map((q) {
                return SurveyEntity(question: q.key, value: q.value);
              }).toList(),
            );
        isLoading.value = false;

        if (context.mounted) {
          // Navigate to the next screen or show success message
          BodyEnergyStepRoute().push(context);
        }
      }
    }

    // Your implementation here
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {GeneralGoalsStepRoute().push(context)},
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
                  AppLinearPercentIndicator(step: 3, maxSteps: 5),
                  AppDimens.verticalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Part 2: Lifestyle & Activity Habits',
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
                      child: const Text('Next'),
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
