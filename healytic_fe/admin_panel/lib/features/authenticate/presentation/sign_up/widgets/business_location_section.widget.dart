import 'package:admin_panel/features/authenticate/domain/location.entity.dart';
import 'package:admin_panel/features/authenticate/presentation/providers/location.provider.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Business Location subsection of Partner Registration.
///
/// Contains:
/// - Province/City dropdown (fetched from API)
/// - District dropdown (cascading based on province)
/// - Ward/Commune dropdown (cascading based on district)
/// - Street Address text field
class BusinessLocationSection extends ConsumerStatefulWidget {
  /// Initial province ID.
  final String? initialProvinceId;

  /// Initial district ID.
  final String? initialDistrictId;

  /// Initial ward ID.
  final String? initialWardId;

  /// Initial street address.
  final String? initialStreetAddress;

  const BusinessLocationSection({
    super.key,
    this.initialProvinceId,
    this.initialDistrictId,
    this.initialWardId,
    this.initialStreetAddress,
  });

  @override
  ConsumerState<BusinessLocationSection> createState() =>
      _BusinessLocationSectionState();
}

class _BusinessLocationSectionState
    extends ConsumerState<BusinessLocationSection> {
  String? _selectedProvinceId;
  String? _selectedDistrictId;
  String? _selectedWardId;

  @override
  void initState() {
    super.initState();
    _selectedProvinceId = widget.initialProvinceId;
    _selectedDistrictId = widget.initialDistrictId;
    _selectedWardId = widget.initialWardId;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Watch location providers
    final provincesAsync = ref.watch(provincesProvider);
    final districtsAsync = ref.watch(districtsProvider(_selectedProvinceId));
    final wardsAsync = ref.watch(wardsProvider(_selectedDistrictId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          padding: const EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.1),
                width: 1,
              ),
            ),
          ),
          child: Text(
            'BUSINESS LOCATION',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.fontSizeLarge,
            ),
          ),
        ),
        AppDimens.verticalMedium,

        // Row 1: Province, District, Ward (3-column on desktop)
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildProvinceDropdown(
                      context,
                      provincesAsync: provincesAsync,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _buildDistrictDropdown(
                      context,
                      districtsAsync: districtsAsync,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _buildWardDropdown(context, wardsAsync: wardsAsync),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _buildProvinceDropdown(context, provincesAsync: provincesAsync),
                AppDimens.verticalMedium,
                _buildDistrictDropdown(context, districtsAsync: districtsAsync),
                AppDimens.verticalMedium,
                _buildWardDropdown(context, wardsAsync: wardsAsync),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Street Address & Clinic Phone
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildTextFieldWithLabel(
                      context,
                      label: 'Street Address',
                      fieldKey: 'street_address',
                      hintText: 'e.g. 123 Nguyen Hue Street',
                      initialValue: widget.initialStreetAddress,
                      isRequired: true,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'clinic_phone',
                      label: 'Clinic Phone',
                      hintText: '028 1234 5678',
                      keyboardType: TextInputType.phone,
                      isRequired: true,
                      validator: _validatePhone,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _buildTextFieldWithLabel(
                  context,
                  label: 'Street Address',
                  fieldKey: 'street_address',
                  hintText: 'e.g. 123 Nguyen Hue Street',
                  initialValue: widget.initialStreetAddress,
                  isRequired: true,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'clinic_phone',
                  label: 'Clinic Phone',
                  hintText: '028 1234 5678',
                  keyboardType: TextInputType.phone,
                  isRequired: true,
                  validator: _validatePhone,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  /// Builds the province dropdown with loading/error handling.
  Widget _buildProvinceDropdown(
    BuildContext context, {
    required AsyncValue<List<LocationEntity>> provincesAsync,
  }) {
    return _buildLocationDropdown(
      context,
      label: 'Province/City',
      fieldKey: 'province',
      asyncValue: provincesAsync,
      selectedId: _selectedProvinceId,
      hintText: 'Select Province',
      onChanged: (id) {
        setState(() {
          _selectedProvinceId = id;
          _selectedDistrictId = null;
          _selectedWardId = null;
        });
      },
      isRequired: true,
    );
  }

  /// Builds the district dropdown with loading/error handling.
  Widget _buildDistrictDropdown(
    BuildContext context, {
    required AsyncValue<List<LocationEntity>> districtsAsync,
  }) {
    return _buildLocationDropdown(
      context,
      label: 'District',
      fieldKey: 'district',
      asyncValue: districtsAsync,
      selectedId: _selectedDistrictId,
      hintText: 'Select District',
      enabled: _selectedProvinceId != null,
      onChanged: (id) {
        setState(() {
          _selectedDistrictId = id;
          _selectedWardId = null;
        });
      },
    );
  }

  /// Builds the ward dropdown with loading/error handling.
  Widget _buildWardDropdown(
    BuildContext context, {
    required AsyncValue<List<LocationEntity>> wardsAsync,
  }) {
    return _buildLocationDropdown(
      context,
      label: 'Ward/Commune',
      fieldKey: 'ward',
      asyncValue: wardsAsync,
      selectedId: _selectedWardId,
      hintText: 'Select Ward',
      enabled: _selectedDistrictId != null,
      onChanged: (id) {
        setState(() {
          _selectedWardId = id;
        });
      },
    );
  }

  /// Generic builder for location dropdowns with async state handling.
  Widget _buildLocationDropdown(
    BuildContext context, {
    required String label,
    required String fieldKey,
    required AsyncValue<List<LocationEntity>> asyncValue,
    required String? selectedId,
    String? hintText,
    bool enabled = true,
    bool isRequired = true,
    ValueChanged<String?>? onChanged,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: label.toUpperCase(),
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        asyncValue.when(
          data: (locations) {
            return FormFieldBuilders.buildCustomDropdownField<String>(
              context,
              fieldKey: fieldKey,
              label: '',
              items: locations
                  .map(
                    (loc) => DropdownMenuItem<String>(
                      value: loc.id,
                      child: Text(
                        loc.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  )
                  .toList(),
              initialValue: selectedId,
              hintText: hintText,
              enabled: enabled && locations.isNotEmpty,
              onChanged: (id) {
                onChanged?.call(id);
              },
              uppercaseLabel: false,
              isRequired: isRequired,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a $label';
                }
                return null;
              },
            );
          },
          loading: () => _buildLoadingDropdown(context, hintText: hintText),
          error: (error, stack) =>
              _buildErrorDropdown(context, error: error, hintText: hintText),
        ),
      ],
    );
  }

  /// Builds a loading state for dropdowns.
  Widget _buildLoadingDropdown(BuildContext context, {String? hintText}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading...',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an error state for dropdowns.
  Widget _buildErrorDropdown(
    BuildContext context, {
    required Object error,
    String? hintText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.error_outline, size: 16, color: colorScheme.error),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Failed to load',
                style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a text field with smaller label styling.
  Widget _buildTextFieldWithLabel(
    BuildContext context, {
    required String label,
    required String fieldKey,
    String? hintText,
    String? initialValue,
    bool? isRequired,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        FormFieldBuilders.buildTextField(
          context,
          fieldKey: fieldKey,
          label: '',
          hintText: hintText,
          initialValue: initialValue,
          uppercaseLabel: true,
          isRequired: isRequired,
        ),
      ],
    );
  }

  /// Validates Vietnamese phone number format.
  ///
  /// Accepts formats starting with +84, 84, or 0
  /// followed by valid network prefixes (3, 5, 7, 8, 9).
  String? _validatePhone(dynamic value) {
    if (value == null || value.toString().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(
      r'^(\+84|84|0)(3|5|7|8|9)[0-9]{8}$',
    );
    final phone = value.toString().replaceAll(
      RegExp(r'[\s\-()]'),
      '',
    );
    if (!phoneRegex.hasMatch(phone)) {
      return 'Please enter a valid Vietnamese'
          ' phone number';
    }
    return null;
  }
}
