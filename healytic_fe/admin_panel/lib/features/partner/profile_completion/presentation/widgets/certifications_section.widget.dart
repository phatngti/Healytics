import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';
import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/clinic_identity_card.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Certifications section with add/edit/delete
/// and reorder actions for trust badges.
class CertificationsSectionWidget extends StatelessWidget {
  const CertificationsSectionWidget({
    required this.certifications,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    required this.onMove,
    super.key,
  });

  final List<PartnerCertificationItem> certifications;
  final VoidCallback onAdd;
  final void Function(int index) onEdit;
  final void Function(int index) onDelete;
  final void Function(int index, int direction) onMove;

  /// Icon name to [IconData] lookup.
  static const Map<String, IconData> iconOptions = {
    'workspace_premium': Icons.workspace_premium_rounded,
    'verified': Icons.verified_rounded,
    'medical_services': Icons.medical_services_rounded,
    'health_and_safety': Icons.health_and_safety_rounded,
    'emoji_events': Icons.emoji_events_rounded,
    'shield': Icons.shield_rounded,
    'star': Icons.star_rounded,
    'recommend': Icons.recommend_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return SectionCardWidget(
      title: 'Trust badges and certifications',
      subtitle:
          'Optional badges help patients trust '
          'the clinic faster. Add accreditations, '
          'standards, or credibility signals that '
          'can be shown publicly.',
      trailing: OutlinedButton.icon(
        onPressed: onAdd,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add badge'),
      ),
      child: certifications.isEmpty
          ? _EmptyCertificationsPlaceholder()
          : Column(
              children: [
                for (var i = 0; i < certifications.length; i++) ...[
                  _CertificationTile(
                    item: certifications[i],
                    icon:
                        iconOptions[certifications[i].iconName] ??
                        Icons.workspace_premium_rounded,
                    onEdit: () => onEdit(i),
                    onDelete: () => onDelete(i),
                    onMoveUp: i == 0 ? null : () => onMove(i, -1),
                    onMoveDown: i == certifications.length - 1
                        ? null
                        : () => onMove(i, 1),
                  ),
                  if (i != certifications.length - 1)
                    AppDimens.verticalMediumSmall,
                ],
              ],
            ),
    );
  }
}

class _EmptyCertificationsPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMediumLarge,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Text(
        'No badges added yet. '
        'This section is optional in v1.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
      ),
    );
  }
}

class _CertificationTile extends StatelessWidget {
  const _CertificationTile({
    required this.item,
    required this.icon,
    required this.onEdit,
    required this.onDelete,
    this.onMoveUp,
    this.onMoveDown,
  });

  final PartnerCertificationItem item;
  final IconData icon;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onMoveUp;
  final VoidCallback? onMoveDown;

  /// Badge icon container size.
  static const double _iconContainerSize = 44;

  /// Badge icon container border radius.
  static const double _iconContainerRadius = 14;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.28),
        borderRadius: const BorderRadius.all(
          Radius.circular(
            AppDimens.spaceLg + AppDimens.spaceXxs,
          ),
        ),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.4)
              : colorScheme.outlineVariant,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _iconContainerSize,
            height: _iconContainerSize,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(
                _iconContainerRadius,
              ),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(
            width: AppDimens.spaceMdLg,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (item.subtitle != null && item.subtitle!.isNotEmpty) ...[
                  AppDimens.verticalExtraSmall,
                  Text(
                    item.subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Wrap(
            spacing: AppDimens.spaceXs + AppDimens.spaceXxs,
            children: [
              IconButton.outlined(
                onPressed: onMoveUp,
                tooltip: 'Move up',
                icon: const Icon(Icons.arrow_upward_rounded),
              ),
              IconButton.outlined(
                onPressed: onMoveDown,
                tooltip: 'Move down',
                icon: const Icon(Icons.arrow_downward_rounded),
              ),
              IconButton.outlined(
                onPressed: onEdit,
                tooltip: 'Edit certification',
                icon: const Icon(Icons.edit_outlined),
              ),
              IconButton.filledTonal(
                onPressed: onDelete,
                tooltip: 'Delete certification',
                icon: const Icon(Icons.delete_outline_rounded),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
