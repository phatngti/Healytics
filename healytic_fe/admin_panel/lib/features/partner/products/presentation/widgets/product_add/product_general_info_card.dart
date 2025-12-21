import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:admin_panel/features/common/widgets/quill.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class ProductGeneralInfoCard extends StatefulWidget {
  final ValueChanged<String>? onProductTypeChanged;
  final String initialProductType;

  const ProductGeneralInfoCard({
    super.key,
    this.onProductTypeChanged,
    this.initialProductType = 'service',
  });

  @override
  State<ProductGeneralInfoCard> createState() => _ProductGeneralInfoCardState();
}

class _ProductGeneralInfoCardState extends State<ProductGeneralInfoCard> {
  late String _selectedProductType;

  @override
  void initState() {
    super.initState();
    _selectedProductType = widget.initialProductType;
  }

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
                // Product Type Selection
                _buildProductTypeSection(context),
                AppDimens.verticalLarge,
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

  Widget _buildProductTypeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Product Type',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ProductTypeOption(
                icon: Icons.inventory_2_outlined,
                title: 'Physical Item',
                subtitle: 'Skincare, supplements, retail.',
                isSelected: _selectedProductType == 'physical',
                onTap: () {
                  setState(() {
                    _selectedProductType = 'physical';
                  });
                  widget.onProductTypeChanged?.call('physical');
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _ProductTypeOption(
                icon: Icons.spa_outlined,
                title: 'Service',
                subtitle: 'Massage, consultation, therapy.',
                isSelected: _selectedProductType == 'service',
                onTap: () {
                  setState(() {
                    _selectedProductType = 'service';
                  });
                  widget.onProductTypeChanged?.call('service');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProductTypeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ProductTypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withAlpha(13)
              : colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? primaryColor : colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 4),
                ],
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? primaryColor : colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
  }
}
