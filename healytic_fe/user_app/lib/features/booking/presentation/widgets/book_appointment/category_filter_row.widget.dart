import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

import '../../../../../theme/app_theme.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';

/// 3-column grid of circular category icons with
/// labels. Tapping selects a category; the selected
/// item gets a coloured ring and elevated shadow.
class CategoryFilterRow extends StatelessWidget {
  const CategoryFilterRow({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<HomeCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.0,
      crossAxisSpacing: 0,
      mainAxisSpacing: 0,
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

/// Single circular icon + label.
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
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgAlpha = isSelected ? 0.18 : 0.10;
    final borderAlpha = isSelected ? 0.55 : 0.20;
    final borderWidth = isSelected ? 2.5 : 1.0;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
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
          ),
          SizedBox(height: AppDimens.spaceSm),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
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
