import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class EmployeeDetailsDocumentsCard extends StatefulWidget {
  const EmployeeDetailsDocumentsCard({super.key});

  @override
  State<EmployeeDetailsDocumentsCard> createState() =>
      _EmployeeDetailsDocumentsCardState();
}

class _EmployeeDetailsDocumentsCardState
    extends State<EmployeeDetailsDocumentsCard> {
  bool _isExpanded = true;

  Future<void> _pickDocument(String fieldName, {bool isList = false}) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final XFile pickedFile = XFile(result.files.single.path!);
        final formState = FormBuilder.of(context);
        final field = formState?.fields[fieldName];

        if (field != null) {
          if (isList) {
            // For list, we append to existing list
            final currentList = (field.value as List<dynamic>?) ?? [];
            final newList = List<dynamic>.from(currentList)..add(pickedFile);
            field.didChange(newList);
          } else {
            // For single item, we replace
            field.didChange(pickedFile);
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  void _removeDocument(String fieldName, {int? index}) {
    final formState = FormBuilder.of(context);
    final field = formState?.fields[fieldName];

    if (field != null) {
      if (index != null) {
        // Removing from list
        final currentList = (field.value as List<dynamic>?) ?? [];
        if (index >= 0 && index < currentList.length) {
          final newList = List<dynamic>.from(currentList)..removeAt(index);
          field.didChange(newList);
        }
      } else {
        // Removing single item
        field.didChange(null);
      }
    }
  }

  Future<void> _viewDocument(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open file: $url')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Icon(
                      Icons.workspace_premium,
                      size: 18,
                      color: Colors.indigo.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Documents & Certifications',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: _buildContent(context),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload verified certificates, professional licenses, and degrees applicable to this therapist or doctor.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _buildRequiredDocuments(context),
          const SizedBox(height: 24),
          _buildAdditionalDocuments(context),
        ],
      ),
    );
  }

  Widget _buildRequiredDocuments(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REQUIRED DOCUMENTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        AppDimens.verticalMedium,
        Column(
          children: [
            _buildManagedDocumentItem(
              context: context,
              fieldName: 'license_file',
              uploadTitle: 'Professional License / Practice Permit',
              uploadSubtitle: 'PDF or JPG • Max 10MB',
              uploadIcon: Icons.badge,
              uploadedTypeLabel: 'License / Permit',
            ),
            AppDimens.verticalMedium,
            _buildManagedDocumentItem(
              context: context,
              fieldName: 'id_card_file',
              uploadTitle: 'Identity Card / Passport',
              uploadSubtitle: 'PDF, JPG, or PNG • Max 10MB',
              uploadIcon: Icons.perm_identity,
              uploadedTypeLabel: 'Identity Card',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildManagedDocumentItem({
    required BuildContext context,
    required String fieldName,
    required String uploadTitle,
    required String uploadSubtitle,
    required IconData uploadIcon,
    required String uploadedTypeLabel,
  }) {
    return FormBuilderField(
      name: fieldName,
      builder: (FormFieldState<dynamic> field) {
        final value = field.value;

        if (value == null || (value is String && value.isEmpty)) {
          return _buildDocumentUploadItem(
            context,
            icon: uploadIcon,
            title: uploadTitle,
            subtitle: uploadSubtitle,
            onUpload: () => _pickDocument(fieldName),
          );
        }

        String fileName = 'Document';
        String fileSize = '';
        bool isUrl = false;
        String? url;

        if (value is XFile) {
          fileName = value.name;
        } else if (value is String) {
          isUrl = true;
          url = value;
          fileName = value.split('/').last.split('?').first;
        }

        return _buildUploadedDocumentItem(
          context,
          fileName: fileName,
          fileSize: fileSize,
          type: uploadedTypeLabel,
          isUrl: isUrl,
          onView: isUrl && url != null ? () => _viewDocument(url!) : null,
          onRemove: () => _removeDocument(fieldName),
          onReplace: () => _pickDocument(fieldName),
        );
      },
    );
  }

  Widget _buildAdditionalDocuments(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ADDITIONAL DOCUMENTS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            AppButton(
              onPressed: () =>
                  _pickDocument('additional_documents', isList: true),
              buttonType: ButtonType.text,
              icon: Icon(Icons.add, size: 18, color: colorScheme.primary),
              child: Text(
                'Add Document',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        FormBuilderField(
          name: 'additional_documents',
          builder: (FormFieldState<List<dynamic>> field) {
            final files = field.value ?? [];

            if (files.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  'No additional documents uploaded',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: files.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final file = files[index];
                String fileName = 'Document';
                bool isUrl = false;
                String? url;

                if (file is XFile) {
                  fileName = file.name;
                } else if (file is String) {
                  isUrl = true;
                  url = file;
                  fileName = file.split('/').last.split('?').first;
                }

                return _buildUploadedDocumentItem(
                  context,
                  fileName: fileName,
                  fileSize: '',
                  type: 'Document',
                  isUrl: isUrl,
                  onView: isUrl && url != null
                      ? () => _viewDocument(url!)
                      : null,
                  onRemove: () =>
                      _removeDocument('additional_documents', index: index),
                  onReplace:
                      null, // Replace not typical for list items, better removed and re-added
                  showReplace: false,
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDocumentUploadItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onUpload,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          AppButton(
            onPressed: onUpload,
            buttonType: ButtonType.outline,
            icon: const Icon(Icons.upload, size: 18),
            child: const Text('Upload'),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedDocumentItem(
    BuildContext context, {
    required String fileName,
    required String fileSize,
    required String type,
    required bool isUrl,
    VoidCallback? onView,
    required VoidCallback onRemove,
    VoidCallback? onReplace,
    bool showReplace = true,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.primary),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Icon(
              _getFileIcon(fileName),
              color: colorScheme.onSurfaceVariant,
              size: 20,
            ),
          ),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    if (fileSize.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Text(
                        fileSize,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          AppDimens.horizontalMedium,
          Row(
            children: [
              if (isUrl && onView != null) ...[
                AppButton(
                  onPressed: onView,
                  buttonType: ButtonType.text,
                  child: Text(
                    'View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                AppDimens.horizontalSmall,
              ],
              if (showReplace && onReplace != null) ...[
                AppButton(
                  onPressed: onReplace,
                  buttonType: ButtonType.outline,
                  customStyle: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.onSurfaceVariant,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    side: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  child: Text(
                    'Replace',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                AppDimens.horizontalMedium,
              ],
              InkWell(
                onTap: onRemove,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.transparent),
                  ),
                  child: Icon(
                    Icons.delete,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    if (!fileName.contains('.')) return Icons.insert_drive_file;
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      default:
        return Icons.insert_drive_file;
    }
  }
}
