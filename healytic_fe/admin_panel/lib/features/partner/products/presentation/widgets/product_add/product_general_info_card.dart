import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:admin_panel/features/common/widgets/quill.dart';
import 'package:admin_panel/utils/demensions.dart';
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
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
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
            padding: const EdgeInsets.all(24),
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
                const SizedBox(height: 4),
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
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                const AppTextField(
                  fieldKey: 'product_name',
                  label: 'Product Name',
                  hintText: 'e.g. Rejuvenating Night Cream',
                  isRequired: true,
                ),
                AppDimens.verticalLarge,
                // Description
                Text(
                  'Description',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                FlutterQuillEditor(
                  initialContent: const [],
                  onChanged: (value) {
                    // Value captured in FormBuilder
                  },
                  height: 250,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
