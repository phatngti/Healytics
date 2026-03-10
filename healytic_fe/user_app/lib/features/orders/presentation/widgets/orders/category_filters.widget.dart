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
        padding: const EdgeInsets.only(left: 16, top: 16),
        child: SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: value.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            padding: const EdgeInsets.only(right: 16),
            itemBuilder: (context, index) {
              final cat = value[index];
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
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
    };
  }
}

// ─── Single category chip ──────────────────────────

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
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
                size: 16,
                color: isActive ? colors.primary : colors.onSurfaceVariant,
              ),
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
