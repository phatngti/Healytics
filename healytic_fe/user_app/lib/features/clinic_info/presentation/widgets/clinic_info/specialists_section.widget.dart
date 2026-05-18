import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:flutter/material.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

/// Horizontally scrollable specialist preview cards.
class SpecialistsSection extends StatelessWidget {
  const SpecialistsSection({
    super.key,
    required this.specialists,
    this.onViewAllTap,
    this.onSpecialistTap,
  });

  final List<ClinicSpecialistPreview> specialists;
  final VoidCallback? onViewAllTap;
  final void Function(String id)? onSpecialistTap;

  @override
  Widget build(BuildContext context) {
    if (specialists.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hPad = AppDimens.horizontalPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'OUR SPECIALISTS',
                style: textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.8,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: onViewAllTap,
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'View All',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        AppDimens.verticalSmall,
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: hPad),
            itemCount: specialists.length,
            separatorBuilder: (_, __) => AppDimens.horizontalMediumSmall,
            itemBuilder: (context, index) {
              final spec = specialists[index];
              return Semantics(
                button: onSpecialistTap != null,
                label: spec.name,
                child: GestureDetector(
                  onTap: () => onSpecialistTap?.call(spec.id),
                  child: SizedBox(
                    width: 120,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: ClipRRect(
                            borderRadius: AppDimens.radiusMediumSmall,
                            child: spec.imageUrl != null
                                ? NetworkImageAuto(
                                    imageUrl: spec.imageUrl!,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    color: colorScheme.surfaceContainerHighest,
                                    child: Icon(
                                      Icons.person,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          spec.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          spec.role,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.labelSmall?.copyWith(
                            fontSize: 9,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (spec.experienceLabel != null) ...[
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.05,
                              ),
                              borderRadius: AppDimens.radiusExtraSmall,
                            ),
                            child: Text(
                              spec.experienceLabel!,
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
