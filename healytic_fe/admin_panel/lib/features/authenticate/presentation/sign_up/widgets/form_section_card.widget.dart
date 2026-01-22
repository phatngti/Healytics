import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A reusable card wrapper for form sections in the signup flow.
///
/// Provides consistent styling with:
/// - Rounded corners (16px radius)
/// - Shadow effect
/// - Border
/// - Theme-aware colors for light/dark mode
class FormSectionCard extends StatelessWidget {
  /// The title of the section displayed in the header.
  final String title;

  /// Optional step information (e.g., "Step 1 of 3").
  final String? stepInfo;

  /// The content of the section.
  final Widget child;

  const FormSectionCard({
    super.key,
    required this.title,
    this.stepInfo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (stepInfo != null)
              Text(
                stepInfo!,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
        AppDimens.verticalMedium,
        // Card container
        Container(
          padding: AppDimens.paddingAllLarge,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppDimens.radiusMedium,
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: child,
        ),
      ],
    );
  }
}
