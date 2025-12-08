import 'package:admin_panel/features/partner/products/presentation/widgets/table/table.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductHomeDesktop extends StatelessWidget {
  const ProductHomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    print('ProductHomeDesktop');
    return Padding(
      padding: AppDimens.paddingAllMedium,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          ProductTable(),
          AppDimens.verticalSmall,
        ],
      ),
    );
  }
}
