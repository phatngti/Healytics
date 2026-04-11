import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Read-only card showing contact and visibility
/// info (phone, email, username).
class ContactCardWidget extends StatelessWidget {
  const ContactCardWidget({
    required this.info,
    super.key,
  });

  final PublicProfileBusinessInfo info;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final hasContact = info.phoneNumber != null ||
        info.email != null ||
        info.username != null;

    if (!hasContact) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: AppDimens.paddingAllLarge,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_mail_outlined,
                  color: cs.primary,
                  size: AppDimens.iconMd,
                ),
                AppDimens.horizontalSmall,
                Text(
                  'Contact & Visibility',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: AppDimens.spaceSm,
                    vertical: AppDimens.spaceXxs,
                  ),
                  decoration: BoxDecoration(
                    color: cs
                        .surfaceContainerHighest,
                    borderRadius:
                        AppDimens.radiusSmall,
                  ),
                  child: Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons
                            .lock_outline_rounded,
                        size: AppDimens.iconXs,
                        color: cs
                            .onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Read-only',
                        style: tt.labelSmall
                            ?.copyWith(
                          color: cs
                              .onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppDimens.verticalMedium,
            if (info.phoneNumber != null)
              _ContactRow(
                icon: Icons.phone_outlined,
                label: 'Phone',
                value: info.phoneNumber!,
              ),
            if (info.email != null)
              _ContactRow(
                icon: Icons.email_outlined,
                label: 'Email',
                value: info.email!,
              ),
            if (info.username != null)
              _ContactRow(
                icon: Icons
                    .alternate_email_rounded,
                label: 'Username',
                value: '@${info.username!}',
              ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  const _ContactRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.spaceSm,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: AppDimens.iconSmMd,
            color: cs.onSurfaceVariant,
          ),
          AppDimens.horizontalSmall,
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: tt.labelSmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
              Text(value, style: tt.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}
