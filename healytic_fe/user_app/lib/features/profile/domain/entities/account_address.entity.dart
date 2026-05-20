class AccountAddressEntity {
  const AccountAddressEntity({
    required this.streetAddress,
    required this.ward,
    required this.district,
    required this.cityOrProvince,
    this.provinceId,
    this.districtId,
    this.wardId,
  });

  final String streetAddress;
  final String ward;
  final String district;
  final String cityOrProvince;
  final String? provinceId;
  final String? districtId;
  final String? wardId;

  String get formatted {
    final parts = [
      streetAddress,
      ward,
      district,
      cityOrProvince,
    ].where((value) => value.trim().isNotEmpty).toList();
    return parts.join(', ');
  }

  bool get hasLocationIds {
    return provinceId != null &&
        provinceId!.isNotEmpty &&
        districtId != null &&
        districtId!.isNotEmpty &&
        wardId != null &&
        wardId!.isNotEmpty;
  }
}
