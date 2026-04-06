import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_product.entity.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_products.provider.dart';

/// Horizontal row of sort options (Popular, Latest,
/// Top Sales, Price) with a trailing filter icon.
///
/// Active sort is highlighted with primary color.
class SortFilterBar extends ConsumerWidget {
  const SortFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeSort = ref.watch(clinicProductSortProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.2),
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.horizontalPadding(context),
        ),
        child: Row(
          children: [
            _SortButton(
              label: 'Popular',
              isActive: activeSort == ClinicProductSort.popular,
              onTap: () => ref
                  .read(clinicProductSortProvider.notifier)
                  .select(ClinicProductSort.popular),
            ),
            const SizedBox(width: AppDimens.spaceLg),
            _SortButton(
              label: 'Latest',
              isActive: activeSort == ClinicProductSort.latest,
              onTap: () => ref
                  .read(clinicProductSortProvider.notifier)
                  .select(ClinicProductSort.latest),
            ),
            const SizedBox(width: AppDimens.spaceLg),
            _SortButton(
              label: 'Top Sales',
              isActive: activeSort == ClinicProductSort.topSales,
              onTap: () => ref
                  .read(clinicProductSortProvider.notifier)
                  .select(ClinicProductSort.topSales),
            ),
            const SizedBox(width: AppDimens.spaceLg),
            _PriceSortButton(activeSort: activeSort),
            const SizedBox(width: AppDimens.spaceLg),
            const _FilterButton(),
          ],
        ),
      ),
    );
  }
}

/// Individual sort button with active/inactive styling.
///
/// Wraps content in a [SizedBox] to ensure the touch
/// target meets the 48dp minimum height guideline.
class _SortButton extends StatelessWidget {
  const _SortButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: isActive,
      label: '$label sort',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: AppDimens.touchTarget,
          child: Center(
            child: Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                color: isActive
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Price sort button with toggle icon (unfold_more).
class _PriceSortButton extends ConsumerWidget {
  const _PriceSortButton({required this.activeSort});

  final ClinicProductSort activeSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isActive =
        activeSort == ClinicProductSort.priceAsc ||
        activeSort == ClinicProductSort.priceDesc;

    return Semantics(
      button: true,
      selected: isActive,
      label: 'Price sort',
      child: GestureDetector(
        onTap: () => ref.read(clinicProductSortProvider.notifier).togglePrice(),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: AppDimens.touchTarget,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Price',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXxs),
                Icon(
                  Icons.unfold_more,
                  size: AppDimens.iconXs,
                  color: isActive
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Trailing filter icon button.
class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      label: 'Filter products',
      child: GestureDetector(
        onTap: () {
          // TODO(product): Open filter bottom sheet
        },
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: AppDimens.touchTarget,
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Filter',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceXs),
                Icon(
                  Icons.filter_alt_outlined,
                  size: AppDimens.iconSm,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
