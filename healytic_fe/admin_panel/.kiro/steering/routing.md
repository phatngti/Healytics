---
inclusion: manual
---

# Routing with GoRouter

Apply when adding screens, modifying navigation, or working with routes.

## Setup

Routes defined in `lib/router/routes.dart` using type-safe `go_router_builder`:

```dart
import 'package:go_router/go_router.dart';

part 'routes.g.dart';
```

Router configured in `lib/router/app_router.dart`.

## Route Structure

### Shell Route (Bottom Navigation)
```dart
@TypedStatefulShellRoute<MobileWrapperRoutes>(
  branches: [
    TypedStatefulShellBranch<HomeBranch>(routes: [...]),
    TypedStatefulShellBranch<OrdersBranch>(routes: [...]),
    TypedStatefulShellBranch<ChatBranch>(routes: [...]),
    TypedStatefulShellBranch<NotificationsBranch>(routes: [...]),
    TypedStatefulShellBranch<ProfileBranch>(routes: [...]),
  ],
)
```

### Standalone Routes
- Bot Chat: `/chat` (optional `conversationId` query param)
- Service Details: `/service_details` (requires `serviceId`)
- Auth flow: `/` (splash), `/onboarding`, `/signin`
- Sign Up flow: email form, code confirmation, finish
- Survey steps: general goals, lifestyle, body energy, health safety

## Adding a New Route

1. Define the route data class in `routes.dart`:
   ```dart
   class NewScreenRoute extends GoRouteData {
     const NewScreenRoute({required this.itemId});
     final String itemId;

     @override
     Widget build(BuildContext context, GoRouterState state) =>
         NewScreen(itemId: itemId);
   }
   ```

2. Add to the appropriate branch or as a standalone `TypedGoRoute`:
   ```dart
   TypedGoRoute<NewScreenRoute>(path: '/new-screen/:itemId')
   ```

3. Use slide transitions via `_buildSlideTransitionPage`:
   ```dart
   @override
   Page<void> buildPage(
     BuildContext context,
     GoRouterState state,
   ) => _buildSlideTransitionPage(
     state: state,
     child: NewScreen(itemId: itemId),
   );
   ```

4. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

## Navigation

```dart
// Type-safe navigation (preferred)
const NewScreenRoute(itemId: '123').go(context);
const NewScreenRoute(itemId: '123').push(context);

// Fallback for simple cases
context.go('/path');
context.push('/path');
```

## Auth Redirects

Handle in `app_router.dart` redirect logic — check auth state and redirect unauthenticated users to `/signin`.
