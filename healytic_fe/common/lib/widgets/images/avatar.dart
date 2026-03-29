import 'package:flutter/material.dart';

import 'network_image_auto.dart';

/// A circular avatar widget that displays a network
/// image or falls back to the user's initials with
/// a deterministic background color.
///
/// Supports **SVG** and **raster** URLs automatically
/// via [NetworkImageAuto].
///
/// ```dart
/// AvatarImage(
///   name: 'John Doe',
///   imageUrl: 'https://example.com/avatar.svg',
///   radius: 24,
/// )
/// ```
class AvatarImage extends StatelessWidget {
  /// Creates an [AvatarImage].
  ///
  /// - [name] — Full name used to derive initials.
  /// - [imageUrl] — Optional network URL (SVG or
  ///   raster).
  /// - [radius] — Half the diameter (defaults 20).
  const AvatarImage({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 20,
  });

  /// Optional network URL for the avatar image.
  final String? imageUrl;

  /// Half the diameter of the circle avatar.
  final double radius;

  /// The user's full name, used to generate
  /// initials as fallback.
  final String name;

  /// Builds the initials fallback widget.
  Widget _buildInitials(BuildContext context) {
    return Container(
      color: _getBackgroundColor(name),
      alignment: Alignment.center,
      child: Text(
        _getInitials(name),
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasUrl =
        imageUrl != null && imageUrl!.isNotEmpty;

    return CircleAvatar(
      radius: radius,
      backgroundColor:
          Theme.of(context).colorScheme.onSurface,
      child: ClipOval(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: hasUrl
              ? NetworkImageAuto(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  width: radius * 2,
                  height: radius * 2,
                  placeholder: (_) =>
                      _buildInitials(context),
                  errorWidget: (_) =>
                      _buildInitials(context),
                )
              : _buildInitials(context),
        ),
      ),
    );
  }
}

/// Extracts initials from a full [name] string.
///
/// - "John Doe" → "JD"
/// - "Alice" → "A"
/// - "" → "?"
String _getInitials(String name) {
  if (name.isEmpty) return '?';

  final nameParts =
      name.trim().split(RegExp(r'\s+'));

  if (nameParts.length > 1) {
    return '${nameParts.first[0]}'
            '${nameParts.last[0]}'
        .toUpperCase();
  }
  return nameParts.first[0].toUpperCase();
}

/// Returns a deterministic background [Color]
/// based on the hash of [name].
Color _getBackgroundColor(String name) {
  const colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];
  return colors[name.hashCode.abs() % colors.length];
}
