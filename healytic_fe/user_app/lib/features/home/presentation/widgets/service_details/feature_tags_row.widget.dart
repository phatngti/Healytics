import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/home/domain/entities/service_details.entity.dart';

/// Type alias for backward compatibility.
typedef FeatureTag = FeatureTagEntity;

/// Maps a semantic icon name to a Material [IconData].
IconData _iconFromName(String name) {
  const map = <String, IconData>{
    'schedule': Icons.schedule,
    'spa': Icons.spa,
    'biotech': Icons.biotech,
    'timer': Icons.timer,
    'star': Icons.star,
    'local_hospital': Icons.local_hospital,
    'healing': Icons.healing,
    'science': Icons.science,
  };
  return map[name] ?? Icons.label;
}

/// Horizontally scrollable row of feature tag chips.
class FeatureTagsRow extends StatelessWidget {
  const FeatureTagsRow({super.key, required this.tags});

  final List<FeatureTag> tags;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          for (int i = 0; i < tags.length; i++) ...[
            if (i > 0) AppDimens.horizontalMediumSmall,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.spaceLg,
                vertical: AppDimens.spaceSm,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.surfaceContainerHighest
                    : colorScheme.surface,
                borderRadius: AppDimens.radiusMediumSmall,
                border: Border.all(
                  color: isDark
                      ? colorScheme.outlineVariant
                      : colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _iconFromName(tags[i].iconName),
                    size: AppDimens.iconXs,
                    color: colorScheme.primary,
                  ),
                  AppDimens.horizontalSmall,
                  Text(
                    tags[i].label,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
