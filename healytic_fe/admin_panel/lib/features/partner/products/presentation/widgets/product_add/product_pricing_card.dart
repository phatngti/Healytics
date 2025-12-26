import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ProductPricingCard extends StatelessWidget {
  final bool showStockQuantity;

  const ProductPricingCard({super.key, this.showStockQuantity = false});

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
            child: Text(
              'Pricing & Inventory',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Price Fields Row
                Row(
                  children: [
                    Expanded(
                      child: _PriceField(
                        label: 'Base Price',
                        fieldKey: 'base_price',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _PriceField(
                        label: 'Sale Price',
                        fieldKey: 'sale_price',
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: _PriceField(
                        label: 'Cost per item',
                        fieldKey: 'cost_per_item',
                        isOptional: true,
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalLarge,
                // Divider
                Divider(color: colorScheme.outlineVariant),
                AppDimens.verticalLarge,
                // SKU and Barcode Row
                const Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        fieldKey: 'sku',
                        label: 'SKU (Stock Keeping Unit)',
                        hintText: 'e.g. CR-001',
                      ),
                    ),
                    SizedBox(width: 24),
                    Expanded(
                      child: AppTextField(
                        fieldKey: 'barcode',
                        label: 'Barcode (ISBN, UPC, GTIN)',
                        hintText: 'Scan or enter barcode',
                      ),
                    ),
                  ],
                ),
                // Stock Quantity (hidden by default for services)
                if (showStockQuantity) ...[
                  AppDimens.verticalLarge,
                  _buildStockQuantityField(context),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockQuantityField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stock Quantity',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'Track inventory history',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: const AppTextField(
            fieldKey: 'stock_quantity',
            label: '',
            hintText: '0',
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}

class _PriceField extends StatelessWidget {
  final String label;
  final String fieldKey;
  final bool isOptional;

  const _PriceField({
    required this.label,
    required this.fieldKey,
    this.isOptional = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              if (isOptional)
                Text(
                  ' (Optional)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
        FormBuilderTextField(
          name: fieldKey,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            hintText: '0.00',
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
