import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

/// Price breakdown card showing subtotal,
/// service fee, total amount, and a cancellation
/// policy notice.
///
/// Employee-booking-specific clone — not shared
/// with the standard booking flow.
class PriceBreakdownCard extends StatelessWidget {
  const PriceBreakdownCard({
    super.key,
    this.subtotal = 'See at checkout',
    this.serviceFee = '—',
    this.totalAmount = 'See at checkout',
  });

  /// Formatted subtotal string.
  final String subtotal;

  /// Formatted service fee string.
  final String serviceFee;

  /// Formatted total amount string.
  final String totalAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardPad =
        AppDimens.cardPadding(context);

    return Container(
      padding: EdgeInsets.all(cardPad),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(
          AppDimens.cardRadius(context),
        ),
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            icon: Symbols.payments,
            label: 'Price Breakdown',
          ),
          SizedBox(height: AppDimens.spaceLg),
          _PriceRow(
            label: 'Subtotal',
            value: subtotal,
          ),
          SizedBox(height: AppDimens.spaceMd),
          _PriceRow(
            label: 'Service Fee',
            value: serviceFee,
          ),
          SizedBox(height: AppDimens.spaceMd),
          _DashedDivider(),
          SizedBox(height: AppDimens.spaceMd),
          _TotalRow(totalAmount: totalAmount),
          SizedBox(height: AppDimens.spaceLg),
          _PolicyNotice(),
        ],
      ),
    );
  }
}

/// Single price line item row.
class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall
              ?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodySmall
              ?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Dashed horizontal divider.
class _DashedDivider extends StatelessWidget {
  const _DashedDivider();

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        const dashWidth = 4.0;
        const dashSpace = 3.0;
        final dashCount =
            (constraints.maxWidth /
                    (dashWidth + dashSpace))
                .floor();
        return Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children:
              List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme
                      .outlineVariant
                      .withValues(alpha: 0.5),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Bold total row with primary-colored amount.
class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.totalAmount});

  final String totalAmount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Amount',
          style: theme.textTheme.titleSmall
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          totalAmount,
          style: theme.textTheme.titleMedium
              ?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

/// Info banner with cancellation policy note.
class _PolicyNotice extends StatelessWidget {
  const _PolicyNotice();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding:
          EdgeInsets.all(AppDimens.spaceMd),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer
            .withValues(alpha: 0.15),
        borderRadius:
            AppDimens.radiusMediumSmall,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Symbols.info,
            size: AppDimens.iconSmMd,
            color: colorScheme.primary,
          ),
          SizedBox(width: AppDimens.spaceMd),
          Expanded(
            child: Text(
              'By clicking "Confirm & Pay", you '
              'agree to our cancellation policy '
              'and terms of service.',
              style: theme.textTheme.labelSmall
                  ?.copyWith(
                color: colorScheme.primary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Uppercase section header with icon.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(
          icon,
          size: AppDimens.iconMd,
          color: colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppDimens.spaceSm),
        Text(
          label.toUpperCase(),
          style: theme.textTheme.labelSmall
              ?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
