//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminPartnerSortBy {
  /// Instantiate a new enum with the provided [value].
  const AdminPartnerSortBy._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const createdAt = AdminPartnerSortBy._(r'createdAt');
  static const brandName = AdminPartnerSortBy._(r'brandName');
  static const legalName = AdminPartnerSortBy._(r'legalName');
  static const verificationStatus = AdminPartnerSortBy._(r'verificationStatus');
  static const priority = AdminPartnerSortBy._(r'priority');

  /// List of all possible values in this [enum][AdminPartnerSortBy].
  static const values = <AdminPartnerSortBy>[
    createdAt,
    brandName,
    legalName,
    verificationStatus,
    priority,
  ];

  static AdminPartnerSortBy? fromJson(dynamic value) => AdminPartnerSortByTypeTransformer().decode(value);

  static List<AdminPartnerSortBy> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerSortBy>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerSortBy.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPartnerSortBy] to String,
/// and [decode] dynamic data back to [AdminPartnerSortBy].
class AdminPartnerSortByTypeTransformer {
  factory AdminPartnerSortByTypeTransformer() => _instance ??= const AdminPartnerSortByTypeTransformer._();

  const AdminPartnerSortByTypeTransformer._();

  String encode(AdminPartnerSortBy data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminPartnerSortBy.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPartnerSortBy? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'createdAt': return AdminPartnerSortBy.createdAt;
        case r'brandName': return AdminPartnerSortBy.brandName;
        case r'legalName': return AdminPartnerSortBy.legalName;
        case r'verificationStatus': return AdminPartnerSortBy.verificationStatus;
        case r'priority': return AdminPartnerSortBy.priority;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminPartnerSortByTypeTransformer] instance.
  static AdminPartnerSortByTypeTransformer? _instance;
}

