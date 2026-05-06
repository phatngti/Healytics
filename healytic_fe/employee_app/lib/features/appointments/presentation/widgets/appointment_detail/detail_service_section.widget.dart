import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'detail_section_header.widget.dart';

/// Service section with icon circle, name, and
/// category + duration subtitle.
class DetailServiceSection extends StatelessWidget {
  /// Service display name.
  final String serviceName;

  /// Category (e.g. "Massage Therapy").
  final String category;

  /// Duration string (e.g. "90 min").
  final String duration;

  const DetailServiceSection({
    required this.serviceName,
    required this.category,
    required this.duration,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionHeader(title: 'Service'),
        AppDimens.verticalSmall,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ServiceIcon(color: cs.primary),
            AppDimens.horizontalMediumSmall,
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
                    style: tt.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppDimens.verticalExtraSmall,
                  Text(
                    '$category • $duration',
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 40dp circular icon container.
class _ServiceIcon extends StatelessWidget {
  final Color color;
  const _ServiceIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      width: AppDimens.ctaButtonMd,
      height: AppDimens.ctaButtonMd,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest
            .withValues(alpha: 0.5),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.spa,
        color: color,
        size: AppDimens.iconLg,
      ),
    );
  }
}
