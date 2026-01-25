import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/features/admin/partner_manager/presentation/widgets/review/reviewable_field.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

/// KYC Documents section showing uploaded verification documents
class KycDocumentsSection extends ConsumerWidget {
  const KycDocumentsSection({this.documents, super.key});

  final List<KycDocument>? documents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final docs = documents ?? [];
    print("docs: $docs");

    final idCards = docs
        .where(
          (d) =>
              d.type == KycDocumentType.idCardFront ||
              d.type == KycDocumentType.idCardBack,
        )
        .toList();
    final otherDocs = docs
        .where((d) => d.type == KycDocumentType.authorizationLetter)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          _buildSectionHeader(context, colorScheme, textTheme, docs),
          const Divider(height: 1),

          // Content
          Padding(
            padding: AppDimens.paddingAllMediumLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID Cards
                if (idCards.isNotEmpty) ...[
                  _buildLabel(context, 'Identity Card (Front/Back)'),
                  AppDimens.verticalMediumSmall,
                  ...idCards.map((doc) {
                    final fieldId = 'kyc.${doc.type.name}';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ReviewableField(
                        fieldId: fieldId,
                        compactMode: true,
                        child: _buildIdCardPreview(context, doc),
                      ),
                    );
                  }),
                ],

                // Authorization Letter
                if (otherDocs.isNotEmpty) ...[
                  AppDimens.verticalLarge,
                  _buildLabel(context, 'Authorization Letter'),
                  AppDimens.verticalMediumSmall,
                  ...otherDocs.map((doc) {
                    final fieldId = 'kyc.${doc.type.name}';
                    return ReviewableField(
                      fieldId: fieldId,
                      child: _buildDocumentItem(context, doc),
                    );
                  }),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
    List<KycDocument> docs,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'KYC DOCUMENTS',
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: AppDimens.radiusPill,
            ),
            child: Text(
              '${docs.length} Files',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String label) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildIdCardPreview(BuildContext context, KycDocument doc) {
    final colorScheme = Theme.of(context).colorScheme;

    final icon = doc.type == KycDocumentType.idCardFront
        ? Icons.badge_outlined
        : Icons.credit_card;

    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            if (doc.fileUrl != null) {
              _showImagePreview(context, doc.fileUrl!);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: _IdCardPreviewTile(
              colorScheme: colorScheme,
              icon: icon,
              docId: doc.id,
              imageUrl: doc.fileUrl,
            ),
          ),
        ),
      ),
    );
  }

  void _showImagePreview(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Backdrop with blur
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.black.withValues(alpha: 0.8)),
              ),
            ),

            // Image
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: AppDimens.radiusMedium,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: AppDimens.paddingAllLarge,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: Colors.red,
                          ),
                          AppDimens.verticalMediumSmall,
                          Text(
                            'Failed to load image',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: Colors.red),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            // Close button
            Positioned(
              top: 24,
              right: 24,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black.withValues(alpha: 0.5),
                  padding: const EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(BuildContext context, KycDocument doc) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final formattedDate = doc.uploadedAt != null
        ? DateFormat('MMM dd').format(doc.uploadedAt!)
        : '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: AppDimens.paddingAllMediumSmall,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: AppDimens.radiusExtraSmall,
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: Colors.red,
                size: 20,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doc.fileName,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${doc.fileSize ?? ''} • Uploaded $formattedDate',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.download, size: 20, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

/// Stateful hover tile for ID card preview
class _IdCardPreviewTile extends StatefulWidget {
  const _IdCardPreviewTile({
    required this.colorScheme,
    required this.icon,
    required this.docId,
    this.imageUrl,
  });

  final ColorScheme colorScheme;
  final IconData icon;
  final String docId;
  final String? imageUrl;

  @override
  State<_IdCardPreviewTile> createState() => _IdCardPreviewTileState();
}

class _IdCardPreviewTileState extends State<_IdCardPreviewTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        width: 180,
        decoration: BoxDecoration(
          color: widget.colorScheme.surfaceContainerHighest,
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: _isHovered
                ? widget.colorScheme.primary
                : widget.colorScheme.outline.withValues(alpha: 0.2),
            width: _isHovered ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image or fallback icon
            if (widget.imageUrl != null)
              Image.network(
                widget.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      widget.icon,
                      color: widget.colorScheme.onSurfaceVariant,
                      size: 32,
                    ),
                  );
                },
              )
            else
              Center(
                child: Icon(
                  widget.icon,
                  color: widget.colorScheme.onSurfaceVariant,
                  size: 32,
                ),
              ),

            // Hover overlay with zoom icon
            if (_isHovered)
              AnimatedOpacity(
                opacity: _isHovered ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: AppDimens.radiusPill,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.zoom_in,
                            color: widget.colorScheme.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'View',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: widget.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
