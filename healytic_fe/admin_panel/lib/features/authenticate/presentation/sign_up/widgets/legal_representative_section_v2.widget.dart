import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
/// - Identity Verification file uploads (front/back)
class LegalRepresentativeSectionV2 extends StatelessWidget {
  /// Callback when front ID image is selected.
  final ValueChanged<String?>? onFrontIdSelected;

  /// Callback when back ID image is selected.
  final ValueChanged<String?>? onBackIdSelected;

  const LegalRepresentativeSectionV2({
    super.key,
    this.onFrontIdSelected,
    this.onBackIdSelected,
  });

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
                      isRequired: false,
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
                  isRequired: false,
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
                      hintText: '+1 (555) 000-0000',
                      isRequired: true,
                      keyboardType: TextInputType.phone,
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
                  hintText: '+1 (555) 000-0000',
                  isRequired: true,
                  keyboardType: TextInputType.phone,
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
                      hintText: 'Enter ID number',
                      isRequired: true,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: FormFieldBuilders.buildDateField(
                      context,
                      fieldKey: 'id_issue_date',
                      label: 'Date of Issue',
                      hintText: 'Select date',
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
                  hintText: 'Enter ID number',
                  isRequired: true,
                ),
                AppDimens.verticalMedium,
                FormFieldBuilders.buildDateField(
                  context,
                  fieldKey: 'id_issue_date',
                  label: 'Date of Issue',
                  hintText: 'Select date',
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

        // ID Upload fields
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;

            if (isWide) {
              return Row(
                children: [
                  Expanded(
                    child: _IdUploadCard(
                      label: 'Front Side',
                      icon: Icons.credit_card_outlined,
                      onFileSelected: onFrontIdSelected,
                    ),
                  ),
                  AppDimens.horizontalMedium,
                  Expanded(
                    child: _IdUploadCard(
                      label: 'Back Side',
                      icon: Icons.badge_outlined,
                      onFileSelected: onBackIdSelected,
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _IdUploadCard(
                  label: 'Front Side',
                  icon: Icons.credit_card_outlined,
                  onFileSelected: onFrontIdSelected,
                ),
                AppDimens.verticalMedium,
                _IdUploadCard(
                  label: 'Back Side',
                  icon: Icons.badge_outlined,
                  onFileSelected: onBackIdSelected,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// ID upload card widget matching the HTML design.
class _IdUploadCard extends ConsumerStatefulWidget {
  final String label;
  final IconData icon;
  final ValueChanged<String?>? onFileSelected;

  const _IdUploadCard({
    required this.label,
    required this.icon,
    this.onFileSelected,
  });

  @override
  ConsumerState<_IdUploadCard> createState() => _IdUploadCardState();
}

class _IdUploadCardState extends ConsumerState<_IdUploadCard> {
  bool _isHovering = false;
  bool _isUploading = false;
  Uint8List? _uploadedImageBytes;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show image preview if uploaded
    if (_uploadedImageBytes != null) {
      return _buildPreviewState(colorScheme);
    }

    return MouseRegion(
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
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: AppDimens.radiusMediumSmall,
            border: Border.all(
              color: _isHovering
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
              Icon(Icons.check_circle, size: 16, color: Colors.greenAccent),
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
        mimeType: _getMimeType(pickedFile.name),
      );

      // Upload to S3
      final s3Service = ref.read(s3ServiceProvider);
      final key = await s3Service.uploadFile(xFile);

      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadedImageBytes = pickedFile.bytes;
        });
        widget.onFileSelected?.call(key);
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

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }
}
