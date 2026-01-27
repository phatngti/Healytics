import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A reusable card wrapper for form sections in the signup flow.
///
/// Provides consistent styling with:
/// - Section title with bottom border
/// - Rounded corners (16px radius) for content card
/// - Shadow effect
/// - Border
/// - Theme-aware colors for light/dark mode
class FormSectionCard extends StatelessWidget {
  /// The section number (e.g., "1" for "1. Account Information").
  final String? sectionNumber;

  /// The title of the section displayed in the header.
  final String title;

  /// The content of the section.
  final Widget child;

  const FormSectionCard({
    super.key,
    this.sectionNumber,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Build the section header text
    final headerText = sectionNumber != null ? '$sectionNumber. $title' : title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with bottom border
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Text(
            headerText,
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
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
