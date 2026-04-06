import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_review.entity.dart';
import 'package:user_app/features/clinic_info/presentation/providers/clinic_reviews.provider.dart';

/// Horizontal scrolling filter pills for reviews.
///
/// Selected pill uses primary bg + onPrimary text.
/// Unselected pill uses surface bg + outline border.
class ReviewFilterPills extends ConsumerWidget {
  const ReviewFilterPills({
    super.key,
    required this.filters,
  });

  final List<ClinicReviewFilter> filters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedId =
        ref.watch(clinicReviewFilterProvider);

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.symmetric(
        vertical: AppDimens.spaceMd,
      ),
      child: SizedBox(
        height: AppDimens.ctaButtonMd,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal:
                AppDimens.horizontalPadding(context),
          ),
          itemCount: filters.length,
          separatorBuilder: (_, __) =>
              const SizedBox(width: AppDimens.spaceSm),
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = filter.id == selectedId;

            return _FilterPill(
              label: filter.label,
              isSelected: isSelected,
              onTap: () => ref
                  .read(
                    clinicReviewFilterProvider.notifier,
                  )
                  .select(filter.id),
            );
          },
        ),
      ),
    );
  }
}

/// Individual filter pill button.
class _FilterPill extends StatelessWidget {
  const _FilterPill({
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
      label: '$label filter',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceLg,
            vertical: AppDimens.spaceXs +
                AppDimens.spaceXxs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.surface,
            borderRadius: AppDimens.radiusExtraSmall,
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: isSelected
                  ? FontWeight.w600
                  : FontWeight.w500,
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
