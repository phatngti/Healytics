import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for Location Details verification.
///
/// Displays location fields with verification status indicators showing
/// which fields need updates and any admin feedback.
class LocationForm extends StatelessWidget {
  /// Creates a new [LocationForm].
  const LocationForm({
    required this.info,
    this.onFieldChanged,
    super.key,
  });

  /// The location details verification data.
  final LocationDetailsInfo? info;

  /// Callback when a field value changes.
  final void Function(String fieldKey, String value)? onFieldChanged;

  @override
  Widget build(BuildContext context) {
    if (info == null) {
      return const Center(
        child: Text('No location information available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Country, City, District
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (info!.country != null)
                    Expanded(
                      child: _VerificationOptionalTextField(
                        label: 'Country',
                        field: info!.country!,
                        hintText: 'Select Country',
                        onChanged: (value) =>
                            onFieldChanged?.call('country', value),
                      ),
                    ),
                  if (info!.country != null) AppDimens.horizontalMedium,
                  if (info!.city != null)
                    Expanded(
                      child: _VerificationOptionalTextField(
                        label: 'City',
                        field: info!.city!,
                        hintText: 'Select City',
                        onChanged: (value) =>
                            onFieldChanged?.call('city', value),
                      ),
                    ),
                  if (info!.city != null) AppDimens.horizontalMedium,
                  if (info!.districtArea != null)
                    Expanded(
                      child: _VerificationOptionalTextField(
                        label: 'District/Area',
                        field: info!.districtArea!,
                        hintText: 'Select Area',
                        onChanged: (value) =>
                            onFieldChanged?.call('district', value),
                      ),
                    ),
                ],
              );
            }

            return Column(
              children: [
                if (info!.country != null)
                  _VerificationOptionalTextField(
                    label: 'Country',
                    field: info!.country!,
                    hintText: 'Select Country',
                    onChanged: (value) =>
                        onFieldChanged?.call('country', value),
                  ),
                if (info!.country != null) AppDimens.verticalMedium,
                if (info!.city != null)
                  _VerificationOptionalTextField(
                    label: 'City',
                    field: info!.city!,
                    hintText: 'Select City',
                    onChanged: (value) => onFieldChanged?.call('city', value),
                  ),
                if (info!.city != null) AppDimens.verticalMedium,
                if (info!.districtArea != null)
                  _VerificationOptionalTextField(
                    label: 'District/Area',
                    field: info!.districtArea!,
                    hintText: 'Select Area',
                    onChanged: (value) =>
                        onFieldChanged?.call('district', value),
                  ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Detailed Address
        _VerificationTextField(
          label: 'Detailed Address',
          field: info!.detailedAddress,
          hintText: '123 Harmony Lane, Suite 400',
          onChanged: (value) => onFieldChanged?.call('detailed_address', value),
        ),
      ],
    );
  }
}

/// Text field with verification status indicator for required fields.
class _VerificationTextField extends StatelessWidget {
  const _VerificationTextField({
    required this.label,
    required this.field,
    this.hintText,
    this.onChanged,
  });

  final String label;
  final VerificationStringField field;
  final String? hintText;
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

/// Text field with verification status indicator for optional fields.
class _VerificationOptionalTextField extends StatelessWidget {
  const _VerificationOptionalTextField({
    required this.label,
    required this.field,
    this.hintText,
    this.onChanged,
  });

  final String label;
  final VerificationOptionalStringField field;
  final String? hintText;
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
            const Spacer(),
            if (field.requiresUpdate)
              _StatusBadge(
                label: 'UPDATE NEEDED',
                color: colorScheme.error,
              )
            else if (field.value != null && field.value!.isNotEmpty)
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
