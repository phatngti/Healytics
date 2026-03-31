import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';

class HomeHeader extends StatelessWidget {
  final String userName;

  const HomeHeader({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
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
      color: colorScheme.surface.withValues(alpha: 0.8),
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
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _HeaderIconButton(
                icon: Symbols.shopping_cart,
                tooltip: 'Shopping cart',
                onTap: () {},
              ),
              SizedBox(width: AppDimens.spaceMd),
              _HeaderIconButton(
                icon: Symbols.settings,
                tooltip: 'Settings',
                onTap: () {},
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
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: AppDimens.iconLg,
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
