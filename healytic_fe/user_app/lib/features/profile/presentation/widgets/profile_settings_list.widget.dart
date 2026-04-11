import 'package:flutter/material.dart';
import 'package:common/utils/demensions.dart';

/// Settings menu with tappable rows inside a
/// rounded container. Each row has a leading icon,
/// title, and a chevron trailing icon.
class ProfileSettingsList extends StatelessWidget {
  const ProfileSettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final items = _settingsItems;
    final colorScheme = Theme.of(context).colorScheme;
    final cardRad = AppDimens.cardRadius(context);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(cardRad),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          items.length,
          (i) => _SettingsRow(
            icon: items[i].icon,
            title: items[i].title,
            onTap: items[i].onTap,
            showDivider: i < items.length - 1,
          ),
        ),
      ),
    );
  }
}

// ─── Settings Item Data ─────────────────────────

class _SettingsItemData {
  const _SettingsItemData({
    required this.icon,
    required this.title,
    // ignore: unused_element_parameter
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
}

/// Static list of profile settings items.
/// Add callbacks when navigation targets are ready.
final _settingsItems = <_SettingsItemData>[
  const _SettingsItemData(icon: Icons.payment, title: 'Payment Methods'),
  const _SettingsItemData(
    icon: Icons.shield_outlined,
    title: 'Security & Privacy',
  ),
  const _SettingsItemData(
    icon: Icons.help_center_outlined,
    title: 'Help Center',
  ),
];

// ─── Single Row ─────────────────────────────────

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.showDivider,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final contentPad = AppDimens.cardPadding(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap ?? () {},
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: contentPad,
              vertical: contentPad,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: AppDimens.iconLg,
                  color: colorScheme.onSurfaceVariant,
                ),
                SizedBox(width: AppDimens.spaceLg),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: AppDimens.iconLg,
                  color: colorScheme.outlineVariant,
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 0.5,
            indent: contentPad,
            endIndent: contentPad,
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
      ],
    );
  }
}
