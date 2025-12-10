import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({
    super.key,
    required this.label,
    required this.value,
    required this.change,
  });

  final String label;
  final String value;
  final double change;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DeviceUtils.getScreenWidth(context) * 0.15,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: AppDimens.radiusMedium,
      ),
      padding: AppDimens.paddingAllMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
              fontSize: AppDimens.fontSizeLarge,
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: AppDimens.fontWeightBold,
              fontSize: AppDimens.fontSizeExtraExtraExtraExtraLarge,
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            '${change < 0 ? "-${change.toString()}" : "+${change.toString()}"}%',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: change < 0
                  ? Theme.of(context).extension<SemanticColors>()?.error
                  : Theme.of(context).extension<SemanticColors>()?.success,
              fontSize: AppDimens.fontSizeLarge,
            ),
          ),
        ],
      ),
    );
  }
}
