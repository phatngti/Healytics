import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/linear_indicator.dart';
import 'package:user_app/router/routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:user_app/utils/device.dart';

class SurveyScreen extends HookConsumerWidget {
  const SurveyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Your implementation here
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Theme.of(context).colorScheme.onSurface,
          onPressed: () => {OnboardingRoute().push(context)},
        ),
        title: Text(
          'Completed your status',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: AppDimens.paddingHorizontalMedium,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: DeviceUtils.getMinBodyHeight(context),
          ),
          child: Container(
            margin: EdgeInsets.only(top: AppDimens.paddingAllSmall.vertical),
            child: Column(
              children: [
                AppLinearPercentIndicator(step: 1, maxSteps: 5),
                AppDimens.verticalLarge,
                AppDimens.verticalLarge,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wellness snapshot',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    AppDimens.verticalSmall,

                    Text(
                      'This brief 5-step survey is designed to help you check in with your overall well-being. Your responses are for your own reflection and will help you identify areas of strength and opportunities for improvement. It should only take 2-3 minutes',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
                (DeviceUtils.getMinBodyHeight(context) * 0.1).verticalSpace,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    // 3. Disable nút khi: Email rỗng HOẶC đang Loading
                    onPressed: () {
                      GeneralGoalsStepRoute().push(context);
                    },
                    buttonType: ButtonType.elevated,
                    customStyle: ElevatedButton.styleFrom(
                      padding: AppDimens.paddingAllMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimens.radiusSmall,
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('I understand and agree to proceed'),
                  ),
                ),
                AppDimens.verticalSmall,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    // 3. Disable nút khi: Email rỗng HOẶC đang Loading
                    onPressed: () {
                      OnboardingRoute().push(context);
                    },
                    buttonType: ButtonType.outline,
                    customStyle: ElevatedButton.styleFrom(
                      padding: AppDimens.paddingAllMedium,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppDimens.radiusSmall,
                      ),
                      textStyle: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Decline and exit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
