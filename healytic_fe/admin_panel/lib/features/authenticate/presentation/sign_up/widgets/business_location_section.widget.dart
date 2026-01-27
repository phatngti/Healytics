import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Business Location subsection of Partner Registration.
///
/// Contains:
/// - Province/City dropdown
/// - District dropdown (cascading based on province)
/// - Ward/Commune dropdown (cascading based on district)
/// - Street Address text field
class BusinessLocationSection extends StatefulWidget {
  /// Initial province value.
  final String? initialProvince;

  /// Initial district value.
  final String? initialDistrict;

  /// Initial ward value.
  final String? initialWard;

  /// Initial street address.
  final String? initialStreetAddress;

  const BusinessLocationSection({
    super.key,
    this.initialProvince,
    this.initialDistrict,
    this.initialWard,
    this.initialStreetAddress,
  });

  @override
  State<BusinessLocationSection> createState() =>
      _BusinessLocationSectionState();
}

class _BusinessLocationSectionState extends State<BusinessLocationSection> {
  String? _selectedProvince;
  String? _selectedDistrict;

  // Mock data for Vietnam provinces/cities and their districts
  final Map<String, List<String>> _provinceDistricts = const {
    'Hanoi': [
      'Hoan Kiem',
      'Ba Dinh',
      'Dong Da',
      'Cau Giay',
      'Hai Ba Trung',
      'Thanh Xuan',
    ],
    'Ho Chi Minh City': [
      'District 1',
      'District 3',
      'District 7',
      'Binh Thanh',
      'Phu Nhuan',
      'Go Vap',
    ],
    'Da Nang': [
      'Hai Chau',
      'Thanh Khe',
      'Son Tra',
      'Ngu Hanh Son',
      'Lien Chieu',
    ],
    'Can Tho': ['Ninh Kieu', 'Binh Thuy', 'Cai Rang', 'O Mon'],
  };

  // Mock data for wards/communes
  final Map<String, List<String>> _districtWards = const {
    'Hoan Kiem': ['Hang Bac', 'Hang Bong', 'Hang Dao', 'Hang Gai'],
    'Ba Dinh': ['Phuc Xa', 'Truc Bach', 'Vinh Phuc', 'Cong Vi'],
    'District 1': ['Ben Nghe', 'Ben Thanh', 'Da Kao', 'Nguyen Thai Binh'],
    'District 3': ['Ward 1', 'Ward 2', 'Ward 3', 'Ward 4'],
    'District 7': ['Tan Phu', 'Tan Quy', 'Phu My', 'Tan Hung'],
    'Hai Chau': ['Hai Chau 1', 'Hai Chau 2', 'Thach Thang', 'Thanh Binh'],
  };

  @override
  void initState() {
    super.initState();
    _selectedProvince = widget.initialProvince;
    _selectedDistrict = widget.initialDistrict;
  }

  List<String> get _availableDistricts {
    if (_selectedProvince == null) return [];
    return _provinceDistricts[_selectedProvince] ?? [];
  }

  List<String> get _availableWards {
    if (_selectedDistrict == null) return [];
    return _districtWards[_selectedDistrict] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              letterSpacing: 0.5,
              color: colorScheme.onSurfaceVariant,
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
                children: [
                  Expanded(
                    child: _buildDropdownWithLabel(
                      context,
                      label: 'Province/City',
                      fieldKey: 'province',
                      items: _provinceDistricts.keys.toList(),
                      initialValue: _selectedProvince,
                      hintText: 'Select Province',
                      onChanged: (value) {
                        setState(() {
                          _selectedProvince = value;
                          _selectedDistrict = null;
                        });
                      },
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _buildDropdownWithLabel(
                      context,
                      label: 'District',
                      fieldKey: 'district',
                      items: _availableDistricts,
                      initialValue: _selectedDistrict,
                      hintText: 'Select District',
                      enabled: _selectedProvince != null,
                      onChanged: (value) {
                        setState(() {
                          _selectedDistrict = value;
                        });
                      },
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _buildDropdownWithLabel(
                      context,
                      label: 'Ward/Commune',
                      fieldKey: 'ward',
                      items: _availableWards,
                      initialValue: widget.initialWard,
                      hintText: 'Select Ward',
                      enabled: _selectedDistrict != null,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _buildDropdownWithLabel(
                  context,
                  label: 'Province/City',
                  fieldKey: 'province',
                  items: _provinceDistricts.keys.toList(),
                  initialValue: _selectedProvince,
                  hintText: 'Select Province',
                  onChanged: (value) {
                    setState(() {
                      _selectedProvince = value;
                      _selectedDistrict = null;
                    });
                  },
                ),
                AppDimens.verticalMedium,
                _buildDropdownWithLabel(
                  context,
                  label: 'District',
                  fieldKey: 'district',
                  items: _availableDistricts,
                  initialValue: _selectedDistrict,
                  hintText: 'Select District',
                  enabled: _selectedProvince != null,
                  onChanged: (value) {
                    setState(() {
                      _selectedDistrict = value;
                    });
                  },
                ),
                AppDimens.verticalMedium,
                _buildDropdownWithLabel(
                  context,
                  label: 'Ward/Commune',
                  fieldKey: 'ward',
                  items: _availableWards,
                  initialValue: widget.initialWard,
                  hintText: 'Select Ward',
                  enabled: _selectedDistrict != null,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Street Address
        _buildTextFieldWithLabel(
          context,
          label: 'Street Address (House No, Street Name)',
          fieldKey: 'street_address',
          hintText: 'e.g. 123 Nguyen Hue Street',
          initialValue: widget.initialStreetAddress,
        ),
      ],
    );
  }

  /// Builds a dropdown with smaller label styling for location fields.
  Widget _buildDropdownWithLabel(
    BuildContext context, {
    required String label,
    required String fieldKey,
    required List<String> items,
    String? initialValue,
    String? hintText,
    bool enabled = true,
    ValueChanged<String?>? onChanged,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        FormFieldBuilders.buildDropdownField(
          context,
          fieldKey: fieldKey,
          label: '',
          items: items,
          initialValue: initialValue,
          hintText: hintText,
          enabled: enabled,
          onChanged: onChanged,
          uppercaseLabel: false,
        ),
      ],
    );
  }

  /// Builds a text field with smaller label styling.
  Widget _buildTextFieldWithLabel(
    BuildContext context, {
    required String label,
    required String fieldKey,
    String? hintText,
    String? initialValue,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        FormFieldBuilders.buildTextField(
          context,
          fieldKey: fieldKey,
          label: '',
          hintText: hintText,
          initialValue: initialValue,
          uppercaseLabel: false,
        ),
      ],
    );
  }
}
