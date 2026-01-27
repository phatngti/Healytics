import 'dart:developer' as developer;

import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Document Verification form section (Section 4) of Partner Registration.
///
/// Contains upload fields for:
/// - Business License (Giấy phép kinh doanh)
/// - Authorization Letter (Giấy ủy quyền)
/// - Tax Registration Certificate (Mã số thuế)
/// - Other Supporting Documents (Tài liệu bổ sung)
class DocumentVerificationSection extends StatelessWidget {
  const DocumentVerificationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Business License (Required)
        _buildDocumentUploadField(
          context,
          name: 'business_license',
          label: 'Business License (Giấy phép kinh doanh)',
          icon: Icons.description_outlined,
          isRequired: true,
        ),
        AppDimens.verticalLarge,

        // Authorization Letter (Optional)
        _buildDocumentUploadField(
          context,
          name: 'authorization_letter',
          label: 'Authorization Letter (Giấy ủy quyền)',
          icon: Icons.assignment_ind_outlined,
          isRequired: false,
        ),
        AppDimens.verticalLarge,

        // Tax Registration Certificate (Required)
        _buildDocumentUploadField(
          context,
          name: 'tax_certificate',
          label: 'Tax Registration Certificate (Mã số thuế)',
          icon: Icons.account_balance_outlined,
          isRequired: true,
        ),
        AppDimens.verticalLarge,

        // Other Supporting Documents (Optional, Multiple files supported)
        _buildMultiDocumentUploadField(
          context,
          name: 'other_documents',
          label: 'Other Supporting Documents (Tài liệu bổ sung)',
          icon: Icons.folder_open_outlined,
          isRequired: false,
        ),
      ],
    );
  }

  /// Builds a document upload field with label using FormBuilderField.
  ///
  /// Shows a required indicator (*) or "(Optional)" text based on [isRequired].
  Widget _buildDocumentUploadField(
    BuildContext context, {
    required String name,
    required String label,
    required IconData icon,
    required bool isRequired,
  }) {
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
              )
            else
              Text(
                ' (Optional)',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        AppDimens.verticalSmall,
        FormBuilderField<String?>(
          name: name,
          builder: (FormFieldState<String?> field) {
            return _DocumentUploadArea(
              icon: icon,
              initialValue: field.value,
              onFileSelected: (value) {
                field.didChange(value);
              },
            );
          },
        ),
      ],
    );
  }

  /// Builds a multi-document upload field with label (supports multiple files).
  ///
  /// Shows a required indicator (*) or "(Optional)" text based on [isRequired].
  Widget _buildMultiDocumentUploadField(
    BuildContext context, {
    required String name,
    required String label,
    required IconData icon,
    required bool isRequired,
  }) {
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
              )
            else
              Text(
                ' (Optional)',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
        AppDimens.verticalSmall,
        FormBuilderField<List<String>>(
          name: name,
          initialValue: const [],
          builder: (FormFieldState<List<String>> field) {
            return _MultiDocumentUploadArea(
              icon: icon,
              initialFiles: field.value ?? [],
              onFilesSelected: (value) {
                field.didChange(value);
              },
            );
          },
        ),
      ],
    );
  }
}

/// Document upload area with drag & drop styling.
class _DocumentUploadArea extends ConsumerStatefulWidget {
  final IconData icon;
  final ValueChanged<String?>? onFileSelected;
  final String? initialValue;

  const _DocumentUploadArea({
    required this.icon,
    this.onFileSelected,
    this.initialValue,
  });

  @override
  ConsumerState<_DocumentUploadArea> createState() =>
      _DocumentUploadAreaState();
}

class _DocumentUploadAreaState extends ConsumerState<_DocumentUploadArea> {
  bool _isHovering = false;
  bool _isUploading = false;
  String? _uploadedFileName;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      // In a real scenario, we might only have the URL/key, not the original filename
      // So we might need to display the key or some placeholder, or fetch metadata
      // For now, let's assume the value is what we want to display or we extract filename from it
      _uploadedFileName = widget.initialValue!.split('/').last;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Show uploaded file info if available
    if (_uploadedFileName != null) {
      return _buildUploadedFileView(colorScheme, textTheme);
    }

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _isUploading ? null : _pickFile,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 128,
          decoration: BoxDecoration(
            color: _isHovering
                ? colorScheme.primary.withValues(alpha: 0.05)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: _isHovering
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: _isUploading
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 28,
                        height: 28,
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
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: 28,
                        color: _isHovering
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
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
                        'PDF, JPG, PNG | Max 10MB',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Builds the view showing uploaded file info with icon and remove button.
  Widget _buildUploadedFileView(ColorScheme colorScheme, TextTheme textTheme) {
    final fileIcon = _getFileIcon(_uploadedFileName!);
    final iconColor = _getFileIconColor(_uploadedFileName!, colorScheme);

    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.5),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // File icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(fileIcon, size: 28, color: iconColor),
            ),
            AppDimens.horizontalMedium,
            // File name
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _uploadedFileName!,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppDimens.verticalExtraSmall,
                  Text(
                    'Uploaded successfully',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            // Remove button
            IconButton(
              onPressed: _removeFile,
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.error,
                size: 20,
              ),
              tooltip: 'Remove file',
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.error.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Returns appropriate icon based on file extension.
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  /// Returns appropriate icon color based on file type.
  Color _getFileIconColor(String fileName, ColorScheme colorScheme) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red.shade600;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.blue.shade600;
      default:
        return colorScheme.primary;
    }
  }

  /// Removes the uploaded file and notifies parent.
  void _removeFile() {
    setState(() => _uploadedFileName = null);
    widget.onFileSelected?.call(null);
  }

  Future<void> _pickFile() async {
    try {
      // Pick file using file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
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
          _uploadedFileName = pickedFile.name;
        });
        widget.onFileSelected?.call(key);
      }
    } catch (e) {
      developer.log('Error picking/uploading file: $e', name: 'DocumentUpload');
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
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

/// Multi-document upload area that supports uploading multiple files.
class _MultiDocumentUploadArea extends ConsumerStatefulWidget {
  final IconData icon;
  final ValueChanged<List<String>>? onFilesSelected;
  final List<String> initialFiles;

  const _MultiDocumentUploadArea({
    required this.icon,
    this.onFilesSelected,
    this.initialFiles = const [],
  });

  @override
  ConsumerState<_MultiDocumentUploadArea> createState() =>
      _MultiDocumentUploadAreaState();
}

class _MultiDocumentUploadAreaState
    extends ConsumerState<_MultiDocumentUploadArea> {
  bool _isHovering = false;
  bool _isUploading = false;

  /// List of uploaded files with their S3 keys and display names.
  late List<_UploadedFileInfo> _uploadedFiles;

  @override
  void initState() {
    super.initState();
    _uploadedFiles = widget.initialFiles.map((url) {
      return _UploadedFileInfo(
        s3Key: url,
        fileName: url.split('/').last, // Approximate filename from URL
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Uploaded files list
        if (_uploadedFiles.isNotEmpty) ...[
          ...List.generate(_uploadedFiles.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildUploadedFileItem(
                _uploadedFiles[index],
                index,
                colorScheme,
                textTheme,
              ),
            );
          }),
          AppDimens.verticalSmall,
        ],

        // Upload area (always visible for adding more files)
        _buildUploadArea(colorScheme, textTheme),
      ],
    );
  }

  /// Builds an individual uploaded file item with remove button.
  Widget _buildUploadedFileItem(
    _UploadedFileInfo fileInfo,
    int index,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    final fileIcon = _getFileIcon(fileInfo.fileName);
    final iconColor = _getFileIconColor(fileInfo.fileName, colorScheme);

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            // File icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(fileIcon, size: 22, color: iconColor),
            ),
            AppDimens.horizontalSmall,
            // File name
            Expanded(
              child: Text(
                fileInfo.fileName,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Remove button
            IconButton(
              onPressed: () => _removeFile(index),
              icon: Icon(
                Icons.close_rounded,
                color: colorScheme.error,
                size: 18,
              ),
              tooltip: 'Remove file',
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.error.withValues(alpha: 0.1),
                padding: const EdgeInsets.all(6),
                minimumSize: const Size(32, 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the upload area for adding more files.
  Widget _buildUploadArea(ColorScheme colorScheme, TextTheme textTheme) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: _isUploading ? null : _pickFiles,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: _uploadedFiles.isEmpty ? 128 : 80,
          decoration: BoxDecoration(
            color: _isHovering
                ? colorScheme.primary.withValues(alpha: 0.05)
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: _isHovering
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Center(
            child: _isUploading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                      AppDimens.horizontalSmall,
                      Text(
                        'Uploading...',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  )
                : _uploadedFiles.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        widget.icon,
                        size: 28,
                        color: _isHovering
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
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
                        'PDF, JPG, PNG | Max 10MB each | Multiple files allowed',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 22,
                        color: _isHovering
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                      ),
                      AppDimens.horizontalSmall,
                      Text(
                        'Add more files',
                        style: textTheme.bodyMedium?.copyWith(
                          color: _isHovering
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  /// Returns appropriate icon based on file extension.
  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_rounded;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  /// Returns appropriate icon color based on file type.
  Color _getFileIconColor(String fileName, ColorScheme colorScheme) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Colors.red.shade600;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Colors.blue.shade600;
      default:
        return colorScheme.primary;
    }
  }

  /// Removes a file at the given index and notifies parent.
  void _removeFile(int index) {
    setState(() => _uploadedFiles.removeAt(index));
    _notifyParent();
  }

  /// Notifies the parent widget with the current list of S3 keys.
  void _notifyParent() {
    print("_uploadedFiles: ${_uploadedFiles.toString()}");
    final keys = _uploadedFiles.map((f) => f.s3Key).toList();
    print("keys: $keys");
    widget.onFilesSelected?.call(keys);
  }

  Future<void> _pickFiles() async {
    try {
      // Pick multiple files using file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
        allowMultiple: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      // Filter and validate files
      final validFiles = <PlatformFile>[];
      for (final file in result.files) {
        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${file.name} exceeds 10MB limit, skipped'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          continue;
        }
        validFiles.add(file);
      }

      if (validFiles.isEmpty) return;

      setState(() => _isUploading = true);

      final s3Service = ref.read(s3ServiceProvider);

      for (final pickedFile in validFiles) {
        try {
          // Validate that bytes are available (withData: true should ensure this)
          if (pickedFile.bytes == null) {
            throw Exception('File bytes not available');
          }

          // Use XFile.fromData for web compatibility (path is not reliable on web)
          final xFile = XFile.fromData(
            pickedFile.bytes!,
            name: pickedFile.name,
            mimeType: _getMimeType(pickedFile.name),
          );

          // Upload to S3
          final key = await s3Service.uploadFile(xFile);

          if (key == null) {
            throw Exception('Upload returned null key');
          }

          if (mounted) {
            setState(() {
              _uploadedFiles.add(
                _UploadedFileInfo(s3Key: key, fileName: pickedFile.name),
              );
            });
          }
        } catch (e) {
          developer.log(
            'Error uploading file ${pickedFile.name}: $e',
            name: 'MultiDocumentUpload',
          );
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to upload ${pickedFile.name}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }

      if (mounted) {
        setState(() => _isUploading = false);
        _notifyParent();
      }
    } catch (e, s) {
      developer.log('Error picking files: $e', name: 'MultiDocumentUpload');
      print(e);
      print(s);
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick files: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getMimeType(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return 'application/pdf';
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

/// Helper class to store uploaded file information.
class _UploadedFileInfo {
  final String s3Key;
  final String fileName;

  const _UploadedFileInfo({required this.s3Key, required this.fileName});

  @override
  String toString() {
    return 'UploadedFileInfo(s3Key: $s3Key, fileName: $fileName)';
  }
}
