//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminPartnerScope {
  /// Instantiate a new enum with the provided [value].
  const AdminPartnerScope._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const VERIFICATION_QUEUE = AdminPartnerScope._(r'VERIFICATION_QUEUE');
  static const ALL_PROVIDERS = AdminPartnerScope._(r'ALL_PROVIDERS');

  /// List of all possible values in this [enum][AdminPartnerScope].
  static const values = <AdminPartnerScope>[
    VERIFICATION_QUEUE,
    ALL_PROVIDERS,
  ];

  static AdminPartnerScope? fromJson(dynamic value) => AdminPartnerScopeTypeTransformer().decode(value);

  static List<AdminPartnerScope> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerScope>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerScope.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPartnerScope] to String,
/// and [decode] dynamic data back to [AdminPartnerScope].
class AdminPartnerScopeTypeTransformer {
  factory AdminPartnerScopeTypeTransformer() => _instance ??= const AdminPartnerScopeTypeTransformer._();

  const AdminPartnerScopeTypeTransformer._();

  String encode(AdminPartnerScope data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminPartnerScope.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPartnerScope? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'VERIFICATION_QUEUE': return AdminPartnerScope.VERIFICATION_QUEUE;
        case r'ALL_PROVIDERS': return AdminPartnerScope.ALL_PROVIDERS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminPartnerScopeTypeTransformer] instance.
  static AdminPartnerScopeTypeTransformer? _instance;
}

