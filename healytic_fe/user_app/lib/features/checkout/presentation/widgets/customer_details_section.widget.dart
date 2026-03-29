import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';

/// Displays customer name, phone, and address with
/// a person icon and an "Edit" button.
class CustomerDetailsSection extends StatelessWidget {
  final CustomerDetails customer;

  const CustomerDetailsSection({
    super.key,
    required this.customer,
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
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.05),
            blurRadius: AppDimens.spaceXl,
            offset: const Offset(
              0,
              AppDimens.spaceXs,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(colorScheme: colorScheme),
          AppDimens.verticalMediumSmall,
          _Content(
            customer: customer,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
        ],
      ),
    );
  }
}

/// Section header with icon, title, and edit button.
class _Header extends StatelessWidget {
  final ColorScheme colorScheme;

  const _Header({required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.person,
              color: colorScheme.primary,
              size: AppDimens.iconSm,
            ),
            AppDimens.horizontalSmall,
            Text(
              'Customer Details',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // TODO: navigate to edit customer details
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(
              AppDimens.touchTarget,
              AppDimens.avatarSm,
            ),
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Edit',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

/// Customer contact details with a left border accent.
class _Content extends StatelessWidget {
  final CustomerDetails customer;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _Content({
    required this.customer,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: AppDimens.spaceSm,
      ),
      padding: const EdgeInsets.only(
        left: AppDimens.spaceLg,
      ),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: colorScheme.outlineVariant,
            width: AppDimens.borderWidthThick,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customer.name,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          AppDimens.verticalExtraSmall,
          Text(
            customer.phone,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(
            height: AppDimens.spaceXxs,
          ),
          Text(
            customer.address,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
