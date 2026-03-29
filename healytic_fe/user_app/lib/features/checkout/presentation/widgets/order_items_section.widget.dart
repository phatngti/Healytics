import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';

/// Displays the list of order items with clinic header,
/// images, pricing, and quantity.
class OrderItemsSection extends StatelessWidget {
  final List<CheckoutItem> items;

  const OrderItemsSection({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceXs,
          ),
          child: Text(
            'Order Items (${items.length})',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        AppDimens.verticalMedium,
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(
              bottom: AppDimens.spaceMd,
            ),
            child: _OrderItemCard(item: item),
          ),
        ),
      ],
    );
  }
}

/// Card displaying a single order item with clinic
/// header, image, details, and pricing.
class _OrderItemCard extends StatelessWidget {
  final CheckoutItem item;

  const _OrderItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final radius = AppDimens.cardRadius(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: colorScheme.outlineVariant
              .withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.08),
            blurRadius: AppDimens.spaceMd,
            offset: const Offset(
              0,
              AppDimens.spaceXxs,
            ),
          ),
          BoxShadow(
            color: colorScheme.shadow
                .withValues(alpha: 0.04),
            blurRadius: AppDimens.spaceXxl,
            offset: const Offset(
              0,
              AppDimens.spaceXs + 2,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ClinicHeader(
            item: item,
            topRadius: radius,
          ),
          Padding(
            padding: EdgeInsets.all(
              AppDimens.contentPadding(context),
            ),
            child: Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                _ItemImage(imageUrl: item.imageUrl),
                AppDimens.horizontalMedium,
                Expanded(
                  child: _ItemDetails(item: item),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Item thumbnail image with rounded corners.
class _ItemImage extends StatelessWidget {
  final String imageUrl;

  const _ItemImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: AppDimens.radiusMediumSmall,
      child: Container(
        width: AppDimens.adaptive(
          context,
          small: 72,
          medium: 80,
          large: 88,
        ),
        height: AppDimens.adaptive(
          context,
          small: 72,
          medium: 80,
          large: 88,
        ),
        color: colorScheme.surfaceContainerHighest,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.image_not_supported_outlined,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

/// Name, tags, and pricing details for an item.
class _ItemDetails extends StatelessWidget {
  final CheckoutItem item;

  const _ItemDetails({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        AppDimens.verticalExtraSmall,
        _ItemTags(item: item),
        AppDimens.verticalSmall,
        _PriceRow(item: item),
      ],
    );
  }
}

/// Duration and specialist name tags.
class _ItemTags extends StatelessWidget {
  final CheckoutItem item;

  const _ItemTags({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spaceXs + 2,
            vertical: AppDimens.spaceXxs,
          ),
          decoration: BoxDecoration(
            color:
                colorScheme.surfaceContainerHighest,
            borderRadius: AppDimens.radiusExtraSmall,
          ),
          child: Text(
            item.duration,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        AppDimens.horizontalSmall,
        Expanded(
          child: Text(
            item.specialistName,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Original and discounted price with quantity.
class _PriceRow extends StatelessWidget {
  final CheckoutItem item;

  const _PriceRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              _formatCurrency(item.originalPrice),
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                decoration:
                    TextDecoration.lineThrough,
              ),
            ),
            Text(
              _formatCurrency(item.discountedPrice),
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        Text(
          'x${item.quantity}',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _formatCurrency(int amount) {
    final formatted =
        amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    return '$formattedđ';
  }
}

/// Header showing clinic icon, name, and address.
class _ClinicHeader extends StatelessWidget {
  final CheckoutItem item;
  final double topRadius;

  const _ClinicHeader({
    required this.item,
    required this.topRadius,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final pad = AppDimens.contentPadding(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: pad + 2,
        vertical: pad - 2,
      ),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer
            .withValues(alpha: 0.35),
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _vendorIconData,
            size: AppDimens.iconSm,
            color: colorScheme.primary,
          ),
          AppDimens.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.vendorName,
                  style:
                      textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (item.vendorAddress.isNotEmpty)
                  Text(
                    item.vendorAddress,
                    style: textTheme.labelSmall
                        ?.copyWith(
                      color: colorScheme
                          .onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData get _vendorIconData {
    return switch (item.vendorIcon) {
      'local_hospital' => Icons.local_hospital,
      'spa' => Icons.spa,
      _ => Icons.storefront,
    };
  }
}
