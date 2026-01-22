import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Business overview section displaying brand, tax code, services, and address
class BusinessOverviewSection extends StatelessWidget {
  const BusinessOverviewSection({
    required this.brandName,
    this.taxRegistrationCode,
    this.isTaxCodeValid = false,
    this.serviceTags = const [],
    this.address,
    super.key,
  });

  final String brandName;
  final String? taxRegistrationCode;
  final bool isTaxCodeValid;
  final List<String> serviceTags;
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
                      child: _buildLabelValue(
                        context,
                        label: 'Brand Name',
                        value: brandName,
                        isLarge: true,
                      ),
                    ),
                    AppDimens.horizontalLarge,
                    Expanded(child: _buildTaxCode(context, semantics)),
                  ],
                ),
                AppDimens.verticalLarge,

                // Service Tags
                _buildLabel(context, 'Service Tags'),
                AppDimens.verticalSmall,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: serviceTags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: AppDimens.radiusSmall,
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.1),
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
                AppDimens.verticalLarge,

                // Address Section
                if (address != null) ...[
                  Container(
                    padding: AppDimens.paddingTopSmall,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                          style: BorderStyle.solid,
                        ),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _buildAddress(context)),
                        AppDimens.horizontalLarge,
                        Expanded(child: _buildMapPlaceholder(context)),
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
        _buildLabel(context, 'Tax Registration Code'),
        AppDimens.verticalExtraSmall,
        Row(
          children: [
            Text(
              taxRegistrationCode ?? 'N/A',
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

  Widget _buildAddress(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, 'Registered Address'),
        AppDimens.verticalExtraSmall,
        Text(
          address?.streetAddress ?? '',
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        if (address?.ward != null || address?.district != null)
          Text(
            '${address?.ward ?? ''}, ${address?.district ?? ''}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        if (address?.city != null || address?.country != null)
          Text(
            '${address?.city ?? ''}, ${address?.country ?? ''}',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
      ],
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
    required String label,
    required String value,
    bool isLarge = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context, label),
        AppDimens.verticalExtraSmall,
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
