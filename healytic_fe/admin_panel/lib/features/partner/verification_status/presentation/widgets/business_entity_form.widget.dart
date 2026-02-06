import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_business_type_field.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for Business Entity (Partner) verification.
///
/// Displays business info fields in a grid layout with verification
/// status indicators for fields requiring updates.
class BusinessEntityForm extends StatelessWidget {
  /// Creates a new [BusinessEntityForm].
  const BusinessEntityForm({
    required this.info,
    this.onFieldChanged,
    super.key,
  });

  /// The business info verification data.
  final BusinessInfo? info;

  /// Callback when a field value changes.
  final void Function(String fieldKey, String value)? onFieldChanged;

  @override
  Widget build(BuildContext context) {
    if (info == null) {
      return const Center(
        child: Text('No business entity information available'),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Info Grid (2 columns on desktop)
        _buildBusinessInfoGrid(context),
        // Registered Address Section
        if (info!.address != null) ...[
          AppDimens.verticalLarge,
          _buildDivider(colorScheme),
          AppDimens.verticalLarge,
        ],
      ],
    );
  }

  Widget _buildBusinessInfoGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        if (isWide) {
          return Column(
            children: [
              // Row 1: Brand Name & Tax Code
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VerificationTextField(
                      label: 'Brand Name',
                      fieldId: info!.brandName.fieldKey,
                      field: info!.brandName,
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  Expanded(
                    child: info!.taxRegistrationCode != null
                        ? VerificationTextField(
                            label: 'Tax Code',
                            fieldId: info!.taxRegistrationCode!.fieldKey,
                            field: info!.taxRegistrationCode!,
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
              AppDimens.verticalMedium,
              // Row 2: Phone Number
              if (info!.phoneNumber != null)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: VerificationTextField(
                        label: 'Phone Number',
                        fieldId: info!.phoneNumber!.fieldKey,
                        field: info!.phoneNumber!,
                      ),
                    ),
                    AppDimens.horizontalLarge,
                    const Expanded(child: SizedBox.shrink()),
                  ],
                ),
              AppDimens.verticalMedium,
              // Business Types (full width, chip selection)
              VerificationBusinessTypeField(
                label: 'Business Types',
                fieldId: info!.serviceTags.fieldKey,
                field: info!.serviceTags,
              ),
            ],
          );
        }

        // Mobile: Single column
        return Column(
          children: [
            VerificationTextField(
              label: 'Brand Name',
              fieldId: info!.brandName.fieldKey,
              field: info!.brandName,
            ),
            if (info!.taxRegistrationCode != null) ...[
              AppDimens.verticalMedium,
              VerificationTextField(
                label: 'Tax Code',
                fieldId: info!.taxRegistrationCode!.fieldKey,
                field: info!.taxRegistrationCode!,
              ),
            ],
            AppDimens.verticalMedium,
            if (info!.phoneNumber != null) ...[
              VerificationTextField(
                label: 'Phone Number',
                fieldId: info!.phoneNumber!.fieldKey,
                field: info!.phoneNumber!,
              ),
              AppDimens.verticalMedium,
            ],
            // Business Types (chip selection)
            VerificationBusinessTypeField(
              label: 'Business Types',
              fieldId: info!.serviceTags.fieldKey,
              field: info!.serviceTags,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.5));
  }
}
