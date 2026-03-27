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

class GeneralGoalsStep extends HookConsumerWidget {
  const GeneralGoalsStep({super.key});

  final List<Map<String, dynamic>> questions = const [
    {
      "key": "primary_goal",
      "question": "1. What is your primary goal for today's session?",
      "options": [
        {"value": "relax", "text": "Relaxation & Stress Relief"},
        {"value": "pain_relief", "text": "Muscle Pain Relief"},
        {"value": "therapy", "text": "Therapeutic Treatment (Joints/Bones)"},
        {"value": "beauty", "text": "Skincare & Beauty"},
      ],
    },
    {
      "key": "lifestyle_nature",
      "question":
          "2. How would you describe your daily work or lifestyle routine?",
      "options": [
        {"value": "sedentary", "text": "Sedentary (Office work > 8h)"},
        {"value": "standing", "text": "Prolonged standing or walking"},
        {"value": "labor", "text": "Heavy lifting/Physical labor"},
        {"value": "active", "text": "High-intensity sports/Activity"},
      ],
    },
    {
      "key": "sleep_quality",
      "question": "How has your sleep quality been over the past week?",
      "options": [
        {"value": "good", "text": "Good, deep sleep"},
        {
          "value": "occasional_difficulty",
          "text": "Occasional difficulty falling asleep",
        },
        {"value": "restless", "text": "Restless/Interrupted sleep"},
        {"value": "insomnia", "text": "Frequent insomnia"},
      ],
    },
    {
      "key": "stress_level",
      "question": "4. How would you rate your current stress level?",
      "options": [
        {"value": "relaxed", "text": "Completely relaxed"},
        {"value": "mild_tired", "text": "Slightly tired, need rest"},
        {"value": "anxious", "text": "Stressed or anxious"},
        {"value": "burnout", "text": "Burnout/Exhausted"},
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
              "general_goals",
              formKey.currentState!.value.entries.map((q) {
                return SurveyEntity(question: q.key, value: q.value);
              }).toList(),
            );
        isLoading.value = false;

        if (context.mounted) {
          // Navigate to the next screen or show success message
          LifestyleActivityStepRoute().push(context);
        }
      }
    }

    // Your implementation here
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {SurveyScreenRoute().push(context)},
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
                  AppLinearPercentIndicator(step: 2, maxSteps: 5),
                  AppDimens.verticalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Part 1: Goals & General Status',
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
