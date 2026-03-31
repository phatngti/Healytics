import 'dart:developer';

import 'package:admin_panel/core/entities/role.entity.dart';
import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/router/admin_routes.dart' as admin;
import 'package:admin_panel/router/partner_routes.dart' as partner;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
final List<Map<String, dynamic>> providerSlideMenuItems = [
  {
    "icon": Icons.admin_panel_settings_outlined,
    "label": 'Dashboard',
    "route": partner.DashboardRoute().location,
  },
  {
    "icon": Icons.production_quantity_limits_outlined,
    "label": 'Products',
    "route": partner.ProductHomeRoute().location,
  },
  {
    "icon": Icons.admin_panel_settings_outlined,
    "label": 'Employee',
    "route": partner.EmployeeHomeRoute().location,
  },
  {
    "icon": Icons.tag,
    "label": 'Service Tags',
    "route": partner.ServiceTagsHomeRoute().location,
  },
  {
    "icon": Icons.chat_bubble_outline_rounded,
    "label": 'Messages',
    "route": partner.PartnerChatInboxRoute().location,
  },
];

final List<Map<String, dynamic>> adminSlideMenuItems = [
  {
    "icon": Icons.admin_panel_settings_outlined,
    "label": 'Dashboard',
    "route": admin.AdminDashboardRoute().location,
  },
  {
    "icon": Icons.production_quantity_limits_outlined,
    "label": 'Category',
    "route": admin.CategoryHomeRoute().location,
  },
  {
    "icon": Icons.production_quantity_limits_outlined,
    "label": 'Provider',
    "route": admin.PartnerManagerRoute().location,
  },
];

@riverpod
GoRouter router(Ref ref) {
  final notifier = ref.watch(routerListenableProvider.notifier);

  // Fall back to login if not authenticated on cold start.
  final String initialLocation;
  if (!UserRoleHelper.isLoggedIn()) {
    initialLocation = '/';
  } else if (Store.get(StoreKey.mockRole, Role.health_partner.value) ==
      Role.health_partner.value) {
    initialLocation = '/provider/dashboard';
  } else {
    initialLocation = '/admin/dashboard';
  }

  String? redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = UserRoleHelper.isLoggedIn();
    final role = UserRoleHelper.getRole();
    final path = state.uri.path;
    final isProviderVerified = UserRoleHelper.isProviderVerified();

    log(
      'Router redirect — isLoggedIn: $isLoggedIn, '
      'role: $role, path: $path, '
      'isProviderVerified: $isProviderVerified',
      name: 'AppRouter',
    );

    final isPublicRoute =
        path == '/' ||
        path == '/forgot-password' ||
        path == '/sign-up' ||
        path.startsWith('/sign-up/');

    final isVerificationRoute = path == '/provider/verification-status';

    if (isLoggedIn) {
      // Authenticated user on a public route → send to home.
      if (isPublicRoute) {
        if (role == Role.admin.value) {
          return '/admin/dashboard';
        }
        return isProviderVerified
            ? '/provider/dashboard'
            : '/provider/verification-status';
      }

      // Unverified provider trying to access protected routes.
      if (role == Role.health_partner.value) {
        if (!isProviderVerified && !isVerificationRoute) {
          return '/provider/verification-status';
        } else if (isProviderVerified && isVerificationRoute) {
          return '/provider/dashboard';
        }
      }
    } else {
      // Unauthenticated user on a protected route → login.
      if (!isPublicRoute) {
        return '/';
      }
    }
    return null;
  }

  return GoRouter(
    initialLocation: initialLocation,
    debugLogDiagnostics: true,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return SelectionArea(child: child);
        },
        routes: [...admin.$appRoutes, ...partner.$appRoutes],
      ),
    ],
    refreshListenable: notifier,
    redirect: redirect,
  );
}

@riverpod
class RouterListenable extends _$RouterListenable implements Listenable {
  final List<VoidCallback> _listeners = [];

  @override
  FutureOr<void> build() {
    // Watch auth state
    final subscription = Store.watch(StoreKey.accessToken).listen((_) {
      _notifyListeners();
    });
    ref.onDispose(subscription.cancel);
  }

  // ignore: unused_element
  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
  }
}
