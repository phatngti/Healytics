import 'package:admin_panel/constants/document_types.dart';
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

  /// Document keys for ID card images
  static const _idCardDocumentKeys = {'identity_front', 'identity_back'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final docs = documents ?? [];

    // Separate ID card documents from other documents
    final idCardDocuments = docs
        .where((d) => _idCardDocumentKeys.contains(d.documentKey))
        .toList();
    final otherDocuments = docs
        .where((d) => !_idCardDocumentKeys.contains(d.documentKey))
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
                // ══════════════════════════════════════════════════════════════
                // Section 1: Identity Card (Front/Back)
                // ══════════════════════════════════════════════════════════════
                if (idCardDocuments.isNotEmpty) ...[
                  AppDimens.verticalMediumSmall,
                  _buildIdCardGrid(context, idCardDocuments),
                ],

                // ══════════════════════════════════════════════════════════════
                // Section 2: Documents (All other documents)
                // ══════════════════════════════════════════════════════════════
                if (otherDocuments.isNotEmpty) ...[
                  if (idCardDocuments.isNotEmpty) AppDimens.verticalLarge,
                  ...otherDocuments.map(
                    (doc) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReviewableField(
                            title:
                                DocumentTypes.findByKey(
                                  doc.documentKey,
                                )?.label ??
                                doc.documentKey,
                            fieldId: 'kyc.${doc.documentKey}',
                            child: _buildDocumentItem(context, doc),
                          ),
                          AppDimens.verticalSmall,
                        ],
                      ),
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

  /// Builds a 2-column grid specifically for ID card (Front/Back) images
  Widget _buildIdCardGrid(BuildContext context, List<KycDocument> idCardDocs) {
    // Sort to ensure Front comes before Back
    final sortedDocs = List<KycDocument>.from(idCardDocs)
      ..sort((a, b) {
        if (a.documentKey == 'identity_front') return -1;
        if (b.documentKey == 'identity_front') return 1;
        return 0;
      });

    return Row(
      children: sortedDocs.map((doc) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: doc.documentKey == 'identity_front' ? 6 : 0,
              left: doc.documentKey == 'identity_back' ? 6 : 0,
            ),
            child: ReviewableField(
              title:
                  DocumentTypes.findByKey(doc.documentKey)?.label ??
                  doc.documentKey,
              fieldId: doc.documentKey,
              compactMode: true,
              child: _buildImagePreview(context, doc),
            ),
          ),
        );
      }).toList(),
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

  Widget _buildImagePreview(BuildContext context, KycDocument doc) {
    final colorScheme = Theme.of(context).colorScheme;

    // Derive icon based on document label/type
    IconData icon = Icons.image_outlined;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (doc.fileUrl != null) {
            _showImagePreview(context, doc.fileUrl!);
          }
        },
        child: _ImagePreviewTile(
          colorScheme: colorScheme,
          icon: icon,
          imageUrl: doc.fileUrl,
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

  /// Returns icon and color based on file extension
  ({IconData icon, Color color}) _getFileTypeInfo(String fileName) {
    final extension = fileName.split('.').lastOrNull?.toLowerCase() ?? '';

    return switch (extension) {
      'pdf' => (icon: Icons.picture_as_pdf, color: Colors.red),
      'doc' || 'docx' => (icon: Icons.article_outlined, color: Colors.blue),
      'xls' ||
      'xlsx' => (icon: Icons.table_chart_outlined, color: Colors.green),
      'txt' => (icon: Icons.text_snippet_outlined, color: Colors.grey),
      'zip' ||
      'rar' ||
      '7z' => (icon: Icons.folder_zip_outlined, color: Colors.amber),
      _ => (icon: Icons.insert_drive_file_outlined, color: Colors.blueGrey),
    };
  }

  Widget _buildDocumentItem(BuildContext context, KycDocument doc) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final fileTypeInfo = _getFileTypeInfo(doc.fileName);

    final formattedDate = doc.uploadedAt != null
        ? DateFormat('MMM dd').format(doc.uploadedAt!)
        : '';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        padding: AppDimens.paddingAllMedium,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerLow,
          borderRadius: AppDimens.radiusMediumSmall,
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            // Document icon (dynamic based on file type)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: fileTypeInfo.color.withValues(alpha: 0.1),
                borderRadius: AppDimens.radiusSmall,
              ),
              child: Icon(
                fileTypeInfo.icon,
                color: fileTypeInfo.color,
                size: 22,
              ),
            ),
            AppDimens.horizontalMedium,
            // Document info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Document label
                  Text(
                    DocumentTypes.findByKey(doc.documentKey)!.label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppDimens.verticalExtraSmall,
                  // File info (name, size, date)
                  Text(
                    [
                      if (formattedDate.isNotEmpty) 'Uploaded $formattedDate',
                      if (doc.fileSize != null) doc.fileSize,
                    ].join(' • '),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Download icon
            IconButton(
              icon: Icon(
                Icons.download,
                size: 20,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                // TODO: Implement download
              },
              tooltip: 'Download',
            ),
          ],
        ),
      ),
    );
  }
}

/// Stateful hover tile for image document preview
class _ImagePreviewTile extends StatefulWidget {
  const _ImagePreviewTile({
    required this.colorScheme,
    required this.icon,
    this.imageUrl,
  });

  final ColorScheme colorScheme;
  final IconData icon;
  final String? imageUrl;

  @override
  State<_ImagePreviewTile> createState() => _ImagePreviewTileState();
}

class _ImagePreviewTileState extends State<_ImagePreviewTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image preview
          AspectRatio(
            aspectRatio: 3 / 2, // Standard document aspect ratio
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
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

                  // Always-visible zoom button in bottom-right corner
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: AnimatedScale(
                      scale: _isHovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: widget.colorScheme.surface.withValues(
                            alpha: 0.9,
                          ),
                          borderRadius: AppDimens.radiusSmall,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.zoom_in,
                          color: widget.colorScheme.primary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  // Hover overlay effect
                  if (_isHovered)
                    AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.colorScheme.primary.withValues(
                            alpha: 0.1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
