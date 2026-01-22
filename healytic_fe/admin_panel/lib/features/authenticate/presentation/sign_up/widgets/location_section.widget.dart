import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Location form section of Partner Registration.
///
/// Contains:
/// - Country dropdown
/// - City dropdown (cascading based on country)
/// - District/Area dropdown
/// - Detailed Address text field
class LocationSection extends StatefulWidget {
  /// Initial country value.
  final String? initialCountry;

  /// Initial city value.
  final String? initialCity;

  /// Initial district value.
  final String? initialDistrict;

  /// Initial detailed address.
  final String? initialAddress;

  const LocationSection({
    super.key,
    this.initialCountry,
    this.initialCity,
    this.initialDistrict,
    this.initialAddress,
  });

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  String? _selectedCountry;
  String? _selectedCity;

  // Mock data for countries, cities, and districts
  // In production, these would come from an API
  final Map<String, List<String>> _countryCities = const {
    'United States': ['New York', 'Los Angeles', 'Chicago', 'Houston'],
    'Canada': ['Toronto', 'Vancouver', 'Montreal', 'Calgary'],
    'United Kingdom': ['London', 'Manchester', 'Birmingham', 'Liverpool'],
    'Vietnam': ['Ho Chi Minh City', 'Hanoi', 'Da Nang', 'Can Tho'],
  };

  final Map<String, List<String>> _cityDistricts = const {
    'New York': ['Manhattan', 'Brooklyn', 'Queens', 'Bronx'],
    'Los Angeles': ['Downtown', 'Hollywood', 'Venice', 'Santa Monica'],
    'Chicago': ['The Loop', 'Lincoln Park', 'Wicker Park', 'River North'],
    'Ho Chi Minh City': [
      'District 1',
      'District 3',
      'District 7',
      'Binh Thanh',
    ],
    'Hanoi': ['Hoan Kiem', 'Ba Dinh', 'Dong Da', 'Cau Giay'],
  };

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialCountry;
    _selectedCity = widget.initialCity;
  }

  List<String> get _availableCities {
    if (_selectedCountry == null) return [];
    return _countryCities[_selectedCountry] ?? [];
  }

  List<String> get _availableDistricts {
    if (_selectedCity == null) return [];
    return _cityDistricts[_selectedCity] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Country, City, District
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildDropdownField(
                      context,
                      fieldKey: 'country',
                      label: 'Country',
                      items: _countryCities.keys.toList(),
                      initialValue: _selectedCountry,
                      hintText: 'Select Country',
                      isRequired: true,
                      onChanged: (value) {
                        setState(() {
                          _selectedCountry = value;
                          _selectedCity = null;
                        });
                      },
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildDropdownField(
                      context,
                      fieldKey: 'city',
                      label: 'City',
                      items: _availableCities,
                      initialValue: _selectedCity,
                      hintText: 'Select City',
                      isRequired: true,
                      onChanged: (value) {
                        setState(() {
                          _selectedCity = value;
                        });
                      },
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildDropdownField(
                      context,
                      fieldKey: 'district',
                      label: 'District/Area',
                      items: _availableDistricts,
                      initialValue: widget.initialDistrict,
                      hintText: 'Select Area',
                      isRequired: true,
                      enabled: _selectedCity != null,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                FormFieldBuilders.buildDropdownField(
                  context,
                  fieldKey: 'country',
                  label: 'Country',
                  items: _countryCities.keys.toList(),
                  initialValue: _selectedCountry,
                  hintText: 'Select Country',
                  isRequired: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedCountry = value;
                      _selectedCity = null;
                    });
                  },
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildDropdownField(
                  context,
                  fieldKey: 'city',
                  label: 'City',
                  items: _availableCities,
                  initialValue: _selectedCity,
                  hintText: 'Select City',
                  isRequired: true,
                  onChanged: (value) {
                    setState(() {
                      _selectedCity = value;
                    });
                  },
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildDropdownField(
                  context,
                  fieldKey: 'district',
                  label: 'District/Area',
                  items: _availableDistricts,
                  initialValue: widget.initialDistrict,
                  hintText: 'Select Area',
                  isRequired: true,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Detailed Address
        FormFieldBuilders.buildTextField(
          context,
          fieldKey: 'detailed_address',
          label: 'Detailed Address',
          hintText: '123 Harmony Lane, Suite 400',
          isRequired: true,
          initialValue: widget.initialAddress,
        ),
      ],
    );
  }
}
