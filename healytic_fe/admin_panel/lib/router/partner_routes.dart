import 'package:admin_panel/features/partner/dashboard/presentation/dashboard.dart';
import 'package:admin_panel/features/partner/employee/presentation/employee_add.dart';
import 'package:admin_panel/features/partner/employee/presentation/employee_edit.dart';
import 'package:admin_panel/features/partner/employee/presentation/employee_details.dart';
import 'package:admin_panel/features/partner/employee/presentation/employee_home.dart';
import 'package:admin_panel/features/partner/products/presentation/product_add.dart';
import 'package:admin_panel/features/partner/products/presentation/product_details.dart';
import 'package:admin_panel/features/partner/products/presentation/product_edit.dart';
import 'package:admin_panel/features/partner/products/presentation/product_home.dart';
import 'package:admin_panel/features/partner/service_tags/presentation/service_tags_home.dart';
import 'package:admin_panel/router/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'partner_routes.g.dart';

@TypedShellRoute<ProviderShellRouteData>(
  routes: [
    TypedGoRoute<DashboardRoute>(
      path: '/provider/dashboard',
      name: DashboardRoute.name,
    ),
    TypedGoRoute<ProductHomeRoute>(
      path: '/provider/products',
      name: ProductHomeRoute.name,
    ),
    TypedGoRoute<ProductAddRoute>(
      path: '/provider/products/add',
      name: ProductAddRoute.name,
    ),
    TypedGoRoute<ProductDetailsRoute>(
      path: '/provider/products/:id',
      name: ProductDetailsRoute.name,
    ),
    TypedGoRoute<ProductEditRoute>(
      path: '/provider/products/:id/edit',
      name: ProductEditRoute.name,
    ),
    TypedGoRoute<EmployeeHomeRoute>(
      path: '/provider/employee',
      name: EmployeeHomeRoute.name,
    ),
    TypedGoRoute<EmployeeAddRoute>(
      path: '/provider/employee/add',
      name: EmployeeAddRoute.name,
    ),
    TypedGoRoute<EmployeeDetailsRoute>(
      path: '/provider/employee/:id',
      name: EmployeeDetailsRoute.name,
    ),
    TypedGoRoute<EmployeeEditRoute>(
      path: '/provider/employee/:id/edit',
      name: EmployeeEditRoute.name,
    ),
    TypedGoRoute<ServiceTagsHomeRoute>(
      path: '/provider/service_tags',
      name: ServiceTagsHomeRoute.name,
    ),
  ],
)
class ProviderShellRouteData extends ShellRouteData {
  const ProviderShellRouteData();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return navigator;
  }
}

class DashboardRoute extends GoRouteData with $DashboardRoute {
  const DashboardRoute();
  static const name = "provider-dashboard";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const DashboardScreen(),
    );
  }
}

class ProductHomeRoute extends GoRouteData with $ProductHomeRoute {
  const ProductHomeRoute();
  static const name = "provider-product-home";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const ProductHomeScreen(),
    );
  }
}

class ProductDetailsRoute extends GoRouteData with $ProductDetailsRoute {
  const ProductDetailsRoute({required this.id});
  static const name = "provider-product-details";
  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ProductDetailsScreen(productId: id),
    );
  }
}

class ProductAddRoute extends GoRouteData with $ProductAddRoute {
  const ProductAddRoute();
  static const name = "provider-product-add";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const ProductAddScreen(),
    );
  }
}

class ProductEditRoute extends GoRouteData with $ProductEditRoute {
  const ProductEditRoute({required this.id});
  static const name = "provider-product-edit";
  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: ProductEditScreen(productId: id),
    );
  }
}

class EmployeeHomeRoute extends GoRouteData with $EmployeeHomeRoute {
  const EmployeeHomeRoute();
  static const name = "provider-employee-home";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const EmployeeHomeScreen(),
    );
  }
}

class EmployeeDetailsRoute extends GoRouteData with $EmployeeDetailsRoute {
  const EmployeeDetailsRoute({required this.id});
  static const name = "provider-employee-details";
  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: EmployeeDetailsScreen(employeeId: id),
    );
  }
}

class EmployeeEditRoute extends GoRouteData with $EmployeeEditRoute {
  const EmployeeEditRoute({required this.id});
  static const name = "provider-employee-edit";
  final String id;

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: EmployeeEditScreen(employeeId: id),
    );
  }
}

class EmployeeAddRoute extends GoRouteData with $EmployeeAddRoute {
  const EmployeeAddRoute();
  static const name = "provider-employee-add";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const EmployeeAddScreen(),
    );
  }
}

class ServiceTagsHomeRoute extends GoRouteData with $ServiceTagsHomeRoute {
  const ServiceTagsHomeRoute();
  static const name = "provider-service-tags";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const ServiceTagsHomeScreen(),
    );
  }
}
