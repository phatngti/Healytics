import 'package:flutter/material.dart';

class EmployeeAvatarSection extends StatelessWidget {
  const EmployeeAvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            const CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAxH-FvzeWbY1PCplyl2NAfILVSwSy8SSKYvBnTUbhoJUgloDYnJvEaljgtiodR55_egTsCmp-3uO-1tVsB1gbvx9JyBdWYxHYkGLYCdh5a9v-9bjIt_VLok23jwhP5Q0lxqT09mlbVkzzgTutweFqG9uplwIfPtIotf_-OITT__joYrfgdoSvd7de8Rt7njTk7l2zMdNeckDhtdmaA-8qhxMmXL2SOFLazPkJZvbzBbgt-Eu73pSDNEWEnrY4ilQ_ea9ZGAaJIovFg',
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF13EC13),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.check, size: 14, color: Colors.black),
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sarah Jenkins',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Display: "Sarah J."',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                'EMP-2049',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontFamily: 'monospace',
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
