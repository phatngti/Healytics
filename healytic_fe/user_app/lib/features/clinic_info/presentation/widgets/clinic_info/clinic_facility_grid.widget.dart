import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

/// Masonry-style facility tour image grid.
class ClinicFacilityGrid extends StatelessWidget {
  const ClinicFacilityGrid({super.key, required this.images});

  final List<ClinicFacilityImage> images;

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hPad = AppDimens.horizontalPadding(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'FACILITY TOUR',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalSmall,
          SizedBox(
            height: 200,
            child: Row(
              children: [
                if (images.isNotEmpty)
                  Expanded(child: _FacilityTile(image: images[0])),
                if (images.length > 1) ...[
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: _FacilityTile(image: images[1])),
                        if (images.length > 2) ...[
                          const SizedBox(height: 6),
                          Expanded(child: _FacilityTile(image: images[2])),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FacilityTile extends StatelessWidget {
  const _FacilityTile({required this.image});

  final ClinicFacilityImage image;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: AppDimens.radiusMediumSmall,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetworkImageAuto(imageUrl: image.imageUrl, fit: BoxFit.cover),
          Positioned(
            bottom: 6,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.4),
                borderRadius: AppDimens.radiusExtraSmall,
              ),
              child: Text(
                image.label,
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
