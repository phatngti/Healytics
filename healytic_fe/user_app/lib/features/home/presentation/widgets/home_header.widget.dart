import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';
import 'package:user_app/core/providers/location.provider.dart';
import 'package:user_app/features/cart/presentation/providers/cart.provider.dart';
import 'package:user_app/router/routes.dart';

class HomeHeader extends ConsumerWidget {
  final String userName;
  final String? avatarUrl;

  const HomeHeader({super.key, required this.userName, this.avatarUrl});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartBadgeCountProvider);
    final locationAsync = ref.watch(currentLocationAddressProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final hPadding = AppDimens.horizontalPadding(context);
    final contentPad = AppDimens.contentPadding(context);

    return Container(
      padding: EdgeInsets.only(
        left: hPadding,
        right: hPadding,
        top: hPadding,
        bottom: contentPad,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      width: AppDimens.borderWidthThick,
                    ),
                  ),
                  child: AvatarImage(
                    name: userName,
                    imageUrl: avatarUrl,
                    radius: AppDimens.avatarMd / 2,
                  ),
                ),
                SizedBox(width: AppDimens.spaceMd),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning,',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        userName,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      _LocationAddress(locationAsync: locationAsync),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Badge(
                isLabelVisible: cartCount > 0,
                label: Text(
                  '$cartCount',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onError,
                  ),
                ),
                backgroundColor: colorScheme.error,
                child: _HeaderIconButton(
                  key: keys.homePage.cartButton,
                  icon: Symbols.shopping_cart,
                  tooltip: 'Shopping cart',
                  onTap: () => const CartRoute().push(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _HeaderIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pad = AppDimens.contentPadding(context);

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppDimens.radiusPill,
        child: Container(
          padding: EdgeInsets.all(pad),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: colorScheme.outlineVariant),
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: AppDimens.spaceXxs,
                offset: Offset(0, AppDimens.spaceXxs),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: AppDimens.iconMd,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _LocationAddress extends StatelessWidget {
  final AsyncValue<String?> locationAsync;

  const _LocationAddress({required this.locationAsync});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return locationAsync.when(
      data: (address) {
        if (address == null || address.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: EdgeInsets.only(top: AppDimens.spaceXxs),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  address + ' ',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.location_on_outlined,
                size: AppDimens.iconSm,
                color: colorScheme.primary,
              ),
            ],
          ),
        );
      },
      loading: () => Padding(
        padding: EdgeInsets.only(top: AppDimens.spaceXxs),
        child: Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: AppDimens.iconSm,
              color: colorScheme.outline,
            ),
            SizedBox(width: AppDimens.spaceXxs),
            SizedBox(
              width: 80,
              height: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: AppDimens.radiusMd,
                ),
              ),
            ),
          ],
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
