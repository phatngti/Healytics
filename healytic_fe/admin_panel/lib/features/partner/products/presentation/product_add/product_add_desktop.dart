import 'package:admin_panel/features/common/widgets/button/back_button.dart';
import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/input/selection_field.dart';
import 'package:admin_panel/features/common/widgets/input/text_field.dart';
import 'package:admin_panel/features/common/widgets/quill.dart';
import 'package:admin_panel/core/providers/storage.provider.dart';
import 'package:admin_panel/features/common/widgets/images/multi_picker.dart';

import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProductAddDesktop extends ConsumerStatefulWidget {
  const ProductAddDesktop({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.priceController,
    required this.descriptionController,
    required this.categoryController,
    required this.imageController,
    required this.statusController,
    required this.onSave,
    required this.onCancel,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController imageController;
  final TextEditingController statusController;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  @override
  ConsumerState<ProductAddDesktop> createState() => _ProductAddDesktopState();
}

class _ProductAddDesktopState extends ConsumerState<ProductAddDesktop> {
  List<dynamic> _currentImages = [];

  Future<void> _handleSave() async {
    if (widget.formKey.currentState!.validate()) {
      // Upload pending images
      final List<String> finalImagePaths = [];
      final storageService = ref.read(storageServiceProvider);

      for (final image in _currentImages) {
        if (image is XFile) {
          final path = await storageService.uploadImage(image);
          finalImagePaths.add(path);
        } else if (image is String) {
          finalImagePaths.add(image);
        }
      }

      widget.imageController.text = finalImagePaths.join(',');
      widget.onSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Scrollable content with top padding to avoid overlap with floating header
        SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppDimens.paddingAllMedium.left,
            right: AppDimens.paddingAllMedium.right,
            bottom: AppDimens.paddingAllMedium.bottom,
            top: 80, // Height for the floating header
          ),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppDimens.verticalLarge,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: AppDimens.paddingAllMedium,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: AppDimens.radiusSmall,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surfaceDim,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Details',
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                AppDimens.verticalLarge,
                                AppTextField(
                                  fieldKey: "product_name",
                                  controller: widget.nameController,
                                  label: 'Product Name',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a product name';
                                    }
                                    return null;
                                  },
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                ),
                                AppDimens.verticalLarge,
                                AppTextField(
                                  fieldKey: "product_price",
                                  controller: widget.priceController,
                                  label: 'Price',
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a price';
                                    }
                                    return null;
                                  },
                                  labelStyle: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                      ),
                                ),
                                Text(
                                  'Set product price to 0 to make it free',
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                                AppDimens.verticalLarge,
                                Text(
                                  'Description',
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                AppDimens.verticalSmall,
                                FlutterQuillEditor(
                                  initialContent: [],
                                  onChanged: (value) {
                                    widget.descriptionController.text = value
                                        .toString();
                                  },
                                  height: 400,
                                  width: double.infinity,
                                ),
                              ],
                            ),
                          ),
                          AppDimens.verticalMedium,
                          Container(
                            width: double.infinity,
                            padding: AppDimens.paddingAllMedium,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: AppDimens.radiusSmall,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surfaceDim,
                              ),
                            ),
                            child: ImageUploadWidget(
                              initialImages: const [],
                              onImagesChanged: (images) {
                                setState(() {
                                  _currentImages = images;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    AppDimens.horizontalSmall,
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: AppDimens.paddingAllMedium,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: AppDimens.radiusSmall,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surfaceDim,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status',
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                AppDimens.verticalSmall,
                                AppSelectionField(
                                  initialValue: widget.statusController.text,
                                  fieldKey: "status",
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'active',
                                      child: Text('Active'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'inactive',
                                      child: Text('Inactive'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    widget.statusController.text = value!;
                                  },
                                ),
                                Text(
                                  'Set product status to active to make it visible to users',
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          AppDimens.verticalMedium,
                          Container(
                            padding: AppDimens.paddingAllMedium,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: AppDimens.radiusSmall,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surfaceDim,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Category',
                                  style: Theme.of(context).textTheme.titleSmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                AppDimens.verticalSmall,
                                AppSelectionField(
                                  initialValue: widget.categoryController.text,
                                  fieldKey: "category",
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'spa',
                                      child: Text('Spa'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'beauty',
                                      child: Text('Beauty'),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    widget.categoryController.text = value!;
                                  },
                                ),
                                Text(
                                  'Set product category to active to make it visible to users',
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(context).hintColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Floating header positioned at the top
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: AppDimens.paddingAllMedium,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.surfaceDim,
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
                      'Add Product',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    AppButton(
                      buttonType: ButtonType.elevated,
                      onPressed: widget.onCancel,

                      customStyle: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).colorScheme.outline,
                        ),
                      ),
                      child: const Text('Discard'),
                    ),
                    AppDimens.horizontalSmall,
                    AppButton(
                      buttonType: ButtonType.elevated,
                      onPressed: _handleSave,
                      child: const Text('Create'),
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
