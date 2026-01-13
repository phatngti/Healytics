import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

import '../employee_badges_strength.dart';
import '../employee_skill_cloud.dart';

class EmployeeSkillsCard extends StatelessWidget {
  final bool isEditing;

  const EmployeeSkillsCard({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.surfaceContainerHighest.withAlpha(100),
                  colorScheme.surface,
                ],
              ),
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: semanticColors.success),
                    AppDimens.horizontalSmall,
                    Text(
                      'Therapy Skills & Attributes',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: semanticColors.success?.withAlpha(25),
                    borderRadius: AppDimens.radiusLarge,
                    border: Border.all(
                      color:
                          semanticColors.success?.withAlpha(75) ??
                          colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified_user,
                        size: 18,
                        color: semanticColors.success,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Health Check Verified: Oct 24, 2023',
                        style: textTheme.labelSmall?.copyWith(
                          color: semanticColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: EmployeeBadgesStrength(isEditing: isEditing)),
                Container(
                  width: 1,
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: colorScheme.outlineVariant,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
                Expanded(child: EmployeeSkillCloud(isEditing: isEditing)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
