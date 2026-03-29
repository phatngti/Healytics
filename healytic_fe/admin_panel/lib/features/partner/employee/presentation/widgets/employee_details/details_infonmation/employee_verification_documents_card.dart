import 'package:admin_panel/features/partner/employee/domain/verification_document_entry.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Read-only card displaying verification documents
/// grouped by field key (license, id_card, etc.).
class EmployeeVerificationDocumentsCard
    extends StatelessWidget {
  /// Grouped verification document entries.
  final List<VerificationDocumentEntry> documents;

  const EmployeeVerificationDocumentsCard({
    super.key,
    required this.documents,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors =
        Theme.of(context).extension<SemanticColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            colorScheme: colorScheme,
            textTheme: textTheme,
            semanticColors: semanticColors,
          ),
          if (documents.isEmpty)
            _EmptyState()
          else
            Padding(
              padding: AppDimens.paddingAllLarge,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  for (int i = 0;
                      i < documents.length;
                      i++) ...[
                    _DocumentGroup(
                      entry: documents[i],
                    ),
                    if (i < documents.length - 1)
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        child: Divider(
                          height: 1,
                          color:
                              colorScheme.outlineVariant,
                        ),
                      ),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader({
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required SemanticColors semanticColors,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.surfaceContainerHighest
                .withAlpha(100),
            colorScheme.surface,
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.verified_user,
            color: semanticColors.info,
          ),
          AppDimens.horizontalSmall,
          Text(
            'Verification Documents',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Renders a single document group (e.g. "License").
class _DocumentGroup extends StatelessWidget {
  final VerificationDocumentEntry entry;

  const _DocumentGroup({required this.entry});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _iconForKey(entry.fieldKey),
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            AppDimens.horizontalSmall,
            Text(
              _labelForKey(entry.fieldKey),
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        AppDimens.verticalMedium,
        if (entry.documents.isEmpty)
          Text(
            'No documents uploaded',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          )
        else
          ...entry.documents.map(
            (doc) => _DocumentTile(document: doc),
          ),
      ],
    );
  }

  /// Maps a field key to a human-readable label.
  String _labelForKey(String key) {
    return switch (key) {
      'license' => 'PROFESSIONAL LICENSE',
      'id_card' => 'IDENTITY CARD / PASSPORT',
      'other_documents' => 'OTHER DOCUMENTS',
      _ => key.replaceAll('_', ' ').toUpperCase(),
    };
  }

  /// Maps a field key to an appropriate icon.
  IconData _iconForKey(String key) {
    return switch (key) {
      'license' => Icons.badge_outlined,
      'id_card' => Icons.perm_identity,
      'other_documents' =>
        Icons.folder_copy_outlined,
      _ => Icons.description_outlined,
    };
  }
}

/// A single document row with name and view action.
class _DocumentTile extends StatelessWidget {
  final DocumentEntry document;

  const _DocumentTile({required this.document});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: AppDimens.paddingAllMedium,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest
              .withAlpha(80),
          borderRadius: AppDimens.radiusMedium,
          border: Border.all(
            color: colorScheme.outlineVariant,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppDimens.radiusSmall,
                border: Border.all(
                  color: colorScheme.outlineVariant,
                ),
              ),
              child: Icon(
                _fileIcon(document.name),
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            AppDimens.horizontalMedium,
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style:
                        textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (document.updatedTime != null)
                    Text(
                      'Updated: ${document.updatedTime}',
                      style:
                          textTheme.bodySmall?.copyWith(
                        color:
                            colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            AppDimens.horizontalSmall,
            TextButton.icon(
              onPressed: () =>
                  _openDocument(context, document.url),
              icon: Icon(
                Icons.open_in_new,
                size: 16,
                color: colorScheme.primary,
              ),
              label: Text(
                'View',
                style: textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Opens the document URL in the browser.
  Future<void> _openDocument(
    BuildContext context,
    String url,
  ) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not open document: $url',
            ),
          ),
        );
      }
    }
  }

  /// Returns an icon based on the file extension.
  IconData _fileIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.pdf')) {
      return Icons.picture_as_pdf;
    }
    if (lower.endsWith('.png') ||
        lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg')) {
      return Icons.image;
    }
    return Icons.insert_drive_file;
  }
}

/// Shown when there are no verification documents.
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: AppDimens.paddingAllLarge,
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.folder_off_outlined,
              size: 36,
              color: colorScheme.onSurfaceVariant,
            ),
            AppDimens.verticalSmall,
            Text(
              'No verification documents',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
