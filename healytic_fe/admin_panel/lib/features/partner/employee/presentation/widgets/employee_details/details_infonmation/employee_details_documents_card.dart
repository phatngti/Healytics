import 'package:common/widgets/button/button.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:file_picker/file_picker.dart';

class EmployeeDetailsDocumentsCard extends StatefulWidget {
  final bool isEditing;

  const EmployeeDetailsDocumentsCard({super.key, this.isEditing = false});

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
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;
    final formEnabled = widget.isEditing;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
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
                      color: semanticColors.info?.withAlpha(25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            semanticColors.info?.withAlpha(75) ??
                            colorScheme.outlineVariant,
                      ),
                    ),
                    child: Icon(
                      Icons.workspace_premium,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ),
                  AppDimens.horizontalMediumSmall,
                  Text(
                    'Documents & Certifications',
                    style: textTheme.titleMedium?.copyWith(
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
            firstChild: _buildContent(context, formEnabled),
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

  Widget _buildContent(BuildContext context, bool formEnabled) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload verified certificates, professional licenses, and degrees applicable to this therapist or doctor.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          AppDimens.verticalLarge,
          _buildRequiredDocuments(context, formEnabled),
          AppDimens.verticalLarge,
          _buildAdditionalDocuments(context, formEnabled),
        ],
      ),
    );
  }

  Widget _buildRequiredDocuments(BuildContext context, bool formEnabled) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REQUIRED DOCUMENTS',
          style: textTheme.labelSmall?.copyWith(
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
              formEnabled: formEnabled,
            ),
            AppDimens.verticalMedium,
            _buildManagedDocumentItem(
              context: context,
              fieldName: 'id_card_file',
              uploadTitle: 'Identity Card / Passport',
              uploadSubtitle: 'PDF, JPG, or PNG • Max 10MB',
              uploadIcon: Icons.perm_identity,
              uploadedTypeLabel: 'Identity Card',
              formEnabled: formEnabled,
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
    required bool formEnabled,
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
            isEnabled: formEnabled,
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
          onRemove: formEnabled ? () => _removeDocument(fieldName) : null,
          onReplace: formEnabled ? () => _pickDocument(fieldName) : null,
          isEnabled: formEnabled,
        );
      },
    );
  }

  Widget _buildAdditionalDocuments(BuildContext context, bool formEnabled) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ADDITIONAL DOCUMENTS',
              style: textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            AppButton(
              onPressed: formEnabled
                  ? () => _pickDocument('additional_documents', isList: true)
                  : null,
              buttonType: ButtonType.text,
              icon: Icon(
                Icons.add,
                size: 18,
                color: formEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurface,
              ),
              child: Text(
                'Add Document',
                style: textTheme.labelMedium?.copyWith(
                  color: formEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        AppDimens.verticalMediumSmall,
        FormBuilderField(
          name: 'additional_documents',
          builder: (FormFieldState<List<dynamic>> field) {
            final files = field.value ?? [];

            if (files.isEmpty) {
              return Container(
                padding: AppDimens.paddingAllLarge,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: formEnabled
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerHighest,
                  borderRadius: AppDimens.radiusMedium,
                  border: Border.all(
                    color: colorScheme.outlineVariant,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  'No additional documents uploaded',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
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
                  onRemove: formEnabled
                      ? () => _removeDocument(
                          'additional_documents',
                          index: index,
                        )
                      : null,
                  onReplace:
                      null, // Replace not typical for list items, better removed and re-added
                  showReplace: false,
                  isEnabled: formEnabled,
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
    required bool isEnabled,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: isEnabled
            ? null
            : colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEnabled
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest,
              borderRadius: AppDimens.radiusSmall,
              border: Border.all(color: colorScheme.outlineVariant),
            ),
            child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
          ),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          AppDimens.horizontalMedium,
          AppButton(
            onPressed: isEnabled ? onUpload : null,
            buttonType: ButtonType.outline,
            icon: const Icon(Icons.upload, size: 18),
            child: Text('Upload', style: textTheme.labelLarge),
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
    // Make onRemove and onReplace nullable
    VoidCallback? onRemove,
    VoidCallback? onReplace,
    bool showReplace = true,
    required bool isEnabled,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: isEnabled
            ? null
            : colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.primary),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isEnabled
                  ? colorScheme.surface
                  : colorScheme.surfaceContainerHighest,
              borderRadius: AppDimens.radiusSmall,
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
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
                        borderRadius: AppDimens.radiusExtraSmall,
                      ),
                      child: Text(
                        type,
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ),
                    if (fileSize.isNotEmpty) ...[
                      AppDimens.horizontalSmall,
                      Text(
                        fileSize,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                AppDimens.horizontalSmall,
              ],
              if (showReplace && onReplace != null) ...[
                // onReplace being non-null implies enabled in my new logic?
                // Actually I should just use the passed callback which I set to null if disabled
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
                    style: textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                AppDimens.horizontalMedium,
              ],
              if (onRemove != null)
                InkWell(
                  onTap: onRemove,
                  borderRadius: AppDimens.radiusSmall,
                  child: Container(
                    padding: AppDimens.paddingAllSmall,
                    decoration: BoxDecoration(
                      borderRadius: AppDimens.radiusSmall,
                      border: Border.all(color: colorScheme.surface),
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
