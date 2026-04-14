import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays a cloud of skill chips from a [skills] list.
class EmployeeSkillCloud extends StatelessWidget {
  /// List of skill names to display.
  final List<String> skills;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeSkillCloud({
    super.key,
    required this.skills,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SKILL SET',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        AppDimens.verticalMedium,
        if (skills.isEmpty)
          Text(
            'No skills listed',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills.map((skill) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withAlpha(25),
                  borderRadius: AppDimens.radiusLarge,
                  border: Border.all(color: colorScheme.primary.withAlpha(75)),
                ),
                child: Text(
                  skill,
                  style: textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
