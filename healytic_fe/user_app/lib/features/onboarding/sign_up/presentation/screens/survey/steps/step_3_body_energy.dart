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

class BodyEnergyStep extends HookConsumerWidget {
  const BodyEnergyStep({super.key});

  final List<Map<String, dynamic>> questions = const [
    {
      "key": "morning_energy",
      "question": "9. How is your energy level when you wake up?",
      "options": [
        {"value": "fresh", "text": "Refreshed and full of energy"},
        {"value": "ok", "text": "Slightly groggy but alert later"},
        {"value": "tired", "text": "Tired, struggle to get out of bed"},
        {"value": "pain", "text": "Body aches and heavy head"},
      ],
    },
    {
      "key": "headache_frequency",
      "question": "10. Do you frequently experience headaches or dizziness?",
      "options": [
        {"value": "rare", "text": "Rarely or never"},
        {"value": "sometimes", "text": "Occasionally"},
        {"value": "frequent", "text": "Frequently (Migraine/Vertigo)"},
        {"value": "chronic", "text": "Dull ache all day"},
      ],
    },
    {
      "key": "leg_condition",
      "question": "11. How do your legs feel at the end of the day?",
      "options": [
        {"value": "normal", "text": "Normal, flexible"},
        {"value": "tired", "text": "Slightly tired"},
        {"value": "cramps", "text": "Numbness or cramps"},
        {"value": "swollen", "text": "Swollen/Heavy (Varicose veins)"},
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
              "body_energy",
              formKey.currentState!.value.entries.map((q) {
                return SurveyEntity(question: q.key, value: q.value);
              }).toList(),
            );
        isLoading.value = false;

        if (context.mounted) {
          // Navigate to the next screen or show success message
          HealthSafetyStepRoute().push(context);
        }
      }
    }

    // Your implementation here
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {LifestyleActivityStepRoute().push(context)},
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
                  AppLinearPercentIndicator(step: 4, maxSteps: 5),
                  AppDimens.verticalLarge,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Part 3: Energy & Body Sensation',
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
