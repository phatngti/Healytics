//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class AdminPartnerRankingVerificationStatus {
  /// Instantiate a new enum with the provided [value].
  const AdminPartnerRankingVerificationStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const pending = AdminPartnerRankingVerificationStatus._(r'pending');
  static const changesRequired = AdminPartnerRankingVerificationStatus._(r'changesRequired');
  static const approved = AdminPartnerRankingVerificationStatus._(r'approved');
  static const rejected = AdminPartnerRankingVerificationStatus._(r'rejected');

  /// List of all possible values in this [enum][AdminPartnerRankingVerificationStatus].
  static const values = <AdminPartnerRankingVerificationStatus>[
    pending,
    changesRequired,
    approved,
    rejected,
  ];

  static AdminPartnerRankingVerificationStatus? fromJson(dynamic value) => AdminPartnerRankingVerificationStatusTypeTransformer().decode(value);

  static List<AdminPartnerRankingVerificationStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminPartnerRankingVerificationStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminPartnerRankingVerificationStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [AdminPartnerRankingVerificationStatus] to String,
/// and [decode] dynamic data back to [AdminPartnerRankingVerificationStatus].
class AdminPartnerRankingVerificationStatusTypeTransformer {
  factory AdminPartnerRankingVerificationStatusTypeTransformer() => _instance ??= const AdminPartnerRankingVerificationStatusTypeTransformer._();

  const AdminPartnerRankingVerificationStatusTypeTransformer._();

  String encode(AdminPartnerRankingVerificationStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a AdminPartnerRankingVerificationStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  AdminPartnerRankingVerificationStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'pending': return AdminPartnerRankingVerificationStatus.pending;
        case r'changesRequired': return AdminPartnerRankingVerificationStatus.changesRequired;
        case r'approved': return AdminPartnerRankingVerificationStatus.approved;
        case r'rejected': return AdminPartnerRankingVerificationStatus.rejected;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [AdminPartnerRankingVerificationStatusTypeTransformer] instance.
  static AdminPartnerRankingVerificationStatusTypeTransformer? _instance;
}

