import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/domain/create_product.request.dart';
import 'package:admin_panel/features/partner/products/presentation/layouts/product_add_desktop.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/router/partner_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductAddScreen extends HookConsumerWidget {
  const ProductAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    final isSubmitting = useState(false);

    Future<void> handleSubmit() async {
      if (formKey.currentState?.saveAndValidate() ?? false) {
        final formData = formKey.currentState!.value;
        debugPrint('Form Data: $formData');

        isSubmitting.value = true;

        try {
          // General Information
          final name = formData['product_name'] as String? ?? '';
          final description = formData['product_description'] as String? ?? '';
          final productType = formData['product_type'] as String? ?? 'service';

          // Pricing & Inventory
          final basePrice =
              double.tryParse(formData['base_price']?.toString() ?? '0') ?? 0.0;
          final salePrice = double.tryParse(
            formData['sale_price']?.toString() ?? '',
          );

          // Visibility
          final status = formData['visibility_status'] as String? ?? 'draft';
          final onlineStore = formData['online_store'] as bool? ?? true;

          // Organization
          final category = formData['category'] as String? ?? '';

          // Operations & Scheduling
          final duration = int.tryParse(formData['duration']?.toString() ?? '');
          final buffer = int.tryParse(formData['buffer']?.toString() ?? '');
          final capacity = int.tryParse(formData['capacity']?.toString() ?? '');
          final leadTime = int.tryParse(
            formData['lead_time']?.toString() ?? '',
          );
          final staffAllocation =
              formData['staff_allocation'] as String? ?? 'any';
          final selectedStaffIds =
              (formData['selected_staff_ids'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];

          // Media
          final productImages =
              (formData['product_images'] as List<dynamic>?)
                  ?.map((e) => e.toString())
                  .toList() ??
              [];

          // Create and submit the product
          final request = CreateProductRequest(
            name: name,
            description: description,
            productType: productType,
            basePrice: basePrice,
            salePrice: salePrice,
            status: status,
            onlineStore: onlineStore,
            category: category,
            duration: duration,
            buffer: buffer,
            capacity: capacity,
            leadTime: leadTime,
            staffAllocation: staffAllocation,
            staffIds: selectedStaffIds,
            images: productImages,
          );

          await ref.read(productProvider.notifier).addProduct(request);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Product created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            context.goNamed(ProductHomeRoute.name);
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create product: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } finally {
          isSubmitting.value = false;
        }
      }
    }

    void handleCancel() {
      context.goNamed(ProductHomeRoute.name);
    }

    return FormBuilder(
      key: formKey,
      child: ResponsiveWrapper(
        useLayout: true,
        desktop: ProductAddDesktop(
          onCancel: handleCancel,
          onSubmit: isSubmitting.value ? null : () => handleSubmit(),
        ),
      ),
    );
  }
}
