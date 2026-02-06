import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/reviewable_field.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Business overview section displaying brand, tax code, services, and address
class BusinessOverviewSection extends StatelessWidget {
  const BusinessOverviewSection({
    required this.brandName,
    this.taxRegistrationCode,
    this.isTaxCodeValid = false,
    required this.businessTypes,
    this.address,
    super.key,
  });

  final VerifiedFieldEntity<String> brandName;
  final VerifiedFieldEntity<String?>? taxRegistrationCode;
  final bool isTaxCodeValid;
  final VerifiedFieldEntity<List<String>> businessTypes;
  final AddressInfo? address;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semantics = Theme.of(context).extension<SemanticColors>();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(context, colorScheme, textTheme),
          const Divider(height: 1),

          // Content
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Brand Name & Tax Code Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ReviewableField(
                        title: 'Brand Name',
                        fieldId: brandName.fieldKey,
                        child: _buildLabelValue(
                          context,
                          value: brandName.value,
                          isLarge: true,
                        ),
                      ),
                    ),
                    Spacer(flex: 1),
                    Expanded(
                      child: ReviewableField(
                        title: 'Tax Code',
                        fieldId: taxRegistrationCode!.fieldKey,
                        child: _buildTaxCode(context, semantics),
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalLarge,

                // Business Types
                ReviewableField(
                  title: 'Business Types',
                  fieldId: businessTypes.fieldKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: businessTypes.value.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: AppDimens.radiusSmall,
                              border: Border.all(
                                color: colorScheme.outline.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                // Address Section (with dashed separator)
                if (address != null) ...[
                  AppDimens.verticalMedium,
                  Container(
                    padding: const EdgeInsets.only(top: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel(context, 'Registered Address'),
                        AppDimens.verticalMediumSmall,
                        // Row 1: Province, District, Ward
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ReviewableField(
                                title: 'Province/City',
                                fieldId: address!.city!.fieldKey,
                                compactMode: true,
                                child: _buildAddressField(
                                  context,
                                  address!.city!.value.name,
                                ),
                              ),
                            ),
                            AppDimens.horizontalMedium,
                            Expanded(
                              child: ReviewableField(
                                title: 'District',
                                fieldId: address!.district!.fieldKey,
                                compactMode: true,
                                child: _buildAddressField(
                                  context,
                                  address!.district!.value.name,
                                ),
                              ),
                            ),
                            AppDimens.horizontalMedium,
                            Expanded(
                              child: ReviewableField(
                                title: 'Ward',
                                fieldId: address!.ward!.fieldKey,
                                compactMode: true,
                                child: _buildAddressField(
                                  context,
                                  address!.ward!.value.name,
                                ),
                              ),
                            ),
                          ],
                        ),
                        AppDimens.verticalMedium,
                        // Row 2: Street Address + Map Preview
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Street Address
                            Expanded(
                              flex: 3,
                              child: ReviewableField(
                                title: 'Street Address',
                                fieldId: address!.streetAddress!.fieldKey,
                                compactMode: true,
                                child: _buildAddressField(
                                  context,
                                  address!.streetAddress?.value,
                                ),
                              ),
                            ),
                            AppDimens.horizontalMedium,
                            // Map Placeholder
                            Expanded(
                              flex: 2,
                              child: _buildMapPlaceholder(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Icon(Icons.store, color: colorScheme.primary, size: 20),
          AppDimens.horizontalSmall,
          Text(
            'Business Overview',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxCode(BuildContext context, SemanticColors? semantics) {
    final textTheme = Theme.of(context).textTheme;
    final successColor = semantics?.success ?? Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              taxRegistrationCode?.value ?? 'N/A',
              style: textTheme.bodyMedium?.copyWith(
                fontFamily: 'monospace',
                fontWeight: FontWeight.w500,
              ),
            ),
            if (isTaxCodeValid) ...[
              AppDimens.horizontalSmall,
              Icon(Icons.check_circle, size: 18, color: successColor),
            ],
          ],
        ),
      ],
    );
  }

  /// Builds a single address field with label and value
  Widget _buildAddressField(BuildContext context, String? value) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value ?? 'N/A',
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      height: 96,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppDimens.radiusSmall,
      ),
      child: Stack(
        children: [
          // Grid pattern
          Positioned.fill(
            child: CustomPaint(painter: _GridPatternPainter(colorScheme)),
          ),
          // Map icon
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map, size: 18, color: colorScheme.onSurfaceVariant),
                AppDimens.horizontalExtraSmall,
                Text(
                  'Map Preview',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildLabelValue(
    BuildContext context, {
    required String value,
    bool isLarge = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: isLarge
              ? textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
              : textTheme.bodyMedium,
        ),
      ],
    );
  }
}

/// Custom painter for grid pattern in map placeholder
class _GridPatternPainter extends CustomPainter {
  _GridPatternPainter(this.colorScheme);

  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = colorScheme.onSurfaceVariant.withValues(alpha: 0.1)
      ..strokeWidth = 1;

    const spacing = 10.0;

    for (var x = 0.0; x < size.width; x += spacing) {
      for (var y = 0.0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
