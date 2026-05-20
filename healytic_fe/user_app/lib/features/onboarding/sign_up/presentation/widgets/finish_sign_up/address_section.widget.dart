import 'package:common/utils/demensions.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/core/utils/form_validators.dart';
import 'package:user_app/features/onboarding/sign_up/domain/entities/location_entity.dart';
import 'package:user_app/features/onboarding/sign_up/presentation/providers/location_provider.dart';

/// Form section for collecting the user's mailing address
/// during sign-up.
class AddressSection extends ConsumerStatefulWidget {
  /// Creates an [AddressSection].
  const AddressSection({super.key});

  @override
  ConsumerState<AddressSection> createState() => _AddressSectionState();
}

class _AddressSectionState extends ConsumerState<AddressSection> {
  String? _selectedProvinceId;
  String? _selectedDistrictId;
  String? _selectedWardId;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: Theme.of(context).textTheme.titleMedium?.color?.withAlpha(700),
      fontWeight: FontWeight.bold,
    );

    final captionStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(700),
    );

    final provincesAsync = ref.watch(provincesProvider);
    final districtsAsync = ref.watch(districtsProvider(_selectedProvinceId));
    final wardsAsync = ref.watch(wardsProvider(_selectedDistrictId));

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 1.0,
        children: [
          Text('Address', style: titleStyle),
          AppDimens.verticalSmall,
          _buildProvinceDropdown(provincesAsync),
          AppDimens.verticalSmall,
          _buildDistrictDropdown(districtsAsync),
          AppDimens.verticalSmall,
          _buildWardDropdown(wardsAsync),
          AppDimens.verticalSmall,
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: 'street_address',
            label: 'Street Address',
            hintText: 'e.g. 123 Nguyen Hue Street',
            uppercaseLabel: false,
            validator: (value) => FormValidators.requiredField(
              value,
              fieldName: 'street address',
            ),
          ),
          AppDimens.verticalSmall,
          FormFieldBuilders.buildTextField(
            context,
            fieldKey: 'country',
            label: 'Country',
            uppercaseLabel: false,
            enabled: false,
            initialValue: 'Vietnam',
          ),
          AppDimens.verticalSmall,
          Text(
            'Please provide your correct address '
            'for direction purposes.',
            style: captionStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildProvinceDropdown(AsyncValue<List<LocationEntity>> asyncValue) {
    return _buildLocationDropdown(
      label: 'Province/City',
      fieldKey: 'city_or_province',
      asyncValue: asyncValue,
      selectedId: _selectedProvinceId,
      hintText: 'Select Province',
      onChanged: (id) {
        setState(() {
          _selectedProvinceId = id;
          _selectedDistrictId = null;
          _selectedWardId = null;
        });
        _resetField('district');
        _resetField('ward');
      },
    );
  }

  Widget _buildDistrictDropdown(AsyncValue<List<LocationEntity>> asyncValue) {
    return _buildLocationDropdown(
      label: 'District',
      fieldKey: 'district',
      asyncValue: asyncValue,
      selectedId: _selectedDistrictId,
      hintText: 'Select District',
      enabled: _selectedProvinceId != null,
      onChanged: (id) {
        setState(() {
          _selectedDistrictId = id;
          _selectedWardId = null;
        });
        _resetField('ward');
      },
    );
  }

  Widget _buildWardDropdown(AsyncValue<List<LocationEntity>> asyncValue) {
    return _buildLocationDropdown(
      label: 'Ward/Commune',
      fieldKey: 'ward',
      asyncValue: asyncValue,
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

  Widget _buildLocationDropdown({
    required String label,
    required String fieldKey,
    required AsyncValue<List<LocationEntity>> asyncValue,
    required String? selectedId,
    required String hintText,
    bool enabled = true,
    required ValueChanged<String?> onChanged,
  }) {
    return asyncValue.when(
      data: (locations) {
        return FormFieldBuilders.buildCustomDropdownField<String>(
          context,
          fieldKey: fieldKey,
          label: label,
          items: locations
              .map(
                (location) => DropdownMenuItem<String>(
                  value: location.id,
                  child: Text(
                    location.fullName ?? location.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          initialValue: selectedId,
          hintText: hintText,
          enabled: enabled && locations.isNotEmpty,
          uppercaseLabel: false,
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a $label';
            }
            return null;
          },
          onChanged: onChanged,
        );
      },
      loading: () => _LocationStatusField(label: label, text: 'Loading...'),
      error: (error, stackTrace) =>
          _LocationStatusField(label: label, text: 'Could not load $label'),
    );
  }

  void _resetField(String fieldName) {
    FormBuilder.of(context)?.fields[fieldName]?.didChange(null);
  }
}

class _LocationStatusField extends StatelessWidget {
  const _LocationStatusField({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormFieldBuilders.buildTextField(
      context,
      fieldKey: '_${label.toLowerCase().replaceAll('/', '_')}_status',
      label: label,
      initialValue: text,
      enabled: false,
      uppercaseLabel: false,
      style: TextStyle(color: colorScheme.onSurfaceVariant),
    );
  }
}
