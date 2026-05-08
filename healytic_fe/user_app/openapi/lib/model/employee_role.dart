//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class EmployeeRole {
  /// Instantiate a new enum with the provided [value].
  const EmployeeRole._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const DOCTOR = EmployeeRole._(r'DOCTOR');
  static const THERAPIST = EmployeeRole._(r'THERAPIST');
  static const RECEPTIONIST = EmployeeRole._(r'RECEPTIONIST');
  static const MANAGER = EmployeeRole._(r'MANAGER');

  /// List of all possible values in this [enum][EmployeeRole].
  static const values = <EmployeeRole>[
    DOCTOR,
    THERAPIST,
    RECEPTIONIST,
    MANAGER,
  ];

  static EmployeeRole? fromJson(dynamic value) => EmployeeRoleTypeTransformer().decode(value);

  static List<EmployeeRole> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <EmployeeRole>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = EmployeeRole.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [EmployeeRole] to String,
/// and [decode] dynamic data back to [EmployeeRole].
class EmployeeRoleTypeTransformer {
  factory EmployeeRoleTypeTransformer() => _instance ??= const EmployeeRoleTypeTransformer._();

  const EmployeeRoleTypeTransformer._();

  String encode(EmployeeRole data) => data.value;

  /// Decodes a [dynamic value][data] to a EmployeeRole.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  EmployeeRole? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'DOCTOR': return EmployeeRole.DOCTOR;
        case r'THERAPIST': return EmployeeRole.THERAPIST;
        case r'RECEPTIONIST': return EmployeeRole.RECEPTIONIST;
        case r'MANAGER': return EmployeeRole.MANAGER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [EmployeeRoleTypeTransformer] instance.
  static EmployeeRoleTypeTransformer? _instance;
}

