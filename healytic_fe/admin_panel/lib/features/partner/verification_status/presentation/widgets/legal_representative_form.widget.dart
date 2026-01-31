import 'dart:ui' as ui;

import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/features/partner/verification_status/presentation/widgets/common/verification_form_fields.widget.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Form section for the Legal Representative verification step.
///
/// Displays:
/// - Personal info fields (disabled/read-only)
/// - Identity verification upload cards with animated glow for required uploads
/// - Verified document cards with green checkmarks
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
  final LegalRepresentativeInfo? legalRepresentative;

  /// Callback when a document upload is requested.
  final void Function(VerificationDocument doc) onUploadDocument;

  @override
  Widget build(BuildContext context) {
    if (legalRepresentative == null) {
      return const Center(
        child: Text('No legal representative information available'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Personal info fields (with reduced opacity as they're read-only)
        _buildPersonalInfoGrid(context),
        AppDimens.verticalLarge,
        // Identity verification section
        _buildIdentityVerification(context),
      ],
    );
  }

  Widget _buildPersonalInfoGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        // Helper to create a VerificationStringField for optional fields
        VerificationStringField positionField() {
          final position = legalRepresentative!.position;
          return VerificationStringField(
            value: position?.value ?? '',
            displayValue: position?.displayValue ?? 'N/A',
            requiresUpdate: position?.requiresUpdate ?? false,
            adminFeedback: position?.adminFeedback,
          );
        }

        VerificationStringField phoneField() {
          final phone = legalRepresentative!.phoneNumber;
          return VerificationStringField(
            value: phone?.value ?? '',
            displayValue: phone?.displayValue ?? 'N/A',
            requiresUpdate: phone?.requiresUpdate ?? false,
            adminFeedback: phone?.adminFeedback,
          );
        }

        if (isWide) {
          return Column(
            children: [
              // Row 1: Full Name & Position
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VerificationTextField(
                      label: 'Full Name',
                      field: legalRepresentative!.fullName,
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  Expanded(
                    child: VerificationTextField(
                      label: 'Position',
                      field: positionField(),
                    ),
                  ),
                ],
              ),
              AppDimens.verticalMedium,
              // Row 2: Phone Number & ID Type
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VerificationTextField(
                      label: 'Phone Number',
                      field: phoneField(),
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  Expanded(
                    child: VerificationTextField(
                      label: 'ID Type',
                      field: legalRepresentative!.idType,
                    ),
                  ),
                ],
              ),
              AppDimens.verticalMedium,
              // Row 3: ID Number & Date of Issue
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: VerificationTextField(
                      label: 'ID Number',
                      field: legalRepresentative!.idNumber,
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  Expanded(
                    child: VerificationTextField(
                      label: 'Date of Issue',
                      field: legalRepresentative!.idIssueDate,
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        // Mobile: Single column
        return Column(
          children: [
            VerificationTextField(
              label: 'Full Name',
              field: legalRepresentative!.fullName,
            ),
            AppDimens.verticalMedium,
            VerificationTextField(label: 'Position', field: positionField()),
            AppDimens.verticalMedium,
            VerificationTextField(label: 'Phone Number', field: phoneField()),
            AppDimens.verticalMedium,
            VerificationTextField(
              label: 'ID Type',
              field: legalRepresentative!.idType,
            ),
            AppDimens.verticalMedium,
            VerificationTextField(
              label: 'ID Number',
              field: legalRepresentative!.idNumber,
            ),
            AppDimens.verticalMedium,
            VerificationTextField(
              label: 'Date of Issue',
              field: legalRepresentative!.idIssueDate,
            ),
          ],
        );
      },
    );
  }

  Widget _buildIdentityVerification(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final idFront = legalRepresentative?.idFrontImage;
    final idBack = legalRepresentative?.idBackImage;
    final frontRequiresUpdate = idFront?.requiresUpdate ?? false;
    final backRequiresUpdate = idBack?.requiresUpdate ?? false;
    final anyRequiresUpdate = frontRequiresUpdate || backRequiresUpdate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header with action badge
        Row(
          children: [
            Text(
              'Identity Verification',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 8),
            if (anyRequiresUpdate)
              VerificationActionRequiredBadge(color: colorScheme.error),
          ],
        ),
        AppDimens.verticalMedium,
        // Document upload cards
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;

            if (isWide) {
              return Row(
                children: [
                  // ID Front: show upload card if requiresUpdate, else completed card
                  if (idFront != null)
                    Expanded(
                      child: frontRequiresUpdate
                          ? _IdentityUploadCard(
                              document: idFront,
                              onUpload: () => onUploadDocument(idFront),
                            )
                          : _CompletedDocumentCard(document: idFront),
                    ),
                  const SizedBox(width: 16),
                  // ID Back: show upload card if requiresUpdate, else completed card
                  if (idBack != null)
                    Expanded(
                      child: backRequiresUpdate
                          ? _IdentityUploadCard(
                              document: idBack,
                              onUpload: () => onUploadDocument(idBack),
                            )
                          : _CompletedDocumentCard(document: idBack),
                    ),
                ],
              );
            }

            return Column(
              children: [
                // ID Front: show upload card if requiresUpdate, else completed card
                if (idFront != null)
                  frontRequiresUpdate
                      ? _IdentityUploadCard(
                          document: idFront,
                          onUpload: () => onUploadDocument(idFront),
                        )
                      : _CompletedDocumentCard(document: idFront),
                AppDimens.verticalMedium,
                // ID Back: show upload card if requiresUpdate, else completed card
                if (idBack != null)
                  backRequiresUpdate
                      ? _IdentityUploadCard(
                          document: idBack,
                          onUpload: () => onUploadDocument(idBack),
                        )
                      : _CompletedDocumentCard(document: idBack),
              ],
            );
          },
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

class _IdentityUploadCardState extends State<_IdentityUploadCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.2, end: 0.5).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Only animate glow if update is required
    if (widget.document.requiresUpdate) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final requiresUpdate = widget.document.requiresUpdate;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedBuilder(
          animation: _glowAnimation,
          builder: (context, child) {
            final hasImage = widget.document.fileUrl != null;

            return Container(
              height: 192,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: requiresUpdate
                    ? colorScheme.error.withValues(alpha: 0.05)
                    : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(12),
                boxShadow: requiresUpdate
                    ? [
                        BoxShadow(
                          color: colorScheme.error.withValues(
                            alpha: _glowAnimation.value,
                          ),
                          blurRadius: 15,
                          spreadRadius: -2,
                        ),
                      ]
                    : null,
              ),
              child: InkWell(
                onTap: widget.onUpload,
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background image preview (blurred)
                    if (hasImage)
                      ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                        child: Image.network(
                          widget.document.fileUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const SizedBox.shrink(),
                        ),
                      ),
                    // Dark overlay for image
                    if (hasImage)
                      Container(color: Colors.black.withValues(alpha: 0.4)),
                    // Dashed border and upload content
                    CustomPaint(
                      painter: _DashedBorderPainter(
                        color: requiresUpdate
                            ? colorScheme.error
                            : colorScheme.outline,
                        strokeWidth: 2,
                        dashWidth: 6,
                        dashSpace: 4,
                        borderRadius: 12,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Upload icon container
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: hasImage
                                    ? Colors.white.withValues(alpha: 0.9)
                                    : requiresUpdate
                                    ? colorScheme.error.withValues(alpha: 0.1)
                                    : colorScheme.primaryContainer,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add_a_photo_rounded,
                                size: 24,
                                color: requiresUpdate
                                    ? colorScheme.error
                                    : hasImage
                                    ? colorScheme.primary
                                    : colorScheme.onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Label
                            Text(
                              widget.document.label,
                              style: textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: hasImage
                                    ? Colors.white
                                    : requiresUpdate
                                    ? colorScheme.error
                                    : colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Helper text
                            Text(
                              'Click to upload new file',
                              style: textTheme.bodySmall?.copyWith(
                                color: hasImage
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : requiresUpdate
                                    ? colorScheme.error.withValues(alpha: 0.7)
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        // Upload New badge
        if (requiresUpdate)
          Positioned(
            top: -12,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.error,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.error.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload_rounded, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'UPLOAD NEW',
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Card showing a completed/verified document.
class _CompletedDocumentCard extends StatelessWidget {
  const _CompletedDocumentCard({required this.document});

  final VerificationDocument document;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;

    final hasImage = document.fileUrl != null;

    return Stack(
      children: [
        Container(
          height: 192,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: hasImage
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    // Document image
                    Image.network(
                      document.fileUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          size: 40,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                          ),
                        );
                      },
                    ),
                    // Gradient overlay for label visibility
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                document.label,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: successColor.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified',
                                    style: textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Opacity(
                    opacity: 0.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Document icon
                        Icon(
                          Icons.assignment_ind_rounded,
                          size: 40,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        // Label
                        Text(
                          document.label,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Verified badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            border: Border.all(
                              color: colorScheme.outlineVariant,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 14,
                                color: successColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Verified',
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        // Green checkmark overlay
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: successColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: successColor.withValues(alpha: 0.3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: const Icon(Icons.check, size: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

/// Custom painter for dashed borders.
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
