import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 20,
  });

  final String? imageUrl;
  final double radius;
  final String name; // New parameter needed for initials

  // The widget that displays the initials
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

// Logic to extract "JD" from "John Doe"
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

// Logic to create a consistent color based on the name string
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
