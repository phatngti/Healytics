import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Document Verification section widget.
///
/// Displays a grid of document cards showing verification status:
/// - Action required cards with upload button
/// - Verified document rows with green checkmarks
class DocumentVerificationSection extends StatelessWidget {
  /// Creates a new [DocumentVerificationSection].
  const DocumentVerificationSection({
    required this.documents,
    required this.onUploadDocument,
    super.key,
  });

  /// The document verification info.
  final DocumentVerificationInfo? documents;

  /// Callback when document upload is requested.
  final void Function(VerificationDocument doc)? onUploadDocument;

  @override
  Widget build(BuildContext context) {
    if (documents == null) {
      return const Center(child: Text('No documents available'));
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        if (isWide) {
          return _buildGridLayout(context);
        }
        return _buildColumnLayout(context);
      },
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    return Column(
      children: [
        // First row: Business License + Authorization Letter
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Business License
            if (documents!.businessLicense != null)
              Expanded(
                child: documents!.businessLicense!.requiresUpdate
                    ? _DocumentActionCard(
                        document: documents!.businessLicense!,
                        onUpload: () =>
                            onUploadDocument?.call(documents!.businessLicense!),
                      )
                    : _VerifiedDocumentRow(
                        document: documents!.businessLicense!,
                        icon: Icons.description_outlined,
                      ),
              ),
            const SizedBox(width: 16),
            // Authorization Letter
            if (documents!.authorizationLetter != null)
              Expanded(
                child: documents!.authorizationLetter!.requiresUpdate
                    ? _DocumentActionCard(
                        document: documents!.authorizationLetter!,
                        onUpload: () => onUploadDocument?.call(
                          documents!.authorizationLetter!,
                        ),
                      )
                    : _VerifiedDocumentRow(
                        document: documents!.authorizationLetter!,
                        icon: Icons.badge_outlined,
                      ),
              ),
          ],
        ),
        AppDimens.verticalMedium,
        // Second row: Tax Registration + Other Documents
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (documents!.taxCertificate != null)
              Expanded(
                child: documents!.taxCertificate!.requiresUpdate
                    ? _DocumentActionCard(
                        document: documents!.taxCertificate!,
                        onUpload: () =>
                            onUploadDocument?.call(documents!.taxCertificate!),
                      )
                    : _VerifiedDocumentRow(
                        document: documents!.taxCertificate!,
                        icon: Icons.account_balance_outlined,
                      ),
              ),
            const SizedBox(width: 16),
            Expanded(
              child: _OtherDocumentsRow(documents: documents!.otherDocuments),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildColumnLayout(BuildContext context) {
    return Column(
      children: [
        // Business License
        if (documents!.businessLicense != null)
          documents!.businessLicense!.requiresUpdate
              ? _DocumentActionCard(
                  document: documents!.businessLicense!,
                  onUpload: () =>
                      onUploadDocument?.call(documents!.businessLicense!),
                )
              : _VerifiedDocumentRow(
                  document: documents!.businessLicense!,
                  icon: Icons.description_outlined,
                ),
        AppDimens.verticalMedium,
        // Authorization Letter
        if (documents!.authorizationLetter != null)
          documents!.authorizationLetter!.requiresUpdate
              ? _DocumentActionCard(
                  document: documents!.authorizationLetter!,
                  onUpload: () =>
                      onUploadDocument?.call(documents!.authorizationLetter!),
                )
              : _VerifiedDocumentRow(
                  document: documents!.authorizationLetter!,
                  icon: Icons.badge_outlined,
                ),
        AppDimens.verticalMediumSmall,
        // Tax Certificate
        if (documents!.taxCertificate != null)
          documents!.taxCertificate!.requiresUpdate
              ? _DocumentActionCard(
                  document: documents!.taxCertificate!,
                  onUpload: () =>
                      onUploadDocument?.call(documents!.taxCertificate!),
                )
              : _VerifiedDocumentRow(
                  document: documents!.taxCertificate!,
                  icon: Icons.account_balance_outlined,
                ),
        AppDimens.verticalMediumSmall,
        _OtherDocumentsRow(documents: documents!.otherDocuments),
      ],
    );
  }
}

/// Action required document card with upload button.
class _DocumentActionCard extends StatelessWidget {
  const _DocumentActionCard({required this.document, required this.onUpload});

  final VerificationDocument document;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final requiresAction = document.requiresUpdate;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: requiresAction
            ? colorScheme.error.withValues(alpha: 0.05)
            : colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: requiresAction
              ? colorScheme.error
              : colorScheme.outlineVariant,
          width: requiresAction ? 2 : 1,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          // Alert icon
          if (requiresAction)
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.priority_high,
                  size: 16,
                  color: colorScheme.error,
                ),
              ),
            ),
          // Document icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: requiresAction
                  ? colorScheme.error.withValues(alpha: 0.1)
                  : colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.description_outlined,
              size: 24,
              color: requiresAction
                  ? colorScheme.error
                  : colorScheme.onPrimaryContainer,
            ),
          ),
          AppDimens.verticalMediumSmall,
          // Label
          Text(
            document.label,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: requiresAction ? colorScheme.error : colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          AppDimens.verticalSmall,
          // Feedback message
          if (document.adminFeedback != null &&
              document.adminFeedback!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                document.adminFeedback!,
                style: textTheme.bodySmall?.copyWith(
                  color: requiresAction
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          AppDimens.verticalMedium,
          // Upload button
          FilledButton.icon(
            onPressed: onUpload,
            style: FilledButton.styleFrom(
              backgroundColor: requiresAction
                  ? colorScheme.error
                  : colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: const Icon(Icons.upload_rounded, size: 18),
            label: const Text('Upload Scan'),
          ),
        ],
      ),
    );
  }
}

/// Row showing a verified document with icon and checkmark.
/// Supports action-required state when document needs update.
class _VerifiedDocumentRow extends StatelessWidget {
  const _VerifiedDocumentRow({required this.document, required this.icon});

  final VerificationDocument document;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;
    final isVerified = document.status == DocumentStatus.approved;
    final requiresUpdate = document.requiresUpdate;
    final hasAdminFeedback =
        document.adminFeedback != null && document.adminFeedback!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: requiresUpdate
            ? colorScheme.error.withValues(alpha: 0.05)
            : colorScheme.surfaceContainerLow,
        border: Border.all(
          color: requiresUpdate
              ? colorScheme.error
              : colorScheme.outlineVariant,
          width: requiresUpdate ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon container
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: requiresUpdate
                      ? colorScheme.error.withValues(alpha: 0.1)
                      : colorScheme.surface,
                  border: Border.all(
                    color: requiresUpdate
                        ? colorScheme.error.withValues(alpha: 0.3)
                        : colorScheme.outlineVariant,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: requiresUpdate
                      ? colorScheme.error
                      : colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              AppDimens.horizontalMediumSmall,
              // Label and date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.label,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: requiresUpdate
                            ? colorScheme.error
                            : colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Updated ${document.fileName ?? 'recently'}',
                      style: textTheme.bodySmall?.copyWith(
                        color: requiresUpdate
                            ? colorScheme.error.withValues(alpha: 0.7)
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Status icon
              if (isVerified)
                Icon(Icons.check_circle, color: successColor, size: 24)
              else
                Icon(Icons.pending, color: colorScheme.outline, size: 24),
            ],
          ),
          // Admin feedback section
          if (hasAdminFeedback) ...[
            AppDimens.verticalSmall,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: colorScheme.error),
                  AppDimens.horizontalSmall,
                  Expanded(
                    child: Text(
                      document.adminFeedback!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Row showing "Other Documents" with count.
class _OtherDocumentsRow extends StatelessWidget {
  const _OtherDocumentsRow({required this.documents});

  final List<VerificationDocument> documents;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;
    final allVerified = documents.every(
      (d) => d.status == DocumentStatus.approved,
    );

    return Opacity(
      opacity: allVerified ? 0.75 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          border: Border.all(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.folder_open_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            // Label and count
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Other Documents',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${documents.length} files attached',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            // Status icon
            if (allVerified)
              Icon(Icons.check_circle, color: successColor, size: 24)
            else
              Icon(Icons.pending, color: colorScheme.outline, size: 24),
          ],
        ),
      ),
    );
  }
}
