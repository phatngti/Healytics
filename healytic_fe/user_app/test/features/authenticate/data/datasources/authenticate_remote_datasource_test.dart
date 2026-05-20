import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/authenticate/data/datasources/remote/authenticate_remote_datasource.dart';
import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';
import 'package:user_openapi/api.dart';

/// Unit tests for [AuthenticateRemoteDatasourceImpl.signInWithGoogle].
///
/// Validates: Requirements 3.2, 3.3, 3.4, 7.1, 7.2, 7.3, 7.4.

class _MockApiService extends Mock implements ApiService {}

class _MockApiClient extends Mock implements ApiClient {}

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

void main() {
  // Used by mocktail's any() matcher for non-primitive parameter types so
  // verify() can match the call arguments.
  setUpAll(() {
    registerFallbackValue(<QueryParam>[]);
    registerFallbackValue(<String, String>{});
    registerFallbackValue(<String, dynamic>{});
  });

  group('signInWithGoogle', () {
    late _MockApiService apiService;
    late _MockApiClient apiClient;
    late AuthenticateRemoteDatasourceImpl ds;

    // A pre-built valid JWT for the success test.
    late String successAccessToken;
    const refreshTokenSample = 'refresh_token_sample';
    const idToken = 'tok_123';

    setUp(() {
      apiService = _MockApiService();
      apiClient = _MockApiClient();
      when(() => apiService.apiClient).thenReturn(apiClient);
      ds = AuthenticateRemoteDatasourceImpl(apiService: apiService);

      successAccessToken = _buildJwt(<String, dynamic>{
        'email': 'alice@example.com',
        'firstName': 'Alice',
        'lastName': 'Test',
        'profileCompleted': false,
      });

      // Sanity check: the token decodes to the expected claims.
      final decoded = JwtDecoder.decode(successAccessToken);
      expect(decoded['email'], 'alice@example.com');
      expect(decoded['firstName'], 'Alice');
      expect(decoded['lastName'], 'Test');
    });

    /// Stubs `apiClient.invokeAPI(...)` to return [response] (or throw).
    void stubInvokeAPI({
      http.Response? response,
      Object? error,
    }) {
      final stub = when(
        () => apiClient.invokeAPI(
          any(),
          any(),
          any(),
          any(),
          any(),
          any(),
          any(),
        ),
      );
      if (error != null) {
        stub.thenThrow(error);
      } else {
        stub.thenAnswer((_) async => response!);
      }
    }

    test(
      'posts {id_token} to /auth/user/google with correct URL and body',
      () async {
        stubInvokeAPI(
          response: http.Response(
            jsonEncode(<String, String>{
              'access_token': successAccessToken,
              'refresh_token': refreshTokenSample,
            }),
            200,
          ),
        );

        await ds.signInWithGoogle(idToken: idToken);

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

        expect(captured[0], '/auth/user/google');
        expect(captured[1], 'POST');
        expect(captured[3], <String, String>{'id_token': idToken});
        expect(captured[6], 'application/json');
      },
    );

    test(
      'returns AuthenticateEntity with decoded BasicInfoEntity on 200',
      () async {
        stubInvokeAPI(
          response: http.Response(
            jsonEncode(<String, String>{
              'access_token': successAccessToken,
              'refresh_token': refreshTokenSample,
            }),
            200,
          ),
        );

        final entity = await ds.signInWithGoogle(idToken: idToken);

        expect(entity, isA<AuthenticateEntity>());
        expect(entity.accessToken, successAccessToken);
        expect(entity.refreshToken, refreshTokenSample);
        expect(entity.basicInfo, isNotNull);
        expect(entity.basicInfo!.email, 'alice@example.com');
        expect(entity.basicInfo!.name, 'Alice Test');
      },
    );

    test(
      'throws ApiException(401, ...) on GOOGLE_TOKEN_INVALID response',
      () async {
        stubInvokeAPI(
          response: http.Response(
            jsonEncode(<String, dynamic>{
              'statusCode': 401,
              'message': 'Invalid Google ID token',
              'code': 'GOOGLE_TOKEN_INVALID',
            }),
            401,
          ),
        );

        await expectLater(
          ds.signInWithGoogle(idToken: idToken),
          throwsA(
            isA<ApiException>()
                .having((e) => e.code, 'code', 401)
                .having(
                  (e) => e.message,
                  'message',
                  contains('Invalid Google ID token'),
                ),
          ),
        );
      },
    );

    test(
      'throws ApiException(409, ...) on '
      'EMAIL_ALREADY_REGISTERED_WITH_PASSWORD response',
      () async {
        stubInvokeAPI(
          response: http.Response(
            jsonEncode(<String, dynamic>{
              'statusCode': 409,
              'message': 'Email already registered with a password',
              'code': 'EMAIL_ALREADY_REGISTERED_WITH_PASSWORD',
            }),
            409,
          ),
        );

        await expectLater(
          ds.signInWithGoogle(idToken: idToken),
          throwsA(
            isA<ApiException>()
                .having((e) => e.code, 'code', 409)
                .having(
                  (e) => e.message,
                  'message',
                  contains('Email already registered with a password'),
                ),
          ),
        );
      },
    );

    test(
      'throws ApiException(403, ...) on ACCOUNT_DISABLED response',
      () async {
        stubInvokeAPI(
          response: http.Response(
            jsonEncode(<String, dynamic>{
              'statusCode': 403,
              'message': 'Account is disabled',
              'code': 'ACCOUNT_DISABLED',
            }),
            403,
          ),
        );

        await expectLater(
          ds.signInWithGoogle(idToken: idToken),
          throwsA(
            isA<ApiException>()
                .having((e) => e.code, 'code', 403)
                .having(
                  (e) => e.message,
                  'message',
                  contains('Account is disabled'),
                ),
          ),
        );
      },
    );

    test(
      'does not time out before the 30-second budget elapses',
      () {
        // Stub invokeAPI to return a Future that never completes so the
        // 30-second `.timeout(...)` in the data source is what governs.
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
          ds.signInWithGoogle(idToken: idToken).catchError((Object e) {
            caught = e;
            return const AuthenticateEntity(
              accessToken: '',
              refreshToken: '',
            );
          });

          // Advance virtual time to just before the 30-second budget.
          async.elapse(const Duration(seconds: 29));
          async.flushMicrotasks();

          expect(
            caught,
            isNull,
            reason: 'Should not time out before 30 seconds',
          );
        });
      },
    );

    test(
      'wraps TimeoutException as ApiException(requestTimeout, ...) '
      'after 30 seconds',
      () {
        // Stub invokeAPI to return a Future that never completes so the
        // 30-second `.timeout(...)` in the data source is what fires.
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
          ds.signInWithGoogle(idToken: idToken).catchError((Object e) {
            caught = e;
            // Return a dummy entity so the Future signature is satisfied;
            // the test only inspects `caught`.
            return const AuthenticateEntity(
              accessToken: '',
              refreshToken: '',
            );
          });

          // Advance virtual time past the 30-second budget.
          async.elapse(const Duration(seconds: 31));
          async.flushMicrotasks();

          expect(caught, isA<ApiException>());
          final apiEx = caught! as ApiException;
          expect(apiEx.code, HttpStatus.requestTimeout);
          expect(apiEx.message, contains('timed out'));
        });
      },
    );

    test(
      'surfaces SocketException as-is (impl does not wrap it)',
      () async {
        // The current implementation does NOT have an explicit
        // `on SocketException catch` branch. The OpenAPI client's
        // `invokeAPI` already wraps SocketException as `ApiException`
        // before our code sees it (see openapi/lib/api_client.dart).
        // Therefore in this datasource-only test we stub `invokeAPI`
        // to throw a raw `SocketException` and assert the call
        // rethrows it unchanged — documenting actual behaviour.
        stubInvokeAPI(
          error: const SocketException('connection refused'),
        );

        await expectLater(
          ds.signInWithGoogle(idToken: idToken),
          throwsA(isA<SocketException>()),
        );
      },
    );
  });
}
