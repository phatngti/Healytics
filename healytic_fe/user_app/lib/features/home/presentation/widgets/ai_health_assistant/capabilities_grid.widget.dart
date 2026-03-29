import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import 'capability_card.widget.dart';

/// 2×2 grid of AI capability cards showcasing what
/// the health assistant can do.
class CapabilitiesGrid extends StatelessWidget {
  const CapabilitiesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gridGap = AppDimens.spaceMd;

    final capabilities = [
      _CapData(
        icon: Symbols.monitor_heart,
        title: 'Symptom Checker',
        description:
            'Describe symptoms and get '
            'preliminary guidance',
        color: colorScheme.error,
      ),
      _CapData(
        icon: Symbols.local_hospital,
        title: 'Health Tips',
        description:
            'Personalized wellness '
            'recommendations',
        color: colorScheme.primary,
      ),
      _CapData(
        icon: Symbols.medication,
        title: 'Medication Info',
        description:
            'Learn about prescriptions '
            'and interactions',
        color: colorScheme.tertiary,
      ),
      _CapData(
        icon: Symbols.fitness_center,
        title: 'Wellness Plans',
        description:
            'Custom routines for a '
            'healthier lifestyle',
        color: colorScheme.secondary,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What I Can Help With',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: AppDimens.spaceLg),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: gridGap,
          mainAxisSpacing: gridGap,
          childAspectRatio: 1.15,
          children: capabilities
              .map(
                (cap) => CapabilityCard(
                  icon: cap.icon,
                  title: cap.title,
                  description: cap.description,
                  color: cap.color,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _CapData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _CapData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
