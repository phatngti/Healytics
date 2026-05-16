//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminDashboardNotificationItemDto {
  /// Returns a new [AdminDashboardNotificationItemDto] instance.
  AdminDashboardNotificationItemDto({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.type,
    required this.priority,
    required this.isRead,
    required this.isBroadcast,
  });


  String id;

  String title;

  String body;

  String createdAt;

  AdminDashboardNotificationType type;

  AdminDashboardNotificationPriority priority;

  bool isRead;

  bool isBroadcast;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboardNotificationItemDto &&
    other.id == id &&
    other.title == title &&
    other.body == body &&
    other.createdAt == createdAt &&
    other.type == type &&
    other.priority == priority &&
    other.isRead == isRead &&
    other.isBroadcast == isBroadcast;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (title.hashCode) +
    (body.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (priority.hashCode) +
    (isRead.hashCode) +
    (isBroadcast.hashCode);

  @override
  String toString() => 'AdminDashboardNotificationItemDto[id=$id, title=$title, body=$body, createdAt=$createdAt, type=$type, priority=$priority, isRead=$isRead, isBroadcast=$isBroadcast]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'title'] = this.title;
      json[r'body'] = this.body;
      json[r'createdAt'] = this.createdAt;
      json[r'type'] = this.type;
      json[r'priority'] = this.priority;
      json[r'isRead'] = this.isRead;
      json[r'isBroadcast'] = this.isBroadcast;
    return json;
  }

  /// Returns a new [AdminDashboardNotificationItemDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboardNotificationItemDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminDashboardNotificationItemDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminDashboardNotificationItemDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminDashboardNotificationItemDto(
        id: mapValueOfType<String>(json, r'id')!,
        title: mapValueOfType<String>(json, r'title')!,
        body: mapValueOfType<String>(json, r'body')!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
        type: AdminDashboardNotificationType.fromJson(json[r'type'])!,
        priority: AdminDashboardNotificationPriority.fromJson(json[r'priority'])!,
        isRead: mapValueOfType<bool>(json, r'isRead')!,
        isBroadcast: mapValueOfType<bool>(json, r'isBroadcast')!,
      );
    }
    return null;
  }

  static List<AdminDashboardNotificationItemDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboardNotificationItemDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboardNotificationItemDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboardNotificationItemDto> mapFromJson(dynamic json) {
    final map = <String, AdminDashboardNotificationItemDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboardNotificationItemDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboardNotificationItemDto-objects as value to a dart map
  static Map<String, List<AdminDashboardNotificationItemDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboardNotificationItemDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboardNotificationItemDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'title',
    'body',
    'createdAt',
    'type',
    'priority',
    'isRead',
    'isBroadcast',
  };
}

