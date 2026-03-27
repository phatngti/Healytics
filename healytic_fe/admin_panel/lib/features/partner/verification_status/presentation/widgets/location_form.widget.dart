import 'package:admin_panel/features/authenticate/domain/location.entity.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/location.provider.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Form section for Location Details verification.
///
/// Displays location fields with verification status indicators showing
/// which fields need updates and any admin feedback.
///
/// Implements cascading dropdowns: selecting a province fetches districts,
/// selecting a district fetches wards.
class LocationForm extends ConsumerStatefulWidget {
  /// Creates a new [LocationForm].
  const LocationForm({
    required this.info,
    this.onFieldChanged,
    this.provinces = const [],
    super.key,
  });

  /// The address info verification data.
  final AddressInfo? info;

  /// Callback when a field value changes.
  final void Function(String fieldKey, String value)? onFieldChanged;

  /// List of available provinces for dropdown selection.
  final List<LocationEntity> provinces;

  @override
  ConsumerState<LocationForm> createState() => _LocationFormState();
}

class _LocationFormState extends ConsumerState<LocationForm> {
  /// Currently selected province ID (for fetching districts).
  String? _selectedProvinceId;

  /// Currently selected district ID (for fetching wards).
  String? _selectedDistrictId;

  @override
  void initState() {
    super.initState();
    // Initialize selected IDs from current field values if available
    _initializeSelectedIds();
  }

  /// Extracts the initial province and district IDs from the address info.
  void _initializeSelectedIds() {
    final info = widget.info;
    if (info == null) return;

    // Try to find matching province by name and get its ID
    final cityValue = info.city?.value;
    if (cityValue != null) {
      final cityName = _extractLocationName(cityValue);
      final matchingProvince = widget.provinces.firstWhere(
        (p) => p.fullName == cityName || p.name == cityName,
        orElse: () => const LocationEntity(id: '', name: ''),
      );
      if (matchingProvince.id.isNotEmpty) {
        _selectedProvinceId = matchingProvince.id;
      }
    }
  }

  /// Extracts location name from various value formats.
  String _extractLocationName(dynamic value) {
    if (value is String) return value;
    if (value is Map) return value['name']?.toString() ?? value.toString();
    return value.toString();
  }

  /// Converts LocationEntity list to dropdown-friendly CustomDropdownItem list.
  List<CustomDropdownItem> _toDropdownItems(List<LocationEntity> locations) {
    return locations
        .map(
          (l) => CustomDropdownItem(value: l.id, label: l.fullName ?? l.name),
        )
        .toList();
  }

  /// Handles province selection change.
  void _onProvinceChanged(CustomDropdownItem item) {
    // Only update if a valid selection was made
    if (item.value.isEmpty) return;

    setState(() {
      _selectedProvinceId = item.value;
      // Reset district when province changes
      _selectedDistrictId = null;
    });
    widget.onFieldChanged?.call(widget.info!.city!.fieldKey, item.value);
  }

  /// Handles district selection change.
  void _onDistrictChanged(CustomDropdownItem item) {
    // Only update if a valid selection was made
    if (item.value.isEmpty) return;

    setState(() {
      _selectedDistrictId = item.value;
    });
    widget.onFieldChanged?.call(
      widget.info?.district?.fieldKey ?? '',
      item.value,
    );
  }

  /// Handles ward selection change.
  void _onWardChanged(CustomDropdownItem item) {
    // Only update if a valid selection was made
    if (item.value.isEmpty) return;

    widget.onFieldChanged?.call(widget.info?.ward?.fieldKey ?? '', item.value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.info == null) {
      return const Center(child: Text('No location information available'));
    }

    // Watch districts provider based on selected province
    final districtsAsync = ref.watch(districtsProvider(_selectedProvinceId));

    // Watch wards provider based on selected district
    final wardsAsync = ref.watch(wardsProvider(_selectedDistrictId));

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
                  if (widget.info!.city != null)
                    Expanded(
                      child: VerificationTextField(
                        label: 'Province',
                        fieldId: widget.info!.city!.fieldKey,
                        field: widget.info!.city!,
                        isDropdown: true,
                        dropdownItems: _toDropdownItems(widget.provinces),
                        onDropdownChanged: _onProvinceChanged,
                      ),
                    ),
                  AppDimens.horizontalMedium,
                  if (widget.info!.district != null)
                    Expanded(child: _buildDistrictField(districtsAsync)),
                  AppDimens.horizontalMedium,
                  if (widget.info!.ward != null)
                    Expanded(child: _buildWardField(wardsAsync)),
                ],
              );
            }

            return Column(
              children: [
                if (widget.info!.city != null) ...[
                  VerificationTextField(
                    label: 'Province',
                    fieldId: widget.info!.city!.fieldKey,
                    field: widget.info!.city!,
                    isDropdown: true,
                    dropdownItems: _toDropdownItems(widget.provinces),
                    onDropdownChanged: _onProvinceChanged,
                  ),
                  AppDimens.verticalMedium,
                ],
                if (widget.info!.district != null) ...[
                  _buildDistrictField(districtsAsync),
                  AppDimens.verticalMedium,
                ],
                if (widget.info!.ward != null) _buildWardField(wardsAsync),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Street Address
        VerificationTextField(
          label: 'Street Address',
          fieldId: widget.info!.streetAddress.fieldKey,
          field: widget.info!.streetAddress,
        ),
      ],
    );
  }

  /// Builds the district dropdown field with loading/error states.
  Widget _buildDistrictField(AsyncValue<List<LocationEntity>> districtsAsync) {
    return districtsAsync.when(
      loading: () => _buildLoadingField('District'),
      error: (error, _) => _buildErrorField('District', error.toString()),
      data: (districts) => VerificationTextField(
        label: 'District',
        fieldId: widget.info!.district!.fieldKey,
        field: widget.info!.district!,
        isDropdown: true,
        dropdownItems: _toDropdownItems(districts),
        onDropdownChanged: _onDistrictChanged,
      ),
    );
  }

  /// Builds the ward dropdown field with loading/error states.
  Widget _buildWardField(AsyncValue<List<LocationEntity>> wardsAsync) {
    return wardsAsync.when(
      loading: () => _buildLoadingField('Ward'),
      error: (error, _) => _buildErrorField('Ward', error.toString()),
      data: (wards) => VerificationTextField(
        label: 'Ward',
        fieldId: widget.info!.ward!.fieldKey,
        field: widget.info!.ward!,
        isDropdown: true,
        dropdownItems: _toDropdownItems(wards),
        onDropdownChanged: _onWardChanged,
      ),
    );
  }

  /// Builds a loading placeholder for a location field.
  Widget _buildLoadingField(String label) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds an error placeholder for a location field.
  Widget _buildErrorField(String label, String error) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.error,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.error),
          ),
          child: Text(
            'Failed to load: $error',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onErrorContainer,
            ),
          ),
        ),
      ],
    );
  }
}
