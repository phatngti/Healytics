import 'package:admin_panel/features/common/widgets/button/back_button.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_general_info_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_media_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_operations_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_organization_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_pricing_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_resources_card.widget.dart';
import 'package:admin_panel/features/partner/products/presentation/widgets/product_add/product_visibility_card.widget.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductAddDesktop extends ConsumerStatefulWidget {
  const ProductAddDesktop({super.key, this.onSubmit, required this.onCancel});

  final VoidCallback? onSubmit;
  final VoidCallback onCancel;

  @override
  ConsumerState<ProductAddDesktop> createState() => _ProductAddDesktopState();
}

class _ProductAddDesktopState extends ConsumerState<ProductAddDesktop> {
  String _status = 'draft';
  String? _category;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        // Scrollable content
        SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppDimens.paddingAllLarge.left,
            right: AppDimens.paddingAllLarge.right,
            bottom: AppDimens.paddingAllLarge.bottom,
            top: 100, // Height for the floating header
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column - Main Content (2/3)
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const ProductGeneralInfoCard(),
                        AppDimens.verticalMedium,
                        const ProductOperationsCard(),
                        AppDimens.verticalMedium,
                        const ProductPricingCard(),
                        AppDimens.verticalMedium,
                        const ProductMediaCard(),
                        AppDimens.verticalMedium,
                        const ProductResourcesCard(),
                      ],
                    ),
                  ),
                  AppDimens.horizontalLarge,
                  // Right Column - Sidebar (1/3)
                  SizedBox(
                    width: 320,
                    child: Column(
                      children: [
                        ProductVisibilityCard(
                          initialStatus: _status,
                          onStatusChanged: (status) {
                            setState(() {
                              _status = status;
                            });
                          },
                        ),
                        AppDimens.verticalMedium,
                        ProductOrganizationCard(
                          initialCategory: _category,
                          onCategoryChanged: (category) {
                            setState(() {
                              _category = category;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Floating header
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: AppDimens.paddingHorizontalLarge.add(
              AppDimens.paddingVerticalMedium,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: colorScheme.outlineVariant),
              ),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.03),
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
                    AppBackButton(onTap: widget.onCancel),
                    AppDimens.horizontalMedium,
                    Text(
                      'Create Product',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppButton(
                      buttonType: ButtonType.outline,
                      onPressed: widget.onCancel,
                      child: const Text('Cancel'),
                    ),
                    AppDimens.horizontalSmall,
                    AppButton(
                      buttonType: ButtonType.elevated,
                      onPressed: widget.onSubmit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.save_outlined,
                            size: 18,
                            color: colorScheme.onPrimary,
                          ),
                          AppDimens.horizontalSmall,
                          const Text('Save & Publish'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
