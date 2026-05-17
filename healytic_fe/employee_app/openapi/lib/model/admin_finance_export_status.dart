//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminFinanceExportStatus {
  /// Instantiate a new enum with the provided [value].
  const AdminFinanceExportStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const queued = AdminFinanceExportStatus._(r'queued');
  static const processing = AdminFinanceExportStatus._(r'processing');
  static const ready = AdminFinanceExportStatus._(r'ready');
  static const failed = AdminFinanceExportStatus._(r'failed');
  static const expired = AdminFinanceExportStatus._(r'expired');

  /// List of all possible values in this [enum][AdminFinanceExportStatus].
  static const values = <AdminFinanceExportStatus>[
    queued,
    processing,
    ready,
    failed,
    expired,
  ];

  static AdminFinanceExportStatus? fromJson(dynamic value) => AdminFinanceExportStatusTypeTransformer().decode(value);

  static List<AdminFinanceExportStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceExportStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceExportStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminFinanceExportStatus] to String,
/// and [decode] dynamic data back to [AdminFinanceExportStatus].
class AdminFinanceExportStatusTypeTransformer {
  factory AdminFinanceExportStatusTypeTransformer() => _instance ??= const AdminFinanceExportStatusTypeTransformer._();

  const AdminFinanceExportStatusTypeTransformer._();

  String encode(AdminFinanceExportStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminFinanceExportStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminFinanceExportStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'queued': return AdminFinanceExportStatus.queued;
        case r'processing': return AdminFinanceExportStatus.processing;
        case r'ready': return AdminFinanceExportStatus.ready;
        case r'failed': return AdminFinanceExportStatus.failed;
        case r'expired': return AdminFinanceExportStatus.expired;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminFinanceExportStatusTypeTransformer] instance.
  static AdminFinanceExportStatusTypeTransformer? _instance;
}

