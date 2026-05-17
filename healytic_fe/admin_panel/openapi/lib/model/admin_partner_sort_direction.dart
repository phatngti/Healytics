//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminPartnerSortDirection {
  /// Instantiate a new enum with the provided [value].
  const AdminPartnerSortDirection._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const ASC = AdminPartnerSortDirection._(r'ASC');
  static const DESC = AdminPartnerSortDirection._(r'DESC');

  /// List of all possible values in this [enum][AdminPartnerSortDirection].
  static const values = <AdminPartnerSortDirection>[
    ASC,
    DESC,
  ];

  static AdminPartnerSortDirection? fromJson(dynamic value) => AdminPartnerSortDirectionTypeTransformer().decode(value);

  static List<AdminPartnerSortDirection> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerSortDirection>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerSortDirection.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPartnerSortDirection] to String,
/// and [decode] dynamic data back to [AdminPartnerSortDirection].
class AdminPartnerSortDirectionTypeTransformer {
  factory AdminPartnerSortDirectionTypeTransformer() => _instance ??= const AdminPartnerSortDirectionTypeTransformer._();

  const AdminPartnerSortDirectionTypeTransformer._();

  String encode(AdminPartnerSortDirection data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminPartnerSortDirection.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPartnerSortDirection? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'ASC': return AdminPartnerSortDirection.ASC;
        case r'DESC': return AdminPartnerSortDirection.DESC;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminPartnerSortDirectionTypeTransformer] instance.
  static AdminPartnerSortDirectionTypeTransformer? _instance;
}

