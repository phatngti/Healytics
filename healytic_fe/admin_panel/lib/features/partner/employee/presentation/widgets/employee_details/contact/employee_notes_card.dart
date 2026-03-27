import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Displays manager notes / description for an employee.
class EmployeeNotesCard extends StatelessWidget {
  /// Employee description or manager notes.
  final String? description;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeNotesCard({
    super.key,
    this.description,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors =
        Theme.of(context).extension<SemanticColors>()!;

    final hasNotes =
        description != null && description!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: semanticColors.warning?.withAlpha(25),
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: semanticColors.warning?.withAlpha(50) ??
              colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 20,
                color: semanticColors.warning,
              ),
              AppDimens.horizontalSmall,
              Text(
                'Manager Notes',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          AppDimens.verticalSmall,
          Text(
            hasNotes
                ? description!
                : 'No manager notes available.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
