//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

/// Status
class HealthServiceStatus {
  /// Instantiate a new enum with the provided [value].
  const HealthServiceStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const draft = HealthServiceStatus._(r'draft');
  static const active = HealthServiceStatus._(r'active');
  static const archived = HealthServiceStatus._(r'archived');

  /// List of all possible values in this [enum][HealthServiceStatus].
  static const values = <HealthServiceStatus>[
    draft,
    active,
    archived,
  ];

  static HealthServiceStatus? fromJson(dynamic value) => HealthServiceStatusTypeTransformer().decode(value);

  static List<HealthServiceStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <HealthServiceStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HealthServiceStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [HealthServiceStatus] to String,
/// and [decode] dynamic data back to [HealthServiceStatus].
class HealthServiceStatusTypeTransformer {
  factory HealthServiceStatusTypeTransformer() => _instance ??= const HealthServiceStatusTypeTransformer._();

  const HealthServiceStatusTypeTransformer._();

  String encode(HealthServiceStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a HealthServiceStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  HealthServiceStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'draft': return HealthServiceStatus.draft;
        case r'active': return HealthServiceStatus.active;
        case r'archived': return HealthServiceStatus.archived;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [HealthServiceStatusTypeTransformer] instance.
  static HealthServiceStatusTypeTransformer? _instance;
}

