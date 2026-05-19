import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/checkout/domain/entities/payment_card.entity.dart';

/// Saved-card selector used by checkout.
class SavedCardsSection extends StatelessWidget {
  final AsyncValue<List<SavedPaymentCard>> cardsAsync;
  final String? selectedCardId;
  final ValueChanged<String?> onSelected;
  final VoidCallback onAddCard;

  const SavedCardsSection({
    super.key,
    required this.cardsAsync,
    required this.selectedCardId,
    required this.onSelected,
    required this.onAddCard,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pad = AppDimens.cardPadding(context);
    final radius = AppDimens.cardRadius(context);

    return Container(
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: AppDimens.spaceMd,
            offset: const Offset(0, AppDimens.spaceXxs),
          ),
        ],
      ),
      child: cardsAsync.when(
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimens.spaceMd),
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Saved Cards',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            AppDimens.verticalSmall,
            Text(
              '$error',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
            AppDimens.verticalSmall,
            OutlinedButton.icon(
              onPressed: onAddCard,
              icon: const Icon(Icons.add_card),
              label: const Text('Add card'),
            ),
          ],
        ),
        data: (cards) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Saved Cards',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: onAddCard,
                  icon: const Icon(Icons.add_card),
                  label: const Text('Add card'),
                ),
              ],
            ),
            if (cards.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppDimens.spaceSm),
                child: Text(
                  'Add a card before paying by credit or debit card.',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            else
              ...cards.map(
                (card) => _SavedCardTile(
                  card: card,
                  selected: selectedCardId == card.id,
                  onTap: () => onSelected(card.id),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SavedCardTile extends StatelessWidget {
  final SavedPaymentCard card;
  final bool selected;
  final VoidCallback onTap;

  const _SavedCardTile({
    required this.card,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimens.radiusMediumSmall,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceXs),
        child: Row(
          children: [
            _SelectionIndicator(selected: selected),
            const Icon(Icons.credit_card),
            AppDimens.horizontalMediumSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.maskedLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Expires ${card.expiryLabel}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (card.isDefault) _DefaultBadge(),
          ],
        ),
      ),
    );
  }
}

class _DefaultBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceSm,
        vertical: AppDimens.spaceXxs,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: AppDimens.radiusSmall,
      ),
      child: Text(
        'Default',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SelectionIndicator extends StatelessWidget {
  final bool selected;

  const _SelectionIndicator({required this.selected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: AppDimens.iconLg,
      height: AppDimens.iconLg,
      margin: const EdgeInsets.only(right: AppDimens.spaceSm),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? colorScheme.primary : colorScheme.outline,
          width: AppDimens.borderWidthThick,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: AppDimens.spaceSmMd,
                height: AppDimens.spaceSmMd,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary,
                ),
              ),
            )
          : null,
    );
  }
}
