import 'package:common/widgets/input/form_field_builders.dart';

import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductGeneralInfoCard extends StatefulWidget {
  const ProductGeneralInfoCard({super.key});

  @override
  State<ProductGeneralInfoCard> createState() => _ProductGeneralInfoCardState();
}

class _ProductGeneralInfoCardState extends State<ProductGeneralInfoCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: AppDimens.paddingAllLarge,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'General Information',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppDimens.verticalExtraSmall,
                Text(
                  'Basic details about your product or service.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                FormFieldBuilders.buildTextField(
                  context,
                  fieldKey: 'product_name',
                  label: 'Product Name',
                  hintText: 'e.g. Rejuvenating Night Cream',
                  isRequired: true,
                ),
                AppDimens.verticalLarge,
                // Description
                FormFieldBuilders.buildQuillEditor(
                  context,
                  label: 'Description',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
