import 'package:admin_panel/features/common/widgets/card/statistic_card.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/charts/sales_trend_by_category.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/table/table.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';

class ProductHomeDesktop extends StatelessWidget {
  const ProductHomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Summary',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppDimens.verticalSmall,
                Text(
                  'Overview of your products',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                AppDimens.verticalSmall,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const StatisticCard(
                        label: 'Total Products',
                        value: '100',
                        change: 10,
                      ),
                      AppDimens.horizontalMedium,
                      const StatisticCard(
                        label: 'Active Products',
                        value: '100',
                        change: 10,
                      ),
                      AppDimens.horizontalMedium,
                      const StatisticCard(
                        label: 'Out of Stock',
                        value: '100',
                        change: 10,
                      ),
                      AppDimens.horizontalMedium,
                      const StatisticCard(
                        label: 'Deleted Products',
                        value: '100',
                        change: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppDimens.verticalLarge,
            Text(
              'Product Management',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.verticalSmall,
            Text(
              'Manage, edit, and delete all products from this central dashboard',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalSmall,
            ProductTable(height: DeviceUtils.getScreenHeight(context)),
            AppDimens.verticalLarge,
            Text(
              'Sales Trends by Category',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
            AppDimens.verticalSmall,
            Text(
              'See how your products perform in different categories over time',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            AppDimens.verticalSmall,
            SalesTrendsByCategory(),
          ],
        ),
      ),
    );
  }
}
