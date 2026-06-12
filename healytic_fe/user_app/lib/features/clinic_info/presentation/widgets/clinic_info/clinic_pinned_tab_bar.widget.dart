import 'package:flutter/material.dart';
import 'package:user_app/core/keys/integration_test_keys.dart';

/// Height of the clinic tab bar used as both
/// [maxExtent] and [minExtent] so it never resizes.
const kClinicTabBarHeight = 48.0;

/// Persistent header delegate that pins the clinic
/// tab bar below the collapsed SliverAppBar.
///
/// Wraps a [TabBar] with the project's standard
/// styling and renders a bottom border separator.
class ClinicPinnedTabBarDelegate extends SliverPersistentHeaderDelegate {
  const ClinicPinnedTabBarDelegate({
    required this.tabController,
    required this.tabLabels,
  });

  /// Controller shared with the [TabBarView].
  final TabController tabController;

  /// Labels for each tab.
  final List<String> tabLabels;

  @override
  double get maxExtent => kClinicTabBarHeight;

  @override
  double get minExtent => kClinicTabBarHeight;

  @override
  bool shouldRebuild(covariant ClinicPinnedTabBarDelegate old) {
    return tabController != old.tabController;
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: TabBar(
        controller: tabController,
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurfaceVariant,
        labelStyle: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: colorScheme.primary,
        indicatorWeight: 2,
        tabs: tabLabels
            .map(
              (label) => Tab(
                key: keys.clinicPage.tab(label.toLowerCase()),
                text: label,
              ),
            )
            .toList(),
      ),
    );
  }
}
