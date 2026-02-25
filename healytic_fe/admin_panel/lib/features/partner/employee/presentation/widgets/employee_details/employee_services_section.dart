import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class EmployeeServicesSection extends StatelessWidget {
  final bool isEditing;

  const EmployeeServicesSection({super.key, this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final services = [
      {'name': '60min Deep Tissue', 'price': '\$120.00'},
      {'name': '90min Aromatherapy', 'price': '\$150.00'},
      {'name': 'Reflexology Add-on', 'price': '\$45.00'},
      {'name': 'Sports Recovery', 'price': '\$135.00'},
      {'name': 'Hot Stone Therapy', 'price': '\$160.00'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PERFORMABLE SERVICES',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
            Text(
              'Showing 6 of 12',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        AppDimens.verticalMedium,
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth >= 600
                ? 3
                : (constraints.maxWidth >= 400 ? 2 : 1);
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ...services.map((service) {
                  final itemWidth =
                      (constraints.maxWidth - 12 * (crossAxisCount - 1)) /
                      crossAxisCount;
                  return SizedBox(
                    width: itemWidth,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Icon(
                              Icons.timer,
                              size: 18,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          AppDimens.horizontalMediumSmall,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service['name']!,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  service['price']!,
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                SizedBox(
                  width:
                      (constraints.maxWidth - 12 * (crossAxisCount - 1)) /
                      crossAxisCount,
                  child: Material(
                    color: colorScheme.surface.withAlpha(0),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.outlineVariant,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View All',
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                            AppDimens.horizontalExtraSmall,
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
