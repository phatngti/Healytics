import 'package:admin_panel/features/partner/profile_edit/domain/public_profile.entity.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Read-only card displaying the partner's address.
class AddressCardWidget extends StatelessWidget {
  const AddressCardWidget({
    required this.address,
    super.key,
  });

  final PublicProfileAddress address;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final parts = <String>[
      address.streetAddress,
      if (address.ward != null)
        address.ward!.name,
      if (address.district != null)
        address.district!.name,
      if (address.province != null)
        address.province!.name,
    ];

    final displayAddress =
        address.formattedAddress ??
            parts.join(', ');

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
                  Icons.location_on_outlined,
                  color: cs.primary,
                  size: AppDimens.iconMd,
                ),
                AppDimens.horizontalSmall,
                Text(
                  'Address',
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
            Text(
              displayAddress,
              style: tt.bodyMedium,
            ),
            if (address.latitude != null &&
                address.longitude != null) ...[
              AppDimens.verticalSmall,
              Text(
                'Coordinates: '
                '${address.latitude!.toStringAsFixed(4)}, '
                '${address.longitude!.toStringAsFixed(4)}',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
