import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show QueryExecutor;
import 'package:drift/native.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:user_app/core/database/repositories/drift.repository.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/repositories/store.repository.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/core/services/store.service.dart';
import 'package:user_app/features/onboarding/sign_up/data/datasources/remote/register_remote_datasource.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/user_entity.dart';
import 'package:user_openapi/api.dart';

/// Unit tests for [RegisterRemoteDatasourceImpl.completeProfile].
///
/// Validates: Requirements 6.1, 6.2, 6.7.

class _MockApiService extends Mock implements ApiService {}

class _MockApiClient extends Mock implements ApiClient {}

void main() {
  setUpAll(() async {
    // Register fallback values for non-primitive parameter types so
    // mocktail's `any()` matcher can match invokeAPI's argument list.
    registerFallbackValue(<QueryParam>[]);
    registerFallbackValue(<String, String>{});
    registerFallbackValue(<String, dynamic>{});

    // Initialise a real StoreService backed by an in-memory Drift database
    // so the impl's `Store.get(StoreKey.accessToken)` resolves to a real
    // value instead of throwing.
    final QueryExecutor executor = NativeDatabase.memory();
    final db = Drift(executor);
    final repo = DriftStoreRepository(db);
    await StoreService.init(storeRepository: repo);
  });

  setUp(() async {
    // Seed a non-empty access token so completeProfile() does not throw
    // the early "Access token is empty" guard.
    await Store.put(StoreKey.accessToken, 'access_token_for_test');
  });

  tearDown(() async {
    await Store.delete(StoreKey.accessToken);
  });

  group('completeProfile', () {
    late _MockApiService apiService;
    late _MockApiClient apiClient;
    late RegisterRemoteDatasourceImpl ds;

    final testProfile = const UserEntity(
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

    setUp(() {
      apiService = _MockApiService();
      apiClient = _MockApiClient();
      when(() => apiService.apiClient).thenReturn(apiClient);
      when(() => apiService.setAccessToken(any())).thenAnswer((_) async {});
      ds = RegisterRemoteDatasourceImpl(apiService: apiService);
    });

    test(
      'PATCHes account profile and address endpoints with correct bodies',
      () async {
        when(
          () => apiClient.invokeAPI(
            any(),
            any(),
            any(),
            any(),
            any(),
            any(),
            any(),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            jsonEncode(<String, String>{
              'access_token': 'new_access_token',
              'refresh_token': 'new_refresh_token',
            }),
            200,
          ),
        );

        await ds.completeProfile(testProfile);

        // Bearer token plumbing happens via apiService.setAccessToken,
        // which the OpenAPI client uses on subsequent requests. Verify
        // the seeded access token was forwarded to the api client.
        verify(
          () => apiService.setAccessToken('access_token_for_test'),
        ).called(1);

        final captured = verify(
          () => apiClient.invokeAPI(
            captureAny(),
            captureAny(),
            captureAny(),
            captureAny(),
            captureAny(),
            captureAny(),
            captureAny(),
          ),
        ).captured;

        expect(captured[0], '/account/me/profile');
        expect(captured[1], 'PATCH');
        expect(captured[3], <String, dynamic>{
          'firstName': 'Alice',
          'lastName': 'Test',
          'dateOfBirth': '1990-01-15',
        });
        expect(captured[4], <String, String>{
          'Content-Type': 'application/json',
        });
        expect(captured[6], 'application/json');

        expect(captured[7], '/account/me/address');
        expect(captured[8], 'PATCH');
        expect(captured[10], <String, dynamic>{
          'streetAddress': '123 Main St',
          'provinceId': 'province-1',
          'districtId': 'district-1',
          'wardId': 'ward-1',
        });
        expect(captured[11], <String, String>{
          'Content-Type': 'application/json',
        });
        expect(captured[13], 'application/json');

        expect(captured[14], '/account/me/profile');
        expect(captured[15], 'PATCH');
        expect(captured[17], <String, dynamic>{
          'firstName': 'Alice',
          'lastName': 'Test',
          'dateOfBirth': '1990-01-15',
          'profileCompleted': true,
        });
        expect(captured[18], <String, String>{
          'Content-Type': 'application/json',
        });
        expect(captured[20], 'application/json');
      },
    );

    test('wraps TimeoutException as ApiException(requestTimeout, ...) '
        'after 30 seconds', () {
      // Stub invokeAPI to return a Future that never completes so the
      // 30-second `.timeout(...)` in the data source fires.
      final completer = Completer<http.Response>();
      when(
        () => apiClient.invokeAPI(
          any(),
          any(),
          any(),
          any(),
          any(),
          any(),
          any(),
        ),
      ).thenAnswer((_) => completer.future);

      fakeAsync((async) {
        Object? caught;
        ds.completeProfile(testProfile).catchError((Object e) {
          caught = e;
          // Return a dummy value to satisfy the Future signature; the
          // test only inspects `caught`.
          return null;
        });

        // Advance virtual time past the 30-second budget.
        async.elapse(const Duration(seconds: 31));
        async.flushMicrotasks();

        expect(caught, isA<ApiException>());
        final apiEx = caught! as ApiException;
        expect(apiEx.code, HttpStatus.requestTimeout);
        expect(apiEx.message, contains('timed out'));
      });
    });
  });
}
