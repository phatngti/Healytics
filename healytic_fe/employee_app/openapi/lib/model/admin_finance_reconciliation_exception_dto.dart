//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminFinanceReconciliationExceptionDto {
  /// Returns a new [AdminFinanceReconciliationExceptionDto] instance.
  AdminFinanceReconciliationExceptionDto({
    required this.id,
    required this.detectedAt,
    required this.provider,
    required this.providerEventId,
    this.relatedTransactionId,
    required this.expectedAmount,
    required this.providerAmount,
    required this.difference,
    required this.currency,
    required this.type,
    required this.status,
    required this.owner,
    required this.summary,
  });


  String id;

  String detectedAt;

  AdminFinanceProvider provider;

  String providerEventId;

  String? relatedTransactionId;

  num expectedAmount;

  num providerAmount;

  num difference;

  String currency;

  AdminFinanceReconciliationType type;

  AdminFinanceReconciliationStatus status;

  String owner;

  String summary;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminFinanceReconciliationExceptionDto &&
    other.id == id &&
    other.detectedAt == detectedAt &&
    other.provider == provider &&
    other.providerEventId == providerEventId &&
    other.relatedTransactionId == relatedTransactionId &&
    other.expectedAmount == expectedAmount &&
    other.providerAmount == providerAmount &&
    other.difference == difference &&
    other.currency == currency &&
    other.type == type &&
    other.status == status &&
    other.owner == owner &&
    other.summary == summary;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id.hashCode) +
    (detectedAt.hashCode) +
    (provider.hashCode) +
    (providerEventId.hashCode) +
    (relatedTransactionId == null ? 0 : relatedTransactionId!.hashCode) +
    (expectedAmount.hashCode) +
    (providerAmount.hashCode) +
    (difference.hashCode) +
    (currency.hashCode) +
    (type.hashCode) +
    (status.hashCode) +
    (owner.hashCode) +
    (summary.hashCode);

  @override
  String toString() => 'AdminFinanceReconciliationExceptionDto[id=$id, detectedAt=$detectedAt, provider=$provider, providerEventId=$providerEventId, relatedTransactionId=$relatedTransactionId, expectedAmount=$expectedAmount, providerAmount=$providerAmount, difference=$difference, currency=$currency, type=$type, status=$status, owner=$owner, summary=$summary]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'id'] = this.id;
      json[r'detectedAt'] = this.detectedAt;
      json[r'provider'] = this.provider;
      json[r'providerEventId'] = this.providerEventId;
    if (this.relatedTransactionId != null) {
      json[r'relatedTransactionId'] = this.relatedTransactionId;
    } else {
      json[r'relatedTransactionId'] = null;
    }
      json[r'expectedAmount'] = this.expectedAmount;
      json[r'providerAmount'] = this.providerAmount;
      json[r'difference'] = this.difference;
      json[r'currency'] = this.currency;
      json[r'type'] = this.type;
      json[r'status'] = this.status;
      json[r'owner'] = this.owner;
      json[r'summary'] = this.summary;
    return json;
  }

  /// Returns a new [AdminFinanceReconciliationExceptionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminFinanceReconciliationExceptionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminFinanceReconciliationExceptionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminFinanceReconciliationExceptionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminFinanceReconciliationExceptionDto(
        id: mapValueOfType<String>(json, r'id')!,
        detectedAt: mapValueOfType<String>(json, r'detectedAt')!,
        provider: AdminFinanceProvider.fromJson(json[r'provider'])!,
        providerEventId: mapValueOfType<String>(json, r'providerEventId')!,
        relatedTransactionId: mapValueOfType<String>(json, r'relatedTransactionId'),
        expectedAmount: num.parse('${json[r'expectedAmount']}'),
        providerAmount: num.parse('${json[r'providerAmount']}'),
        difference: num.parse('${json[r'difference']}'),
        currency: mapValueOfType<String>(json, r'currency')!,
        type: AdminFinanceReconciliationType.fromJson(json[r'type'])!,
        status: AdminFinanceReconciliationStatus.fromJson(json[r'status'])!,
        owner: mapValueOfType<String>(json, r'owner')!,
        summary: mapValueOfType<String>(json, r'summary')!,
      );
    }
    return null;
  }

  static List<AdminFinanceReconciliationExceptionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminFinanceReconciliationExceptionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminFinanceReconciliationExceptionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminFinanceReconciliationExceptionDto> mapFromJson(dynamic json) {
    final map = <String, AdminFinanceReconciliationExceptionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminFinanceReconciliationExceptionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminFinanceReconciliationExceptionDto-objects as value to a dart map
  static Map<String, List<AdminFinanceReconciliationExceptionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminFinanceReconciliationExceptionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminFinanceReconciliationExceptionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'id',
    'detectedAt',
    'provider',
    'providerEventId',
    'expectedAmount',
    'providerAmount',
    'difference',
    'currency',
    'type',
    'status',
    'owner',
    'summary',
  };
}

