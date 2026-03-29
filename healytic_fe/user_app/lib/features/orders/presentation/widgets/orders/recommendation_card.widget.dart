import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';

/// Compact horizontal card for service
/// recommendations.
class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.service,
    this.isLast = false,
  });

  final RecommendedServiceEntity service;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: 288,
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colors.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.shadow
                .withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _Thumbnail(imageUrl: service.imageUrl),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: _Details(service: service),
          ),
        ],
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppDimens.radiusSmall,
      child: SizedBox(
        width: 96,
        height: 96,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest,
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.service});
  final RecommendedServiceEntity service;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          service.name,
          style:
              theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalExtraSmall,
        Text(
          service.description,
          style:
              theme.textTheme.bodySmall?.copyWith(
            color:
                theme.colorScheme.onSurfaceVariant,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalSmall,
        Row(
          children: [
            Flexible(
              child: Text(
                service.price,
                style: theme.textTheme.titleSmall
                    ?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            Icon(
              Icons.schedule,
              size: AppDimens.iconXs,
              color:
                  theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: AppDimens.spaceXxs),
            Flexible(
              child: Text(
                service.duration,
                style: theme.textTheme.bodySmall
                    ?.copyWith(
                  color: theme
                      .colorScheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
