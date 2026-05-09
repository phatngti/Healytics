import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:user_app/core/widgets/main_screen_layout.widget.dart';

/// Standard layout for home "View all" screens.
class HomeListScreenLayout extends StatelessWidget {
  const HomeListScreenLayout({
    super.key,
    required this.title,
    required this.body,
  });

  /// App bar title.
  final String title;

  /// Screen content.
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return MainScreenLayout(
      appBar: _HomeListAppBar(
        title: title,
        onBack: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/home');
          }
        },
      ),
      body: body,
    );
  }
}

class _HomeListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeListAppBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: colorScheme.surface,
      centerTitle: true,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: colorScheme.surface,
      leadingWidth: AppDimens.touchTarget + AppDimens.spaceMd,
      leading: Padding(
        padding: EdgeInsets.only(left: AppDimens.spaceMd),
        child: Center(
          child: IconButton(
            onPressed: onBack,
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: AppDimens.iconMd,
            color: colorScheme.onSurfaceVariant,
            style: IconButton.styleFrom(
              minimumSize: const Size.square(AppDimens.touchTarget),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: AppDimens.radiusMediumSmall,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: AppDimens.fontWeightSemiBold,
          color: colorScheme.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(AppDimens.borderWidth),
        child: Divider(
          height: AppDimens.borderWidth,
          thickness: AppDimens.borderWidth,
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
