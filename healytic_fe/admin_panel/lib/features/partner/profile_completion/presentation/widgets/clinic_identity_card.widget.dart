import 'package:admin_panel/features/partner/profile_completion/domain/profile_completion.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Read-only verified clinic identity card
/// showing brand name, legal name, phone, address,
/// and business type chips.
class ClinicIdentityCardWidget extends StatelessWidget {
  const ClinicIdentityCardWidget({required this.identity, super.key});

  final ClinicIdentity identity;

  @override
  Widget build(BuildContext context) {
    final infoTiles = <Widget>[
      InfoTileWidget(label: 'Brand name', value: identity.brandName),
      InfoTileWidget(label: 'Legal name', value: identity.legalName),
      if ((identity.phoneNumber ?? '').trim().isNotEmpty)
        InfoTileWidget(
          label: 'Phone number',
          value: identity.phoneNumber!.trim(),
        ),
      if ((identity.address ?? '').trim().isNotEmpty)
        InfoTileWidget(label: 'Address', value: identity.address!.trim()),
    ];

    return SectionCardWidget(
      title: 'Verified clinic identity',
      subtitle:
          'These verified business details are '
          'read-only here and provide context for '
          'the public profile you are completing.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: AppDimens.spaceMd,
            runSpacing: AppDimens.spaceMd,
            children: infoTiles,
          ),
          if (identity.businessType.isNotEmpty) ...[
            AppDimens.verticalMedium,
            Text(
              'Business type',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            AppDimens.verticalSmall,
            Wrap(
              spacing: AppDimens.spaceSm,
              runSpacing: AppDimens.spaceSm,
              children: identity.businessType
                  .map(
                    (item) => Chip(
                      label: Text(
                        _formatBusinessType(item),
                      ),
                      avatar: Icon(
                        Icons.local_hospital_rounded,
                        size: AppDimens.iconSmMd,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  String _formatBusinessType(String value) {
    return value
        .split('_')
        .where((part) => part.isNotEmpty)
        .map(
          (part) =>
              '${part[0].toUpperCase()}'
              '${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}

/// Reusable section card container with title,
/// subtitle, optional trailing widget, and a body.
class SectionCardWidget extends StatelessWidget {
  const SectionCardWidget({
    required this.title,
    required this.subtitle,
    required this.child,
    this.trailing,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllLarge,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerLow : colorScheme.surface,
        borderRadius: AppDimens.radiusLarge,
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.5)
              : colorScheme.outlineVariant,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? colorScheme.shadow.withValues(alpha: 0.2)
                : colorScheme.shadow.withValues(alpha: 0.06),
            blurRadius: isDark
                ? AppDimens.spaceXl
                : AppDimens.spaceMd,
            offset: const Offset(
              0,
              AppDimens.spaceXs,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    AppDimens.verticalSmall,
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                AppDimens.horizontalMedium,
                trailing!,
              ],
            ],
          ),
          AppDimens.verticalLargeExtra,
          child,
        ],
      ),
    );
  }
}

/// Compact info tile showing a label-value pair
/// within a subtle rounded container.
class InfoTileWidget extends StatelessWidget {
  const InfoTileWidget({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      constraints: const BoxConstraints(
        minWidth: 240,
        maxWidth: 360,
      ),
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHigh.withValues(alpha: 0.6)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: AppDimens.radiusMedium,
        border: isDark
            ? Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppDimens.spaceXs + AppDimens.spaceXxs),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
