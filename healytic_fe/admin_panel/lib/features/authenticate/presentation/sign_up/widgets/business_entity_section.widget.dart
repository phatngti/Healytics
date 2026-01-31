import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Model class for service data in Business Entity section.
class BusinessServiceItem {
  final String id;
  final String name;
  final double price;
  final int duration;

  const BusinessServiceItem({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessServiceItem &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Business Entity form section (Step 1) of Partner Registration.
///
/// Contains:
/// - Company Name text field
/// - Tax Registration Code text field
/// - Business Email field
/// - Business Phone field
/// - Service Categories multi-select chips
/// - Performable Services checkbox grid
class BusinessEntitySection extends StatefulWidget {
  /// Initial company name value.
  final String? initialCompanyName;

  /// Initial tax registration code value.
  final String? initialTaxCode;

  /// Initial business email value.
  final String? initialEmail;

  /// Initial business phone value.
  final String? initialPhone;

  /// Initial service categories.
  final List<String>? initialServiceCategories;

  /// Available service categories for selection.
  final Map<String, String> availableServices;

  /// Available performable services for selection.
  final List<BusinessServiceItem> availablePerformableServices;

  /// Initial selected performable services.
  final List<String>? initialPerformableServices;

  /// Callback when service categories change.
  final ValueChanged<List<String>>? onServicesChanged;

  /// Callback when performable services change.
  final ValueChanged<List<String>>? onPerformableServicesChanged;

  const BusinessEntitySection({
    super.key,
    this.initialCompanyName,
    this.initialTaxCode,
    this.initialEmail,
    this.initialPhone,
    this.initialServiceCategories,
    this.availableServices = const {
      'massage': 'Massage Therapy',
      'sauna': 'Sauna',
      'facials': 'Facials',
      'body_treatments': 'Body Treatments',
      'aromatherapy': 'Aromatherapy',
      'nail_care': 'Nail Care',
      'hair_care': 'Hair Care',
      'wellness': 'Wellness Programs',
    },
    this.availablePerformableServices = const [
      BusinessServiceItem(
        id: 'deep_tissue_60',
        name: '60min Deep Tissue',
        price: 120.00,
        duration: 60,
      ),
      BusinessServiceItem(
        id: 'aromatherapy_90',
        name: '90min Aromatherapy',
        price: 150.00,
        duration: 90,
      ),
      BusinessServiceItem(
        id: 'hot_stone',
        name: 'Hot Stone Therapy',
        price: 160.00,
        duration: 75,
      ),
      BusinessServiceItem(
        id: 'sports_recovery',
        name: 'Sports Recovery',
        price: 135.00,
        duration: 60,
      ),
      BusinessServiceItem(
        id: 'swedish_massage',
        name: 'Swedish Massage',
        price: 110.00,
        duration: 60,
      ),
      BusinessServiceItem(
        id: 'facial_treatment',
        name: 'Facial Treatment',
        price: 95.00,
        duration: 45,
      ),
    ],
    this.initialPerformableServices,
    this.onServicesChanged,
    this.onPerformableServicesChanged,
  });

  @override
  State<BusinessEntitySection> createState() => _BusinessEntitySectionState();
}

class _BusinessEntitySectionState extends State<BusinessEntitySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Company Name & Tax Registration Code
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'company_name',
                      label: 'Company Name',
                      hintText: 'Serenity Spa & Wellness LLC',
                      isRequired: true,
                      initialValue: widget.initialCompanyName,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'tax_registration_code',
                      label: 'Tax Registration Code',
                      hintText: 'XX-1234567-Y',
                      isRequired: true,
                      initialValue: widget.initialTaxCode,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'company_name',
                  label: 'Company Name',
                  hintText: 'Serenity Spa & Wellness LLC',
                  isRequired: true,
                  initialValue: widget.initialCompanyName,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'tax_registration_code',
                  label: 'Tax Registration Code',
                  hintText: 'XX-1234567-Y',
                  isRequired: true,
                  initialValue: widget.initialTaxCode,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Business Email & Business Phone
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'business_email',
                      label: 'Business Email',
                      hintText: 'partners@serenityspa.com',
                      isRequired: true,
                      keyboardType: TextInputType.emailAddress,
                      initialValue: widget.initialEmail,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'business_phone',
                      label: 'Business Phone',
                      hintText: '+1 (555) 000-0000',
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                      initialValue: widget.initialPhone,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'business_email',
                  label: 'Business Email',
                  hintText: 'partners@serenityspa.com',
                  isRequired: true,
                  keyboardType: TextInputType.emailAddress,
                  initialValue: widget.initialEmail,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'business_phone',
                  label: 'Business Phone',
                  hintText: '+1 (555) 000-0000',
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  initialValue: widget.initialPhone,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 3: Service Categories
        FormFieldBuilders.buildMultiSelectChipField(
          context,
          fieldKey: 'service_categories',
          label: 'Service Categories',
          availableOptions: widget.availableServices,
          onChanged: widget.onServicesChanged,
          searchHint: 'Add services...',
          allowCreate: false,
        ),
        AppDimens.verticalLarge,
      ],
    );
  }
}
