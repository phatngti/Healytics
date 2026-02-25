import 'package:common/widgets/button/button.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeStatsActionsSection extends StatelessWidget {
  final bool isEditing;
  final VoidCallback? onEdit;

  const EmployeeStatsActionsSection({
    super.key,
    this.isEditing = false,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Rating
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'RATING',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '4.8',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AppDimens.horizontalExtraSmall,
                    Row(
                      children: List.generate(5, (index) {
                        if (index < 4) {
                          return Icon(
                            Icons.star,
                            size: 18,
                            color: Theme.of(
                              context,
                            ).extension<SemanticColors>()!.warning,
                          );
                        } else {
                          return Icon(
                            Icons.star_half,
                            size: 18,
                            color: Theme.of(
                              context,
                            ).extension<SemanticColors>()!.warning,
                          );
                        }
                      }),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: colorScheme.outlineVariant,
            ),
            // Personal
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'PERSONAL',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Female • 34 yrs',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        AppDimens.verticalMedium,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed: onEdit,
              buttonType: ButtonType.outline,
              child: const Text('Edit Profile'),
            ),
            AppDimens.horizontalMediumSmall,
            AppButton(
              onPressed: () {},
              buttonType: ButtonType.elevated,
              customStyle: OutlinedButton.styleFrom(
                backgroundColor: Theme.of(
                  context,
                ).extension<SemanticColors>()!.error!.withAlpha(25),
                foregroundColor: Theme.of(
                  context,
                ).extension<SemanticColors>()!.error,
                side: BorderSide(
                  color: Theme.of(
                    context,
                  ).extension<SemanticColors>()!.error!.withAlpha(50),
                ),
              ),
              child: const Text('Deactivate'),
            ),
          ],
        ),
      ],
    );
  }
}
