import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/domain/entities/service_manual.entity.dart';
import 'package:user_app/features/orders/presentation/widgets/service_manual/manual_section_card.widget.dart';

/// Displays the "Cơ sở vật chất" section with a
/// horizontally scrollable image carousel.
class FacilitiesCarousel extends StatelessWidget {
  const FacilitiesCarousel({super.key, required this.facilities});

  /// List of facility items.
  final List<FacilityEntity> facilities;

  @override
  Widget build(BuildContext context) {
    return ManualSectionCard(
      icon: Symbols.pool,
      title: 'Cơ sở vật chất',
      padding: const EdgeInsets.only(
        top: AppDimens.spaceXl,
        bottom: AppDimens.spaceXl,
      ),
      child: SizedBox(
        height: 156,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: AppDimens.paddingHorizontalMediumLarge,
          itemCount: facilities.length,
          separatorBuilder: (_, __) => AppDimens.horizontalMediumSmall,
          itemBuilder: (context, index) =>
              _FacilityItem(facility: facilities[index]),
        ),
      ),
    );
  }
}

class _FacilityItem extends StatelessWidget {
  const _FacilityItem({required this.facility});

  final FacilityEntity facility;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: AppDimens.radiusMediumSmall,
            child: SizedBox(
              height: 120,
              width: 160,
              child: Image.network(
                facility.imageUrl,
                fit: BoxFit.cover,
                semanticLabel: facility.name,
                errorBuilder: (_, __, ___) => Container(
                  color: colors.surfaceContainerHighest,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: AppDimens.iconXxl,
                      color: colors.outline,
                    ),
                  ),
                ),
              ),
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            facility.name,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
