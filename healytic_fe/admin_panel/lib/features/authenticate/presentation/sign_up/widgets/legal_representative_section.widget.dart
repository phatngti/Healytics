import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/file_upload_field.widget.dart';
import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Legal Representative form section of Partner Registration.
///
/// Contains:
/// - Full Name text field
/// - Gov. ID Number text field
/// - Identity Verification file uploads (front/back)
/// - Authorization Letter toggle switch
/// - Authorization Letter file upload (conditional)
class LegalRepresentativeSection extends StatefulWidget {
  /// Whether the authorization letter toggle is initially on.
  final bool initialRequiresAuthorization;

  /// Callback when authorization requirement changes.
  final ValueChanged<bool>? onAuthorizationChanged;

  const LegalRepresentativeSection({
    super.key,
    this.initialRequiresAuthorization = false,
    this.onAuthorizationChanged,
  });

  @override
  State<LegalRepresentativeSection> createState() =>
      _LegalRepresentativeSectionState();
}

class _LegalRepresentativeSectionState
    extends State<LegalRepresentativeSection> {
  late bool _requiresAuthorization;

  @override
  void initState() {
    super.initState();
    _requiresAuthorization = widget.initialRequiresAuthorization;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Full Name & Gov. ID Number
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'representative_name',
                      label: 'Full Name',
                      hintText: 'Jane Doe',
                      isRequired: true,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'government_id_number',
                      label: 'Gov. ID Number',
                      hintText: 'A12345678',
                      isRequired: true,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'representative_name',
                  label: 'Full Name',
                  hintText: 'Jane Doe',
                  isRequired: true,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'government_id_number',
                  label: 'Gov. ID Number',
                  hintText: 'A12345678',
                  isRequired: true,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalLarge,

        // Identity Verification section
        Text(
          'IDENTITY VERIFICATION',
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppDimens.verticalSmall,

        // ID Upload fields
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FileUploadField(
                      label: 'Front Side ID',
                      icon: Icons.credit_card,
                      onFileSelected: (url) {
                        // TODO: Handle front ID upload
                      },
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FileUploadField(
                      label: 'Back Side ID',
                      icon: Icons.badge,
                      onFileSelected: (url) {
                        // TODO: Handle back ID upload
                      },
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                FileUploadField(
                  label: 'Front Side ID',
                  icon: Icons.credit_card,
                  onFileSelected: (url) {
                    // TODO: Handle front ID upload
                  },
                ),
                AppDimens.verticalMedium,
                FileUploadField(
                  label: 'Back Side ID',
                  icon: Icons.badge,
                  onFileSelected: (url) {
                    // TODO: Handle back ID upload
                  },
                ),
              ],
            );
          },
        ),
        AppDimens.verticalLarge,

        // Authorization Letter section
        Container(
          padding: const EdgeInsets.only(top: 24),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: colorScheme.outline.withOpacity(0.1),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Toggle row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Requires Authorization Letter?',
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        AppDimens.verticalExtraSmall,
                        Text(
                          'Enable if the contact person is not the legal owner',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _requiresAuthorization,
                    onChanged: (value) {
                      setState(() {
                        _requiresAuthorization = value;
                      });
                      widget.onAuthorizationChanged?.call(value);
                    },
                    activeColor: colorScheme.primary,
                  ),
                ],
              ),

              // Conditional Authorization Letter Upload
              if (_requiresAuthorization) ...[
                AppDimens.verticalMedium,
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'UPLOAD AUTHORIZATION LETTER',
                            style: textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // TODO: Download template
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Download Template',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      AppDimens.verticalSmall,
                      _AuthorizationLetterUpload(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Authorization Letter Upload Widget with different styling.
class _AuthorizationLetterUpload extends StatefulWidget {
  @override
  State<_AuthorizationLetterUpload> createState() =>
      _AuthorizationLetterUploadState();
}

class _AuthorizationLetterUploadState
    extends State<_AuthorizationLetterUpload> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: () {
          // TODO: Implement file picker
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 128,
          decoration: BoxDecoration(
            color: _isHovering
                ? colorScheme.primary.withOpacity(0.05)
                : colorScheme.surfaceContainerHighest.withOpacity(0.2),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: _isHovering
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                  size: 24,
                  color: colorScheme.onSurfaceVariant,
                ),
                AppDimens.verticalSmall,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Click to upload',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' or drag and drop',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  'PDF, DOCX (Max 5MB)',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
