import 'package:admin_panel/features/admin/partner_manager/domain/partner_verification_detail.entity.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// KYC Documents section showing uploaded verification documents
class KycDocumentsSection extends StatelessWidget {
  const KycDocumentsSection({required this.documents, super.key});

  final List<KycDocument> documents;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final idCards = documents.where(
      (d) =>
          d.type == KycDocumentType.idCardFront ||
          d.type == KycDocumentType.idCardBack,
    );
    final otherDocs = documents.where(
      (d) => d.type == KycDocumentType.authorizationLetter,
    );

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
          _buildSectionHeader(context, colorScheme, textTheme),
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
                  Row(
                    children: idCards.map((doc) {
                      return Expanded(child: _buildIdCardPreview(context, doc));
                    }).toList(),
                  ),
                ],

                // Authorization Letter
                if (otherDocs.isNotEmpty) ...[
                  AppDimens.verticalLarge,
                  _buildLabel(context, 'Authorization Letter'),
                  AppDimens.verticalMediumSmall,
                  ...otherDocs.map((doc) => _buildDocumentItem(context, doc)),
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
              '${documents.length} Files',
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: _IdCardPreviewTile(colorScheme: colorScheme, icon: icon),
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
  const _IdCardPreviewTile({required this.colorScheme, required this.icon});

  final ColorScheme colorScheme;
  final IconData icon;

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
        height: 64,
        decoration: BoxDecoration(
          color: widget.colorScheme.surfaceContainerHighest,
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: _isHovered
                ? widget.colorScheme.primary
                : widget.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  widget.icon,
                  key: ValueKey(_isHovered),
                  color: _isHovered
                      ? widget.colorScheme.primary
                      : widget.colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ),
            if (_isHovered)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.4),
                    borderRadius: AppDimens.radiusSmall,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.visibility,
                      color: Colors.white,
                      size: 24,
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
