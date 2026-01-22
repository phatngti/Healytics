import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Legal representative information section
class LegalRepresentativeSection extends StatelessWidget {
  const LegalRepresentativeSection({this.representative, super.key});

  final LegalRepresentative? representative;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        'Full Name',
                        representative?.fullName,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        'Position',
                        representative?.position,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        context,
                        'Citizen ID',
                        representative?.citizenId,
                        isMono: true,
                      ),
                    ),
                  ],
                ),

                // Verification Note
                if (representative?.verificationNote != null) ...[
                  AppDimens.verticalMedium,
                  _buildVerificationNote(context),
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
          Icon(Icons.gavel, color: colorScheme.primary, size: 20),
          AppDimens.horizontalSmall,
          Text(
            'Legal Representative',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    String label,
    String? value, {
    bool isMono = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        AppDimens.verticalExtraSmall,
        Text(
          value ?? 'N/A',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontFamily: isMono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationNote(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllMediumSmall,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: colorScheme.primary),
          AppDimens.horizontalMediumSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verification Note',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  representative?.verificationNote ?? '',
                  style: textTheme.bodySmall?.copyWith(
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
}
