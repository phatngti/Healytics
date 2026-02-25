import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:common/utils/demensions.dart';
import 'package:common/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

/// A multi-image picker and upload widget with thumbnail previews.
///
/// Allows users to select multiple images from their device. Each image
/// is displayed as a removable thumbnail. When an [onUpload] callback is
/// provided, images are uploaded asynchronously and replaced with their
/// resulting URL strings. A progress indicator is shown during upload.
///
/// Supports displaying images from URLs (including SVG), local file paths,
/// XFile objects, and handles web/mobile platform differences.
///
/// ```dart
/// ImageUploadWidget(
///   initialImages: ['https://example.com/photo1.jpg'],
///   onImagesChanged: (images) => setState(() => _images = images),
///   onUpload: (xFile) async {
///     return await myApiService.uploadImage(xFile);
///   },
/// )
/// ```
class ImageUploadWidget extends StatefulWidget {
  /// Creates an [ImageUploadWidget].
  ///
  /// - [onImagesChanged] — Called whenever the image list changes (add/remove).
  /// - [initialImages] — Pre-populated list of image URLs.
  /// - [onUpload] — Async callback to upload an [XFile]; returns the URL string.
  const ImageUploadWidget({
    super.key,
    required this.onImagesChanged,
    this.initialImages = const [],
    this.onUpload,
  });

  /// Callback invoked whenever images are added or removed.
  /// The list contains a mix of URL strings and [XFile] objects (during upload).
  final Function(List<dynamic>) onImagesChanged;

  /// Pre-populated image URLs to display on first render.
  final List<String> initialImages;

  /// Optional async upload handler. When provided, picked images are uploaded
  /// and their [XFile] entries are replaced with the returned URL strings.
  final Future<String> Function(XFile)? onUpload;

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  List<dynamic> _images = [];
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _images = List.from(widget.initialImages);
  }

  @override
  void didUpdateWidget(ImageUploadWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update from initialImages when NOT uploading
    // During upload, we manage state internally and don't want to lose XFile objects
    if (!_isUploading && widget.initialImages != oldWidget.initialImages) {
      setState(() {
        _images = List.from(widget.initialImages);
      });
    }
  }

  Future<void> _pickImages() async {
    final picker = ImagePicker();

    try {
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        if (widget.onUpload != null) {
          setState(() {
            _isUploading = true;
            _images.addAll(images);
          });

          for (final image in images) {
            try {
              final url = await widget.onUpload!(image);
              if (mounted) {
                setState(() {
                  final index = _images.indexOf(image);
                  if (index != -1) {
                    _images[index] = url;
                  }
                });
              }
            } catch (e) {
              debugPrint('Error uploading image: $e');
            }
          }

          if (mounted) {
            setState(() {
              _isUploading = false;
            });
            widget.onImagesChanged(_images);
          }
        } else {
          setState(() {
            _images.addAll(images);
          });
          widget.onImagesChanged(_images);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading images: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged(_images);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isUploading) ...[
          const LinearProgressIndicator(),
          AppDimens.verticalMedium,
        ],
        Text(
          'Product Images',
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppDimens.verticalMedium,
        Container(
          width: double.infinity,
          padding: AppDimens.paddingAllMedium,
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: .3),
            borderRadius: AppDimens.radiusSmall,
            border: Border.all(
              color: Theme.of(context).colorScheme.surfaceDim,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Uploaded Files (${_images.length})',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (_images.isNotEmpty) ...[
                AppDimens.verticalMedium,
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: _images.asMap().entries.map((entry) {
                    final index = entry.key;
                    final image = entry.value;
                    return _ImageThumbnail(
                      image: image,
                      onRemove: () => _removeImage(index),
                    );
                  }).toList(),
                ),
              ],
              AppDimens.verticalMedium,
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isUploading ? null : _pickImages,
                  icon: Icon(
                    Icons.add_photo_alternate_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  label: Text(
                    _isUploading ? 'Uploading...' : 'Add Images',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// An individual image thumbnail with a remove button overlay.
///
/// Handles displaying images from three sources:
/// - [XFile] objects (read as bytes from disk)
/// - Network URL strings (HTTP/HTTPS, including SVG detection)
/// - Local file path strings (platform-aware: web vs mobile)
///
/// Shows a loading spinner while the image is being read, and a
/// broken-image icon on errors.
class _ImageThumbnail extends StatefulWidget {
  /// Creates an [_ImageThumbnail].
  ///
  /// - [image] — Either an [XFile] or a URL/path [String].
  /// - [onRemove] — Callback when the user taps the remove (X) button.
  const _ImageThumbnail({required this.image, required this.onRemove});

  /// The image data — can be an [XFile] during upload or a [String] URL after.
  final dynamic image;

  /// Called when the user taps the remove button.
  final VoidCallback onRemove;

  @override
  State<_ImageThumbnail> createState() => _ImageThumbnailState();
}

class _ImageThumbnailState extends State<_ImageThumbnail> {
  Uint8List? _imageBytes;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(_ImageThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      if (widget.image is XFile) {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
        _loadImage();
      } else {
        setState(() {
          _isLoading = false;
          _hasError = false;
        });
      }
    }
  }

  Future<void> _loadImage() async {
    if (widget.image is XFile) {
      try {
        final bytes = await (widget.image as XFile).readAsBytes();
        if (mounted) {
          setState(() {
            _imageBytes = bytes;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _hasError = true;
            _isLoading = false;
          });
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final thumbSize = responsive<double>(context, mobile: 100, web: 120);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: thumbSize,
          height: thumbSize,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Theme.of(context).colorScheme.surfaceDim),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildImage(context),
          ),
        ),
        Positioned(
          top: -8,
          right: -8,
          child: GestureDetector(
            onTap: widget.onRemove,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surfaceDim,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                size: 16,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Checks if the URL points to an SVG file by examining the file extension
  bool _isSvgUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path.toLowerCase();
      return path.endsWith('.svg');
    } catch (e) {
      return false;
    }
  }

  Widget _buildImage(BuildContext context) {
    // Handle loading state
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    // Handle error state
    if (_hasError) {
      return Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 40,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }

    // Handle XFile with loaded bytes
    if (widget.image is XFile && _imageBytes != null) {
      return Image.memory(
        _imageBytes!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Center(
            child: Icon(
              Icons.broken_image_outlined,
              size: 40,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          );
        },
      );
    }

    // Handle String paths
    if (widget.image is String) {
      final String imagePath = widget.image as String;
      if (imagePath.startsWith('http') ||
          imagePath.startsWith('https') ||
          imagePath.startsWith('blob:')) {
        // Check if the URL points to an SVG file
        final isSvg = _isSvgUrl(imagePath);
        if (isSvg) {
          return SvgPicture.network(
            imagePath,
            fit: BoxFit.cover,
            placeholderBuilder: (context) => Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }
        return Image.network(
          imagePath,
          fit: BoxFit.cover,
          cacheWidth: 240, // Cache at 2x thumbnail size for retina displays
          cacheHeight: 240,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).colorScheme.primary,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Image load error for $imagePath: $error');
            return Center(
              child: Icon(
                Icons.image_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            );
          },
        );
      } else {
        if (kIsWeb) {
          return Image.network(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              debugPrint('Image load error (web) for $imagePath: $error');
              return Center(
                child: Icon(
                  Icons.broken_image_outlined,
                  size: 40,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              );
            },
          );
        }
        return Image.file(
          File(imagePath),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            debugPrint('Image load error for $imagePath: $error');
            return Center(
              child: Icon(
                Icons.broken_image_outlined,
                size: 40,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            );
          },
        );
      }
    }

    return const SizedBox();
  }
}
