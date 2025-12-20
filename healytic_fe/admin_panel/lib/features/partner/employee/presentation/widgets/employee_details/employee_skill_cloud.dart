import 'package:flutter/material.dart';

class EmployeeSkillCloud extends StatelessWidget {
  const EmployeeSkillCloud({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final skills = [
      {'name': 'Thai Massage', 'color': Colors.teal},
      {'name': 'Shiatsu', 'color': Colors.blue},
      {'name': 'Deep Tissue', 'color': Colors.purple},
      {'name': 'Hot Stone', 'color': Colors.orange},
      {'name': 'Aromatherapy', 'color': Colors.grey},
      {'name': 'Reflexology', 'color': Colors.grey},
      {'name': 'Sports Massage', 'color': Colors.indigo},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SKILL SET',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            final color = skill['color'] as MaterialColor;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withAlpha(75)),
              ),
              child: Text(
                skill['name'] as String,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: color.shade700,
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
