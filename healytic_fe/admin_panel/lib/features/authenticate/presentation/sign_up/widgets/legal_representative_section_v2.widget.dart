import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/constants/document_types.dart';
import 'package:admin_panel/constants/file_type.dart';
import 'package:admin_panel/features/authenticate/presentation/sign_up/widgets/document_verification_section.widget.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:common/utils/demensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Legal Representative form section (Section 3) of Partner Registration.
///
/// Contains:
/// - Full Name text field
/// - Position text field
/// - Phone Number text field
/// - ID Type dropdown
/// - ID Number text field
/// - Date of Issue date picker
/// - Identity Verification file uploads (front/back) using FormBuilderField
///   with document keys 'id_front' and 'id_back' to integrate with form submission.
class LegalRepresentativeSectionV2 extends StatelessWidget {
  const LegalRepresentativeSectionV2({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row 1: Full Name & Position
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
                      hintText: 'As shown on ID',
                      isRequired: true,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'representative_position',
                      label: 'Position',
                      hintText: 'e.g. Director',
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
                  hintText: 'As shown on ID',
                  isRequired: true,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'representative_position',
                  label: 'Position',
                  hintText: 'e.g. Director',
                  isRequired: true,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 2: Phone Number & ID Type
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'representative_phone',
                      label: 'Phone Number',
                      hintText: '0912345678',
                      isRequired: true,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return 'Phone number is required';
                        }
                        // Vietnamese phone number pattern
                        final phoneRegex = RegExp(
                          r'^(\+84|84|0)(3|5|7|8|9)[0-9]{8}$',
                        );
                        final phone = value.toString().replaceAll(
                          RegExp(r'[\s\-()]'),
                          '',
                        );
                        if (!phoneRegex.hasMatch(phone)) {
                          return 'Please enter a valid Vietnamese phone number';
                        }
                        return null;
                      },
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildDropdownField(
                      context,
                      fieldKey: 'id_type',
                      label: 'ID Type',
                      items: const [
                        'ID Card',
                        'Citizen Identity Card',
                        'Passport',
                      ],
                      initialValue: 'ID Card',
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
                  fieldKey: 'representative_phone',
                  label: 'Phone Number',
                  hintText: '0912345678',
                  isRequired: true,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return 'Phone number is required';
                    }
                    // Vietnamese phone number pattern
                    final phoneRegex = RegExp(
                      r'^(\+84|84|0)(3|5|7|8|9)[0-9]{8}$',
                    );
                    final phone = value.toString().replaceAll(
                      RegExp(r'[\s\-()]'),
                      '',
                    );
                    if (!phoneRegex.hasMatch(phone)) {
                      return 'Please enter a valid Vietnamese phone number';
                    }
                    return null;
                  },
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildDropdownField(
                  context,
                  fieldKey: 'id_type',
                  label: 'ID Type',
                  items: const ['ID Card', 'Citizen Identity Card', 'Passport'],
                  initialValue: 'ID Card',
                  isRequired: true,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalMedium,

        // Row 3: ID Number & Date of Issue
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: FormFieldBuilders.buildTextField(
                      context,
                      fieldKey: 'id_number',
                      label: 'ID Number',
                      hintText: 'Enter ID number (9 or 12 digits)',
                      isRequired: true,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.toString().isEmpty) {
                          return 'ID number is required';
                        }
                        final idNumber = value.toString().replaceAll(
                          RegExp(r'\s'),
                          '',
                        );
                        if (idNumber.length != 9 && idNumber.length != 12) {
                          return 'ID number must be 9 or 12 digits';
                        }
                        if (!RegExp(r'^[0-9]+$').hasMatch(idNumber)) {
                          return 'ID number must contain only digits';
                        }
                        return null;
                      },
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildDateField(
                      context,
                      fieldKey: 'id_issue_date',
                      label: 'Date of Issue',
                      hintText: 'Select date',
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
                  fieldKey: 'id_number',
                  label: 'ID Number',
                  hintText: 'Enter ID number (9 or 12 digits)',
                  isRequired: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.toString().isEmpty) {
                      return 'ID number is required';
                    }
                    final idNumber = value.toString().replaceAll(
                      RegExp(r'\s'),
                      '',
                    );
                    if (idNumber.length != 9 && idNumber.length != 12) {
                      return 'ID number must be 9 or 12 digits';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(idNumber)) {
                      return 'ID number must contain only digits';
                    }
                    return null;
                  },
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'id_issue_date',
                  label: 'Date of Issue',
                  hintText: 'Select date',
                  isRequired: true,
                ),
              ],
            );
          },
        ),
        AppDimens.verticalLarge,

        // Identity Verification section
        Text(
          'IDENTITY VERIFICATION IMAGES',
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppDimens.verticalMedium,

        // ID Upload fields using FormBuilderField with documents.* pattern
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _IdUploadField(
                      documentKey: DocumentTypes.idCardFront.documentKey,
                      label: DocumentTypes.idCardFront.label,
                      icon: Icons.credit_card_outlined,
                      isRequired: true,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _IdUploadField(
                      documentKey: DocumentTypes.idCardBack.documentKey,
                      label: DocumentTypes.idCardBack.label,
                      icon: Icons.badge_outlined,
                      isRequired: true,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _IdUploadField(
                  documentKey: DocumentTypes.idCardFront.documentKey,
                  label: DocumentTypes.idCardFront.label,
                  icon: Icons.credit_card_outlined,
                  isRequired: true,
                ),
                AppDimens.verticalMedium,
                _IdUploadField(
                  documentKey: DocumentTypes.idCardBack.documentKey,
                  label: DocumentTypes.idCardBack.label,
                  icon: Icons.badge_outlined,
                  isRequired: true,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

// ============================================================================
// ID Upload Field with FormBuilder Integration
// ============================================================================

/// Single ID image upload field with FormBuilder integration.
///
/// The form value is stored as a [DocumentUploadType] to integrate with
/// the form's document collection pattern using the documents.* key prefix.
class _IdUploadField extends StatelessWidget {
  const _IdUploadField({
    required this.documentKey,
    required this.label,
    required this.icon,
    required this.isRequired,
  });

  final String documentKey;
  final String label;
  final IconData icon;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.error,
                ),
              ),
          ],
        ),
        AppDimens.verticalSmall,
        FormBuilderField<DocumentUploadType?>(
          name: 'documents.$documentKey',
          validator: isRequired
              ? (value) =>
                    (value == null || value.url.isEmpty) ? 'Required' : null
              : null,
          builder: (FormFieldState<DocumentUploadType?> field) {
            return _IdUploadArea(
              documentKey: documentKey,
              label: label,
              icon: icon,
              initialValue: field.value,
              errorText: field.errorText,
              onFileSelected: (file) => field.didChange(file),
            );
          },
        ),
      ],
    );
  }
}

/// ID image upload area with image preview support.
///
/// When a file is uploaded, this widget calls [onFileSelected] with a
/// [DocumentUploadType] containing the S3 key and file metadata.
class _IdUploadArea extends ConsumerStatefulWidget {
  const _IdUploadArea({
    required this.documentKey,
    required this.label,
    required this.icon,
    this.onFileSelected,
    this.initialValue,
    this.errorText,
  });

  final String documentKey;
  final String label;
  final IconData icon;
  final ValueChanged<DocumentUploadType?>? onFileSelected;
  final DocumentUploadType? initialValue;
  final String? errorText;

  @override
  ConsumerState<_IdUploadArea> createState() => _IdUploadAreaState();
}

class _IdUploadAreaState extends ConsumerState<_IdUploadArea> {
  bool _isHovering = false;
  bool _isUploading = false;
  Uint8List? _uploadedImageBytes;

  @override
  void initState() {
    super.initState();
    // Note: We can't load image bytes from URL in initState for existing values
    // The preview will only show for newly uploaded images
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show image preview if uploaded
    if (_uploadedImageBytes != null) {
      return _buildPreviewState(colorScheme);
    }

    // Show uploaded file indicator if we have initial value but no bytes
    if (widget.initialValue != null) {
      return _buildUploadedIndicator(colorScheme, textTheme);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: GestureDetector(
            onTap: _isUploading ? null : _pickFile,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 180,
              decoration: BoxDecoration(
                color: _isHovering
                    ? colorScheme.primary.withValues(alpha: 0.05)
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                borderRadius: AppDimens.radiusMediumSmall,
                border: Border.all(
                  color: widget.errorText != null
                      ? colorScheme.error
                      : _isHovering
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: _isUploading
                    ? _buildUploadingState(colorScheme, textTheme)
                    : _buildDefaultState(colorScheme, textTheme),
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          AppDimens.verticalExtraSmall,
          Text(
            widget.errorText!,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
          ),
        ],
      ],
    );
  }

  Widget _buildUploadingState(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: colorScheme.primary,
          ),
        ),
        AppDimens.verticalSmall,
        Text(
          'Uploading...',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultState(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          widget.icon,
          size: 40,
          color: _isHovering
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
        ),
        AppDimens.verticalSmall,
        Text(
          widget.label,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        AppDimens.verticalExtraSmall,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Click to upload',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: ' or drag & drop',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        AppDimens.verticalExtraSmall,
        Text(
          'JPG, PNG | Max 10MB',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  /// Builds an indicator for when we have an initial value but no image bytes.
  Widget _buildUploadedIndicator(ColorScheme colorScheme, TextTheme textTheme) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 40,
                  color: colorScheme.primary,
                ),
                AppDimens.verticalSmall,
                Text(
                  widget.label,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  'Image uploaded',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          // Remove button at top right
          Positioned(
            top: 8,
            right: 8,
            child: Material(
              color: colorScheme.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _removeImage,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(Icons.close, size: 18, color: colorScheme.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewState(ColorScheme colorScheme) {
    return Stack(
      children: [
        // Image preview
        ClipRRect(
          borderRadius: AppDimens.radiusMediumSmall,
          child: SizedBox(
            height: 180,
            width: double.infinity,
            child: Image.memory(_uploadedImageBytes!, fit: BoxFit.cover),
          ),
        ),
        // Overlay with label and remove button
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppDimens.radiusMediumSmall,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),
        ),
        // Label at bottom left
        Positioned(
          left: 12,
          bottom: 12,
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                size: 16,
                color: Colors.greenAccent,
              ),
              AppDimens.horizontalExtraSmall,
              Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        // Remove button at top right
        Positioned(
          top: 8,
          right: 8,
          child: Material(
            color: Colors.black.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _removeImage,
              child: const Padding(
                padding: EdgeInsets.all(6),
                child: Icon(Icons.close, size: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _removeImage() {
    setState(() {
      _uploadedImageBytes = null;
    });
    widget.onFileSelected?.call(null);
  }

  Future<void> _pickFile() async {
    try {
      // Pick image file using file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final pickedFile = result.files.single;

      // Validate file size (max 10MB)
      if (pickedFile.size > 10 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 10MB limit'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() => _isUploading = true);

      // Convert PlatformFile to XFile for S3Service
      final xFile = XFile(
        pickedFile.path!,
        name: pickedFile.name,
        bytes: pickedFile.bytes,
        mimeType: FileTypeUtils.getMimeType(pickedFile.name),
      );

      // Upload to S3
      final s3Service = ref.read(s3ServiceProvider);
      final key = await s3Service.uploadFile(xFile);

      if (key == null) {
        if (mounted) {
          setState(() => _isUploading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Upload failed: No key returned'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadedImageBytes = pickedFile.bytes;
        });

        // Create DocumentUploadType with file info
        final extension = pickedFile.name.split('.').last.toLowerCase();
        final documentUpload = DocumentUploadType(
          type: extension,
          key: key,
          documentKey: widget.documentKey,
        );
        widget.onFileSelected?.call(documentUpload);
      }
    } catch (e) {
      developer.log('Error picking/uploading ID image: $e', name: 'IdUpload');
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
