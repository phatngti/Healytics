import 'dart:developer' as developer;
import 'dart:ui' as ui;

import 'package:admin_panel/constants/document_types.dart';
import 'package:admin_panel/constants/file_type.dart';
import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/features/partner/verification_status/domain/verification_status.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/url_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Result of a successful document upload.
class DocumentUploadResult {
  const DocumentUploadResult({
    required this.documentKey,
    required this.url,
    required this.fileName,
  });

  final String documentKey;
  final String url;
  final String fileName;

  @override
  String toString() {
    return 'DocumentUploadResult(documentKey: $documentKey, url: $url, fileName: $fileName)';
  }
}

/// Gets a human-readable label for a document field key.
String getDocumentLabel(String fieldKey) {
  final document = DocumentTypes.findByKey(fieldKey);
  if (document != null) {
    return document.label;
  }
  // Fallback for unknown keys
  return fieldKey
      .replaceAll('_', ' ')
      .split(' ')
      .map(
        (word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '',
      )
      .join(' ');
}

/// Gets the file URL from the document value.
String? getFileUrl(VerifiedField document) {
  final value = document.value;
  if (value is String && value.isNotEmpty) return value;
  if (value is Map) {
    return value['fileUrl']?.toString() ?? value['url']?.toString();
  }
  return null;
}

/// FormBuilder field for document uploads with animated glow effect.
///
/// Features:
/// - Registers automatically with parent FormBuilder
/// - Animated glow effect for attention
/// - File picking and S3 upload logic
/// - Shows "EDITED" badge after successful upload
/// - Shows uploaded file preview immediately after upload
class DocumentUploadCard extends FormBuilderField<DocumentUploadResult> {
  DocumentUploadCard({
    required this.document,
    this.uploadedPreviewUrl,
    this.showEditedBadge = false,
    this.height = 192,
    this.onUploadComplete,
    super.key,
  }) : super(
         name: document.fieldKey,
         builder: (FormFieldState<DocumentUploadResult> field) {
           final state = field as _DocumentUploadCardState;
           return _DocumentUploadCardContent(
             state: state,
             document: document,
             uploadedPreviewUrl: uploadedPreviewUrl,
             showEditedBadge: showEditedBadge,
             height: height,
             onUploadComplete: onUploadComplete,
           );
         },
       );

  /// The document field data.
  final VerifiedField document;

  /// Optional URL to show as preview (e.g., after upload success).
  final String? uploadedPreviewUrl;

  /// Whether to show the "EDITED" badge.
  final bool showEditedBadge;

  /// Card height.
  final double height;

  /// Callback when upload completes successfully.
  final ValueChanged<DocumentUploadResult>? onUploadComplete;

  @override
  FormBuilderFieldState<DocumentUploadCard, DocumentUploadResult>
  createState() => _DocumentUploadCardState();
}

class _DocumentUploadCardState
    extends FormBuilderFieldState<DocumentUploadCard, DocumentUploadResult> {}

/// Internal content widget for DocumentUploadCard that handles animations
/// and upload logic.
class _DocumentUploadCardContent extends ConsumerStatefulWidget {
  const _DocumentUploadCardContent({
    required this.state,
    required this.document,
    this.uploadedPreviewUrl,
    this.showEditedBadge = false,
    this.height = 192,
    this.onUploadComplete,
  });

  final _DocumentUploadCardState state;
  final VerifiedField document;
  final String? uploadedPreviewUrl;
  final bool showEditedBadge;
  final double height;
  final ValueChanged<DocumentUploadResult>? onUploadComplete;

  @override
  ConsumerState<_DocumentUploadCardContent> createState() =>
      _DocumentUploadCardContentState();
}

class _DocumentUploadCardContentState
    extends ConsumerState<_DocumentUploadCardContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowAnimation;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _glowAnimation = Tween<double>(begin: 0.15, end: 0.4).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadFile() async {
    if (_isUploading) return;

    try {
      // Pick file using file_picker
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) {
        return;
      }

      final pickedFile = result.files.single;

      // Validate file size (max 10MB)
      if (pickedFile.size > 10 * 1024 * 1024) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('File size exceeds 10MB limit'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      setState(() => _isUploading = true);

      // Validate that bytes are available
      if (pickedFile.bytes == null) {
        throw Exception('File bytes not available');
      }

      // Use XFile.fromData for web compatibility
      final xFile = XFile.fromData(
        pickedFile.bytes!,
        name: pickedFile.name,
        mimeType: FileTypeUtils.getMimeType(pickedFile.name),
      );

      // Upload to S3
      final s3Service = ref.read(s3ServiceProvider);
      final key = await s3Service.uploadFile(xFile);

      if (key == null) {
        throw Exception('Upload returned null key');
      }

      if (mounted) {
        setState(() => _isUploading = false);

        final uploadResult = DocumentUploadResult(
          documentKey: widget.document.fieldKey,
          url: formatR2Url(key) ?? key,
          fileName: pickedFile.name,
        );

        // Update FormBuilder field state via the parent state
        widget.state.didChange(uploadResult);

        // Also notify via callback if provided
        widget.onUploadComplete?.call(uploadResult);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${pickedFile.name} uploaded successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      developer.log(
        'Error picking/uploading file: $e',
        name: 'DocumentUploadCard',
      );
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload file: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final label = getDocumentLabel(widget.document.fieldKey);
    // Use form state value URL, uploaded preview URL, or document's URL
    final formValue = widget.state.value;
    final fileUrl =
        formValue?.url ??
        widget.uploadedPreviewUrl ??
        getFileUrl(widget.document);
    final showEdited =
        widget.showEditedBadge ||
        widget.uploadedPreviewUrl != null ||
        formValue != null;

    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        // Use primary color for edited state, error color otherwise
        final accentColor = showEdited
            ? colorScheme.primary
            : colorScheme.error;

        return Container(
          height: widget.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: accentColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: _glowAnimation.value),
                blurRadius: 12,
                spreadRadius: -3,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _isUploading ? null : _pickAndUploadFile,
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Current file preview (blurred) - only for images
                  if (fileUrl != null)
                    Positioned.fill(
                      child: ImageFiltered(
                        imageFilter: ui.ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Image.network(
                          fileUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        ),
                      ),
                    ),
                  // Overlay
                  if (fileUrl != null)
                    Positioned.fill(
                      child: Container(
                        color: accentColor.withValues(alpha: 0.3),
                      ),
                    ),
                  // Dashed border
                  Positioned.fill(
                    child: CustomPaint(
                      painter: DashedBorderPainter(
                        color: accentColor,
                        strokeWidth: 2,
                        dashWidth: 6,
                        dashSpace: 4,
                        borderRadius: 12,
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Upload icon or loading indicator
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: fileUrl != null
                                ? Colors.white.withValues(alpha: 0.9)
                                : accentColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: _isUploading
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: accentColor,
                                  ),
                                )
                              : Icon(
                                  Icons.cloud_upload_outlined,
                                  color: accentColor,
                                  size: 24,
                                ),
                        ),
                        const SizedBox(width: 16),
                        // Text content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                label,
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: fileUrl != null
                                      ? Colors.white
                                      : accentColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isUploading
                                    ? 'Uploading...'
                                    : showEdited
                                    ? 'Click to change'
                                    : 'Click to upload',
                                style: textTheme.bodySmall?.copyWith(
                                  color: fileUrl != null
                                      ? Colors.white.withValues(alpha: 0.9)
                                      : accentColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Arrow
                        if (!_isUploading)
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: fileUrl != null ? Colors.white : accentColor,
                          ),
                      ],
                    ),
                  ),
                  // Badge (EDITED or UPLOAD)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isUploading
                            ? 'UPLOADING...'
                            : showEdited
                            ? 'EDITED'
                            : 'UPLOAD',
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                          color: showEdited
                              ? colorScheme.onPrimary
                              : colorScheme.onError,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Card displaying a completed/verified document.
///
/// Features:
/// - Image preview with zoom/pan on tap
/// - Green checkmark overlay
/// - Optional "EDITED" badge when file has been replaced
class CompletedDocumentCard extends StatelessWidget {
  const CompletedDocumentCard({
    required this.document,
    this.previewUrlOverride,
    this.showEditedBadge = false,
    this.height = 192,
    super.key,
  });

  /// The document field data.
  final VerifiedField document;

  /// Optional URL override for showing newly uploaded file.
  final String? previewUrlOverride;

  /// Whether to show the "EDITED" badge.
  final bool showEditedBadge;

  /// Card height.
  final double height;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>();
    final successColor = semanticColors?.success ?? Colors.green;
    final label = getDocumentLabel(document.fieldKey);
    final showEdited = showEditedBadge || previewUrlOverride != null;

    return Stack(
      children: [
        Container(
          height: height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: showEdited
                ? colorScheme.primary.withValues(alpha: 0.05)
                : colorScheme.surfaceContainerLow.withValues(alpha: 0.5),
            border: Border.all(
              color: showEdited
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.5),
              width: showEdited ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DocumentPlaceholder(
            label: label,
            successColor: successColor,
            icon: Icons.description_rounded,
          ),
        ),
        // Badge overlay (checkmark or EDITED)
        Positioned(
          top: 12,
          right: 12,
          child: showEdited
              ? Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'EDITED',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: colorScheme.onPrimary,
                    ),
                  ),
                )
              : Container(
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

/// Image preview widget with hover effects and tap-to-preview functionality.
class DocumentImagePreview extends StatefulWidget {
  const DocumentImagePreview({
    required this.imageUrl,
    required this.label,
    required this.successColor,
    this.showEditedBadge = false,
    super.key,
  });

  final String imageUrl;
  final String label;
  final Color successColor;
  final bool showEditedBadge;

  @override
  State<DocumentImagePreview> createState() => _DocumentImagePreviewState();
}

class _DocumentImagePreviewState extends State<DocumentImagePreview> {
  bool _isHovered = false;

  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Backdrop
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(color: Colors.black.withValues(alpha: 0.8)),
              ),
            ),
            // Image with zoom/pan
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.height * 0.9,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
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
                  widget.imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.broken_image_outlined,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 12),
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => _showImagePreview(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Document image
            Image.network(
              widget.imageUrl,
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
            // Hover overlay
            if (_isHovered)
              Container(color: colorScheme.primary.withValues(alpha: 0.1)),
            // Zoom button (always visible, scales on hover)
            Positioned(
              left: 12,
              top: 12,
              child: AnimatedScale(
                scale: _isHovered ? 1.1 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(8),
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
                    color: colorScheme.primary,
                    size: 18,
                  ),
                ),
              ),
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
                        widget.label,
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
                        color: widget.successColor.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.showEditedBadge
                                ? Icons.edit
                                : Icons.check_circle,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.showEditedBadge ? 'Edited' : 'Verified',
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
        ),
      ),
    );
  }
}

/// Placeholder widget when no image is available.
class DocumentPlaceholder extends StatelessWidget {
  const DocumentPlaceholder({
    required this.label,
    required this.successColor,
    this.icon,
    super.key,
  });

  final String label;
  final Color successColor;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Opacity(
        opacity: 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Document icon
            Icon(
              icon ?? Icons.assignment_ind_rounded,
              size: 40,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            // Label
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            // Verified badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, size: 14, color: successColor),
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
    );
  }
}

/// Custom painter for dashed borders.
class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
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

/// Reusable feedback message widget for displaying admin feedback.
class FeedbackMessage extends StatelessWidget {
  const FeedbackMessage({required this.feedback, super.key});

  final String feedback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: colorScheme.error.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border(left: BorderSide(color: colorScheme.error, width: 3)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote,
              size: 16,
              color: colorScheme.error.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                feedback,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
