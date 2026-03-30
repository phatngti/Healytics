import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';

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
///
/// Uses [ListView.builder] for lazy chip building when
/// the tag count grows, instead of eagerly building all
/// chips in a `for`-loop `Row`.
class FeatureTagsRow extends StatelessWidget {
  const FeatureTagsRow({super.key, required this.tags});

  final List<FeatureTag> tags;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: tags.length,
        separatorBuilder: (_, __) => AppDimens.horizontalMediumSmall,
        itemBuilder: (context, i) => Container(
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
      ),
    );
  }
}
