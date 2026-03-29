import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

class EditProfilePicture extends StatelessWidget {
  const EditProfilePicture({
    super.key,
    required this.name,
    this.imageUrl,
  });

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.surfaceContainerLow,
                  width: 4,
                ),
              ),
              child: AvatarImage(
                name: name,
                imageUrl: imageUrl,
                radius: 64,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Material(
                color: colorScheme.primary,
                shape: const CircleBorder(),
                elevation: 4,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    // TODO: Implement image picker
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.camera_alt,
                      color: colorScheme.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'PERSONAL IDENTITY',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
              ),
        ),
      ],
    );
  }
}
