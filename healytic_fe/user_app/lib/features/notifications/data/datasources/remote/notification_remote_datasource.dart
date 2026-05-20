import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:user_app/core/config/app_environment.dart';
import 'package:user_app/core/providers/api.provider.dart';
import 'package:user_app/core/services/api.service.dart';
import 'package:user_app/features/notifications/domain/'
    'entities/notification.entity.dart';
import 'package:user_openapi/api.dart';

import 'notification_mock_data.dart';

final _log = Logger('NotificationDatasource');

// ─── Abstract Interface ────────────────────────────

/// Contract for fetching notification data from
/// a remote source.
abstract class NotificationRemoteDatasource {
  /// Fetches a cursor-paginated page of
  /// notifications from the backend.
  Future<NotificationPage> getNotifications({int limit = 20, String? cursor});

  /// Returns the total unread count.
  Future<int> getUnreadCount();

  /// Mark a single notification as read.
  Future<void> markRead(String notificationId);

  /// Mark all notifications as read.
  /// Returns the number marked.
  Future<int> markAllRead();

  /// Register a device token for push
  /// notifications.
  Future<void> registerDevice({
    required String token,
    required String platform,
  });

  /// Unregister a device token.
  Future<void> unregisterDevice(String token);
}

// ─── Real Implementation ───────────────────────────

/// Calls the backend notification REST APIs via the
/// generated [UserNotificationsApi] OpenAPI client:
/// - GET    /v1/user/notifications
/// - GET    /v1/user/notifications/unread-count
/// - PATCH  /v1/user/notifications/:id/read
/// - PATCH  /v1/user/notifications/read-all
///
/// Device registration uses [UserDevicesApi]:
/// - POST   /v1/user/devices
/// - DELETE /v1/user/devices/:token
class NotificationRemoteDatasourceImpl implements NotificationRemoteDatasource {
  NotificationRemoteDatasourceImpl(this._apiService);
  final ApiService _apiService;

  UserNotificationsApi get _api => _apiService.userNotificationsApi;

  UserDevicesApi get _devicesApi => _apiService.userDevicesApi;

  // ── Methods ──────────────────────────────────────

  @override
  Future<NotificationPage> getNotifications({
    int limit = 20,
    String? cursor,
  }) async {
    try {
      final response = await _api
          .userNotificationControllerGetNotificationsWithHttpInfo(
            limit: limit,
            cursor: cursor,
          );

      if (response.statusCode != 200) {
        _log.warning(
          'getNotifications failed: '
          '${response.statusCode}',
        );
        return const NotificationPage(notifications: [], hasMore: false);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return _mapNotificationPage(json);
    } catch (e, s) {
      _log.severe('getNotifications error', e, s);
      return const NotificationPage(notifications: [], hasMore: false);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _api
          .userNotificationControllerGetUnreadCountWithHttpInfo();

      if (response.statusCode != 200) {
        _log.warning(
          'getUnreadCount failed: '
          '${response.statusCode}',
        );
        return 0;
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      // Defensive: backend may return 'count' or
      // 'unreadCount' or a plain number.
      final raw = json['count'] ?? json['unreadCount'];
      if (raw is num) return raw.toInt();
      return 0;
    } catch (e, s) {
      _log.severe('getUnreadCount error', e, s);
      return 0;
    }
  }

  @override
  Future<void> markRead(String notificationId) async {
    try {
      final response = await _api
          .userNotificationControllerMarkReadWithHttpInfo(notificationId);

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw ApiException(
          response.statusCode,
          'markRead failed: ${response.body}',
        );
      }
    } catch (e, s) {
      _log.warning('markRead error', e, s);
      rethrow;
    }
  }

  @override
  Future<int> markAllRead() async {
    try {
      final response = await _api
          .userNotificationControllerMarkAllReadWithHttpInfo();

      if (response.statusCode != 200) {
        throw ApiException(
          response.statusCode,
          'markAllRead failed: ${response.body}',
        );
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final raw = json['markedCount'] ?? json['count'] ?? 0;
      if (raw is num) return raw.toInt();
      return 0;
    } catch (e, s) {
      _log.severe('markAllRead error', e, s);
      rethrow;
    }
  }

  @override
  Future<void> registerDevice({
    required String token,
    required String platform,
  }) async {
    try {
      final dto = RegisterDeviceDto(
        token: token,
        platform: _mapPlatform(platform),
      );
      await _devicesApi.userDeviceControllerRegisterDevice(dto);
    } catch (e, s) {
      _log.severe('registerDevice error', e, s);
    }
  }

  @override
  Future<void> unregisterDevice(String token) async {
    try {
      await _devicesApi.userDeviceControllerUnregisterDevice(token);
    } catch (e, s) {
      _log.severe('unregisterDevice error', e, s);
    }
  }

  // ── DTO → Entity mappers ──────────────────────────

  /// Maps a platform string to the OpenAPI
  /// [DevicePlatform] enum.
  DevicePlatform _mapPlatform(String platform) {
    return switch (platform.toLowerCase()) {
      'ios' => DevicePlatform.ios,
      'android' => DevicePlatform.android,
      _ => DevicePlatform.android,
    };
  }

  NotificationPage _mapNotificationPage(Map<String, dynamic> json) {
    final list =
        (json['notifications'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    final notifications = list.map(_mapNotification).toList(growable: false);

    return NotificationPage(
      notifications: notifications,
      hasMore: json['hasMore'] as bool? ?? false,
      nextCursor: json['nextCursor'] as String?,
    );
  }

  NotificationEntity _mapNotification(Map<String, dynamic> json) {
    // map raw JSON (may come from WithHttpInfo body)
    final dto = NotificationResponseDto.fromJson(json);
    if (dto == null) {
      throw FormatException('Failed to parse NotificationResponseDto: $json');
    }
    return _mapDto(dto);
  }

  NotificationEntity _mapDto(NotificationResponseDto dto) {
    return NotificationEntity(
      id: dto.id,
      type: _mapNotificationType(dto.type),
      title: dto.title,
      body: dto.body,
      data: _parseData(dto.data),
      isRead: dto.isRead,
      isBroadcast: dto.isBroadcast,
      createdAt: dto.createdAt,
      readAt: _parseReadAt(dto.readAt),
    );
  }

  /// Safely cast the `Object?` DTO data field.
  Map<String, dynamic>? _parseData(Object? raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) {
      return raw.cast<String, dynamic>();
    }
    return null;
  }

  /// Safely parse the `Object?` DTO readAt field.
  DateTime? _parseReadAt(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    if (raw is String) return DateTime.tryParse(raw);
    return null;
  }

  NotificationType _mapNotificationType(NotificationResponseDtoTypeEnum type) {
    return switch (type) {
      NotificationResponseDtoTypeEnum.bookingConfirmed =>
        NotificationType.bookingConfirmed,
      NotificationResponseDtoTypeEnum.bookingCancelled =>
        NotificationType.bookingCancelled,
      NotificationResponseDtoTypeEnum.bookingCompleted =>
        NotificationType.bookingCompleted,
      NotificationResponseDtoTypeEnum.appointmentReminder =>
        NotificationType.appointmentReminder,
      NotificationResponseDtoTypeEnum.appointmentUpdated =>
        NotificationType.appointmentUpdated,
      NotificationResponseDtoTypeEnum.newChatMessage =>
        NotificationType.newChatMessage,
      NotificationResponseDtoTypeEnum.paymentSuccess =>
        NotificationType.paymentSuccess,
      NotificationResponseDtoTypeEnum.paymentFailed =>
        NotificationType.paymentFailed,
      NotificationResponseDtoTypeEnum.systemBroadcast =>
        NotificationType.systemBroadcast,
      NotificationResponseDtoTypeEnum.systemMaintenance =>
        NotificationType.systemMaintenance,
      NotificationResponseDtoTypeEnum.partnerVerified =>
        NotificationType.partnerVerified,
      NotificationResponseDtoTypeEnum.partnerRejected =>
        NotificationType.partnerRejected,
      _ => NotificationType.systemBroadcast,
    };
  }
}

// ─── Mock Implementation ───────────────────────────

/// Returns empty data after a simulated delay.
class NotificationRemoteDatasourceMock implements NotificationRemoteDatasource {
  NotificationRemoteDatasourceMock()
    : _items = List<NotificationEntity>.from(kMockNotifications);

  final List<NotificationEntity> _items;

  @override
  Future<NotificationPage> getNotifications({
    int limit = 20,
    String? cursor,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Mirror backend: exclude broadcasts sent before
    // the simulated account creation date.
    final visible = _items.where((item) {
      if (item.isBroadcast) {
        return !item.createdAt.isBefore(
          kMockAccountCreatedAt,
        );
      }
      return true;
    }).toList();

    final start = _resolveStartIndex(cursor, visible);
    final end = (start + limit).clamp(0, visible.length);
    final pageItems = visible.sublist(start, end);
    final hasMore = end < visible.length;
    final nextCursor =
        hasMore ? pageItems.last.id : null;

    return NotificationPage(
      notifications: pageItems,
      hasMore: hasMore,
      nextCursor: nextCursor,
    );
  }

  @override
  Future<int> getUnreadCount() async {
    await Future.delayed(const Duration(milliseconds: 160));
    return _items.where((item) {
      if (item.isRead) return false;
      if (item.isBroadcast) {
        return !item.createdAt.isBefore(kMockAccountCreatedAt);
      }
      return true;
    }).length;
  }

  @override
  Future<void> markRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 120));
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    _items[index] = _items[index].copyWith(isRead: true);
  }

  @override
  Future<int> markAllRead() async {
    await Future.delayed(const Duration(milliseconds: 180));

    var changed = 0;
    for (var i = 0; i < _items.length; i++) {
      if (_items[i].isRead) continue;
      // Skip broadcasts that predate account creation
      if (_items[i].isBroadcast &&
          _items[i].createdAt.isBefore(kMockAccountCreatedAt)) {
        continue;
      }
      _items[i] = _items[i].copyWith(isRead: true);
      changed++;
    }
    return changed;
  }

  @override
  Future<void> registerDevice({
    required String token,
    required String platform,
  }) async {
    await Future.delayed(const Duration(milliseconds: 120));
  }

  @override
  Future<void> unregisterDevice(String token) async {
    await Future.delayed(const Duration(milliseconds: 120));
  }

  int _resolveStartIndex(
    String? cursor,
    List<NotificationEntity> list,
  ) {
    if (cursor == null || cursor.isEmpty) return 0;
    final cursorIndex =
        list.indexWhere((item) => item.id == cursor);
    if (cursorIndex == -1) return 0;
    return cursorIndex + 1;
  }
}

// ─── Provider ──────────────────────────────────────

final notificationRemoteDatasourceProvider =
    Provider<NotificationRemoteDatasource>((ref) {
      if (AppEnvironment.current.useMock) {
        return NotificationRemoteDatasourceMock();
      }
      final apiService = ref.read(apiServiceProvider);
      return NotificationRemoteDatasourceImpl(apiService);
    });
