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

  /// The address info verification data.
  final AddressInfo? info;

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
                  if (info!.city != null)
                    Expanded(
                      child: VerificationTextField(
                        label: 'Province',
                        fieldId: info!.city!.fieldKey,
                        field: info!.city!,
                        isDropdown: true,
                        dropdownItems: _toDropdownItems(provinces),
                        onChanged: (value) =>
                            onFieldChanged?.call(info!.city!.fieldKey, value),
                      ),
                    ),
                  AppDimens.horizontalMedium,
                  if (info!.district != null)
                    Expanded(
                      child: VerificationTextField(
                        label: 'District',
                        fieldId: info!.district!.fieldKey,
                        field: info!.district!,
                        isDropdown: true,
                        dropdownItems: _toDropdownItems(districts),
                        onChanged: (value) => onFieldChanged?.call(
                          info!.district!.fieldKey,
                          value,
                        ),
                      ),
                    ),
                  AppDimens.horizontalMedium,
                  if (info!.ward != null)
                    Expanded(
                      child: VerificationTextField(
                        label: 'Ward',
                        fieldId: info!.ward!.fieldKey,
                        field: info!.ward!,
                        isDropdown: true,
                        dropdownItems: _toDropdownItems(wards),
                        onChanged: (value) =>
                            onFieldChanged?.call(info!.ward!.fieldKey, value),
                      ),
                    ),
                ],
              );
            }

            return Column(
              children: [
                if (info!.city != null) ...[
                  VerificationTextField(
                    label: 'Province',
                    fieldId: info!.city!.fieldKey,
                    field: info!.city!,
                    isDropdown: true,
                    dropdownItems: _toDropdownItems(provinces),
                    onChanged: (value) =>
                        onFieldChanged?.call(info!.city!.fieldKey, value),
                  ),
                  AppDimens.verticalMedium,
                ],
                if (info!.district != null) ...[
                  VerificationTextField(
                    label: 'District',
                    fieldId: info!.district!.fieldKey,
                    field: info!.district!,
                    isDropdown: true,
                    dropdownItems: _toDropdownItems(districts),
                    onChanged: (value) =>
                        onFieldChanged?.call('district', value),
                  ),
                  AppDimens.verticalMedium,
                ],
                if (info!.ward != null)
                  VerificationTextField(
                    label: 'Ward',
                    fieldId: info!.ward!.fieldKey,
                    field: info!.ward!,
                    isDropdown: true,
                    dropdownItems: _toDropdownItems(wards),
                    onChanged: (value) =>
                        onFieldChanged?.call(info!.ward!.fieldKey, value),
                  ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Street Address
        VerificationTextField(
          label: 'Street Address',
          fieldId: info!.streetAddress!.fieldKey,
          field: info!.streetAddress!,
          onChanged: (value) =>
              onFieldChanged?.call(info!.streetAddress!.fieldKey, value),
        ),
      ],
    );
  }
}
