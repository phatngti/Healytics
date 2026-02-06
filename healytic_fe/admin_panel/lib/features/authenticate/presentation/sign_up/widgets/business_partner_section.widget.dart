import 'package:admin_panel/features/authenticate/presentation/providers/business_services.provider.dart';
import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_openapi/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Business & Partner Information form section (Section 2) of Partner
/// Registration.
///
/// Contains:
/// - Brand Name text field
/// - Legal Company Name text field
/// - Business Types selector
/// - Tax Code text field
class BusinessPartnerSection extends ConsumerStatefulWidget {
  /// Initial brand name value.
  final String? initialBrandName;

  /// Initial legal company name value.
  final String? initialLegalName;

  /// Initial tax code value.
  final String? initialTaxCode;

  /// Initial business type value.
  final String? initialBusinessType;

  /// Initial service tag values (list of service tag value strings).
  final List<String>? initialServiceTags;

  const BusinessPartnerSection({
    super.key,
    this.initialBrandName,
    this.initialLegalName,
    this.initialTaxCode,
    this.initialBusinessType,
    this.initialServiceTags,
  });

  @override
  ConsumerState<BusinessPartnerSection> createState() =>
      _BusinessPartnerSectionState();
}

class _BusinessPartnerSectionState
    extends ConsumerState<BusinessPartnerSection> {
  List<BusinessServiceDto> _selectedServices = [];

  @override
  void initState() {
    super.initState();
    // Initial business types will be matched once services are loaded
  }

  /// Sync selected services with FormBuilder
  void _updateFormBuilderServices() {
    final formState = FormBuilder.of(context);
    if (formState != null) {
      final serviceValues = _selectedServices.map((s) => s.value).toList();
      formState.fields['business_types']?.didChange(serviceValues);
    }
  }

  void _showServiceTagSelectionDialog(
    BuildContext context,
    List<BusinessServiceDto> allServices,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => _ServiceTagSelectionDialog(
        allServices: allServices,
        selectedServices: _selectedServices,
        onConfirm: (selected) {
          setState(() {
            _selectedServices = selected;
          });
          _updateFormBuilderServices();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final servicesAsync = ref.watch(businessServicesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hidden FormBuilder field to store service tag values
        FormBuilderField<List<dynamic>>(
          name: 'business_types',
          initialValue: widget.initialServiceTags ?? [],
          builder: (field) => const SizedBox.shrink(),
        ),
        // Row 1: Brand Name & Legal Company Name & Business Types
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'brand_name',
                      label: 'Brand Name',
                      hintText: 'e.g. Serenity Spa',
                      isRequired: true,
                      initialValue: widget.initialBrandName,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'legal_name',
                      label: 'Legal Company Name',
                      hintText: 'e.g. Serenity Wellness LLC',
                      isRequired: true,
                      initialValue: widget.initialLegalName,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'brand_name',
                  label: 'Brand Name',
                  hintText: 'e.g. Serenity Spa',
                  isRequired: true,
                  initialValue: widget.initialBrandName,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'legal_name',
                  label: 'Legal Company Name',
                  hintText: 'e.g. Serenity Wellness LLC',
                  isRequired: true,
                  initialValue: widget.initialLegalName,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Tax Code & Business Type
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'tax_code',
                      label: 'Tax Code',
                      hintText: 'Tax Identification Number',
                      isRequired: true,
                      initialValue: widget.initialTaxCode,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(child: _buildServiceTagsSelector(servicesAsync)),
                ],
              );
            }

            return Column(
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'tax_code',
                  label: 'Tax Code',
                  hintText: 'Tax Identification Number',
                  isRequired: true,
                  initialValue: widget.initialTaxCode,
                ),
                AppDimens.verticalMedium,
                _buildServiceTagsSelector(servicesAsync),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildServiceTagsSelector(
    AsyncValue<List<BusinessServiceDto>> servicesAsync,
  ) {
    return servicesAsync.when(
      loading: () => FormFieldBuilders.buildChipSelectorField(
        context,
        fieldKey: 'business_types',
        label: 'Business Types',
        chips: const [],
        emptyPlaceholder: 'Loading services...',
        enabled: false,
      ),
      error: (error, _) => FormFieldBuilders.buildChipSelectorField(
        context,
        fieldKey: 'business_types',
        label: 'Business Types',
        chips: const [],
        emptyPlaceholder: 'Failed to load services',
        enabled: false,
      ),
      data: (services) {
        // Initialize selected services from initial tags on first load
        if (_selectedServices.isEmpty && widget.initialServiceTags != null) {
          final initialTags = widget.initialServiceTags!;
          _selectedServices = services
              .where((s) => initialTags.contains(s.value))
              .toList();
        }

        return FormFieldBuilders.buildChipSelectorField(
          context,
          fieldKey: 'business_types',
          label: 'Business Types',
          chips: _selectedServices
              .map(
                (service) => _ServiceTagChip(
                  service: service,
                  onRemove: () {
                    setState(() {
                      _selectedServices.remove(service);
                    });
                    _updateFormBuilderServices();
                  },
                ),
              )
              .toList(),
          emptyPlaceholder: 'Select business types...',
          onTap: () => _showServiceTagSelectionDialog(context, services),
        );
      },
    );
  }
}

/// Chip widget to display a selected service tag
class _ServiceTagChip extends StatelessWidget {
  final BusinessServiceDto service;
  final VoidCallback onRemove;

  const _ServiceTagChip({required this.service, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.only(left: 10, right: 6, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: AppDimens.radiusPill,
        border: Border.all(color: colorScheme.primary.withAlpha(50)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            service.label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            borderRadius: AppDimens.radiusPill,
            child: Icon(
              Icons.close,
              size: 14,
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}

/// Dialog for selecting business types
class _ServiceTagSelectionDialog extends StatefulWidget {
  final List<BusinessServiceDto> allServices;
  final List<BusinessServiceDto> selectedServices;
  final ValueChanged<List<BusinessServiceDto>> onConfirm;

  const _ServiceTagSelectionDialog({
    required this.allServices,
    required this.selectedServices,
    required this.onConfirm,
  });

  @override
  State<_ServiceTagSelectionDialog> createState() =>
      _ServiceTagSelectionDialogState();
}

class _ServiceTagSelectionDialogState
    extends State<_ServiceTagSelectionDialog> {
  late List<BusinessServiceDto> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedServices);
  }

  bool _isSelected(BusinessServiceDto service) {
    return _tempSelected.any((s) => s.value == service.value);
  }

  void _toggleSelection(BusinessServiceDto service) {
    setState(() {
      if (_isSelected(service)) {
        _tempSelected.removeWhere((s) => s.value == service.value);
      } else {
        _tempSelected.add(service);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Select Business Services',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.allServices.map((service) {
              final isSelected = _isSelected(service);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (_) => _toggleSelection(service),
                title: Text(
                  service.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
                subtitle:
                    service.description != null &&
                        service.description!.isNotEmpty
                    ? Text(
                        service.description!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onConfirm(_tempSelected);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
