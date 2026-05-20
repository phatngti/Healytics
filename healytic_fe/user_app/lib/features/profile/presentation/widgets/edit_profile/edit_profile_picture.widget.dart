import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

class EditProfilePicture extends StatelessWidget {
  const EditProfilePicture({
    super.key,
    required this.name,
    this.imageUrl,
    this.onEditAvatar,
    this.isBusy = false,
  });

  final String name;
  final String? imageUrl;
  final VoidCallback? onEditAvatar;
  final bool isBusy;

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
              child: _EditableAvatarImage(
                name: name,
                imageUrl: imageUrl,
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
                  onTap: isBusy ? null : onEditAvatar,
                  child: Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: isBusy
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: colorScheme.onPrimary,
                            ),
                          )
                        : Icon(
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

class _EditableAvatarImage extends StatelessWidget {
  const _EditableAvatarImage({
    required this.name,
    this.imageUrl,
  });

  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return AvatarImage(
      name: name,
      imageUrl: imageUrl,
      radius: 64,
    );
  }
}
