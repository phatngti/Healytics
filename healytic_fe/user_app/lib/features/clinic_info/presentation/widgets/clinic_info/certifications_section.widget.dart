import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/clinic_info/domain/entities/clinic_info.entity.dart';

/// Horizontally scrollable certifications &amp; awards.
class CertificationsSection extends StatelessWidget {
  const CertificationsSection({super.key, required this.certifications});

  final List<ClinicCertification> certifications;

  static const _iconMap = <String, IconData>{
    'workspace_premium': Symbols.workspace_premium,
    'rewarded_ads': Symbols.rewarded_ads,
    'verified_user': Symbols.verified_user,
    'star': Symbols.star,
    'military_tech': Symbols.military_tech,
  };

  @override
  Widget build(BuildContext context) {
    if (certifications.isEmpty) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final hPad = AppDimens.horizontalPadding(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Text(
            'CERTIFICATIONS & AWARDS',
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        AppDimens.verticalSmall,
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: hPad),
            itemCount: certifications.length,
            separatorBuilder: (_, __) => AppDimens.horizontalSmall,
            itemBuilder: (context, index) {
              final cert = certifications[index];
              final icon = _iconMap[cert.iconName] ?? Symbols.verified;

              return Container(
                width: 140,
                padding: const EdgeInsets.all(AppDimens.spaceSm),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLowest,
                  borderRadius: AppDimens.radiusMediumSmall,
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: AppDimens.radiusExtraSmall,
                      ),
                      child: Icon(
                        icon,
                        size: AppDimens.iconSmMd,
                        color: colorScheme.primary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      cert.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      cert.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(
                        fontSize: 9,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
