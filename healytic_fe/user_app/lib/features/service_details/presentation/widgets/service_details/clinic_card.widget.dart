import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// Clinic info card with icon, name, address, favorite, and visit
/// button.
///
/// The entire card is tappable via [onTap]. The visit
/// button fires [onVisit] (or falls back to [onTap]).
class ClinicCard extends StatelessWidget {
  const ClinicCard({
    super.key,
    required this.clinicName,
    required this.address,
    this.onTap,
    this.onVisit,
    this.onFavorite,
    this.isFavorite = false,
    this.avatar,
  });

  final String clinicName;
  final String address;
  final String? avatar;
  final VoidCallback? onTap;
  final VoidCallback? onVisit;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final displayAddress = _districtAndProvinceAddress(address);

    return Material(
      color: isDark ? colorScheme.surfaceContainerHighest : colorScheme.surface,
      borderRadius: AppDimens.radiusMedium,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusMedium,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: AppDimens.spaceSm,
            bottom: AppDimens.spaceSm,
          ),
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusMedium,
            border: Border.all(
              color: isDark
                  ? colorScheme.outlineVariant
                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Clinic icon
                    ClipRRect(
                      borderRadius: AppDimens.radiusSmall,
                      child: Container(
                        width: AppDimens.touchTarget,
                        height: AppDimens.touchTarget,
                        color: colorScheme.surface,
                        child: avatar == null || avatar!.isEmpty
                            ? Icon(
                                Icons.storefront_outlined,
                                color: colorScheme.primary,
                              )
                            : NetworkImageAuto(imageUrl: avatar!),
                      ),
                    ),
                    AppDimens.horizontalSmall,
                    // Name + address
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clinicName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppDimens.verticalExtraSmall,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.location_on,
                                size: AppDimens.iconXs,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              AppDimens.horizontalExtraSmall,
                              Expanded(
                                child: Text(
                                  displayAddress,
                                  softWrap: true,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Favorite
                  _ActionIcon(
                    icon: isFavorite ? Icons.favorite : Icons.favorite_border,
                    onTap: onFavorite,
                    isActive: isFavorite,
                  ),
                  AppDimens.horizontalSmall,
                  // Visit button
                  Material(
                    color: colorScheme.primary,
                    borderRadius: AppDimens.radiusSmall,
                    child: InkWell(
                      onTap: onVisit ?? onTap,
                      borderRadius: AppDimens.radiusSmall,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimens.spaceLg,
                          vertical: AppDimens.spaceSm,
                        ),
                        child: Text(
                          'Visit',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _districtAndProvinceAddress(String address) {
  final parts = address
      .split(',')
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();
  if (parts.length < 2) return address;

  final provinceIndex = parts.lastIndexWhere(_isProvincePart);
  if (provinceIndex < 0) return address;

  final districtCandidates = parts.take(provinceIndex).toList();
  final districtIndex = districtCandidates.lastIndexWhere(_isDistrictPart);
  if (districtIndex < 0) return parts[provinceIndex];

  return '${districtCandidates[districtIndex]}, ${parts[provinceIndex]}';
}

bool _isProvincePart(String value) {
  final part = value.toLowerCase();
  return part.startsWith('thành phố ') ||
      part.startsWith('tỉnh ') ||
      part.startsWith('tp ') ||
      part.startsWith('tp. ') ||
      part.endsWith(' city') ||
      part.endsWith(' province');
}

bool _isDistrictPart(String value) {
  final part = value.toLowerCase();
  return part.startsWith('quận ') ||
      part.startsWith('huyện ') ||
      part.startsWith('thị xã ') ||
      part.startsWith('thành phố ') ||
      part.startsWith('district ');
}

/// Small outlined icon button for the clinic card actions.
class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, this.onTap, this.isActive = false});

  final IconData icon;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: isActive ? colorScheme.primary : colorScheme.outlineVariant,
          ),
        ),
        child: Icon(
          icon,
          size: AppDimens.iconSmMd,
          color: isActive ? colorScheme.primary : colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
