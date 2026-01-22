import 'dart:ui' as ui;
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for the Legal Representative verification step.
///
/// Displays disabled inputs for name/ID and interactive upload cards
/// for ID verification documents.
class LegalRepresentativeForm extends StatelessWidget {
  /// Creates a new [LegalRepresentativeForm].
  const LegalRepresentativeForm({
    required this.section,
    required this.legalRepresentative,
    required this.onUploadDocument,
    super.key,
  });

  /// The section entity for displaying step number and status.
  final VerificationSectionEntity section;

  /// The legal representative data.
  final LegalRepresentativeEntity? legalRepresentative;

  /// Callback when a document upload is requested.
  final void Function(VerificationDocument doc) onUploadDocument;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with step number
        Row(
          children: [
            // Step badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${section.stepNumber ?? 3}',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              section.label,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        AppDimens.verticalMedium,
        // Form card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disabled inputs row
              if (legalRepresentative != null) ...[
                _buildDisabledInputs(context),
                AppDimens.verticalLarge,
              ],
              // Identity verification section
              _buildIdentityVerification(context),
              // Authorization letter section
              if (legalRepresentative?.authorizationLetter != null) ...[
                const Divider(height: 48),
                _buildAuthorizationLetter(context),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDisabledInputs(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 500;
          final children = [
            _DisabledTextField(
              label: 'Full Name',
              value: legalRepresentative?.fullName ?? '',
            ),
            if (isWide) const SizedBox(width: 24),
            if (!isWide) AppDimens.verticalMedium,
            _DisabledTextField(
              label: 'Gov. ID Number',
              value: legalRepresentative?.govIdNumber ?? '',
            ),
          ];

          if (isWide) {
            return Row(
              children: [
                Expanded(child: children[0]),
                children[1],
                Expanded(child: children[2]),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          );
        },
      ),
    );
  }

  Widget _buildIdentityVerification(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final idFront = legalRepresentative?.idFront;
    final idBack = legalRepresentative?.idBack;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with update badge
        Row(
          children: [
            Text(
              'Identity Verification',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            if (idFront?.requiresUpdate == true) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'UPDATE NEEDED',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ],
        ),
        AppDimens.verticalExtraLarge,
        // Document upload cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            final children = [
              if (idFront != null)
                _IdentityUploadCard(
                  document: idFront,
                  onUpload: () => onUploadDocument(idFront),
                ),
              if (isWide) const SizedBox(width: 16),
              if (!isWide) AppDimens.verticalMedium,
              if (idBack != null) _CompletedDocumentCard(document: idBack),
            ];

            if (isWide) {
              return Row(
                children: [
                  if (idFront != null) Expanded(child: children[0]),
                  children[1],
                  if (idBack != null) Expanded(child: children[2]),
                ],
              );
            }
            return Column(children: children);
          },
        ),
      ],
    );
  }

  Widget _buildAuthorizationLetter(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();

    return Opacity(
      opacity: 0.5,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Authorization Letter',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'No changes required for this document.',
                  style: textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.verified, color: semanticColors?.success ?? Colors.green),
        ],
      ),
    );
  }
}

/// Disabled text field showing readonly data.
class _DisabledTextField extends StatelessWidget {
  const _DisabledTextField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            border: Border.all(color: colorScheme.outlineVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// Upload card for documents requiring update with animated glow effect.
class _IdentityUploadCard extends StatefulWidget {
  const _IdentityUploadCard({required this.document, required this.onUpload});

  final VerificationDocument document;
  final VoidCallback onUpload;

  @override
  State<_IdentityUploadCard> createState() => _IdentityUploadCardState();
}

class _IdentityUploadCardState extends State<_IdentityUploadCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 176,
            decoration: BoxDecoration(
              color: _isHovering
                  ? successColor.withValues(alpha: 0.1)
                  : successColor.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: widget.onUpload,
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                painter: _DashedBorderPainter(
                  color: successColor,
                  strokeWidth: 2,
                  dashWidth: 6,
                  dashSpace: 4,
                  borderRadius: 12,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: successColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_rounded,
                          size: 32,
                          color: successColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Upload ${widget.document.label}',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: successColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to browse files',
                        style: textTheme.bodySmall?.copyWith(
                          color: successColor.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Upload New badge - positioned on top edge
          Positioned(
            top: -12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: successColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: successColor.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  'UPLOAD NEW',
                  style: textTheme.labelSmall?.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Card showing a completed/approved document.
class _CompletedDocumentCard extends StatelessWidget {
  const _CompletedDocumentCard({required this.document});

  final VerificationDocument document;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    return Container(
      height: 176,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: successColor, width: 2),
              ),
              child: Icon(Icons.check, size: 24, color: successColor),
            ),
            const SizedBox(height: 12),
            Text(
              document.label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.image_outlined,
                    size: 16,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      document.fileName ?? 'document.jpg',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2,
    this.dashWidth = 6,
    this.dashSpace = 4,
    this.borderRadius = 0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    double distance = 0.0;
    for (final ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
