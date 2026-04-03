import 'dart:io' show Platform;

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/providers/auth_session.provider.dart';
import 'package:user_app/features/notifications/'
    'data/datasources/remote/'
    'notification_remote_datasource.dart';

part 'push_notification_flutter.service.g.dart';

final _log = Logger('PushNotificationFlutter');

/// Flutter-side push notification service.
///
/// **Current mode: MOCK** — no Firebase dependency.
/// This service registers a synthetic device token
/// with the backend so the REST device-registration
/// flow is exercised end-to-end.
///
/// To enable real push support, replace the mock
/// methods with `firebase_messaging` and
/// `flutter_local_notifications` calls.
class PushNotificationFlutterService {
  PushNotificationFlutterService({
    required NotificationRemoteDatasource datasource,
    required String? userId,
  })  : _datasource = datasource,
        _userId = userId;

  final NotificationRemoteDatasource _datasource;
  final String? _userId;
  bool _initialized = false;

  /// Initialise the service. Safe to call multiple
  /// times — subsequent calls are no-ops.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    _log.info(
      'Push notifications: MOCK mode '
      '(no Firebase credentials configured)',
    );

    // Request permission (mock — always granted)
    final granted = await requestPermission();
    if (!granted) {
      _log.warning('Push permission denied');
      return;
    }

    // Register mock token
    final token = getToken();
    if (_userId != null) {
      await _registerToken(token);
    } else {
      _log.warning(
        'No userId available — skipping token'
        ' registration',
      );
    }
  }

  /// Mock permission request. Returns `true`.
  Future<bool> requestPermission() async {
    _log.fine('Mock: permission granted');
    return true;
  }

  /// Returns a mock FCM/APNs token.
  String getToken() {
    final ts = DateTime.now().millisecondsSinceEpoch;
    return 'mock-fcm-token-$ts';
  }

  /// Registers the token with the backend.
  Future<void> _registerToken(String token) async {
    final platform =
        Platform.isIOS ? 'ios' : 'android';
    try {
      await _datasource.registerDevice(
        token: token,
        platform: platform,
      );
      _log.info(
        'Registered mock device token: '
        '${token.substring(0, 20)}... '
        '(platform: $platform)',
      );
    } catch (e) {
      _log.warning(
        'Failed to register device token: $e',
      );
    }
  }
}

// ─── Provider ──────────────────────────────────────

/// Provides and eagerly initialises the mock push
/// notification service after the user authenticates.
///
/// Watch this in the shell route alongside the WS
/// connection provider.
@Riverpod(keepAlive: true)
Future<PushNotificationFlutterService>
    pushNotificationService(Ref ref) async {
  final datasource = ref.read(
    notificationRemoteDatasourceProvider,
  );
  final userId = ref.read(currentUserIdProvider);

  final service = PushNotificationFlutterService(
    datasource: datasource,
    userId: userId,
  );

  await service.initialize();
  return service;
}
