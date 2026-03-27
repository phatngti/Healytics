import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';

class AdaptiveRootScraffold extends HookConsumerWidget {
  const AdaptiveRootScraffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = navigationShell.currentIndex;

    final destinations = [
      NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      NavigationDestination(icon: Icon(Symbols.order_approve), label: 'Orders'),
      NavigationDestination(
        icon: Icon(Symbols.support_agent_rounded),
        label: 'Chat',
      ),
      NavigationDestination(
        icon: Icon(Icons.notifications),
        label: 'Notifications',
      ),
      NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
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

class _CustomAdaptiveScaffold extends HookConsumerWidget {
  const _CustomAdaptiveScaffold({
    required this.selectedIndex,
    required this.onSelectedIndexChange,
    required this.destinations,
    required this.bottomDestinationRange,
    required this.body,
  });

  final int selectedIndex;
  final Function(int) onSelectedIndexChange;
  final List<NavigationDestination> destinations;
  final (int, int?) bottomDestinationRange;
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
