import 'package:flutter/material.dart';

class CircularImage extends StatelessWidget {
  final ImageProvider image; // Allows NetworkImage, AssetImage, etc.
  final double size;
  final double borderWidth;

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
