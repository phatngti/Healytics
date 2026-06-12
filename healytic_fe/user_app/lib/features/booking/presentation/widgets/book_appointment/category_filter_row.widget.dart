import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

import '../../../../../theme/app_theme.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';

enum CategoryFilterRowStyle { circle, showcase }

/// 3-column grid of category icons with
/// labels. Tapping selects a category; the selected
/// item gets a coloured ring and elevated shadow.
class CategoryFilterRow extends StatelessWidget {
  const CategoryFilterRow({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
    this.style = CategoryFilterRowStyle.circle,
  });

  final List<HomeCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final CategoryFilterRowStyle style;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: switch (style) {
        CategoryFilterRowStyle.circle => 1.0,
        CategoryFilterRowStyle.showcase => 0.78,
      },
      crossAxisSpacing: switch (style) {
        CategoryFilterRowStyle.circle => 0,
        CategoryFilterRowStyle.showcase => AppDimens.spaceMd,
      },
      mainAxisSpacing: switch (style) {
        CategoryFilterRowStyle.circle => 0,
        CategoryFilterRowStyle.showcase => AppDimens.spaceLg,
      },
      padding: EdgeInsets.zero,
      children: List.generate(categories.length, (index) {
        final cat = categories[index];
        return _CategoryGridItem(
          key: keys.bookingPage.categoryTile(cat.id),
          icon: cat.icon,
          label: cat.name,
          color: _colorForType(context, cat.categoryType),
          isSelected: index == selectedIndex,
          onTap: () => onSelected(index),
          style: style,
        );
      }),
    );
  }

  /// Maps a category type to a theme colour.
  Color _colorForType(BuildContext context, String categoryType) {
    final theme = Theme.of(context);
    final semantic = theme.extension<SemanticColors>()!;

    switch (categoryType) {
      case 'primary':
        return theme.colorScheme.primary;
      case 'secondary':
        return theme.colorScheme.secondary;
      case 'tertiary':
        return theme.colorScheme.tertiary;
      case 'error':
        return semantic.warning!;
      case 'success':
        return semantic.success!;
      case 'info':
        return semantic.info!;
      default:
        return theme.colorScheme.primary;
    }
  }
}

/// Single category icon + label.
///
/// Shows a coloured ring and subtle shadow when
/// [isSelected] is true.
class _CategoryGridItem extends StatelessWidget {
  const _CategoryGridItem({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
    required this.style,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  final CategoryFilterRowStyle style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final icon = switch (style) {
      CategoryFilterRowStyle.circle => _CircleCategoryIcon(
        color: color,
        icon: this.icon,
        isSelected: isSelected,
      ),
      CategoryFilterRowStyle.showcase => _ShowcaseCategoryIcon(
        color: color,
        icon: this.icon,
        isSelected: isSelected,
      ),
    };

    final labelStyle = switch (style) {
      CategoryFilterRowStyle.circle => theme.textTheme.bodySmall,
      CategoryFilterRowStyle.showcase => theme.textTheme.bodyMedium,
    };

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: AppDimens.spaceSm),
          Text(
            label,
            style: labelStyle?.copyWith(
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected ? color : null,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CircleCategoryIcon extends StatelessWidget {
  const _CircleCategoryIcon({
    required this.color,
    required this.icon,
    required this.isSelected,
  });

  final Color color;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgAlpha = isSelected ? 0.18 : 0.10;
    final borderAlpha = isSelected ? 0.55 : 0.20;
    final borderWidth = isSelected ? 2.5 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: AppDimens.avatarLg,
      width: AppDimens.avatarLg,
      decoration: BoxDecoration(
        color: color.withValues(alpha: bgAlpha),
        shape: BoxShape.circle,
        border: Border.all(
          color: color.withValues(alpha: borderAlpha),
          width: borderWidth,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.20),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.02),
                  blurRadius: AppDimens.spaceXs,
                  offset: Offset(0, AppDimens.spaceXxs),
                ),
              ],
      ),
      child: Icon(icon, color: color, size: AppDimens.iconXl),
    );
  }
}

class _ShowcaseCategoryIcon extends StatelessWidget {
  const _ShowcaseCategoryIcon({
    required this.color,
    required this.icon,
    required this.isSelected,
  });

  final Color color;
  final IconData icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const tileSize = 84.0;
    final bgAlpha = isSelected ? 0.20 : 0.11;
    final borderAlpha = isSelected ? 0.78 : 0.28;
    final borderWidth = isSelected
        ? AppDimens.borderWidthThick
        : AppDimens.borderWidth;

    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      scale: isSelected ? 1.10 : 1.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: tileSize,
        width: tileSize,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: bgAlpha + 0.06),
              color.withValues(alpha: bgAlpha),
              theme.colorScheme.surface,
            ],
          ),
          borderRadius: AppDimens.radiusMediumLarge,
          border: Border.all(
            color: color.withValues(alpha: borderAlpha),
            width: borderWidth,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.28),
                    blurRadius: AppDimens.spaceXl,
                    spreadRadius: 1,
                    offset: const Offset(0, AppDimens.spaceXs),
                  ),
                ]
              : [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.06),
                    blurRadius: AppDimens.spaceMd,
                    offset: const Offset(0, AppDimens.spaceXxs),
                  ),
                ],
        ),
        child: Center(
          child: Container(
            height: AppDimens.avatarMd,
            width: AppDimens.avatarMd,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.72),
              borderRadius: AppDimens.radiusMediumSmall,
              border: Border.all(
                color: color.withValues(alpha: isSelected ? 0.20 : 0.12),
              ),
            ),
            child: Icon(icon, color: color, size: AppDimens.iconXxl),
          ),
        ),
      ),
    );
  }
}
