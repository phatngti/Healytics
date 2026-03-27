import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

/// Card widget for managing facility/clinic images.
///
/// Each row picks an image from the device gallery, uploads it
/// to S3, and displays the resulting URL in a read-only field.
class ProductFacilityImagesCard extends StatelessWidget {
  const ProductFacilityImagesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormBuilderField<List<Map<String, String>>>(
      name: 'facility_images',
      builder: (field) {
        final images = field.value ?? <Map<String, String>>[];

        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, textTheme, colorScheme),
                AppDimens.verticalMedium,
                if (images.isEmpty)
                  _buildEmptyState(context, colorScheme, textTheme)
                else
                  _buildImageGrid(context, images, field),
                AppDimens.verticalSmall,
                _buildAddButton(context, colorScheme, field, images),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    TextTheme textTheme,
    ColorScheme colorScheme,
  ) {
    return Row(
      children: [
        Icon(Icons.business_outlined, color: colorScheme.primary, size: 20),
        AppDimens.horizontalSmall,
        Text(
          'Facility Images',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.add_photo_alternate_outlined,
            color: colorScheme.onSurfaceVariant,
            size: 32,
          ),
          AppDimens.verticalSmall,
          Text(
            'No facility images yet',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            'Add images of your clinic or facility',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a 2-column grid of facility image tiles.
  Widget _buildImageGrid(
    BuildContext context,
    List<Map<String, String>> images,
    FormFieldState<List<Map<String, String>>> field,
  ) {
    const gap = 12.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - gap) / 2;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: images.asMap().entries.map((entry) {
            return SizedBox(
              width: itemWidth,
              child: _FacilityImageRow(
                index: entry.key,
                data: entry.value,
                onUpdate: (updated) {
                  final list = List<Map<String, String>>.from(images);
                  list[entry.key] = updated;
                  field.didChange(list);
                },
                onRemove: () {
                  final list = List<Map<String, String>>.from(images);
                  list.removeAt(entry.key);
                  field.didChange(list);
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildAddButton(
    BuildContext context,
    ColorScheme colorScheme,
    FormFieldState<List<Map<String, String>>> field,
    List<Map<String, String>> images,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          final list = List<Map<String, String>>.from(images);
          list.add({'imageUrl': '', 'label': ''});
          field.didChange(list);
        },
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Add Facility Image'),
        style: OutlinedButton.styleFrom(
          padding: AppDimens.paddingVerticalSmall,
          side: BorderSide(color: colorScheme.primary),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _FacilityImageRow
// ---------------------------------------------------------------------------

/// A single row for a facility image entry.
///
/// Tap the upload area to pick an image from the device gallery.
/// Once uploaded, shows a preview with the resulting URL below.
class _FacilityImageRow extends ConsumerStatefulWidget {
  final int index;
  final Map<String, String> data;
  final ValueChanged<Map<String, String>> onUpdate;
  final VoidCallback onRemove;

  const _FacilityImageRow({
    required this.index,
    required this.data,
    required this.onUpdate,
    required this.onRemove,
  });

  @override
  ConsumerState<_FacilityImageRow> createState() => _FacilityImageRowState();
}

class _FacilityImageRowState extends ConsumerState<_FacilityImageRow> {
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _labelController = TextEditingController();

  XFile? _selectedFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _labelController.text = widget.data['label'] ?? '';
  }

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  // ── Device upload ────────────────────────────────────────────────

  Future<void> _pickAndUpload() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      if (file == null || !mounted) return;

      setState(() {
        _selectedFile = file;
        _isUploading = true;
      });

      final s3 = ref.read(s3ServiceProvider);
      final key = await s3.uploadFile(file);

      if (!mounted) return;

      if (key != null) {
        final url = await s3.getFileUrl(key);
        if (!mounted) return;

        setState(() => _isUploading = false);

        if (url != null) {
          widget.onUpdate({...widget.data, 'imageUrl': url});
        }
      } else {
        _showError('Upload failed – could not get storage key.');
      }
    } catch (e) {
      debugPrint('_FacilityImageRow._pickAndUpload error: $e');
      if (mounted) {
        _showError('Error uploading image: $e');
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────

  bool get _hasImage =>
      _selectedFile != null || (widget.data['imageUrl']?.isNotEmpty ?? false);

  String get _imageUrl => widget.data['imageUrl'] ?? '';

  ImageProvider? get _previewImage {
    if (_selectedFile != null) {
      return kIsWeb
          ? NetworkImage(_selectedFile!.path)
          : FileImage(File(_selectedFile!.path)) as ImageProvider;
    }
    if (_imageUrl.isNotEmpty) return NetworkImage(_imageUrl);
    return null;
  }

  // ── Build ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRowHeader(colorScheme, textTheme),
          const SizedBox(height: 6),
          _buildUploadArea(colorScheme, textTheme),
          if (_hasImage) ...[
            const SizedBox(height: 4),
            _buildReplaceHint(colorScheme, textTheme),
          ],
          const SizedBox(height: 6),
          _buildLabelField(textTheme),
        ],
      ),
    );
  }

  // ── Row header ───────────────────────────────────────────────────

  Widget _buildRowHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return Row(
      children: [
        Text(
          'Image ${widget.index + 1}',
          style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.close, size: 18, color: colorScheme.error),
          onPressed: widget.onRemove,
          constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
          padding: EdgeInsets.zero,
          tooltip: 'Remove image',
        ),
      ],
    );
  }

  // ── Label field ──────────────────────────────────────────────────

  Widget _buildLabelField(TextTheme textTheme) {
    return TextFormField(
      controller: _labelController,
      decoration: InputDecoration(
        labelText: 'Label',
        hintText: 'e.g. Treatment Room',
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: AppDimens.paddingAllSmall,
      ),
      style: textTheme.bodyMedium,
      onChanged: (value) => widget.onUpdate({...widget.data, 'label': value}),
    );
  }

  // ── Upload area ──────────────────────────────────────────────────

  Widget _buildUploadArea(ColorScheme colorScheme, TextTheme textTheme) {
    if (_isUploading) {
      return _buildUploadContainer(
        colorScheme: colorScheme,
        borderColor: colorScheme.primary,
        height: 120,
        child: _buildUploadingState(colorScheme, textTheme),
      );
    }

    if (_hasImage) {
      return GestureDetector(
        onTap: _showZoomDialog,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: _buildUploadContainer(
            colorScheme: colorScheme,
            height: 120,
            child: _buildPreview(colorScheme),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: _pickAndUpload,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: _buildUploadContainer(
          colorScheme: colorScheme,
          height: 100,
          child: _buildEmptyUpload(colorScheme, textTheme),
        ),
      ),
    );
  }

  Widget _buildUploadContainer({
    required ColorScheme colorScheme,
    required double height,
    required Widget child,
    Color? borderColor,
  }) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? colorScheme.outlineVariant),
      ),
      child: child,
    );
  }

  // ── Zoom dialog ─────────────────────────────────────────────────

  void _showZoomDialog() {
    final image = _previewImage;
    if (image == null) return;

    showDialog(
      context: context,
      builder: (_) => _ImageZoomDialog(imageProvider: image),
    );
  }

  Widget _buildUploadingState(ColorScheme colorScheme, TextTheme textTheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: colorScheme.primary,
            ),
          ),
          AppDimens.verticalSmall,
          Text(
            'Uploading…',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyUpload(ColorScheme colorScheme, TextTheme textTheme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.cloud_upload_outlined,
          size: 28,
          color: colorScheme.onSurfaceVariant,
        ),
        AppDimens.verticalSmall,
        Text(
          'Tap to pick from gallery',
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        AppDimens.verticalSmall,
        Text(
          'JPEG · PNG · WEBP  ·  max 10 MB',
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  // ── Preview ──────────────────────────────────────────────────────

  Widget _buildPreview(ColorScheme colorScheme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image(
        image: _previewImage!,
        width: double.infinity,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: colorScheme.errorContainer,
          child: Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: colorScheme.onErrorContainer,
            ),
          ),
        ),
      ),
    );
  }

  // ── Replace hint (bottom) ────────────────────────────────────────

  Widget _buildReplaceHint(ColorScheme colorScheme, TextTheme textTheme) {
    return GestureDetector(
      onTap: _isUploading ? null : _pickAndUpload,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_outlined, size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              'Tap to replace image',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// _ImageZoomDialog
// ---------------------------------------------------------------------------

/// Full-screen dialog that shows the image at actual size
/// with pan & zoom via [InteractiveViewer].
class _ImageZoomDialog extends StatelessWidget {
  final ImageProvider imageProvider;

  const _ImageZoomDialog({required this.imageProvider});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Zoomable image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image(
                  image: imageProvider,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 200,
                    height: 200,
                    color: colorScheme.errorContainer,
                    child: Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: colorScheme.onErrorContainer,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Close button — top-right of image
            Positioned(
              top: -8,
              right: -8,
              child: IconButton.filled(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: colorScheme.surface.withValues(alpha: 0.8),
                  foregroundColor: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
