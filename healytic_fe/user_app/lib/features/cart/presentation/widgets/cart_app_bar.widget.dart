import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Cart screen app bar with back button, search field,
/// share and overflow menu actions.
///
/// The search field filters items client-side by name.
class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback invoked when search text changes.
  final ValueChanged<String>? onSearchChanged;

  const CartAppBar({super.key, this.onSearchChanged});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0.5,
      shadowColor: colorScheme.shadow.withValues(alpha: 0.1),
      titleSpacing: AppDimens.spaceSm,
      leadingWidth: 48 + AppDimens.spaceMd,
      leading: Padding(
        padding: const EdgeInsets.only(left: AppDimens.spaceMd),
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      title: SizedBox(
        height: AppDimens.ctaButtonMd,
        child: TextField(
          onChanged: onSearchChanged,
          style: textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Search items in cart...',
            hintStyle: textTheme.bodyMedium?.copyWith(
              color: colorScheme.outline,
            ),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppDimens.spaceXs,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: AppDimens.spaceMd),
              child: Icon(
                Icons.search,
                size: AppDimens.iconSmMd,
                color: colorScheme.outline,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: AppDimens.radiusPill,
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          tooltip: 'Share',
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          tooltip: 'More options',
          onPressed: () {},
        ),
        const SizedBox(width: AppDimens.spaceXs),
      ],
    );
  }
}
