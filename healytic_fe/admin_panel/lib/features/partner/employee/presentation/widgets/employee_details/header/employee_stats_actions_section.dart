import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:flutter/material.dart';

class EmployeeStatsActionsSection extends StatelessWidget {
  const EmployeeStatsActionsSection({super.key});

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
                    const SizedBox(width: 4),
                    Row(
                      children: List.generate(5, (index) {
                        if (index < 4) {
                          return const Icon(
                            Icons.star,
                            size: 18,
                            color: Colors.amber,
                          );
                        } else {
                          return const Icon(
                            Icons.star_half,
                            size: 18,
                            color: Colors.amber,
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
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              onPressed: () {},
              buttonType: ButtonType.outline,
              child: const Text('Edit Profile'),
            ),
            const SizedBox(width: 12),
            AppButton(
              onPressed: () {},
              buttonType: ButtonType.elevated,
              customStyle: OutlinedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red.shade700,
                side: BorderSide(color: Colors.red.shade200),
              ),
              child: const Text('Deactivate'),
            ),
          ],
        ),
      ],
    );
  }
}
