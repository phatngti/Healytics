//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceExportJobDto {
  /// Returns a new [AdminFinanceExportJobDto] instance.
  AdminFinanceExportJobDto({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.requestedBy,
    required this.status,
    required this.rowCount,
    this.downloadUrl,
    this.expiresAt,
  });


  String id;

  String createdAt;

  AdminFinanceExportType type;

  String requestedBy;

  AdminFinanceExportStatus status;

  num rowCount;

  String? downloadUrl;

  String? expiresAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceExportJobDto &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.type == type &&
    other.requestedBy == requestedBy &&
    other.status == status &&
    other.rowCount == rowCount &&
    other.downloadUrl == downloadUrl &&
    other.expiresAt == expiresAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (createdAt.hashCode) +
    (type.hashCode) +
    (requestedBy.hashCode) +
    (status.hashCode) +
    (rowCount.hashCode) +
    (downloadUrl == null ? 0 : downloadUrl!.hashCode) +
    (expiresAt == null ? 0 : expiresAt!.hashCode);

  @override
  String toString() => 'AdminFinanceExportJobDto[id=$id, createdAt=$createdAt, type=$type, requestedBy=$requestedBy, status=$status, rowCount=$rowCount, downloadUrl=$downloadUrl, expiresAt=$expiresAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'createdAt'] = this.createdAt;
      json[r'type'] = this.type;
      json[r'requestedBy'] = this.requestedBy;
      json[r'status'] = this.status;
      json[r'rowCount'] = this.rowCount;
    if (this.downloadUrl != null) {
      json[r'downloadUrl'] = this.downloadUrl;
    } else {
      json[r'downloadUrl'] = null;
    }
    if (this.expiresAt != null) {
      json[r'expiresAt'] = this.expiresAt;
    } else {
      json[r'expiresAt'] = null;
    }
    return json;
  }

  /// Returns a new [AdminFinanceExportJobDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceExportJobDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceExportJobDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceExportJobDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceExportJobDto(
        id: mapValueOfType<String>(json, r'id')!,
        createdAt: mapValueOfType<String>(json, r'createdAt')!,
        type: AdminFinanceExportType.fromJson(json[r'type'])!,
        requestedBy: mapValueOfType<String>(json, r'requestedBy')!,
        status: AdminFinanceExportStatus.fromJson(json[r'status'])!,
        rowCount: num.parse('${json[r'rowCount']}'),
        downloadUrl: mapValueOfType<String>(json, r'downloadUrl'),
        expiresAt: mapValueOfType<String>(json, r'expiresAt'),
      );
    }
    return null;
  }

  static List<AdminFinanceExportJobDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceExportJobDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceExportJobDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceExportJobDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceExportJobDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceExportJobDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceExportJobDto-objects as value to a dart map
  static Map<String, List<AdminFinanceExportJobDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceExportJobDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceExportJobDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'createdAt',
    'type',
    'requestedBy',
    'status',
    'rowCount',
  };
}

