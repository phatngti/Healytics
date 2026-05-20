import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_products.provider.dart';

/// Horizontal scrolling list of category chips.
///
/// Selected chip uses primary bg + onPrimary text.
/// Unselected chip uses surfaceContainerHighest bg.
class CategoryScroller extends ConsumerWidget {
  const CategoryScroller({super.key, required this.categories});

  final List<ClinicProductCategory> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(clinicProductCategoryProvider);

    return SizedBox(
      height: AppDimens.ctaButtonMd,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context),
        ),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppDimens.spaceSm),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category.id == selectedId;

          return _CategoryChip(
            label: category.label,
            isSelected: isSelected,
            onTap: () => ref
                .read(clinicProductCategoryProvider.notifier)
                .select(category.id),
          );
        },
      ),
    );
  }
}

/// Individual category chip button.
class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: '$label category',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
            vertical: AppDimens.spaceXs + AppDimens.spaceXxs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.surfaceContainerHighest,
            borderRadius: AppDimens.radiusSmall,
          ),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}
