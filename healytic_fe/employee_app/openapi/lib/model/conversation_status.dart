//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class ConversationStatus {
  /// Instantiate a new enum with the provided [value].
  const ConversationStatus._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const active = ConversationStatus._(r'active');
  static const archived = ConversationStatus._(r'archived');
  static const closed = ConversationStatus._(r'closed');

  /// List of all possible values in this [enum][ConversationStatus].
  static const values = <ConversationStatus>[
    active,
    archived,
    closed,
  ];

  static ConversationStatus? fromJson(dynamic value) => ConversationStatusTypeTransformer().decode(value);

  static List<ConversationStatus> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ConversationStatus>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ConversationStatus.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ConversationStatus] to String,
/// and [decode] dynamic data back to [ConversationStatus].
class ConversationStatusTypeTransformer {
  factory ConversationStatusTypeTransformer() => _instance ??= const ConversationStatusTypeTransformer._();

  const ConversationStatusTypeTransformer._();

  String encode(ConversationStatus data) => data.value;

  /// Decodes a [dynamic value][data] to a ConversationStatus.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ConversationStatus? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'active': return ConversationStatus.active;
        case r'archived': return ConversationStatus.archived;
        case r'closed': return ConversationStatus.closed;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ConversationStatusTypeTransformer] instance.
  static ConversationStatusTypeTransformer? _instance;
}

