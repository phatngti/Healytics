# Create Screen

Description: Adds a new screen to an existing feature with routing, provider, and proper widget structure.

## Input Required
- `<feature_name>`: Existing feature (e.g., `home`)
- `<screen_name>`: New screen name (snake_case, e.g., `product_details`)
- `<route_path>`: URL path (e.g., `/product-details`)
- `<route_params>`: Required route parameters (e.g., `productId: String`)

## Steps

1. **Create the screen file:** Create `lib/features/<feature_name>/presentation/screens/<screen_name>.screen.dart`:
   - Use `ConsumerWidget` or `HookConsumerWidget`.
   - Accept route parameters as constructor arguments.
   - Watch relevant providers in `build()`.
   - Use `Theme.of(context)` for all styling.
   - Add `const` constructor.

   ```dart
   import 'package:flutter/material.dart';
   import 'package:hooks_riverpod/hooks_riverpod.dart';

   class ProductDetailsScreen extends ConsumerWidget {
     const ProductDetailsScreen({
       super.key,
       required this.productId,
     });

     final String productId;

     @override
     Widget build(BuildContext context, WidgetRef ref) {
       return Scaffold(
         appBar: AppBar(
           title: Text(
             'Details',
             style: Theme.of(context).textTheme.titleLarge,
           ),
         ),
         body: const Center(child: Text('Content')),
       );
     }
   }
   ```

2. **Create supporting widgets:** If the screen has complex sections (3+ sub-widgets or >150 lines), create widget files in `presentation/widgets/<screen_name>/`:
   - Each sub-widget gets its own `<widget_name>.widget.dart` file
   - Closely-related private helpers can share a file (e.g., `_TimeColumn` inside `check_in_out_card.widget.dart`)
   - Widgets shared across multiple screens stay in flat `widgets/` root
   - See `/refactor-screen-widgets` workflow for detailed extraction steps

3. **Create presentation provider (if needed):** Add a `@riverpod` notifier in `presentation/providers/<screen_name>.provider.dart` for screen-specific state.

4. **Add route definition:** In `lib/router/routes.dart`:

   First, determine the route type:
   - **Main navigation tab** → add to `MobileWrapperRoutes` branches (bottom nav)
   - **Auth/onboarding flow** → add as child of `LottieSplashRoute`
   - **Standalone page** → create new `@TypedGoRoute` at root level
   - **Nested page** → add as child of existing route

   Then create the route class:
   - Create a `GoRouteData` class with parameters.
   - Add `TypedGoRoute` annotation to the appropriate location.
   - Use `_buildSlideTransitionPage` for transitions.
   - Add a static `name` constant for the route.

   ```dart
   class ProductDetailsRoute extends GoRouteData {
     const ProductDetailsRoute({required this.productId});
     final String productId;

     @override
     Page<void> buildPage(
       BuildContext context,
       GoRouterState state,
     ) => _buildSlideTransitionPage(
       state: state,
       child: ProductDetailsScreen(productId: productId),
     );
   }
   ```

5. **Run code generation:**
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. **Verify navigation works:** Ensure the screen can be navigated to:
   ```dart
   const ProductDetailsRoute(productId: '123').push(context);
   ```

7. **Run analysis:** `dart analyze` to check for errors.
