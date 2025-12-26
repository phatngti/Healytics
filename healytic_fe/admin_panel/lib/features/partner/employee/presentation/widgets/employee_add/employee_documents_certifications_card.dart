import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EmployeeDocumentsCertificationsCard extends StatefulWidget {
  const EmployeeDocumentsCertificationsCard({super.key});

  @override
  State<EmployeeDocumentsCertificationsCard> createState() =>
      _EmployeeDocumentsCertificationsCardState();
}

class _EmployeeDocumentsCertificationsCardState
    extends State<EmployeeDocumentsCertificationsCard> {
  bool _isExpanded = true;
  XFile? _licenseFile;
  XFile? _idCardFile;
  String _licenseFileSize = '';
  String _idCardFileSize = '';

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDocument(String type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final int sizeInBytes = await pickedFile.length();
        final String sizeString = _getFileSizeString(sizeInBytes);

        setState(() {
          if (type == 'license') {
            _licenseFile = pickedFile;
            _licenseFileSize = sizeString;
          } else if (type == 'id_card') {
            _idCardFile = pickedFile;
            _idCardFileSize = sizeString;
          }
        });
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  String _getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _removeDocument(String type) {
    setState(() {
      if (type == 'license') {
        _licenseFile = null;
        _licenseFileSize = '';
      } else if (type == 'id_card') {
        _idCardFile = null;
        _idCardFileSize = '';
      }
    });
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
          // Header
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
          // Content
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
              documentKey: 'license',
              file: _licenseFile,
              fileSize: _licenseFileSize,
              uploadTitle: 'Professional License / Practice Permit',
              uploadSubtitle: 'PDF or JPG • Max 10MB',
              uploadIcon: Icons.badge,
              uploadedTypeLabel: 'License / Permit',
            ),
            AppDimens.verticalMedium,
            _buildManagedDocumentItem(
              context: context,
              documentKey: 'id_card',
              file: _idCardFile,
              fileSize: _idCardFileSize,
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
    required String documentKey,
    required XFile? file,
    required String fileSize,
    required String uploadTitle,
    required String uploadSubtitle,
    required IconData uploadIcon,
    required String uploadedTypeLabel,
  }) {
    if (file == null) {
      return _buildDocumentUploadItem(
        context,
        icon: uploadIcon,
        title: uploadTitle,
        subtitle: uploadSubtitle,
        onUpload: () => _pickDocument(documentKey),
      );
    }

    return _buildUploadedDocumentItem(
      context,
      fileName: file.name,
      fileSize: fileSize,
      type: uploadedTypeLabel,
      onRemove: () => _removeDocument(documentKey),
      onReplace: () => _pickDocument(documentKey),
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
    required VoidCallback onRemove,
    required VoidCallback onReplace,
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
                    const SizedBox(width: 8),
                    Text(
                      fileSize,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppDimens.horizontalMedium,
          Row(
            children: [
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

  Widget _buildAdditionalDocuments(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ADDITIONAL DOCUMENTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant,
                style: BorderStyle
                    .solid, // Dashed border not native, solid for now or custom painter if needed. HTML says dashed.
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10), // 0.04 * 255
                        blurRadius: 2,
                      ),
                    ],
                    border: Border.all(color: colorScheme.outlineVariant),
                  ),
                  child: Icon(
                    Icons.cloud_upload,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Click to upload or drag and drop',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  'Upload any other relevant certificates, records, or files.\nSupported formats: PDF, JPG, PNG. Max file size: 10MB.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.outlineVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
