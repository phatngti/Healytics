import 'package:common/utils/demensions.dart';
import 'package:common/widgets/images/avatar.dart';
import 'package:flutter/material.dart';

import 'detail_section_header.widget.dart';

/// Customer section with avatar initials and name.
class DetailCustomerSection extends StatelessWidget {
  /// Customer display name.
  final String customerName;

  /// Optional avatar image URL.
  final String? imageUrl;

  const DetailCustomerSection({
    required this.customerName,
    this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DetailSectionHeader(title: 'Customer'),
        AppDimens.verticalSmall,
        Row(
          children: [
            AvatarImage(
              name: customerName,
              imageUrl: imageUrl,
              radius: AppDimens.spaceXl,
            ),
            AppDimens.horizontalMediumSmall,
            Expanded(
              child: Text(
                customerName,
                style: tt.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
