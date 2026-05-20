import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The top-level adaptive scaffold for the app's shell route.
///
/// Wraps a [StatefulNavigationShell] from GoRouter with a
/// bottom [NavigationBar] containing Home, Orders, Chat,
/// Notifications, and Profile destinations.
///
/// This widget acts as the persistent frame around all branch routes,
/// preserving navigation state across tabs.
///
/// ```dart
/// // In your GoRouter config:
/// StatefulShellRoute.indexedStack(
///   builder: (context, state, navigationShell) =>
///       AdaptiveRootScraffold(navigationShell: navigationShell),
///   branches: [ /* ... */ ],
/// )
/// ```
class AdaptiveRootScraffold extends HookConsumerWidget {
  /// Creates an [AdaptiveRootScraffold].
  ///
  /// - [navigationShell] — The GoRouter shell that manages branch navigation.
  /// - [destinationKeys] — Optional keys for each destination (for integration tests).
  const AdaptiveRootScraffold({
    super.key,
    required this.navigationShell,
    this.destinationKeys,
    this.notificationBadgeCount = 0,
  });

  /// The stateful navigation shell managing tab-based branch routing.
  final StatefulNavigationShell navigationShell;

  /// Optional keys for each [NavigationDestination].
  ///
  /// Must match the number of destinations if provided.
  final List<Key>? destinationKeys;

  /// Optional unread notification badge count.
  ///
  /// When > 0, a badge is shown on the
  /// Notifications tab icon.
  final int notificationBadgeCount;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = navigationShell.currentIndex;

    final notifIcon = notificationBadgeCount > 0
        ? Badge.count(
            count: notificationBadgeCount,
            child: const Icon(Icons.notifications),
          )
        : const Icon(Icons.notifications);

    final destinations = [
      NavigationDestination(
        key: destinationKeys?.elementAtOrNull(0),
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      NavigationDestination(
        key: destinationKeys?.elementAtOrNull(1),
        icon: Icon(Symbols.order_approve),
        label: 'Orders',
      ),
      NavigationDestination(
        key: destinationKeys?.elementAtOrNull(2),
        icon: Icon(Symbols.support_agent_rounded),
        label: 'Chat',
      ),
      NavigationDestination(
        key: destinationKeys?.elementAtOrNull(3),
        icon: notifIcon,
        label: 'Notifications',
      ),
      NavigationDestination(
        key: destinationKeys?.elementAtOrNull(4),
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return _CustomAdaptiveScaffold(
      selectedIndex: selectedIndex,
      onSelectedIndexChange: (index) {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      },
      destinations: destinations,
      bottomDestinationRange: (0, null),
      body: navigationShell,
    );
  }
}

/// Internal scaffold implementation that renders a [NavigationBar]
/// with offset-aware selection for displaying a subset of destinations.
///
/// Handles the mapping between the visible destination index and the
/// full destination list index via [bottomDestinationRange].
class _CustomAdaptiveScaffold extends HookConsumerWidget {
  /// Creates a [_CustomAdaptiveScaffold].
  ///
  /// - [selectedIndex] — Currently selected destination index (global).
  /// - [onSelectedIndexChange] — Callback when user selects a destination.
  /// - [destinations] — Full list of navigation destinations.
  /// - [bottomDestinationRange] — Tuple (start, end?) slicing the destinations shown.
  /// - [body] — The main content widget (usually the navigation shell).
  const _CustomAdaptiveScaffold({
    required this.selectedIndex,
    required this.onSelectedIndexChange,
    required this.destinations,
    required this.bottomDestinationRange,
    required this.body,
  });

  /// The currently active destination index in the full list.
  final int selectedIndex;

  /// Called with the full-list index when the user taps a destination.
  final Function(int) onSelectedIndexChange;

  /// All navigation destinations available.
  final List<NavigationDestination> destinations;

  /// Range tuple (start, end?) defining which destinations appear in the bottom bar.
  final (int, int?) bottomDestinationRange;

  /// The main body content widget.
  final Widget body;

  int? selectedWithOffset((int, int?) range) {
    final index = selectedIndex - range.$1;
    return index < 0 || (range.$2 != null && index > (range.$2! - 1))
        ? null
        : index;
  }

  List<NavigationDestination> destinationsSlice((int, int?) range) =>
      destinations.sublist(range.$1, range.$2);

  void selectWithOffset(int index, (int, int?) range) =>
      onSelectedIndexChange(index + range.$1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: body,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: Theme.of(context).colorScheme.onSurface,
            );
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return Theme.of(context).iconTheme.copyWith(
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              );
            }
            return Theme.of(context).iconTheme.copyWith(size: 24);
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectedWithOffset(bottomDestinationRange) ?? 0,
          destinations: destinationsSlice(bottomDestinationRange),
          onDestinationSelected: (index) =>
              selectWithOffset(index, bottomDestinationRange),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
        ),
      ),
    );
  }
}
