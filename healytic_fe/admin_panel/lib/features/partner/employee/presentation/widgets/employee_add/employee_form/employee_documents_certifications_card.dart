import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:admin_panel/features/partner/employee/domain/verification_document_entry.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/widgets/button/button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

/// Keys identifying each verification document
/// type. Must match the backend's
/// `VerificationDocumentEntryDto.fieldKey`.
abstract final class DocFieldKey {
  static const license = 'license';
  static const idCard = 'id_card';
  static const others = 'other_documents';
}

/// Manages the verification documents section of
/// the employee add form.
///
/// All documents are stored as a single
/// `FormBuilderField` keyed by
/// [EmployeeFormField.verificationDocuments].
///
/// Each entry is a `Map<String, dynamic>` with
/// `fieldKey` and `documents` (a list of maps with
/// `name` and `url`) matching the
/// `VerificationDocumentEntryDto` structure.
class EmployeeDocumentsCertificationsCard extends ConsumerStatefulWidget {
  const EmployeeDocumentsCertificationsCard({super.key});

  @override
  ConsumerState<EmployeeDocumentsCertificationsCard> createState() =>
      _EmployeeDocsCertCardState();
}

class _EmployeeDocsCertCardState
    extends ConsumerState<EmployeeDocumentsCertificationsCard> {
  static const _allowedDocumentExtensions = ['jpg', 'jpeg', 'png', 'pdf'];
  static const _maxDocumentSizeBytes = 10 * 1024 * 1024;

  bool _isExpanded = true;
  bool _isUploading = false;

  // ── Validation ──────────────────────────────

  /// Validates that both required documents
  /// (license and identity card) are uploaded.
  String? _validateRequiredDocuments(List<Map<String, dynamic>>? value) {
    final groups = value ?? [];
    final hasLicense = _hasDocInGroup(groups, DocFieldKey.license);
    final hasIdCard = _hasDocInGroup(groups, DocFieldKey.idCard);
    if (!hasLicense && !hasIdCard) {
      return 'Both Professional License and '
          'Identity Card are required';
    }
    if (!hasLicense) {
      return 'Professional License / '
          'Practice Permit is required';
    }
    if (!hasIdCard) {
      return 'Identity Card / Passport '
          'is required';
    }
    return null;
  }

  /// Checks whether a group identified by
  /// [fieldKey] has at least one document.
  bool _hasDocInGroup(List<Map<String, dynamic>> groups, String fieldKey) {
    for (final g in groups) {
      if (g['fieldKey'] == fieldKey) {
        final docs = g['documents'];
        if (docs is List && docs.isNotEmpty) {
          return true;
        }
      }
    }
    return false;
  }

  // ── Document list helpers ────────────────────

  /// Returns the current grouped doc list from the
  /// form field or an empty list.
  List<Map<String, dynamic>> _currentGroups(FormFieldState<dynamic> field) {
    final raw = field.value;
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  /// Finds a group entry by its [fieldKey].
  Map<String, dynamic>? _findGroup(
    List<Map<String, dynamic>> groups,
    String fieldKey,
  ) {
    for (final g in groups) {
      if (g['fieldKey'] == fieldKey) return g;
    }
    return null;
  }

  /// Returns the `documents` list from a group.
  List<Map<String, dynamic>> _docsFromGroup(Map<String, dynamic>? group) {
    final raw = group?['documents'];
    if (raw is List) {
      return raw.whereType<Map<String, dynamic>>().toList();
    }
    return [];
  }

  /// Upserts a single-document group (for
  /// `license` and `id_card` which only hold one
  /// document).
  List<Map<String, dynamic>> _upsertSingleDoc(
    List<Map<String, dynamic>> groups, {
    required String fieldKey,
    required String name,
    required String url,
  }) {
    final updated = groups.where((g) => g['fieldKey'] != fieldKey).toList();
    updated.add(
      VerificationDocumentEntry(
        fieldKey: fieldKey,
        documents: [
          DocumentEntry(
            name: name,
            url: url,
            updatedTime: DateTime.now().toIso8601String(),
          ),
        ],
      ).toJson(),
    );
    return updated;
  }

  /// Removes a group entry by [fieldKey].
  List<Map<String, dynamic>> _removeGroup(
    List<Map<String, dynamic>> groups,
    String fieldKey,
  ) => groups.where((g) => g['fieldKey'] != fieldKey).toList();

  /// Adds a document to the `other_documents`
  /// group, creating it if absent.
  List<Map<String, dynamic>> _addToOtherDocs(
    List<Map<String, dynamic>> groups, {
    required String name,
    required String url,
  }) {
    final existing = _findGroup(groups, DocFieldKey.others);
    final docs = _docsFromGroup(existing);
    docs.add(
      DocumentEntry(
        name: name,
        url: url,
        updatedTime: DateTime.now().toIso8601String(),
      ).toJson(),
    );

    final updated = groups
        .where((g) => g['fieldKey'] != DocFieldKey.others)
        .toList();
    updated.add(
      VerificationDocumentEntry(
        fieldKey: DocFieldKey.others,
        documents: docs.map((d) => DocumentEntry.fromJson(d)).toList(),
      ).toJson(),
    );
    return updated;
  }

  /// Removes a document at [index] from the
  /// `other_documents` group.
  List<Map<String, dynamic>> _removeFromOtherDocs(
    List<Map<String, dynamic>> groups,
    int index,
  ) {
    final existing = _findGroup(groups, DocFieldKey.others);
    final docs = _docsFromGroup(existing);
    if (index >= 0 && index < docs.length) {
      docs.removeAt(index);
    }

    final updated = groups
        .where((g) => g['fieldKey'] != DocFieldKey.others)
        .toList();
    if (docs.isNotEmpty) {
      updated.add(
        VerificationDocumentEntry(
          fieldKey: DocFieldKey.others,
          documents: docs.map((d) => DocumentEntry.fromJson(d)).toList(),
        ).toJson(),
      );
    }
    return updated;
  }

  /// Replaces a document at [index] in the
  /// `other_documents` group.
  List<Map<String, dynamic>> _replaceInOtherDocs(
    List<Map<String, dynamic>> groups,
    int index, {
    required String name,
    required String url,
  }) {
    final existing = _findGroup(groups, DocFieldKey.others);
    final docs = _docsFromGroup(existing);
    if (index >= 0 && index < docs.length) {
      docs[index] = DocumentEntry(
        name: name,
        url: url,
        updatedTime: DateTime.now().toIso8601String(),
      ).toJson();
    }

    final updated = groups
        .where((g) => g['fieldKey'] != DocFieldKey.others)
        .toList();
    updated.add(
      VerificationDocumentEntry(
        fieldKey: DocFieldKey.others,
        documents: docs.map((d) => DocumentEntry.fromJson(d)).toList(),
      ).toJson(),
    );
    return updated;
  }

  // ── Upload / View ───────────────────────────

  /// Picks and uploads a file, then calls
  /// [onUploaded] with the original file name and
  /// resulting URL.
  Future<void> _pickAndUpload(
    void Function(String fileName, String url) onUploaded,
  ) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _allowedDocumentExtensions,
        allowMultiple: false,
        withData: true,
      );
      final file = result?.files.single;
      if (file == null) return;

      if (file.size > _maxDocumentSizeBytes) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('File must be 10MB or smaller.')),
          );
        }
        return;
      }

      final picked = _toUploadFile(file);
      if (picked == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not read selected file.')),
          );
        }
        return;
      }

      setState(() => _isUploading = true);

      final s3 = ref.read(s3ServiceProvider);
      final key = await s3.uploadFile(picked);
      if (key != null) {
        final url = await s3.getFileUrl(key);
        if (mounted && url != null) {
          onUploaded(file.name, url);
        }
      }
    } catch (e) {
      debugPrint('Upload error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error uploading file: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  XFile? _toUploadFile(PlatformFile file) {
    final mimeType = _mimeTypeFor(file.extension);
    final path = file.path;
    if (path != null && path.isNotEmpty) {
      return XFile(path, name: file.name, mimeType: mimeType);
    }

    final bytes = file.bytes;
    if (bytes == null) return null;
    return XFile.fromData(bytes, name: file.name, mimeType: mimeType);
  }

  String? _mimeTypeFor(String? extension) {
    return switch (extension?.toLowerCase()) {
      'pdf' => 'application/pdf',
      'jpg' || 'jpeg' => 'image/jpeg',
      'png' => 'image/png',
      _ => null,
    };
  }

  /// Opens a URL in the external browser.
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

  // ── Build ────────────────────────────────────

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
            color: colorScheme.shadow.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeader(context, colorScheme),
          AnimatedCrossFade(
            firstChild: _buildBody(context),
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

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: semanticColors.info!.withAlpha(25),
                shape: BoxShape.circle,
                border: Border.all(color: semanticColors.info!.withAlpha(50)),
              ),
              child: Icon(
                Icons.workspace_premium,
                size: 18,
                color: semanticColors.info,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            Text(
              'Documents & Certifications',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
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
    );
  }

  Widget _buildBody(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: FormBuilderField<List<Map<String, dynamic>>>(
        name: EmployeeFormField.verificationDocuments.key,
        enabled: FormBuilder.of(context)?.enabled ?? true,
        validator: _validateRequiredDocuments,
        builder: (field) {
          final groups = _currentGroups(field);
          final formEnabled = field.widget.enabled;
          final hasError = field.errorText != null;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upload verified certificates, '
                'professional licenses, and '
                'degrees applicable to this '
                'therapist or doctor.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              AppDimens.verticalLarge,
              _buildRequiredSection(context, groups, field, formEnabled),
              AppDimens.verticalLarge,
              _buildOtherDocumentsSection(context, groups, field, formEnabled),
              if (hasError) ...[
                AppDimens.verticalSmall,
                Text(
                  field.errorText!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: colorScheme.error),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  // ── Required documents ──────────────────────

  Widget _buildRequiredSection(
    BuildContext context,
    List<Map<String, dynamic>> groups,
    FormFieldState<List<Map<String, dynamic>>> field,
    bool formEnabled,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'REQUIRED DOCUMENTS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        AppDimens.verticalMedium,
        _buildSingleDocRow(
          context: context,
          groups: groups,
          field: field,
          fieldKey: DocFieldKey.license,
          uploadTitle:
              'Professional License /'
              ' Practice Permit',
          uploadSubtitle: 'PDF or JPG • Max 10MB',
          uploadIcon: Icons.badge,
          typeLabel: 'License / Permit',
          formEnabled: formEnabled,
          isRequired: true,
        ),
        AppDimens.verticalMedium,
        _buildSingleDocRow(
          context: context,
          groups: groups,
          field: field,
          fieldKey: DocFieldKey.idCard,
          uploadTitle: 'Identity Card / Passport',
          uploadSubtitle: 'PDF, JPG, or PNG • Max 10MB',
          uploadIcon: Icons.perm_identity,
          typeLabel: 'Identity Card',
          formEnabled: formEnabled,
          isRequired: true,
        ),
      ],
    );
  }

  /// Builds a row for a single-document group
  /// (license or id_card).
  Widget _buildSingleDocRow({
    required BuildContext context,
    required List<Map<String, dynamic>> groups,
    required FormFieldState<List<Map<String, dynamic>>> field,
    required String fieldKey,
    required String uploadTitle,
    required String uploadSubtitle,
    required IconData uploadIcon,
    required String typeLabel,
    required bool formEnabled,
    bool isRequired = false,
  }) {
    final group = _findGroup(groups, fieldKey);
    final docs = _docsFromGroup(group);
    final firstDoc = docs.isNotEmpty ? docs.first : null;

    if (firstDoc == null) {
      return _DocumentUploadTile(
        icon: uploadIcon,
        title: _isUploading ? 'Uploading...' : uploadTitle,
        subtitle: uploadSubtitle,
        isRequired: isRequired,
        onUpload: !formEnabled || _isUploading
            ? null
            : () => _pickAndUpload((fileName, url) {
                final updated = _upsertSingleDoc(
                  _currentGroups(field),
                  fieldKey: fieldKey,
                  name: fileName,
                  url: url,
                );
                field.didChange(updated);
              }),
      );
    }

    final url = firstDoc['url']?.toString() ?? '';
    final name = firstDoc['name']?.toString() ?? fieldKey;

    return _UploadedDocumentTile(
      fileName: _fileNameFromUrl(url, name),
      typeLabel: typeLabel,
      isRequired: isRequired,
      onView: url.isNotEmpty ? () => _viewDocument(url) : null,
      onReplace: formEnabled
          ? () => _pickAndUpload((fileName, newUrl) {
              final updated = _upsertSingleDoc(
                _currentGroups(field),
                fieldKey: fieldKey,
                name: fileName,
                url: newUrl,
              );
              field.didChange(updated);
            })
          : null,
      onRemove: formEnabled
          ? () {
              final updated = _removeGroup(_currentGroups(field), fieldKey);
              field.didChange(updated);
            }
          : null,
    );
  }

  // ── Other documents (subform) ───────────────

  /// Builds the "Other Documents" section with a
  /// subform for adding/removing documents within
  /// the `other_documents` group.
  Widget _buildOtherDocumentsSection(
    BuildContext context,
    List<Map<String, dynamic>> groups,
    FormFieldState<List<Map<String, dynamic>>> field,
    bool formEnabled,
  ) {
    final otherGroup = _findGroup(groups, DocFieldKey.others);
    final otherDocs = _docsFromGroup(otherGroup);
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'OTHER DOCUMENTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        AppDimens.verticalMediumSmall,

        // Existing other documents list
        ...List.generate(otherDocs.length, (index) {
          final doc = otherDocs[index];
          final url = doc['url']?.toString() ?? '';
          final name = doc['name']?.toString() ?? '';

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _UploadedDocumentTile(
              fileName: _fileNameFromUrl(url, name),
              typeLabel: name,
              onView: url.isNotEmpty ? () => _viewDocument(url) : null,
              onReplace: formEnabled
                  ? () => _pickAndUpload((fileName, newUrl) {
                      final updated = _replaceInOtherDocs(
                        _currentGroups(field),
                        index,
                        name: fileName,
                        url: newUrl,
                      );
                      field.didChange(updated);
                    })
                  : null,
              onRemove: formEnabled
                  ? () {
                      final updated = _removeFromOtherDocs(
                        _currentGroups(field),
                        index,
                      );
                      field.didChange(updated);
                    }
                  : null,
            ),
          );
        }),

        // Upload zone
        _buildUploadZone(context, colorScheme, field, formEnabled),
      ],
    );
  }

  /// Cloud-upload zone for adding new documents
  /// to the `other_documents` group.
  Widget _buildUploadZone(
    BuildContext context,
    ColorScheme colorScheme,
    FormFieldState<List<Map<String, dynamic>>> field,
    bool formEnabled,
  ) {
    return InkWell(
      onTap: !formEnabled || _isUploading
          ? null
          : () => _pickAndUpload((fileName, url) {
              final updated = _addToOtherDocs(
                _currentGroups(field),
                name: fileName,
                url: url,
              );
              field.didChange(updated);
            }),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
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
                    color: colorScheme.shadow.withAlpha(10),
                    blurRadius: 2,
                  ),
                ],
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: _isUploading
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      Icons.cloud_upload,
                      color: colorScheme.primary,
                      size: 24,
                    ),
            ),
            AppDimens.verticalMediumSmall,
            Text(
              _isUploading ? 'Uploading...' : 'Click to upload',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            AppDimens.verticalExtraSmall,
            Text(
              'Upload any relevant '
              'certificates, records, '
              'or files.\n'
              'Supported: PDF, JPG, PNG'
              ' • Max 10MB.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────

  /// Extracts a display-friendly file name
  /// from a URL, falling back to [fallback].
  String _fileNameFromUrl(String url, String fallback) {
    if (url.isEmpty) return fallback;
    var name = url.split('/').last;
    if (name.contains('?')) {
      name = name.split('?').first;
    }
    return name.isNotEmpty ? name : fallback;
  }
}

// ══════════════════════════════════════════════
// Private extracted widgets
// ══════════════════════════════════════════════

/// A row showing an "upload" placeholder for a
/// document that hasn't been uploaded yet.
class _DocumentUploadTile extends StatelessWidget {
  const _DocumentUploadTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onUpload,
    this.isRequired = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onUpload;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          _iconBox(cs, icon),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isRequired)
                      Text(' *', style: TextStyle(color: Colors.red)),
                  ],
                ),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
          AppDimens.horizontalMedium,
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
}

/// A row showing an already-uploaded document
/// with View / Replace / Remove actions.
class _UploadedDocumentTile extends StatelessWidget {
  const _UploadedDocumentTile({
    required this.fileName,
    required this.typeLabel,
    this.isRequired = false,
    this.onView,
    this.onReplace,
    this.onRemove,
  });

  final String fileName;
  final String typeLabel;
  final bool isRequired;
  final VoidCallback? onView;
  final VoidCallback? onReplace;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.primary),
      ),
      child: Row(
        children: [
          _iconBox(cs, _fileIcon(fileName)),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        fileName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isRequired)
                      Text(
                        ' *',
                        style: TextStyle(
                          color: cs.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
                _typeBadge(context, cs),
              ],
            ),
          ),
          AppDimens.horizontalMedium,
          _actions(context, cs),
        ],
      ),
    );
  }

  Widget _typeBadge(BuildContext context, ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: cs.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        typeLabel,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: cs.onPrimary,
        ),
      ),
    );
  }

  Widget _actions(BuildContext context, ColorScheme cs) {
    return Row(
      children: [
        if (onView != null) ...[
          AppButton(
            onPressed: onView,
            buttonType: ButtonType.text,
            child: Text(
              'View',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.primary,
              ),
            ),
          ),
          AppDimens.horizontalSmall,
        ],
        if (onReplace != null) ...[
          AppButton(
            onPressed: onReplace,
            buttonType: ButtonType.outline,
            customStyle: OutlinedButton.styleFrom(
              foregroundColor: cs.onSurfaceVariant,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              side: BorderSide(color: cs.outlineVariant),
            ),
            child: Text(
              'Replace',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: cs.onSurfaceVariant,
              ),
            ),
          ),
          AppDimens.horizontalMedium,
        ],
        if (onRemove != null)
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.delete, size: 20, color: cs.onSurfaceVariant),
            ),
          ),
      ],
    );
  }

  IconData _fileIcon(String name) {
    if (!name.contains('.')) {
      return Icons.insert_drive_file;
    }
    final ext = name.split('.').last.toLowerCase();
    return switch (ext) {
      'pdf' => Icons.picture_as_pdf,
      'jpg' || 'jpeg' || 'png' => Icons.image,
      'doc' || 'docx' => Icons.description,
      _ => Icons.insert_drive_file,
    };
  }
}

// ── Shared icon box ────────────────────────────

Widget _iconBox(ColorScheme cs, IconData icon) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: cs.surface,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: cs.outlineVariant),
    ),
    child: Icon(icon, color: cs.onSurfaceVariant, size: 20),
  );
}
