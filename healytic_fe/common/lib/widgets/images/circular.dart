import 'package:flutter/material.dart';

/// A circular image widget with optional border and shadow.
///
/// Clips any [ImageProvider] (network, asset, file, etc.) into a circle
/// with configurable [size], [borderWidth], and a subtle shadow.
///
/// ```dart
/// CircularImage(
///   image: NetworkImage('https://example.com/photo.jpg'),
///   size: 80,
///   borderWidth: 2,
/// )
/// ```
class CircularImage extends StatelessWidget {
  /// The image to display, e.g. [NetworkImage], [AssetImage], [FileImage].
  final ImageProvider image;

  /// Diameter of the circular image in logical pixels (defaults to 60).
  final double size;

  /// Width of the border around the circle. Set to 0 for no border (default).
  final double borderWidth;

  /// Creates a [CircularImage].
  const CircularImage({
    super.key,
    required this.image,
    this.size = 60.0,
    this.borderWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        // 1. Make it a circle
        shape: BoxShape.circle,

        // 2. Add the Border
        border: borderWidth > 0
            ? Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: borderWidth,
              )
            : null,

        // 3. The Image (automatically clipped to the shape)
        image: DecorationImage(
          image: image,
          fit: BoxFit.cover, // Ensures image fills circle without distortion
        ),

        // 4. Optional: Add Shadow
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSurface,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
