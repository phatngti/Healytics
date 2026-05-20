import 'dart:convert';

import 'package:drift/drift.dart' show QueryExecutor;
import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/database/repositories/drift.repository.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/repositories/store.repository.dart';
import 'package:user_app/core/services/store.service.dart';
import 'package:user_app/features/authenticate/presentation/providers/google_sign_in_just_completed.provider.dart';
import 'package:user_app/router/app_router.dart';
import 'package:user_app/router/routes.dart';

/// Router redirect tests for [FinishGoogleSignUpRoute].
///
/// Validates: Requirements 5.12.
///
/// The redirect logic lives in
/// [RouterListenable.redirect] (`lib/router/app_router.dart`).
/// It reads:
///   - [authSessionStoreProvider] — to gate on `isLoggedIn`.
///   - [googleSignInJustCompletedProvider] — transient flag set by the
///     sign-in screen immediately before navigating to
///     `/finish_google_sign_up`.
///
/// Implementation note (per task brief): the impl does not use the
/// `BuildContext` argument, so a mock BuildContext is sufficient.
/// `GoRouterState`'s public constructor is internal to go_router, so we
/// stub it via mocktail.

class _MockBuildContext extends Mock implements BuildContext {}

class _MockGoRouterState extends Mock implements GoRouterState {}

/// Builds a JWT-shaped token whose payload encodes [payload].
String _buildJwt(Map<String, dynamic> payload) {
  // HS256/JWT header.
  const header = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9';

  // base64url-encode the payload, stripping padding the way JWT does.
  final encodedPayload = base64Url
      .encode(utf8.encode(jsonEncode(payload)))
      .replaceAll('=', '');

  return '$header.$encodedPayload.dummy_signature';
}

/// Builds a non-expired access token whose `exp` claim is one hour in the
/// future. `JwtDecoder.isExpired(token)` will therefore return `false`,
/// so `AuthSessionStore._isTokenValid()` evaluates to `true`.
String _buildValidAccessToken() {
  final exp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600;
  return _buildJwt(<String, dynamic>{
    'sub': 'user-id-123',
    'email': 'alice@example.com',
    'profileCompleted': true,
    'exp': exp,
  });
}

GoRouterState _stateForPath(String path) {
  final state = _MockGoRouterState();
  when(() => state.uri).thenReturn(Uri.parse(path));
  return state;
}

void main() {
  setUpAll(() async {
    // `AuthSessionStore.isLoggedIn` short-circuits on
    // `AppEnvironment.current.useMock`. The getter throws if `setCurrent`
    // has not been called. `useMock` is only true for `dev`, so picking
    // `test` keeps the redirect on the JWT-validity branch we care about.
    AppEnvironment.setCurrent(AppEnvironment.test);

    // A real StoreService backed by an in-memory Drift database so the
    // `Store.put` / `Store.tryGet` calls inside `_isTokenValid()` and the
    // `watchAccessToken()` subscription set up in
    // `RouterListenable.build()` operate against real storage.
    final QueryExecutor executor = NativeDatabase.memory();
    final db = Drift(executor);
    final repo = DriftStoreRepository(db);
    await StoreService.init(storeRepository: repo);
  });

  setUp(() async {
    // Each test starts from a fresh Token_Store.
    await Store.delete(StoreKey.accessToken);
    await Store.delete(StoreKey.refreshToken);
  });

  /// Builds a [ProviderContainer], optionally overriding the
  /// `googleSignInJustCompletedProvider` flag.
  Future<ProviderContainer> makeContainer({
    bool justCompletedGoogle = false,
  }) async {
    final container = ProviderContainer(
      overrides: [
        googleSignInJustCompletedProvider.overrideWith(
          (ref) => justCompletedGoogle,
        ),
      ],
    );
    addTearDown(container.dispose);

    // Force the notifier (and its build()) to initialise so the access
    // token watcher subscription is set up before we invoke redirect.
    await container.read(routerListenableProvider.future);
    return container;
  }

  group('RouterListenable.redirect — /finish_google_sign_up', () {
    test(
      'direct nav without recent Google sign-in → redirect to /signin',
      () async {
        // Logged-out (no access token in Store) AND
        // googleSignInJustCompletedProvider == false (default).
        final container = await makeContainer();
        final notifier = container.read(routerListenableProvider.notifier);
        final ctx = _MockBuildContext();
        final state = _stateForPath(FinishGoogleSignUpRoute.pathPattern);

        final result = notifier.redirect(ctx, state);

        expect(result, SignInRoute.pathPattern);
      },
    );

    test(
      'direct nav after a successful Google sign-in renders the screen '
      '(redirect returns null)',
      () async {
        // Pre-write a non-expired access token so
        // `authSessionStore.isLoggedIn == true`.
        await Store.put(StoreKey.accessToken, _buildValidAccessToken());

        // Flag is set to true to indicate a fresh successful Google
        // sign-in in the current session.
        final container = await makeContainer(justCompletedGoogle: true);
        final notifier = container.read(routerListenableProvider.notifier);
        final ctx = _MockBuildContext();
        final state = _stateForPath(FinishGoogleSignUpRoute.pathPattern);

        final result = notifier.redirect(ctx, state);

        expect(
          result,
          isNull,
          reason:
              'Logged-in user with the just-completed flag set must be '
              'allowed to render FinishGoogleSignUpScreen.',
        );
      },
    );

    test(
      'logged-in user without recent Google sign-in is redirected away',
      () async {
        // Pre-write a non-expired access token so
        // `authSessionStore.isLoggedIn == true`.
        await Store.put(StoreKey.accessToken, _buildValidAccessToken());

        // googleSignInJustCompletedProvider stays false.
        final container = await makeContainer();
        final notifier = container.read(routerListenableProvider.notifier);
        final ctx = _MockBuildContext();
        final state = _stateForPath(FinishGoogleSignUpRoute.pathPattern);

        final result = notifier.redirect(ctx, state);

        expect(result, SignInRoute.pathPattern);
      },
    );
  });
}
