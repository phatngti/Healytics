import 'package:admin_panel/features/common/widgets/responsive/responsive.dart';
import 'package:admin_panel/features/partner/products/presentation/layouts/product_add_desktop.dart';
import 'package:admin_panel/router/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProductAddScreen extends HookConsumerWidget {
  const ProductAddScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController imageController = TextEditingController();
    final TextEditingController statusController = TextEditingController();
    void onSave() {}
    void onCancel() {
      context.goNamed(ProductHomeRoute.name);
    }

    return ResponsiveWrapper(
      useLayout: true,
      desktop: ProductAddDesktop(
        formKey: formKey,
        nameController: nameController,
        priceController: priceController,
        descriptionController: descriptionController,
        categoryController: categoryController,
        imageController: imageController,
        statusController: statusController,
        onSave: onSave,
        onCancel: onCancel,
      ),
    );
  }
}
