import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/orders/domain/entities/appointment.entity.dart';
import 'package:user_app/features/orders/presentation/providers/appointment.provider.dart';

/// Horizontal scrolling category filter chips
/// for narrowing appointments by type.
class CategoryFilters extends HookConsumerWidget {
  const CategoryFilters({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncCategories = ref.watch(appointmentCategoriesProvider);
    final selectedId = ref.watch(selectedCategoryProvider);

    return switch (asyncCategories) {
      AsyncData(:final value) => Padding(
        padding: EdgeInsets.only(
          left: AppDimens.spaceLg,
          top: AppDimens.spaceLg,
        ),
        child: SizedBox(
          height: AppDimens.ctaButtonMd,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount:
                _visibleCategories(value).length +
                (selectedId == kCategoryAllFilterId ? 0 : 1),
            separatorBuilder: (_, __) => AppDimens.horizontalMediumSmall,
            padding: EdgeInsets.only(right: AppDimens.spaceLg),
            itemBuilder: (context, index) {
              final hasActiveFilter = selectedId != kCategoryAllFilterId;
              if (hasActiveFilter && index == 0) {
                return _ClearFilterChip(
                  onTap: () =>
                      ref.read(selectedCategoryProvider.notifier).clear(),
                );
              }

              final categories = _visibleCategories(value);
              final cat = categories[index - (hasActiveFilter ? 1 : 0)];
              final isActive = cat.id == selectedId;
              return _CategoryChip(
                category: cat,
                isActive: isActive,
                onTap: () =>
                    ref.read(selectedCategoryProvider.notifier).select(cat.id),
              );
            },
          ),
        ),
      ),
      AsyncError() => const SizedBox.shrink(),
      _ => const Padding(
        padding: AppDimens.paddingAllMedium,
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    };
  }

  List<AppointmentCategory> _visibleCategories(
    List<AppointmentCategory> categories,
  ) {
    return categories
        .where((cat) => cat.id != kCategoryAllFilterId)
        .toList(growable: false);
  }
}

// ─── Single category chip ──────────────────────────

class _ClearFilterChip extends StatelessWidget {
  const _ClearFilterChip({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Tooltip(
      message: 'Clear category filter',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppDimens.radiusMediumLarge,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.spaceLg,
              vertical: AppDimens.spaceSm,
            ),
            decoration: BoxDecoration(
              borderRadius: AppDimens.radiusMediumLarge,
              border: Border.all(color: colors.outlineVariant),
              color: colors.surfaceContainerLow,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.close,
                  size: AppDimens.iconSm,
                  color: colors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  'Clear',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.category,
    required this.isActive,
    required this.onTap,
  });

  final AppointmentCategory category;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final icon = _resolveIcon(category.iconSlug);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusMediumLarge,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.spaceXl,
            vertical: AppDimens.spaceSm,
          ),
          decoration: BoxDecoration(
            borderRadius: AppDimens.radiusMediumLarge,
            border: Border.all(
              color: isActive ? colors.primary : colors.outlineVariant,
            ),
            color: isActive
                ? colors.primary.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppDimens.iconSm,
                color: isActive ? colors.primary : colors.onSurfaceVariant,
              ),
              // 6dp contextual chip spacing
              const SizedBox(width: 6),
              Text(
                category.name,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: isActive ? colors.primary : colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _resolveIcon(String slug) {
    return switch (slug) {
      'check_circle_outline' => Icons.check_circle_outline,
      'spa' => Symbols.spa,
      'self_improvement' => Symbols.self_improvement,
      'face' => Symbols.face,
      _ => Icons.category,
    };
  }
}
