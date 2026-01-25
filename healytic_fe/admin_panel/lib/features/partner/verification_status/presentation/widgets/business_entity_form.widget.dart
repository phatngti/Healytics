import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for Business Entity verification.
///
/// Displays fields with verification status indicators showing
/// which fields need updates and any admin feedback.
class BusinessEntityForm extends StatelessWidget {
  /// Creates a new [BusinessEntityForm].
  const BusinessEntityForm({
    required this.info,
    this.onFieldChanged,
    super.key,
  });

  /// The business entity verification data.
  final BusinessEntityInfo? info;

  /// Callback when a field value changes.
  final void Function(String fieldKey, String value)? onFieldChanged;

  @override
  Widget build(BuildContext context) {
    if (info == null) {
      return const Center(
        child: Text('No business entity information available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Company Name & Tax Registration Code
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _VerificationTextField(
                      label: 'Company Name',
                      field: info!.companyName,
                      hintText: 'Serenity Spa & Wellness LLC',
                      onChanged: (value) =>
                          onFieldChanged?.call('company_name', value),
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _VerificationTextField(
                      label: 'Tax Registration Code',
                      field: info!.taxRegistrationCode,
                      hintText: 'XX-1234567-Y',
                      onChanged: (value) =>
                          onFieldChanged?.call('tax_registration_code', value),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _VerificationTextField(
                  label: 'Company Name',
                  field: info!.companyName,
                  hintText: 'Serenity Spa & Wellness LLC',
                  onChanged: (value) =>
                      onFieldChanged?.call('company_name', value),
                ),
                AppDimens.verticalMedium,
                _VerificationTextField(
                  label: 'Tax Registration Code',
                  field: info!.taxRegistrationCode,
                  hintText: 'XX-1234567-Y',
                  onChanged: (value) =>
                      onFieldChanged?.call('tax_registration_code', value),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _VerificationTextField(
                      label: 'Business Email',
                      field: info!.businessEmail,
                      hintText: 'partners@serenityspa.com',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) =>
                          onFieldChanged?.call('business_email', value),
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _VerificationTextField(
                      label: 'Business Phone',
                      field: info!.businessPhone,
                      hintText: '+1 (555) 000-0000',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) =>
                          onFieldChanged?.call('business_phone', value),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _VerificationTextField(
                  label: 'Business Email',
                  field: info!.businessEmail,
                  hintText: 'partners@serenityspa.com',
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) =>
                      onFieldChanged?.call('business_email', value),
                ),
                AppDimens.verticalMedium,
                _VerificationTextField(
                  label: 'Business Phone',
                  field: info!.businessPhone,
                  hintText: '+1 (555) 000-0000',
                  keyboardType: TextInputType.phone,
                  onChanged: (value) =>
                      onFieldChanged?.call('business_phone', value),
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 3: Service Categories
        _ServiceCategoriesField(
          field: info!.serviceCategories,
          onChanged: (categories) =>
              onFieldChanged?.call('service_categories', categories.join(',')),
        ),
      ],
    );
  }
}

/// Text field with verification status indicator.
class _VerificationTextField extends StatelessWidget {
  const _VerificationTextField({
    required this.label,
    required this.field,
    this.hintText,
    this.keyboardType,
    this.onChanged,
  });

  final String label;
  final VerificationStringField field;
  final String? hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    final isEditable = field.requiresUpdate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with status indicator
        Row(
          children: [
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.error,
              ),
            ),
            const Spacer(),
            if (field.requiresUpdate)
              _StatusBadge(
                label: 'UPDATE NEEDED',
                color: colorScheme.error,
              )
            else
              Icon(Icons.check_circle, size: 16, color: successColor),
          ],
        ),
        const SizedBox(height: 8),

        // Text field
        Opacity(
          opacity: isEditable ? 1.0 : 0.6,
          child: TextFormField(
            initialValue: field.value,
            enabled: isEditable,
            keyboardType: keyboardType,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: isEditable
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: field.requiresUpdate
                      ? colorScheme.error
                      : colorScheme.outlineVariant,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: field.requiresUpdate
                      ? colorScheme.error
                      : colorScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: colorScheme.primary,
                  width: 2,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
          ),
        ),

        // Admin feedback
        if (field.adminFeedback != null && field.adminFeedback!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: colorScheme.error,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  field.adminFeedback!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Service categories field with chips display.
class _ServiceCategoriesField extends StatelessWidget {
  const _ServiceCategoriesField({
    required this.field,
    this.onChanged,
  });

  final VerificationStringListField field;
  final ValueChanged<List<String>>? onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with status
        Row(
          children: [
            Text(
              'Service Categories',
              style: textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            if (field.requiresUpdate)
              _StatusBadge(
                label: 'UPDATE NEEDED',
                color: colorScheme.error,
              )
            else
              Icon(Icons.check_circle, size: 16, color: successColor),
          ],
        ),
        const SizedBox(height: 8),

        // Chips display
        Opacity(
          opacity: field.requiresUpdate ? 1.0 : 0.6,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: field.value.map((category) {
              return Chip(
                label: Text(category),
                backgroundColor: colorScheme.primaryContainer,
                labelStyle: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                ),
                deleteIcon: field.requiresUpdate
                    ? Icon(
                        Icons.close,
                        size: 16,
                        color: colorScheme.onPrimaryContainer,
                      )
                    : null,
                onDeleted: field.requiresUpdate
                    ? () {
                        final updated = List<String>.from(field.value)
                          ..remove(category);
                        onChanged?.call(updated);
                      }
                    : null,
              );
            }).toList(),
          ),
        ),

        // Admin feedback
        if (field.adminFeedback != null && field.adminFeedback!.isNotEmpty) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.info_outline,
                size: 14,
                color: colorScheme.error,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  field.adminFeedback!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// Small status badge widget.
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
