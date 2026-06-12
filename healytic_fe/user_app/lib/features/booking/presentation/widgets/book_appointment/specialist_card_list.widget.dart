import 'package:flutter/material.dart';
import 'package:common/widgets/images/network_image_auto.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

import 'package:user_app/core/keys/integration_test_keys.dart';
import '../../../domain/entities/booking.entity.dart';

/// Horizontal scrollable list of specialist cards with
/// a header row ("Select Specialist" + "See all").
///
/// Accepts a [specialists] list from the data layer.
/// Reports the selected index via [onSelected].
class SpecialistCardList extends StatelessWidget {
  const SpecialistCardList({
    super.key,
    required this.specialists,
    required this.selectedIndex,
    required this.onSelected,
    this.isLocked = false,
  });

  final List<BookingSpecialist> specialists;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// When true, non-selected cards are dimmed
  /// and tapping them is a no-op. The "See all"
  /// link is also hidden.
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardWidth = AppDimens.widthFraction(context, fraction: 0.4);

    return Column(
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Specialist',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!isLocked)
              GestureDetector(
                onTap: () {
                  // TODO: navigate to full list
                },
                child: Text(
                  'See all',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: AppDimens.spaceMd),

        // Cards
        SizedBox(
          height: cardWidth * 1.35,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: specialists.length,
            separatorBuilder: (_, __) => SizedBox(width: AppDimens.spaceMd),
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;
              final isDimmed = isLocked && !isSelected;

              return Opacity(
                opacity: isDimmed ? 0.4 : 1.0,
                child: IgnorePointer(
                  ignoring: isDimmed,
                  child: _SpecialistCard(
                    key: keys.bookingPage.specialistTile(specialists[index].id),
                    specialist: specialists[index],
                    isSelected: isSelected,
                    width: cardWidth,
                    onTap: () => onSelected(index),
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

class _SpecialistCard extends StatelessWidget {
  const _SpecialistCard({
    super.key,
    required this.specialist,
    required this.isSelected,
    required this.width,
    required this.onTap,
  });

  final BookingSpecialist specialist;
  final bool isSelected;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: width,
        padding: EdgeInsets.all(AppDimens.spaceMd),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppDimens.radiusMedium,
          border: Border.all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: isSelected
                ? AppDimens.borderWidthThick
                : AppDimens.borderWidth,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar image / fallback
                AspectRatio(
                  aspectRatio: 1,
                  child: _SpecialistAvatar(
                    avatarUrl: specialist.avatarUrl,
                    isSelected: isSelected,
                  ),
                ),
                SizedBox(height: AppDimens.spaceSm),
                Text(
                  specialist.name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppDimens.spaceXxs),
                Text(
                  specialist.specialty,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            // Check badge for selected
            if (isSelected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 2),
                  ),
                  child: Icon(
                    Symbols.check,
                    size: AppDimens.iconSm,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Specialist avatar with network image support.
///
/// Falls back to a person icon when [avatarUrl]
/// is null or the image fails to load.
class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({this.avatarUrl, required this.isSelected});

  final String? avatarUrl;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasUrl = avatarUrl != null && avatarUrl!.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasUrl
          ? NetworkImageAuto(
              imageUrl: avatarUrl!,
              fit: BoxFit.cover,
              placeholder: (_) => _AvatarFallback(isSelected: isSelected),
              errorWidget: (_) => _AvatarFallback(isSelected: isSelected),
            )
          : _AvatarFallback(isSelected: isSelected),
    );
  }
}

/// Person icon fallback for specialist avatar.
class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Icon(
        Symbols.person,
        size: AppDimens.iconXxl,
        color: isSelected
            ? colorScheme.primary
            : colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }
}
