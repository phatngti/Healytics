import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/presentation/product_edit/product_edit_desktop.dart';
import 'package:admin_panel/features/partner/products/domain/product.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_panel/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductEditScreen extends StatelessWidget {
  final int productId;

  const ProductEditScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWrapper(
      useLayout: true,
      desktop: ProductDetailsContent(productId: productId),
    );
  }
}

class ProductDetailsContent extends HookConsumerWidget {
  final int productId;

  const ProductDetailsContent({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productNotifier = ref.read(productProvider.notifier);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final product = useState<ProductEntity?>(null);
    final isLoading = useState(true);
    final isEditing = useState(false);

    useEffect(() {
      Future.microtask(() async {
        try {
          final result = await productNotifier.getProductById(productId);
          product.value = result;
        } catch (e) {
          // Handle error
        } finally {
          isLoading.value = false;
        }
      });
      return null;
    }, [productId]);

    if (isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (product.value == null) {
      return const Center(child: Text('Product not found'));
    }

    final nameController = useTextEditingController(text: product.value!.name);
    final priceController = useTextEditingController(
      text: product.value!.price.toString(),
    );
    final descriptionController = useTextEditingController(
      text: product.value!.description,
    );
    final categoryController = useTextEditingController(
      text: product.value!.category,
    );
    final imageController = useTextEditingController(
      text: product.value!.image,
    );
    final statusController = useTextEditingController(text: 'active');

    Future<void> onSave() async {
      if (formKey.currentState!.validate()) {
        final updatedProduct = product.value!.copyWith(
          name: nameController.text,
          price: double.parse(priceController.text),
          description: descriptionController.text,
          category: categoryController.text,
          image: imageController.text,
        );
        await productNotifier.updateProduct(updatedProduct);
        product.value = updatedProduct; // Update local state
        isEditing.value = false; // Exit edit mode
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product updated successfully')),
          );
        }
      }
    }

    void onCancel() {
      // Reset controllers to original values
      nameController.text = product.value!.name;
      priceController.text = product.value!.price.toString();
      descriptionController.text = product.value!.description;
      categoryController.text = product.value!.category;
      imageController.text = product.value!.image;

      context.goNamed(ProductHomeRoute.name);
    }

    return ProductEditDesktop(
      formKey: formKey,
      nameController: nameController,
      priceController: priceController,
      descriptionController: descriptionController,
      categoryController: categoryController,
      imageController: imageController,
      statusController: statusController,
      onSave: onSave,
      onCancel: onCancel,
    );
  }
}
