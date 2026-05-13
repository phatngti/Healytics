import 'package:common/widgets/button/back_button.dart';
import 'package:common/widgets/button/button.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_general_info_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_media_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_operations_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_organization_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_pricing_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_service_manual_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_visibility_card.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Desktop layout for editing an existing product.
///
/// Reuses the same card widgets as [ProductAddDesktop]
/// but maintains its own independent state and layout.
class ProductEditDesktop extends StatelessWidget {
  /// The loaded product entity for pre-population.
  final Product product;

  /// Called when the user presses Save.
  final VoidCallback? onSave;

  /// Called when the user presses Cancel / Back.
  final VoidCallback onCancel;

  /// Key to access the service manual card data.
  final GlobalKey<ProductServiceManualCardState>? serviceManualKey;

  /// Pre-populated service manual data.
  final List<String> initialGuidelines;
  final List<Map<String, String>> initialRules;
  final List<Map<String, String>> initialSteps;

  const ProductEditDesktop({
    super.key,
    required this.product,
    required this.onSave,
    required this.onCancel,
    this.serviceManualKey,
    this.initialGuidelines = const [],
    this.initialRules = const [],
    this.initialSteps = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrollable content
        Positioned.fill(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              left: AppDimens.paddingAllLarge.left,
              right: AppDimens.paddingAllLarge.right,
              bottom: AppDimens.paddingAllLarge.bottom,
              top: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column — Main Content
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          ProductGeneralInfoCard(
                            initialDescription: product.description,
                          ),
                          AppDimens.verticalMedium,
                          ProductOperationsCard(
                            initialStaffAllocation: product.staffAllocation,
                            initialStaffIds: product.staffIds,
                          ),
                          AppDimens.verticalMedium,
                          const ProductPricingCard(),
                          AppDimens.verticalMedium,
                          const ProductMediaCard(),
                        ],
                      ),
                    ),
                    AppDimens.horizontalLarge,
                    // Right Column — Sidebar
                    SizedBox(
                      width: 320,
                      child: Column(
                        children: [
                          ProductVisibilityCard(
                            initialStatus: product.status,
                            initialOnlineStore: product.onlineStore,
                          ),
                          AppDimens.verticalMedium,
                          ProductOrganizationCard(
                            initialCategory: product.category.id,
                            initialTags: product.tags,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                AppDimens.verticalMedium,
                ProductServiceManualCard(
                  key: serviceManualKey,
                  initialGuidelines: initialGuidelines,
                  initialRules: initialRules,
                  initialSteps: initialSteps,
                ),
              ],
            ),
          ),
        ),
        // Floating header
        _FloatingHeader(
          productName: product.name,
          onSave: onSave,
          onCancel: onCancel,
        ),
      ],
    );
  }
}

class _FloatingHeader extends StatelessWidget {
  final String productName;
  final VoidCallback? onSave;
  final VoidCallback onCancel;

  const _FloatingHeader({
    required this.productName,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: AppDimens.paddingHorizontalLarge.add(
          AppDimens.paddingVerticalMedium,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withAlpha(8),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppBackButton(onTap: onCancel),
                AppDimens.horizontalMedium,
                Text(
                  'Edit Product',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                AppDimens.horizontalSmall,
                Text(
                  '— $productName',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                AppButton(
                  buttonType: ButtonType.outline,
                  onPressed: onCancel,
                  child: const Text('Discard'),
                ),
                AppDimens.horizontalSmall,
                AppButton(
                  buttonType: ButtonType.elevated,
                  onPressed: onSave,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.save_outlined,
                        size: 18,
                        color: colorScheme.onPrimary,
                      ),
                      AppDimens.horizontalSmall,
                      const Text('Save Changes'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
