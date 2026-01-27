import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Business & Partner Information form section (Section 2) of Partner
/// Registration.
///
/// Contains:
/// - Brand Name text field
/// - Legal Company Name text field
/// - Tax Code text field
/// - Business Type dropdown
class BusinessPartnerSection extends StatelessWidget {
  /// Initial brand name value.
  final String? initialBrandName;

  /// Initial legal company name value.
  final String? initialLegalName;

  /// Initial tax code value.
  final String? initialTaxCode;

  /// Initial business type value.
  final String? initialBusinessType;

  const BusinessPartnerSection({
    super.key,
    this.initialBrandName,
    this.initialLegalName,
    this.initialTaxCode,
    this.initialBusinessType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Brand Name & Legal Company Name
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
                      initialValue: initialBrandName,
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
                      initialValue: initialLegalName,
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
                  initialValue: initialBrandName,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'legal_name',
                  label: 'Legal Company Name',
                  hintText: 'e.g. Serenity Wellness LLC',
                  isRequired: true,
                  initialValue: initialLegalName,
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
                      initialValue: initialTaxCode,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildDropdownField(
                      context,
                      fieldKey: 'business_type',
                      label: 'Business Type',
                      items: const [
                        'Individual Business',
                        'Limited Liability Company',
                        'Corporation',
                      ],
                      hintText: 'Select type',
                      isRequired: true,
                      initialValue: initialBusinessType,
                    ),
                  ),
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
                  initialValue: initialTaxCode,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildDropdownField(
                  context,
                  fieldKey: 'business_type',
                  label: 'Business Type',
                  items: const [
                    'Individual Business',
                    'Limited Liability Company',
                    'Corporation',
                  ],
                  hintText: 'Select type',
                  isRequired: true,
                  initialValue: initialBusinessType,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
