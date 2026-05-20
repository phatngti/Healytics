import 'package:drift/drift.dart' show QueryExecutor;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_app/core/database/repositories/drift.repository.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/repositories/store.repository.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/core/services/store.service.dart';
import 'package:user_app/features/onboarding/sign_up/data/repositories/register_repository_impl.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/survey_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_app/features/onboarding/sign_up/domain/repositories/register_repo.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/finish_google_sign_up.provider.dart';
import 'package:user_openapi/api.dart';

/// Unit tests for [CompleteGoogleProfileNotifier.completeGoogleProfile].
///
/// Validates: Requirements 6.3, 6.4, 6.6, 6.9, 6.10.

class _MockRegisterRepository extends Mock implements RegisterRepository {}

class _MockApiService extends Mock implements ApiService {}

class _MockAuthenticationApi extends Mock implements AuthenticationApi {}

const _testProfile = UserEntity(
  email: 'alice@example.com',
  firstName: 'Alice',
  lastName: 'Test',
  dateOfBirth: '1990-01-15',
  password: '',
  address: AddressEntity(
    streetAddress: '123 Main St',
    provinceId: 'province-1',
    districtId: 'district-1',
    wardId: 'ward-1',
  ),
);

void main() {
  setUpAll(() async {
    // Fallback values for mocktail `any()` matchers on non-primitive
    // parameter types passed through the mocked APIs.
    registerFallbackValue(_testProfile);
    registerFallbackValue(RefreshTokenRequestDto(refreshToken: 'fallback'));

    // Real StoreService backed by an in-memory Drift database so the
    // notifier's `Store.put` / `Store.get` / `Store.tryGet` calls behave
    // against a real cache + DB (same pattern as Tasks 7.3 / 7.4).
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

  /// Builds a [ProviderContainer] with the register repository and api
  /// service overridden by mocks.
  ProviderContainer makeContainer({
    required RegisterRepository repo,
    required ApiService apiService,
  }) {
    final container = ProviderContainer(
      overrides: [
        registerRepositoryProvider.overrideWithValue(repo),
        apiServiceProvider.overrideWithValue(apiService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('completeGoogleProfile', () {
    late _MockRegisterRepository repo;
    late _MockApiService apiService;
    late _MockAuthenticationApi authenticateApi;

    setUp(() {
      repo = _MockRegisterRepository();
      apiService = _MockApiService();
      authenticateApi = _MockAuthenticationApi();
      when(() => apiService.authenticateApi).thenReturn(authenticateApi);
    });

    test(
      '200 with new tokens persists tokens then emits AsyncData — '
      'Reqs 6.3, 6.4, 6.5',
      () async {
        when(() => repo.completeProfile(any())).thenAnswer(
          (_) async => const AuthTokensEntity(
            accessToken: 'new_a',
            refreshToken: 'new_r',
          ),
        );

        final container = makeContainer(repo: repo, apiService: apiService);
        final notifier =
            container.read(completeGoogleProfileProvider.notifier);

        // Wait for build() to settle before invoking.
        await container.read(completeGoogleProfileProvider.future);

        await notifier.completeGoogleProfile(_testProfile);

        final state = container.read(completeGoogleProfileProvider);
        expect(state, isA<AsyncData<CompleteGoogleProfileStateData>>());
        expect(
          state.value,
          const CompleteGoogleProfileStateData(isProfileCompleted: true),
        );

        // Both tokens persisted from the profile-update response.
        expect(Store.tryGet(StoreKey.accessToken), 'new_a');
        expect(Store.tryGet(StoreKey.refreshToken), 'new_r');

        // No fallback to /auth/refresh.
        verifyNever(() => authenticateApi.authControllerRefresh(any()));
      },
    );

    test(
      '200 without new tokens → fallback to /auth/refresh and persists '
      'those — Req 6.3',
      () async {
        // Pre-seed only refresh token; access is empty.
        await Store.put(StoreKey.refreshToken, 'old_refresh');

        when(() => repo.completeProfile(any())).thenAnswer((_) async => null);
        when(() => authenticateApi.authControllerRefresh(any())).thenAnswer(
          (_) async => AuthTokensDto(
            accessToken: 'fresh_a',
            refreshToken: 'fresh_r',
            accessExpiresIn: '3600s',
            refreshExpiresIn: '7d',
          ),
        );

        final container = makeContainer(repo: repo, apiService: apiService);
        final notifier =
            container.read(completeGoogleProfileProvider.notifier);
        await container.read(completeGoogleProfileProvider.future);

        await notifier.completeGoogleProfile(_testProfile);

        final state = container.read(completeGoogleProfileProvider);
        expect(state, isA<AsyncData<CompleteGoogleProfileStateData>>());
        expect(
          state.value,
          const CompleteGoogleProfileStateData(isProfileCompleted: true),
        );

        // Tokens replaced with the refreshed pair.
        expect(Store.tryGet(StoreKey.accessToken), 'fresh_a');
        expect(Store.tryGet(StoreKey.refreshToken), 'fresh_r');

        // Refresh was forwarded with the previously-stored refresh token.
        final captured = verify(
          () => authenticateApi.authControllerRefresh(captureAny()),
        ).captured.single as RefreshTokenRequestDto;
        expect(captured.refreshToken, 'old_refresh');
      },
    );

    test(
      '4xx → AsyncError, tokens unchanged — Reqs 6.6, 6.10',
      () async {
        // Pre-seed both tokens.
        await Store.put(StoreKey.accessToken, 'untouched_access');
        await Store.put(StoreKey.refreshToken, 'untouched_refresh');

        when(() => repo.completeProfile(any())).thenThrow(
          ApiException(400, 'Validation error'),
        );

        final container = makeContainer(repo: repo, apiService: apiService);
        final notifier =
            container.read(completeGoogleProfileProvider.notifier);
        await container.read(completeGoogleProfileProvider.future);

        await notifier.completeGoogleProfile(_testProfile);

        final state = container.read(completeGoogleProfileProvider);
        expect(state, isA<AsyncError<CompleteGoogleProfileStateData>>());
        expect(
          state.error,
          isA<ServerException>().having(
            (e) => e.statusCode,
            'statusCode',
            400,
          ),
        );

        // Tokens UNCHANGED in Store.
        expect(Store.tryGet(StoreKey.accessToken), 'untouched_access');
        expect(Store.tryGet(StoreKey.refreshToken), 'untouched_refresh');

        // No refresh attempted on a failed update.
        verifyNever(() => authenticateApi.authControllerRefresh(any()));
      },
    );

    test(
      '5xx → AsyncError, tokens unchanged — Reqs 6.9, 6.10',
      () async {
        await Store.put(StoreKey.accessToken, 'untouched_access');
        await Store.put(StoreKey.refreshToken, 'untouched_refresh');

        when(() => repo.completeProfile(any())).thenThrow(
          ApiException(503, 'Service unavailable'),
        );

        final container = makeContainer(repo: repo, apiService: apiService);
        final notifier =
            container.read(completeGoogleProfileProvider.notifier);
        await container.read(completeGoogleProfileProvider.future);

        await notifier.completeGoogleProfile(_testProfile);

        final state = container.read(completeGoogleProfileProvider);
        expect(state, isA<AsyncError<CompleteGoogleProfileStateData>>());
        expect(
          state.error,
          isA<ServerException>().having(
            (e) => e.statusCode,
            'statusCode',
            503,
          ),
        );

        expect(Store.tryGet(StoreKey.accessToken), 'untouched_access');
        expect(Store.tryGet(StoreKey.refreshToken), 'untouched_refresh');

        verifyNever(() => authenticateApi.authControllerRefresh(any()));
      },
    );

    test(
      'Refresh failure → AsyncError, tokens unchanged — Req 6.10',
      () async {
        // Pre-seed both tokens; refresh path will be taken because
        // completeProfile returns null.
        await Store.put(StoreKey.accessToken, 'old_access');
        await Store.put(StoreKey.refreshToken, 'old_refresh');

        when(() => repo.completeProfile(any())).thenAnswer((_) async => null);
        when(() => authenticateApi.authControllerRefresh(any())).thenThrow(
          ApiException(401, 'Refresh denied'),
        );

        final container = makeContainer(repo: repo, apiService: apiService);
        final notifier =
            container.read(completeGoogleProfileProvider.notifier);
        await container.read(completeGoogleProfileProvider.future);

        await notifier.completeGoogleProfile(_testProfile);

        final state = container.read(completeGoogleProfileProvider);
        expect(state, isA<AsyncError<CompleteGoogleProfileStateData>>());
        expect(
          state.error,
          isA<ServerException>().having(
            (e) => e.statusCode,
            'statusCode',
            401,
          ),
        );

        // Tokens UNCHANGED in Store.
        expect(Store.tryGet(StoreKey.accessToken), 'old_access');
        expect(Store.tryGet(StoreKey.refreshToken), 'old_refresh');
      },
    );
  });
}
