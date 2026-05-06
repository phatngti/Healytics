import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

import 'detail_section_header.widget.dart';

/// Location section with pin icon, clinic name,
/// and street address.
class DetailLocationSection extends StatelessWidget {
  /// Clinic or spa display name.
  final String clinicName;

  /// Full street address.
  final String address;

  const DetailLocationSection({
    required this.clinicName,
    required this.address,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionHeader(title: 'Location'),
        AppDimens.verticalSmall,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppDimens.spaceXxs,
              ),
              child: Icon(
                Icons.location_on,
                size: AppDimens.iconMd,
                color: cs.primary,
              ),
            ),
            AppDimens.horizontalSmall,
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    clinicName,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  AppDimens.verticalExtraSmall,
                  Text(
                    address,
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
