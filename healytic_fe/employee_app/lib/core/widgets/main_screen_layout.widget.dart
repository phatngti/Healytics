import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../keys/integration_test_keys.dart';

/// Main scaffold with bottom navigation.
class MainScreenLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreenLayout({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            key: keys.bottomNav.appointmentsTab,
            icon: const Icon(Icons.calendar_today_outlined),
            selectedIcon: const Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          NavigationDestination(
            key: keys.bottomNav.revenueTab,
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: const Icon(Icons.bar_chart),
            label: 'Revenue',
          ),
          NavigationDestination(
            key: keys.bottomNav.profileTab,
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
