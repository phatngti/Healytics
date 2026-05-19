import 'package:common/utils/demensions.dart';
import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:user_app/features/checkout/domain/entities/payment_card.entity.dart';
import 'package:user_app/features/checkout/presentation/providers/saved_cards.provider.dart';

class PaymentCardsScreen extends ConsumerWidget {
  const PaymentCardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(savedPaymentCardsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Cards'),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCard(context, ref),
        icon: const Icon(Icons.add_card),
        label: const Text('Add card'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(ref),
        child: cardsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            children: [
              Icon(
                Icons.credit_card_off,
                size: AppDimens.avatarLg,
                color: colorScheme.error,
              ),
              AppDimens.verticalMedium,
              Text(
                '$error',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
              ),
            ],
          ),
          data: (cards) {
            if (cards.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.18),
                  Icon(
                    Icons.add_card,
                    size: AppDimens.avatarLg,
                    color: colorScheme.primary,
                  ),
                  AppDimens.verticalMedium,
                  Text(
                    'No saved cards',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AppDimens.verticalSmall,
                  Text(
                    'Add a card to use credit or debit card checkout.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              );
            }

            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceLg,
                AppDimens.spaceLg,
                AppDimens.spaceLg,
                AppDimens.spaceXxl * 3,
              ),
              itemBuilder: (context, index) => _PaymentCardManagementTile(
                card: cards[index],
                onSetDefault: cards[index].isDefault
                    ? null
                    : () => _setDefault(context, ref, cards[index].id),
                onDelete: () => _confirmDelete(context, ref, cards[index]),
              ),
              separatorBuilder: (_, _) => AppDimens.verticalMedium,
              itemCount: cards.length,
            );
          },
        ),
      ),
    );
  }

  Future<void> _refresh(WidgetRef ref) async {
    ref.invalidate(savedPaymentCardsProvider);
    await ref.read(savedPaymentCardsProvider.future);
  }

  Future<void> _addCard(BuildContext context, WidgetRef ref) async {
    try {
      final cards =
          ref.read(savedPaymentCardsProvider).asData?.value ?? const [];
      await ref
          .read(savedPaymentCardsControllerProvider)
          .addCard(setDefault: cards.isEmpty);
      if (!context.mounted) return;
      AppToast.success(context, 'Card added.');
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) return;
      if (!context.mounted) return;
      AppToast.error(
        context,
        e.error.localizedMessage ?? 'Unable to add card.',
      );
    } catch (e) {
      if (!context.mounted) return;
      AppToast.error(context, '$e');
    }
  }

  Future<void> _setDefault(
    BuildContext context,
    WidgetRef ref,
    String cardId,
  ) async {
    try {
      await ref.read(savedPaymentCardsControllerProvider).setDefault(cardId);
      if (!context.mounted) return;
      AppToast.success(context, 'Default card updated.');
    } catch (e) {
      if (!context.mounted) return;
      AppToast.error(context, '$e');
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SavedPaymentCard card,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Remove card'),
        content: Text('Remove ${card.maskedLabel}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(savedPaymentCardsControllerProvider).delete(card.id);
      if (!context.mounted) return;
      AppToast.success(context, 'Card removed.');
    } catch (e) {
      if (!context.mounted) return;
      AppToast.error(context, '$e');
    }
  }
}

class _PaymentCardManagementTile extends StatelessWidget {
  final SavedPaymentCard card;
  final VoidCallback? onSetDefault;
  final VoidCallback onDelete;

  const _PaymentCardManagementTile({
    required this.card,
    required this.onSetDefault,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: AppDimens.avatarMd,
            height: AppDimens.avatarMd,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppDimens.radiusSmall,
            ),
            child: Icon(
              Icons.credit_card,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        card.maskedLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    if (card.isDefault) ...[
                      AppDimens.horizontalSmall,
                      _DefaultBadge(),
                    ],
                  ],
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  'Expires ${card.expiryLabel}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Card actions',
            onSelected: (value) {
              if (value == 'default') onSetDefault?.call();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'default',
                enabled: onSetDefault != null,
                child: const Text('Set default'),
              ),
              const PopupMenuItem(value: 'delete', child: Text('Remove')),
            ],
          ),
        ],
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
