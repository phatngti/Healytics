import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show QueryExecutor;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_app/core/database/repositories/drift.repository.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/repositories/store.repository.dart';
import 'package:user_app/core/services/push_notification_flutter.service.dart';
import 'package:user_app/core/services/store.service.dart';
import 'package:user_app/features/authenticate/data/repositories/authenticate_repository_impl.dart';
import 'package:user_app/features/authenticate/data/services/google_sign_in.service.dart';
import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';
import 'package:user_app/features/authenticate/domain/repositories/authenticate.repository.dart';
import 'package:user_app/features/authenticate/presentation/providers/authenticate.provider.dart';
import 'package:user_openapi/api.dart';

/// Unit tests for [AuthenticateNotifier.signInWithGoogle].
///
/// Validates: Requirements 1.3, 1.4, 1.5, 1.8, 2.6, 3.5, 3.6, 3.7,
/// 7.6, 7.7.

class _FakeRepo extends Mock implements AuthenticateRepository {}

const _testAccessToken = 'access_token_value';
const _testRefreshToken = 'refresh_token_value';
const _previousAccessToken = 'previous_access_token';
const _previousRefreshToken = 'previous_refresh_token';

const _successEntity = AuthenticateEntity(
  accessToken: _testAccessToken,
  refreshToken: _testRefreshToken,
  basicInfo: BasicInfoEntity(email: 'alice@example.com', name: 'Alice Test'),
);

const _previousEntity = AuthenticateEntity(
  accessToken: _previousAccessToken,
  refreshToken: _previousRefreshToken,
  basicInfo: BasicInfoEntity(email: 'old@example.com'),
);

void main() {
  setUpAll(() async {
    // Real StoreService backed by an in-memory Drift database so the
    // notifier's `Store.put`/`Store.delete`/`Store.tryGet` calls behave
    // against a real cache + DB.
    final QueryExecutor executor = NativeDatabase.memory();
    final db = Drift(executor);
    final repo = DriftStoreRepository(db);
    await StoreService.init(storeRepository: repo);
  });

  setUp(() async {
    // Start every test from a clean Token_Store.
    await Store.delete(StoreKey.accessToken);
    await Store.delete(StoreKey.refreshToken);
  });

  /// Builds a [ProviderContainer] with the repository overridden and the
  /// push-notification provider stubbed to error so the
  /// `unawaited(_initializePushNotifications())` call inside the notifier
  /// fails fast instead of pulling in Firebase. The notifier wraps that
  /// call in a try/catch and only logs, so the failure does not affect
  /// state observed by these tests.
  ProviderContainer makeContainer(AuthenticateRepository repo) {
    final container = ProviderContainer(
      overrides: [
        authenticateRepositoryProvider.overrideWithValue(repo),
        pushNotificationServiceProvider.overrideWith(
          (ref) => Future<PushNotificationFlutterService>.error(
            UnimplementedError('push notifications disabled in test'),
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('signInWithGoogle', () {
    test(
      'cancellation restores previous AsyncData (no error toast) — '
      'Reqs 1.8, 2.6',
      () async {
        final repo = _FakeRepo();
        // Prime the notifier with a previous successful login so we can
        // verify cancellation restores it.
        when(repo.signInWithGoogle).thenAnswer((_) async => _previousEntity);

        final container = makeContainer(repo);
        final notifier = container.read(authenticateProvider.notifier);

        // First call: succeed so `state.value` is the previous entity.
        await notifier.signInWithGoogle();
        expect(
          container.read(authenticateProvider),
          AsyncData<AuthenticateStateData>(
            const AuthenticateStateData(authenticate: _previousEntity),
          ),
        );

        // Now stub the next call to throw a cancellation.
        when(repo.signInWithGoogle).thenThrow(
          const GoogleSignInCancelledException(),
        );

        await notifier.signInWithGoogle();

        // State must be restored to the previous AsyncData (NOT AsyncError).
        final state = container.read(authenticateProvider);
        expect(state, isA<AsyncData<AuthenticateStateData>>());
        expect(state.hasError, isFalse);
        expect(
          state.value,
          const AuthenticateStateData(authenticate: _previousEntity),
        );
      },
    );

    test(
      'success → AsyncData; tokens persisted (refresh + access) — '
      'Reqs 1.5, 3.5, 3.6',
      () async {
        final repo = _FakeRepo();
        when(repo.signInWithGoogle).thenAnswer((_) async => _successEntity);

        final container = makeContainer(repo);
        final notifier = container.read(authenticateProvider.notifier);

        await notifier.signInWithGoogle();

        final state = container.read(authenticateProvider);
        expect(state, isA<AsyncData<AuthenticateStateData>>());
        expect(
          state.value,
          const AuthenticateStateData(authenticate: _successEntity),
        );

        // Both tokens have been persisted with the entity's values.
        expect(Store.tryGet(StoreKey.accessToken), _testAccessToken);
        expect(Store.tryGet(StoreKey.refreshToken), _testRefreshToken);
      },
    );

    test(
      '4xx error → AsyncError(ServerException); tokens cleared — '
      'Reqs 3.7, 7.6, 7.7',
      () async {
        // Pre-write tokens to verify they get cleared on failure.
        await Store.put(StoreKey.accessToken, 'stale_access');
        await Store.put(StoreKey.refreshToken, 'stale_refresh');

        final repo = _FakeRepo();
        when(repo.signInWithGoogle).thenThrow(
          ApiException(401, 'Invalid Google ID token'),
        );

        final container = makeContainer(repo);
        final notifier = container.read(authenticateProvider.notifier);

        await notifier.signInWithGoogle();

        final state = container.read(authenticateProvider);
        expect(state, isA<AsyncError<AuthenticateStateData>>());
        expect(
          state.error,
          isA<ServerException>().having(
            (e) => e.statusCode,
            'statusCode',
            401,
          ),
        );

        // Both tokens cleared.
        expect(Store.tryGet(StoreKey.accessToken), isNull);
        expect(Store.tryGet(StoreKey.refreshToken), isNull);
      },
    );

    test(
      'network error → AsyncError(NetworkException); tokens cleared — '
      'Reqs 7.1, 7.6, 7.7',
      () async {
        await Store.put(StoreKey.accessToken, 'stale_access');
        await Store.put(StoreKey.refreshToken, 'stale_refresh');

        final repo = _FakeRepo();
        when(repo.signInWithGoogle).thenThrow(
          const SocketException('connection refused'),
        );

        final container = makeContainer(repo);
        final notifier = container.read(authenticateProvider.notifier);

        await notifier.signInWithGoogle();

        final state = container.read(authenticateProvider);
        expect(state, isA<AsyncError<AuthenticateStateData>>());
        expect(state.error, isA<NetworkException>());

        expect(Store.tryGet(StoreKey.accessToken), isNull);
        expect(Store.tryGet(StoreKey.refreshToken), isNull);
      },
    );

    test(
      'emits AsyncLoading before any await — Reqs 1.3, 1.4',
      () async {
        // Stub the repository to return a Future that never completes so
        // we can observe the synchronous transition into AsyncLoading.
        final completer = Completer<AuthenticateEntity>();
        final repo = _FakeRepo();
        when(repo.signInWithGoogle).thenAnswer((_) => completer.future);

        final container = makeContainer(repo);
        final notifier = container.read(authenticateProvider.notifier);

        // Initial state: AsyncData (build() resolved synchronously to
        // const AuthenticateStateData()).
        // Fire signInWithGoogle without awaiting it.
        // ignore: unawaited_futures
        notifier.signInWithGoogle();

        // The notifier sets `state = const AsyncLoading()` BEFORE its
        // first `await`, so right after the synchronous part runs the
        // state must already be loading.
        final state = container.read(authenticateProvider);
        expect(state, isA<AsyncLoading<AuthenticateStateData>>());
        expect(state.isLoading, isTrue);
      },
    );
  });
}
