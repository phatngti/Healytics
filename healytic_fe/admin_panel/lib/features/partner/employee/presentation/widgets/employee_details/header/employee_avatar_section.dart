import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EmployeeAvatarSection extends StatelessWidget {
  final String avatar;
  final String fullName;
  final String displayName;
  final EmployeeId employeeId;
  final bool isEditing;

  const EmployeeAvatarSection({
    super.key,
    required this.avatar,
    required this.fullName,
    required this.displayName,
    required this.employeeId,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: avatar.isNotEmpty
                  ? CachedNetworkImageProvider(avatar)
                  : null,
              child: avatar.isEmpty
                  ? Text(
                      _getInitials(fullName),
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  : null,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).extension<SemanticColors>()!.success,
                  shape: BoxShape.circle,
                  border: Border.all(color: colorScheme.surface, width: 2),
                ),
                child: Icon(
                  Icons.check,
                  size: 14,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        AppDimens.horizontalLarge,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              'Display: "$displayName"',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalExtraSmall,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: colorScheme.outlineVariant),
              ),
              child: Text(
                'EMP-${employeeId.value.substring(0, 6).toUpperCase()}',
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

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}
