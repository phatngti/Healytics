import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/reviewable_field.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Legal representative information section
class LegalRepresentativeSection extends StatelessWidget {
  const LegalRepresentativeSection({
    this.representative,
    this.readOnly = false,
    super.key,
  });

  final LegalRepresentative? representative;

  /// When true, hides field-level feedback controls
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    if (representative == null) {
      return const SizedBox.shrink();
    }
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
                // Row 1: Full Name & Position & ID Type
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ReviewableField(
                        readOnly: readOnly,
                        title: 'Full Name',
                        fieldId: representative!.fullName.fieldKey,
                        compactMode: true,
                        child: _buildInfoItem(
                          context,
                          representative!.fullName.value,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReviewableField(
                        readOnly: readOnly,
                        title: 'Position',
                        fieldId:
                            representative!.position?.fieldKey ?? 'position',
                        compactMode: true,
                        child: _buildInfoItem(
                          context,
                          representative?.position?.value,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ReviewableField(
                        readOnly: readOnly,
                        title: 'ID Type',
                        fieldId: representative!.idType?.fieldKey ?? 'idType',
                        compactMode: true,
                        child: _buildInfoItem(
                          context,
                          representative?.idType?.value,
                        ),
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalMedium,
                // Row 2: ID Number & ID Issue Date
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ReviewableField(
                        readOnly: readOnly,
                        title: 'ID Number',
                        fieldId:
                            representative!.idNumber?.fieldKey ?? 'idNumber',
                        compactMode: true,
                        child: _buildInfoItem(
                          context,
                          representative?.idNumber?.value,
                          isMono: true,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Expanded(
                      child: ReviewableField(
                        readOnly: readOnly,
                        title: 'ID Issue Date',
                        fieldId:
                            representative!.idIssueDate?.fieldKey ??
                            'idIssueDate',
                        compactMode: true,
                        child: _buildInfoItem(
                          context,
                          representative?.idIssueDate?.value,
                        ),
                      ),
                    ),
                  ],
                ),
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
    String? value, {
    bool isMono = false,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
}
