import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/entities/store.entity.dart';
import 'package:user_app/core/entities/app_exception.dart';
import 'package:user_app/core/models/store.model.dart';
import 'package:user_app/core/services/push_notification_flutter.service.dart';
import 'package:user_app/features/authenticate/data/repositories/authenticate_repository_impl.dart';
import 'package:user_app/features/authenticate/data/services/google_sign_in.service.dart';
import 'package:user_app/features/authenticate/domain/entities/authenticate.entity.dart';
import 'package:user_openapi/api.dart';

part 'authenticate.provider.freezed.dart';
part 'authenticate.provider.g.dart';

final _log = Logger('AuthenticateNotifier');

@Freezed(toJson: true)
abstract class AuthenticateStateData with _$AuthenticateStateData {
  const factory AuthenticateStateData({AuthenticateEntity? authenticate}) =
      _AuthenticateStateData;

  factory AuthenticateStateData.fromJson(Map<String, dynamic> json) =>
      _$AuthenticateStateDataFromJson(json);
}

@Riverpod(keepAlive: true)
class AuthenticateNotifier extends _$AuthenticateNotifier {
  @override
  Future<AuthenticateStateData> build() async {
    return const AuthenticateStateData();
  }

  Future<void> login({required String email, required String password}) async {
    try {
      state = const AsyncLoading();
      final authenticate = await ref
          .read(authenticateRepositoryProvider)
          .login(email: email, password: password);

      await Store.put(StoreKey.refreshToken, authenticate.refreshToken);

      state = AsyncData(AuthenticateStateData(authenticate: authenticate));

      // Store the watched access token after the success
      // state so the sign-in screen can show its toast
      // before the router redirects away from /signin.
      await Store.put(StoreKey.accessToken, authenticate.accessToken);

      unawaited(_initializePushNotifications());
    } on ApiException catch (e) {
      _log.warning('Login failed', e);
      state = AsyncError<AuthenticateStateData>(
        AppException.fromError(e),
        e.stackTrace ?? StackTrace.current,
      );
    } catch (e, stack) {
      _log.warning('Login failed unexpectedly', e);
      state = AsyncError<AuthenticateStateData>(
        AppException.fromError(e),
        stack,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    final previous = state.value;
    try {
      state = const AsyncLoading();
      final authenticate = await ref
          .read(authenticateRepositoryProvider)
          .signInWithGoogle();

      // Same write order as login() so the redirect guard
      // (which watches access_token) only fires after the
      // refresh_token is already persisted.
      await Store.put(StoreKey.refreshToken, authenticate.refreshToken);

      state = AsyncData(AuthenticateStateData(authenticate: authenticate));

      await Store.put(StoreKey.accessToken, authenticate.accessToken);

      unawaited(_initializePushNotifications());
    } on GoogleSignInCancelledException {
      // Restore the previous state so the screen's
      // ref.listen does not fire its error branch and
      // no toast is shown (Reqs 1.8, 2.6).
      state = AsyncData(previous ?? const AuthenticateStateData());
    } on ApiException catch (e) {
      _log.warning('Google sign-in failed', e);
      await _clearTokensIfPartial();
      state = AsyncError<AuthenticateStateData>(
        AppException.fromError(e),
        e.stackTrace ?? StackTrace.current,
      );
    } catch (e, stack) {
      _log.warning('Google sign-in failed unexpectedly', e);
      await _clearTokensIfPartial();
      state = AsyncError<AuthenticateStateData>(
        AppException.fromError(e),
        stack,
      );
    }
  }

  /// Removes any access/refresh token that may have been
  /// partially written during a failed sign-in attempt
  /// so no half-written token pair persists in the
  /// `Token_Store` (Req 7.7).
  Future<void> _clearTokensIfPartial() async {
    try {
      await Store.delete(StoreKey.accessToken);
    } catch (e, stack) {
      _log.warning(
        'Failed to clear access token after sign-in failure',
        e,
        stack,
      );
    }
    try {
      await Store.delete(StoreKey.refreshToken);
    } catch (e, stack) {
      _log.warning(
        'Failed to clear refresh token after sign-in failure',
        e,
        stack,
      );
    }
  }

  Future<void> _initializePushNotifications() async {
    try {
      final service = await ref.read(pushNotificationServiceProvider.future);
      await service.initialize();
    } catch (e, stack) {
      _log.warning(
        'Failed to initialize push notifications after login',
        e,
        stack,
      );
    }
  }
}
