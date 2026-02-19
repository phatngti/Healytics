import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';

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
                  height: AppDimens.avatarMd,
                  width: AppDimens.avatarMd,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.2),
                      width: AppDimens.borderWidthThick,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAHFOX7h9F48tcGwMIcEIfkFIO_BCb-TwyhCGYTSYlivBYYPeitHy4W3oeX4l3dEEfJb_yZupssfa2sclSZPLyXfEG5q3pl2sx39c1coakQeOePB7aFA1dAPE3Ra0lpxaiQawpTpkWJktpcY7JCrjO_VPaGyAgzVQM37ZX_Y0pjSESxXa_IpilQ3wPqplOIkK3Rv_S_u-cz9aZh75qv45DoVVZ9RQ3Jl9ta2otLB3h_v3CdJg2ZGgoU5oVyRGojV_h0ciQfIgAJaK6I',
                      fit: BoxFit.cover,
                      semanticLabel: 'User avatar',
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.person,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
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
