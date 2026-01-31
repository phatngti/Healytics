import 'package:admin_panel/features/authenticate/domain/location.entity.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for Location Details verification.
///
/// Displays location fields with verification status indicators showing
/// which fields need updates and any admin feedback.
class LocationForm extends StatelessWidget {
  /// Creates a new [LocationForm].
  const LocationForm({
    required this.info,
    this.onFieldChanged,
    this.provinces = const [],
    this.districts = const [],
    this.wards = const [],
    super.key,
  });

  /// The location details verification data.
  final LocationDetailsInfo? info;

  /// Callback when a field value changes.
  final void Function(String fieldKey, String value)? onFieldChanged;

  /// List of available provinces for dropdown selection.
  final List<LocationEntity> provinces;

  /// List of available districts for dropdown selection.
  final List<LocationEntity> districts;

  /// List of available wards for dropdown selection.
  final List<LocationEntity> wards;

  /// Converts LocationEntity list to dropdown-friendly string list.
  List<String> _toDropdownItems(List<LocationEntity> locations) {
    return locations.map((l) => l.fullName ?? l.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (info == null) {
      return const Center(child: Text('No location information available'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Province, District, Ward
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VerificationTextField(
                      label: 'Province',
                      field: info!.provinceId,
                      hintText: 'Select Province',
                      isDropdown: true,
                      dropdownItems: _toDropdownItems(provinces),
                      onChanged: (value) =>
                          onFieldChanged?.call('province_id', value),
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: VerificationTextField(
                      label: 'District',
                      field: info!.districtId,
                      hintText: 'Select District',
                      isDropdown: true,
                      dropdownItems: _toDropdownItems(districts),
                      onChanged: (value) =>
                          onFieldChanged?.call('district_id', value),
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: VerificationTextField(
                      label: 'Ward',
                      field: info!.wardId,
                      hintText: 'Select Ward',
                      isDropdown: true,
                      dropdownItems: _toDropdownItems(wards),
                      onChanged: (value) =>
                          onFieldChanged?.call('ward_id', value),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                VerificationTextField(
                  label: 'Province',
                  field: info!.provinceId,
                  hintText: 'Select Province',
                  isDropdown: true,
                  dropdownItems: _toDropdownItems(provinces),
                  onChanged: (value) =>
                      onFieldChanged?.call('province_id', value),
                ),
                AppDimens.verticalMedium,
                VerificationTextField(
                  label: 'District',
                  field: info!.districtId,
                  hintText: 'Select District',
                  isDropdown: true,
                  dropdownItems: _toDropdownItems(districts),
                  onChanged: (value) =>
                      onFieldChanged?.call('district_id', value),
                ),
                AppDimens.verticalMedium,
                VerificationTextField(
                  label: 'Ward',
                  field: info!.wardId,
                  hintText: 'Select Ward',
                  isDropdown: true,
                  dropdownItems: _toDropdownItems(wards),
                  onChanged: (value) => onFieldChanged?.call('ward_id', value),
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Street Address
        VerificationTextField(
          label: 'Street Address',
          field: info!.streetAddress,
          hintText: '123 Harmony Lane, Suite 400',
          onChanged: (value) => onFieldChanged?.call('street_address', value),
        ),
      ],
    );
  }
}
