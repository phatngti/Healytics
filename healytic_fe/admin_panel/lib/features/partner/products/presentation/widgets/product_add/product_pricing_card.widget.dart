import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ProductPricingCard extends StatelessWidget {
  const ProductPricingCard({super.key});

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
            child: Text(
              'Service Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          // Content
          Padding(
            padding: AppDimens.paddingAllLarge,
            child: Column(
              children: [
                // Price Fields Row
                Row(
                  children: [
                    Expanded(
                      child: _PriceField(
                        label: 'Base Price',
                        fieldKey: ProductFormField.basePrice.key,
                        isRequired: true,
                      ),
                    ),
                    AppDimens.horizontalLarge,
                    Expanded(
                      child: _PriceField(
                        label: 'Sale Price',
                        fieldKey: ProductFormField.salePrice.key,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceField extends StatelessWidget {
  final String label;
  final String fieldKey;
  final bool isRequired;

  const _PriceField({
    required this.label,
    required this.fieldKey,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (isRequired)
                  const TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
        FormBuilderTextField(
          name: fieldKey,
          validator: _buildValidator,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            prefixText: '\$ ',
            prefixStyle: TextStyle(
              color: colorScheme.onSurfaceVariant,
            ),
            hintText: '0.00',
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: colorScheme.outlineVariant,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: colorScheme.primary,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: colorScheme.error,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: AppDimens.radiusSmall,
              borderSide: BorderSide(
                color: colorScheme.error,
                width: 2,
              ),
            ),
            contentPadding: AppDimens.paddingAllMediumSmall,
          ),
        ),
      ],
    );
  }

  /// Validates the price field value.
  ///
  /// Checks emptiness for required fields, then
  /// validates numeric format and non-negative value.
  String? _buildValidator(String? value) {
    final trimmed = value?.trim() ?? '';

    if (isRequired && trimmed.isEmpty) {
      return 'Price is required';
    }

    if (trimmed.isEmpty) return null;

    final parsed = double.tryParse(trimmed);
    if (parsed == null) {
      return 'Enter a valid number';
    }

    if (parsed < 0) {
      return 'Price cannot be negative';
    }

    return null;
  }
}
