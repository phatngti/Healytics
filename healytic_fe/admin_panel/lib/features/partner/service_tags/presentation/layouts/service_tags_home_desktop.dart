import 'package:admin_panel/features/partner/service_tags/presentation/widgets/table/service_tags_table.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:admin_panel/utils/device.dart';
import 'package:flutter/material.dart';

class ServiceTagsHomeDesktop extends StatelessWidget {
  const ServiceTagsHomeDesktop({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Service Tags Management',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      AppDimens.verticalSmall,
                      Text(
                        'Create and manage service tags to organize support tickets efficiently. Ensure consistent categorization across the platform.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppDimens.verticalLarge,
            // Service Tags Table
            ServiceTagsTable(height: DeviceUtils.getScreenHeight(context)),
          ],
        ),
      ),
    );
  }
}
