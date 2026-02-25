import 'dart:developer' as developer;

import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/constants/document_types.dart';
import 'package:admin_panel/constants/file_type.dart';
import 'package:common/utils/demensions.dart';
import 'package:admin_panel/utils/url_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Presentation config combining business document type with UI properties.
class _DocumentFieldConfig {
  const _DocumentFieldConfig({
    required this.documentType,
    required this.icon,
    required this.isRequired,
  });

  final DocumentType documentType;
  final IconData icon;
  final bool isRequired;

  String get documentKey => documentType.documentKey;
  String get label => documentType.label;
}

class DocumentUploadType {
  final String type;
  final String key;
  final String documentKey;

  DocumentUploadType({
    required this.type,
    required this.key,
    required this.documentKey,
  });

  /// Extracts the S3 key from the full URL.
  /// Example: 'http://bucket.s3.amazonaws.com/path/to/file.pdf' -> 'path/to/file.pdf'
  String get url {
    return formatR2Url(key) ?? key;
  }

  /// Returns the display type based on file extension.
  String get fileType => FileTypeDisplay.fromExtension(type).name;
}

/// Document Verification form section (Section 4) of Partner Registration.
///
/// Renders different document upload fields based on the business [scope].
/// Each scope has specific required and optional documents.
///
/// Each document field is registered with FormBuilder using the document's key.
/// The form values are stored as String URLs (S3 keys).
class DocumentVerificationSection extends StatelessWidget {
  /// Creates a document verification section.
  ///
  /// The [scope] parameter determines which documents are displayed.
  const DocumentVerificationSection({super.key, required this.scope});

  /// The business scope/type that determines which documents to show.
  final String scope;

  /// Returns the list of document field configs for the given scope.
  List<_DocumentFieldConfig> _getDocumentsForScope(String scope) {
    switch (scope.toUpperCase()) {
      case 'DENTAL':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.rhmLicense,
            icon: Icons.sentiment_satisfied_alt_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.medicalWasteContract,
            icon: Icons.delete_outline,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.kcbLicense,
            icon: Icons.medical_services_outlined,
            isRequired: false,
          ),
        ];
      case 'DERMATOLOGY':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.dermatologyLicense,
            icon: Icons.face_retouching_natural_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.technicalPortfolio,
            icon: Icons.folder_special_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.kcbLicense,
            icon: Icons.medical_services_outlined,
            isRequired: false,
          ),
        ];
      case 'TRADITIONAL_MEDICINE':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.yhctLicense,
            icon: Icons.spa_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.kcbLicense,
            icon: Icons.medical_services_outlined,
            isRequired: false,
          ),
        ];
      case 'PSYCHOLOGY':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.psychologyLicense,
            icon: Icons.psychology_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.kcbLicense,
            icon: Icons.medical_services_outlined,
            isRequired: false,
          ),
        ];
      case 'PSYCHIATRY':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.psychiatryLicense,
            icon: Icons.psychology_alt_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.kcbLicense,
            icon: Icons.medical_services_outlined,
            isRequired: false,
          ),
        ];
      case 'NUTRITION':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.nutritionLicense,
            icon: Icons.restaurant_menu_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.antt,
            icon: Icons.verified_user_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
        ];
      case 'PHARMACY':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.gpp,
            icon: Icons.local_pharmacy_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
        ];
      case 'FITNESS':
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.gcnFitness,
            icon: Icons.fitness_center_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
        ];
      case 'SPA_BEAUTY':
      case 'MASSAGE_THERAPY':
      case 'MASSAGE_REHABILITATION':
      default:
        return [
          _DocumentFieldConfig(
            documentType: DocumentTypes.businessLicense,
            icon: Icons.description_outlined,
            isRequired: true,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.authorizationLetter,
            icon: Icons.assignment_ind_outlined,
            isRequired: false,
          ),
          _DocumentFieldConfig(
            documentType: DocumentTypes.kcbLicense,
            icon: Icons.medical_services_outlined,
            isRequired: false,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final documents = _getDocumentsForScope(scope);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Render document fields based on scope
        for (int i = 0; i < documents.length; i++) ...[
          _DocumentUploadField(
            documentKey: documents[i].documentKey,
            label: documents[i].label,
            icon: documents[i].icon,
            isRequired: documents[i].isRequired,
          ),
          if (i < documents.length - 1) AppDimens.verticalLarge,
        ],
        AppDimens.verticalLarge,

        // Other Supporting Documents (Optional, Multiple files supported)
        _MultiDocumentUploadField(
          name: DocumentTypes.otherDocuments.documentKey,
          label: DocumentTypes.otherDocuments.label,
          icon: Icons.folder_open_outlined,
          isRequired: false,
        ),
      ],
    );
  }
}

/// Single document upload field with FormBuilder integration.
///
/// The form value is stored as a String (S3 URL/key).
class _DocumentUploadField extends StatelessWidget {
  const _DocumentUploadField({
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
        FormBuilderField<DocumentUploadType?>(
          name: 'documents.$documentKey',
          validator: isRequired
              ? (value) =>
                    (value == null || value.url.isEmpty) ? 'Required' : null
              : null,
          builder: (FormFieldState<DocumentUploadType?> field) {
            return _DocumentUploadArea(
              documentKey: documentKey,
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

/// Multi-document upload field with FormBuilder integration.
///
/// The form value is stored as a `List<String>` (S3 URLs/keys).
class _MultiDocumentUploadField extends StatelessWidget {
  const _MultiDocumentUploadField({
    required this.name,
    required this.label,
    required this.icon,
    required this.isRequired,
  });

  final String name;
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
        FormBuilderField<List<DocumentUploadType>>(
          name: 'documents.$name',
          initialValue: const [],
          builder: (FormFieldState<List<DocumentUploadType>> field) {
            return _MultiDocumentUploadArea(
              icon: icon,
              initialFiles: field.value ?? [],
              onFilesSelected: (value) => field.didChange(value),
            );
          },
        ),
      ],
    );
  }
}

/// Document upload area with drag & drop styling.
///
/// When a file is uploaded, this widget calls [onFileSelected] with the S3 key.
class _DocumentUploadArea extends ConsumerStatefulWidget {
  const _DocumentUploadArea({
    required this.documentKey,
    required this.icon,
    this.onFileSelected,
    this.initialValue,
    this.errorText,
  });

  final String documentKey;

  final IconData icon;
  final ValueChanged<DocumentUploadType?>? onFileSelected;
  final DocumentUploadType? initialValue;
  final String? errorText;

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
      _uploadedFileName = widget.initialValue!.url.split('/').last;
    }
  }

  @override
  void didUpdateWidget(covariant _DocumentUploadArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      if (widget.initialValue != null) {
        _uploadedFileName = widget.initialValue!.url.split('/').last;
      } else {
        _uploadedFileName = null;
      }
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
              height: 128,
              decoration: BoxDecoration(
                color: _isHovering
                    ? colorScheme.primary.withValues(alpha: 0.05)
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.3,
                      ),
                borderRadius: AppDimens.radiusSmall,
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

  /// Builds the view showing uploaded file info with icon and remove button.
  Widget _buildUploadedFileView(ColorScheme colorScheme, TextTheme textTheme) {
    final fileIcon = FileTypeUtils.getFileIcon(_uploadedFileName!);
    final iconColor = FileTypeUtils.getFileIconColor(
      _uploadedFileName!,
      colorScheme,
    );

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
          _uploadedFileName = pickedFile.name;
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
}

/// Multi-document upload area that supports uploading multiple files.
class _MultiDocumentUploadArea extends ConsumerStatefulWidget {
  const _MultiDocumentUploadArea({
    required this.icon,
    this.onFilesSelected,
    this.initialFiles = const [],
  });

  final IconData icon;
  final ValueChanged<List<DocumentUploadType>>? onFilesSelected;
  final List<DocumentUploadType> initialFiles;

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
    _uploadedFiles = widget.initialFiles.map((file) {
      return _UploadedFileInfo(
        s3Key: file.url,
        fileName: file.url.split('/').last,
        documentUploadType: file,
      );
    }).toList();
  }

  @override
  void didUpdateWidget(covariant _MultiDocumentUploadArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialFiles != oldWidget.initialFiles) {
      _uploadedFiles = widget.initialFiles.map((file) {
        return _UploadedFileInfo(
          s3Key: file.url,
          fileName: file.url.split('/').last,
          documentUploadType: file,
        );
      }).toList();
    }
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
    final fileIcon = FileTypeUtils.getFileIcon(fileInfo.fileName);
    final iconColor = FileTypeUtils.getFileIconColor(
      fileInfo.fileName,
      colorScheme,
    );

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

  /// Removes a file at the given index and notifies parent.
  void _removeFile(int index) {
    setState(() => _uploadedFiles.removeAt(index));
    _notifyParent();
  }

  /// Notifies the parent widget with the current list of documents.
  void _notifyParent() {
    final files = _uploadedFiles.map((f) => f.documentUploadType).toList();
    widget.onFilesSelected?.call(files);
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
            mimeType: FileTypeUtils.getMimeType(pickedFile.name),
          );

          // Upload to S3
          final key = await s3Service.uploadFile(xFile);

          if (key == null) {
            throw Exception('Upload returned null key');
          }

          if (mounted) {
            final extension = pickedFile.name.split('.').last.toLowerCase();
            final documentUpload = DocumentUploadType(
              type: extension,
              key: formatR2Url(key) ?? key,
              documentKey: 'other_documents',
            );
            setState(() {
              _uploadedFiles.add(
                _UploadedFileInfo(
                  s3Key: key,
                  fileName: pickedFile.name,
                  documentUploadType: documentUpload,
                ),
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
    } catch (e) {
      developer.log('Error picking files: $e', name: 'MultiDocumentUpload');
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
}

/// Helper class to store uploaded file information.
class _UploadedFileInfo {
  final String s3Key;
  final String fileName;
  final DocumentUploadType documentUploadType;

  const _UploadedFileInfo({
    required this.s3Key,
    required this.fileName,
    required this.documentUploadType,
  });

  @override
  String toString() {
    return 'UploadedFileInfo(s3Key: $s3Key, fileName: $fileName)';
  }
}
