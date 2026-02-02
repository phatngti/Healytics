import 'package:admin_panel/constants/document_types.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/document_cards.widget.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

// Re-export DocumentUploadResult for external use
export 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/document_cards.widget.dart'
    show DocumentUploadResult;

/// Section for displaying document verification status and upload actions.
///
/// Shows required documents with their verification status:
/// - Documents needing upload are highlighted with animated upload cards
/// - Verified documents show a compact success indicator
class DocumentVerificationSection extends StatefulWidget {
  /// Creates a new [DocumentVerificationSection].
  const DocumentVerificationSection({
    required this.documents,
    this.onUploadComplete,
    super.key,
  });

  /// The KYC documents as VerifiedField list.
  final List<VerifiedField>? documents;

  /// Callback when a document upload completes successfully.
  final void Function(DocumentUploadResult result)? onUploadComplete;

  @override
  State<DocumentVerificationSection> createState() =>
      _DocumentVerificationSectionState();
}

class _DocumentVerificationSectionState
    extends State<DocumentVerificationSection> {
  /// Identity document keys that are shown in Legal Representative section.
  static final _identityDocKeys = {
    DocumentTypes.idCardFront.documentKey,
    DocumentTypes.idCardBack.documentKey,
  };

  /// Tracks uploaded file URLs by document key for EDITED status and preview.
  final Map<String, String> _uploadedUrls = {};

  void _handleUploadComplete(DocumentUploadResult result) {
    setState(() {
      _uploadedUrls[result.documentKey] = result.url;
    });
    widget.onUploadComplete?.call(result);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (widget.documents == null || widget.documents!.isEmpty) {
      return const Center(child: Text('No documents to verify'));
    }

    // Filter out identity documents (shown in Legal Representative section)
    final filteredDocuments = widget.documents!
        .where((doc) => !_identityDocKeys.contains(doc.fieldKey))
        .toList();

    if (filteredDocuments.isEmpty) {
      return const Center(child: Text('No documents to verify'));
    }

    // Separate documents into needs action vs verified
    final documentsNeedingAction = filteredDocuments
        .where((doc) => !doc.isVerified)
        .toList();
    final verifiedDocuments = filteredDocuments
        .where((doc) => doc.isVerified)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Documents Needing Action Section
        if (documentsNeedingAction.isNotEmpty) ...[
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: colorScheme.error,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Documents Requiring Action',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.error,
                ),
              ),
              const SizedBox(width: 8),
              VerificationActionRequiredBadge(color: colorScheme.error),
            ],
          ),
          AppDimens.verticalMedium,
          _buildActionDocumentsGrid(context, documentsNeedingAction),
        ],

        // Verified Documents Section
        if (verifiedDocuments.isNotEmpty) ...[
          if (documentsNeedingAction.isNotEmpty) ...[
            AppDimens.verticalLarge,
            Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            AppDimens.verticalLarge,
          ],
          Row(
            children: [
              Icon(
                Icons.check_circle_outline,
                color:
                    Theme.of(context).extension<SemanticColors>()?.success ??
                    Colors.green,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Verified Documents',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          AppDimens.verticalMedium,
          _buildVerifiedDocumentsList(context, verifiedDocuments),
        ],
      ],
    );
  }

  Widget _buildActionDocumentsGrid(
    BuildContext context,
    List<VerifiedField> documents,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        final cardWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: documents.map((document) {
            final uploadedUrl = _uploadedUrls[document.fieldKey];
            final hasBeenEdited = uploadedUrl != null;

            return SizedBox(
              width: cardWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: isWide ? 2.0 : 2.5,
                    child: DocumentUploadCard(
                      document: document,
                      onUploadComplete: _handleUploadComplete,
                      uploadedPreviewUrl: uploadedUrl,
                      showEditedBadge: hasBeenEdited,
                      height: double.infinity,
                    ),
                  ),
                  if (document.feedback != null &&
                      document.feedback!.isNotEmpty)
                    FeedbackMessage(feedback: document.feedback!),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildVerifiedDocumentsList(
    BuildContext context,
    List<VerifiedField> documents,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        children: documents.asMap().entries.map((entry) {
          final index = entry.key;
          final document = entry.value;
          return Column(
            children: [
              _VerifiedDocumentRow(
                document: document,
                icon: _getDocumentIcon(document.fieldKey),
              ),
              if (index < documents.length - 1)
                Divider(
                  height: 1,
                  indent: 56,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  IconData _getDocumentIcon(String fieldKey) {
    switch (fieldKey) {
      case 'business_license':
        return Icons.description_outlined;
      case 'authorization_letter':
        return Icons.assignment_ind_outlined;
      case 'tax_certificate':
        return Icons.receipt_long_outlined;
      case 'id_front_image':
      case 'id_back_image':
        return Icons.badge_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }
}

/// Row showing a verified document with its info.
class _VerifiedDocumentRow extends StatelessWidget {
  const _VerifiedDocumentRow({required this.document, required this.icon});

  final VerifiedField document;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;
    final label = getDocumentLabel(document.fieldKey);

    return Opacity(
      opacity: 0.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Document icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
            ),
            const SizedBox(width: 16),
            // Document info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    'Verified',
                    style: textTheme.bodySmall?.copyWith(
                      color: successColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (document.feedback != null &&
                      document.feedback!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      document.feedback!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            // Check icon
            Icon(Icons.check_circle, size: 20, color: successColor),
          ],
        ),
      ),
    );
  }
}
