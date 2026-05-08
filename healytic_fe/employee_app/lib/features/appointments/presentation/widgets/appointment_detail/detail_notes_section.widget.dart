import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'detail_section_header.widget.dart';

/// Notes section with italic quoted text in a subtle
/// surface-tinted container.
class DetailNotesSection extends StatelessWidget {
  /// The note text content.
  final String notes;

  const DetailNotesSection({
    required this.notes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionHeader(title: 'Notes'),
        AppDimens.verticalSmall,
        Container(
          width: double.infinity,
          padding: AppDimens.paddingAllMediumSmall,
          decoration: BoxDecoration(
            color: cs.surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: cs.outlineVariant
                  .withValues(alpha: 0.4),
            ),
          ),
          child: Text(
            '"$notes"',
            style: tt.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}
