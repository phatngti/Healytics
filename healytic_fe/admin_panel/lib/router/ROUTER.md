# Routing Guidelines

This project uses [go_router](https://pub.dev/packages/go_router) with [go_router_builder](https://pub.dev/packages/go_router_builder) for type-safe routing.

## File Organization

Routes are separated by domain to keep the configuration manageable:

*   **`app_router.dart`**: Main configuration, redirect logic, and global ShellRoute composition.
*   **`partner_routes.dart`**: Routes specific to the Partner/Provider panel (prefix `/provider`).
*   **`admin_routes.dart`**: Routes for the Super Admin panel (prefix `/admin`) and Authentication/Onboarding.

## Naming Conventions

### Classes
*   Use **PascalCase** for route classes.
*   Suffix with `Route`.
*   Example: `ProductDetailsRoute`, `EmployeeEditRoute`.

### Route Names
*   Use **kebab-case**.
*   Include a domain prefix to avoid collisions.
    *   Partner routes: `provider-feature-action`
    *   Admin routes: `admin-feature-action`
*   Example: `provider-product-details`

### Paths
*   Use **snake_case** for path segments.
*   Partner routes must start with `/provider/`.
*   Admin routes must start with `/admin/`.
*   Dynamic parameters use `:paramName`.

## Creating a New Route

### 1. Define the Route Class

Create a class extending `GoRouteData` in the appropriate file (`partner_routes.dart` or `admin_routes.dart`).

```dart
class MyNewRoute extends GoRouteData with $MyNewRoute {
  const MyNewRoute();
  
  static const name = "domain-feature-name";

  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return buildSlideTransitionPage(
      pageKey: state.pageKey,
      child: const MyNewScreen(),
    );
  }
}
```

### 2. Handle Parameters

If the route requires parameters, define them as `final` fields in the class and constructor.

```dart
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
```

### 3. Add to Route Tree

Add the route to the `@TypedShellRoute` or `@TypedGoRoute` list in the file.

```dart
@TypedShellRoute<ProviderShellRouteData>(
  routes: [
    // ... existing routes
    TypedGoRoute<MyNewRoute>(
      path: '/provider/my-new-feature',
      name: MyNewRoute.name,
    ),
  ],
)
```

### 4. Page Transitions

Always use the `buildSlideTransitionPage` helper from `package:admin_panel/router/utils.dart` to ensure consistent transitions across the app.

```dart
import 'package:admin_panel/router/utils.dart';

// ...
return buildSlideTransitionPage(
  pageKey: state.pageKey,
  child: const MyScreen(),
);
```

### 5. Generate Code

After defining the route, run the build runner to generate the necessary glue code:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Navigation

Use the generated type-safe extension methods to navigate.

```dart
// Basic navigation
MyNewRoute().go(context);

// With parameters
ProductDetailsRoute(id: '123').go(context);

// Push instead of Go (if needed)
MyNewRoute().push(context);
```
