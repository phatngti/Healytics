import 'package:admin_panel/core/entities/store.entity.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/utils/user_role_helper.dart';
import 'package:admin_panel/router/partner_routes.dart' as partner;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:admin_panel/router/admin_routes.dart' as admin;
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
  String initialLocation =
      Store.get(StoreKey.mockRole, 'provider') == 'provider'
      ? '/provider/dashboard'
      : '/admin/dashboard';

  String? redirect(BuildContext context, GoRouterState state) {
    final isLoggedIn = UserRoleHelper.isLoggedIn();
    final role = UserRoleHelper.getRole();
    final path = state.uri.path;
    final isProviderVerified = UserRoleHelper.isProviderVerified();

    final isPublicRoute =
        path == '/' ||
        path == '/forgot-password' ||
        path == '/sign-up' ||
        path.startsWith('/sign-up/');

    final isVerificationRoute = path == '/provider/verification-status';

    if (isLoggedIn) {
      if (isPublicRoute) {
        if (role == 'admin') {
          return '/admin/dashboard';
        } else {
          // Provider: check verification status
          if (isProviderVerified) {
            return '/provider/dashboard';
          } else {
            return '/provider/verification-status';
          }
        }
      }

      // Provider-specific verification redirect logic
      if (role == 'provider') {
        if (!isProviderVerified && !isVerificationRoute) {
          // Unverified provider trying to access other routes
          return '/provider/verification-status';
        } else if (isProviderVerified && isVerificationRoute) {
          // Verified provider trying to access verification page
          return '/provider/dashboard';
        }
      }
    } else {
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
