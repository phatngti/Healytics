import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/domain/update_product.request.dart';
import 'package:admin_panel/features/partner/products/presentation/layouts/product_edit_desktop.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product_details.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// Screen for editing an existing product.
///
/// Uses [productDetailsProvider] to load the product,
/// then wraps a [FormBuilder] around [ProductEditDesktop]
/// and pre-populates fields from the [Product] entity.
class ProductEditScreen extends ConsumerWidget {
  final String productId;

  const ProductEditScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(
      productDetailsProvider(productId),
    );

    return productAsync.when(
      data: (product) => ResponsiveWrapper(
        useLayout: true,
        desktop: _ProductEditContent(product: product),
      ),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () =>
                context.goNamed(ProductHomeRoute.name),
          ),
        ),
        body: Center(
          child: Text('Error loading product: $error'),
        ),
      ),
    );
  }
}

/// Content widget that wraps the form and handles
/// save/cancel logic.
class _ProductEditContent extends HookConsumerWidget {
  final Product product;

  const _ProductEditContent({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(
      () => GlobalKey<FormBuilderState>(),
    );
    final isSubmitting = useState(false);

    /// Build initial values from the loaded product.
    final initialValues = useMemoized(
      () => _buildInitialValues(product),
      [product],
    );

    Future<void> handleSave() async {
      final state = formKey.currentState;
      if (state == null || !state.saveAndValidate()) return;

      isSubmitting.value = true;
      try {
        final data = state.value;

        final request = UpdateProductRequest(
          id: product.id,
          name: data['product_name'] as String?,
          basePrice: double.tryParse(
            data['base_price']?.toString() ?? '',
          ),
          description:
              data['product_description'] as String?,
          category: data['category'] as String?,
          images: (data['product_images'] as List?)
              ?.map((e) => e.toString())
              .toList(),
          staffIds: (data['selected_staff_ids'] as List?)
              ?.map((e) => e.toString())
              .toList(),
        );

        await ref
            .read(productProvider.notifier)
            .updateProduct(request);

        // Invalidate cache so details refresh
        ref.invalidate(
          productDetailsProvider(product.id.value),
        );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Product updated successfully!',
              ),
            ),
          );
          context.goNamed(ProductHomeRoute.name);
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update: $e'),
            ),
          );
        }
      } finally {
        isSubmitting.value = false;
      }
    }

    void handleCancel() {
      context.goNamed(ProductHomeRoute.name);
    }

    return FormBuilder(
      key: formKey,
      initialValue: initialValues,
      child: ProductEditDesktop(
        product: product,
        onSave: isSubmitting.value ? null : handleSave,
        onCancel: handleCancel,
      ),
    );
  }

  /// Maps [Product] entity fields to FormBuilder
  /// field keys used by the card widgets.
  static Map<String, dynamic> _buildInitialValues(
    Product product,
  ) {
    return {
      'product_name': product.name,
      'product_description': product.description,
      'product_type': product.productType,
      'base_price': product.basePrice.toString(),
      'sale_price': product.salePrice?.toString(),
      'visibility_status': product.status,
      'online_store': product.onlineStore,
      'category': product.category.id,
      'duration': product.duration?.toString(),
      'buffer': product.buffer?.toString(),
      'capacity': product.capacity?.toString(),
      'lead_time': product.leadTime?.toString(),
      'staff_allocation': product.staffAllocation,
      'selected_staff_ids': product.staffIds,
      'product_images': product.images,
    };
  }
}
