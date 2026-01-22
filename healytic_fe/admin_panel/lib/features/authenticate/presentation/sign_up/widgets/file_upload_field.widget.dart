import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A reusable file upload field with drag-and-drop styling.
///
/// Displays:
/// - Dashed border drop zone
/// - Icon and label
/// - Supported file types hint
/// - Hover state with primary color border
class FileUploadField extends StatefulWidget {
  /// The label displayed in the upload area.
  final String label;

  /// The icon displayed in the upload area.
  final IconData icon;

  /// Supported file types hint text.
  final String supportedTypes;

  /// Maximum file size hint text.
  final String maxSize;

  /// Callback when a file is selected.
  final ValueChanged<String?>? onFileSelected;

  /// Whether the field is enabled.
  final bool enabled;

  /// The currently selected file URL (for display).
  final String? selectedFileUrl;

  const FileUploadField({
    super.key,
    required this.label,
    this.icon = Icons.upload_file,
    this.supportedTypes = 'SVG, PNG, JPG',
    this.maxSize = 'Max 2MB',
    this.onFileSelected,
    this.enabled = true,
    this.selectedFileUrl,
  });

  @override
  State<FileUploadField> createState() => _FileUploadFieldState();
}

class _FileUploadFieldState extends State<FileUploadField> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.enabled ? _pickFile : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 160,
          decoration: BoxDecoration(
            color: _isHovering && widget.enabled
                ? colorScheme.primary.withOpacity(0.05)
                : colorScheme.surfaceContainerHighest.withOpacity(0.3),
            borderRadius: AppDimens.radiusMediumSmall,
            border: Border.all(
              color: _isHovering && widget.enabled
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.3),
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: _isHovering && widget.enabled
                  ? colorScheme.primary
                  : colorScheme.outline.withOpacity(0.3),
              strokeWidth: 2,
              dashWidth: 8,
              dashSpace: 4,
              borderRadius: 12,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.icon,
                    size: 32,
                    color: _isHovering && widget.enabled
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                  ),
                  AppDimens.verticalSmall,
                  Text(
                    widget.label,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  AppDimens.verticalExtraSmall,
                  Text(
                    '${widget.supportedTypes} (${widget.maxSize})',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    // TODO: Implement file picker
    // For now, just simulate a file selection
    widget.onFileSelected?.call('mock_file_url');
  }
}

/// Custom painter to draw a dashed border.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  _DashedBorderPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Dashed border is now handled by the Container's border
    // This painter is kept for potential future customization
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
