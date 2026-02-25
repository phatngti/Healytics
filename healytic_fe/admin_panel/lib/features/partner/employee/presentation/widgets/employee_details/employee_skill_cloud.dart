import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeSkillCloud extends StatelessWidget {
  final bool isEditing;

  const EmployeeSkillCloud({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final skills = [
      'Thai Massage',
      'Shiatsu',
      'Deep Tissue',
      'Hot Stone',
      'Aromatherapy',
      'Reflexology',
      'Sports Massage',
    ];

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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
