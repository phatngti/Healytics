import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for Business Entity (Partner) verification.
///
/// Displays business info fields and registered address in a grid layout
/// with verification status indicators for fields requiring updates.
class BusinessEntityForm extends StatelessWidget {
  /// Creates a new [BusinessEntityForm].
  const BusinessEntityForm({
    required this.info,
    this.locationInfo,
    this.onFieldChanged,
    super.key,
  });

  /// The partner info verification data.
  final PartnerInfo? info;

  /// The location details verification data.
  final LocationDetailsInfo? locationInfo;

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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business Info Grid (2 columns on desktop)
        _buildBusinessInfoGrid(context),
        // Registered Address Section
        if (locationInfo != null) ...[
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
              // Row 1: Brand Name & Legal Name
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VerificationTextField(
                      label: 'Brand Name',
                      field: info!.brandName,
                      onChanged: onFieldChanged != null
                          ? (value) => onFieldChanged!('brandName', value)
                          : null,
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  Expanded(
                    child: VerificationTextField(
                      label: 'Legal Name',
                      field: info!.legalName,
                      onChanged: onFieldChanged != null
                          ? (value) => onFieldChanged!('legalName', value)
                          : null,
                    ),
                  ),
                ],
              ),
              AppDimens.verticalMedium,
              // Row 2: Tax Code & Business Type
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VerificationTextField(
                      label: 'Tax Code',
                      field: info!.taxCode,
                      onChanged: onFieldChanged != null
                          ? (value) => onFieldChanged!('taxCode', value)
                          : null,
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  Expanded(
                    child: VerificationTextField(
                      label: 'Business Type',
                      field: info!.businessType,
                      onChanged: onFieldChanged != null
                          ? (value) => onFieldChanged!('businessType', value)
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // Mobile: Single column
        return Column(
          children: [
            VerificationTextField(
              label: 'Brand Name',
              field: info!.brandName,
              onChanged: onFieldChanged != null
                  ? (value) => onFieldChanged!('brandName', value)
                  : null,
            ),
            AppDimens.verticalMedium,
            VerificationTextField(
              label: 'Legal Name',
              field: info!.legalName,
              onChanged: onFieldChanged != null
                  ? (value) => onFieldChanged!('legalName', value)
                  : null,
            ),
            AppDimens.verticalMedium,
            VerificationTextField(
              label: 'Tax Code',
              field: info!.taxCode,
              onChanged: onFieldChanged != null
                  ? (value) => onFieldChanged!('taxCode', value)
                  : null,
            ),
            AppDimens.verticalMedium,
            VerificationTextField(
              label: 'Business Type',
              field: info!.businessType,
              onChanged: onFieldChanged != null
                  ? (value) => onFieldChanged!('businessType', value)
                  : null,
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
