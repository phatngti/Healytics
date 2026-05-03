//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegisterPartnerDto {
  /// Returns a new [RegisterPartnerDto] instance.
  RegisterPartnerDto({
    required this.account,
    required this.partner,
    required this.legalRepresentative,
  });


  /// Account credentials for login
  AccountRequestDto account;

  /// Partner (Business Entity) information
  PartnerRequestDto partner;

  /// Legal representative information
  LegalRepresentativeRequestDto legalRepresentative;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegisterPartnerDto &&
    other.account == account &&
    other.partner == partner &&
    other.legalRepresentative == legalRepresentative;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (account.hashCode) +
    (partner.hashCode) +
    (legalRepresentative.hashCode);

  @override
  String toString() => 'RegisterPartnerDto[account=$account, partner=$partner, legalRepresentative=$legalRepresentative]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'account'] = this.account;
      json[r'partner'] = this.partner;
      json[r'legalRepresentative'] = this.legalRepresentative;
    return json;
  }

  /// Returns a new [RegisterPartnerDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegisterPartnerDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RegisterPartnerDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RegisterPartnerDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RegisterPartnerDto(
        account: AccountRequestDto.fromJson(json[r'account'])!,
        partner: PartnerRequestDto.fromJson(json[r'partner'])!,
        legalRepresentative: LegalRepresentativeRequestDto.fromJson(json[r'legalRepresentative'])!,
      );
    }
    return null;
  }

  static List<RegisterPartnerDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterPartnerDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterPartnerDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegisterPartnerDto> mapFromJson(dynamic json) {
    final map = <String, RegisterPartnerDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegisterPartnerDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegisterPartnerDto-objects as value to a dart map
  static Map<String, List<RegisterPartnerDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegisterPartnerDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegisterPartnerDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'account',
    'partner',
    'legalRepresentative',
  };
}

