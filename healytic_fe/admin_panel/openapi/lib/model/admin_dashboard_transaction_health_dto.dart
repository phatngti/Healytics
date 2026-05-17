//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AdminDashboardTransactionHealthDto {
  /// Returns a new [AdminDashboardTransactionHealthDto] instance.
  AdminDashboardTransactionHealthDto({
    required this.totalTransactions,
    required this.paid,
    required this.pending,
    required this.refunded,
    required this.failed,
    required this.canceled,
    required this.grossRevenue,
    required this.refundAmount,
    required this.failedAmount,
  });


  num totalTransactions;

  num paid;

  num pending;

  num refunded;

  num failed;

  num canceled;

  num grossRevenue;

  num refundAmount;

  num failedAmount;

  @override
  bool operator ==(Object other) => identical(this, other) || other is AdminDashboardTransactionHealthDto &&
    other.totalTransactions == totalTransactions &&
    other.paid == paid &&
    other.pending == pending &&
    other.refunded == refunded &&
    other.failed == failed &&
    other.canceled == canceled &&
    other.grossRevenue == grossRevenue &&
    other.refundAmount == refundAmount &&
    other.failedAmount == failedAmount;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalTransactions.hashCode) +
    (paid.hashCode) +
    (pending.hashCode) +
    (refunded.hashCode) +
    (failed.hashCode) +
    (canceled.hashCode) +
    (grossRevenue.hashCode) +
    (refundAmount.hashCode) +
    (failedAmount.hashCode);

  @override
  String toString() => 'AdminDashboardTransactionHealthDto[totalTransactions=$totalTransactions, paid=$paid, pending=$pending, refunded=$refunded, failed=$failed, canceled=$canceled, grossRevenue=$grossRevenue, refundAmount=$refundAmount, failedAmount=$failedAmount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'totalTransactions'] = this.totalTransactions;
      json[r'paid'] = this.paid;
      json[r'pending'] = this.pending;
      json[r'refunded'] = this.refunded;
      json[r'failed'] = this.failed;
      json[r'canceled'] = this.canceled;
      json[r'grossRevenue'] = this.grossRevenue;
      json[r'refundAmount'] = this.refundAmount;
      json[r'failedAmount'] = this.failedAmount;
    return json;
  }

  /// Returns a new [AdminDashboardTransactionHealthDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AdminDashboardTransactionHealthDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "AdminDashboardTransactionHealthDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "AdminDashboardTransactionHealthDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AdminDashboardTransactionHealthDto(
        totalTransactions: num.parse('${json[r'totalTransactions']}'),
        paid: num.parse('${json[r'paid']}'),
        pending: num.parse('${json[r'pending']}'),
        refunded: num.parse('${json[r'refunded']}'),
        failed: num.parse('${json[r'failed']}'),
        canceled: num.parse('${json[r'canceled']}'),
        grossRevenue: num.parse('${json[r'grossRevenue']}'),
        refundAmount: num.parse('${json[r'refundAmount']}'),
        failedAmount: num.parse('${json[r'failedAmount']}'),
      );
    }
    return null;
  }

  static List<AdminDashboardTransactionHealthDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <AdminDashboardTransactionHealthDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AdminDashboardTransactionHealthDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AdminDashboardTransactionHealthDto> mapFromJson(dynamic json) {
    final map = <String, AdminDashboardTransactionHealthDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AdminDashboardTransactionHealthDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AdminDashboardTransactionHealthDto-objects as value to a dart map
  static Map<String, List<AdminDashboardTransactionHealthDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<AdminDashboardTransactionHealthDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AdminDashboardTransactionHealthDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'totalTransactions',
    'paid',
    'pending',
    'refunded',
    'failed',
    'canceled',
    'grossRevenue',
    'refundAmount',
    'failedAmount',
  };
}

