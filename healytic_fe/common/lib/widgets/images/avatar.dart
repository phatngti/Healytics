import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A circular avatar widget that displays a network image or falls back
/// to the user's initials with a deterministic background color.
///
/// When [imageUrl] is provided and loads successfully, the network image
/// is displayed. While loading or on error, initials derived from [name]
/// are shown instead, providing a graceful fallback.
///
/// ```dart
/// AvatarImage(
///   name: 'John Doe',
///   imageUrl: 'https://example.com/avatar.jpg',
///   radius: 24,
/// )
/// ```
class AvatarImage extends StatelessWidget {
  /// Creates an [AvatarImage].
  ///
  /// - [name] — Full name used to derive initials (e.g. "John Doe" → "JD").
  /// - [imageUrl] — Optional network URL for the avatar image.
  /// - [radius] — Half the diameter of the avatar circle (defaults to 20).
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

  /// The user's full name, used to generate initials as fallback.
  final String name;

  /// Builds the initials widget used as placeholder or error fallback.
  Widget _buildInitials(BuildContext context) {
    return Container(
      color: _getBackgroundColor(name),
      alignment: Alignment.center,

      child: Text(
        _getInitials(name),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.8, // Scale text based on radius
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.onSurface,
      child: ClipOval(
        child: (imageUrl != null && imageUrl!.isNotEmpty)
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                // While loading, show the initials (better UX than a spinner)
                placeholder: (context, url) => _buildInitials(context),
                // If error, show the initials
                errorWidget: (context, url, error) => _buildInitials(context),
              )
            : _buildInitials(context),
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

  List<String> nameParts = name.trim().split(RegExp(r'\s+'));

  if (nameParts.length > 1) {
    // First letter of first name + First letter of last name
    return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
  } else {
    // Just first letter of the single name
    return nameParts.first[0].toUpperCase();
  }
}

/// Returns a deterministic background [Color] based on the hash of [name].
///
/// This ensures the same name always gets the same color across sessions.
Color _getBackgroundColor(String name) {
  final colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];
  // Hash the name to pick a consistent color from the list
  return colors[name.hashCode.abs() % colors.length];
}
