import 'package:admin_panel/features/common/widgets/images/multi_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ProductMediaCard extends StatelessWidget {
  final List<dynamic> initialImages;
  final ValueChanged<List<dynamic>> onImagesChanged;

  const ProductMediaCard({
    super.key,
    this.initialImages = const [],
    required this.onImagesChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hidden FormBuilder field to store image URLs
        FormBuilderField<List<dynamic>>(
          name: 'product_images',
          initialValue: initialImages,
          builder: (field) => const SizedBox.shrink(),
        ),
        Container(
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Media Gallery',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Upload images or videos.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        _showAddFromUrlDialog(context);
                      },
                      child: Text(
                        'Add from URL',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: ImageUploadWidget(
                  initialImages: initialImages.whereType<String>().toList(),
                  onImagesChanged: (images) {
                    onImagesChanged(images);
                    // Update FormBuilder field
                    FormBuilder.of(
                      context,
                    )?.fields['product_images']?.didChange(images);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddFromUrlDialog(BuildContext parentContext) {
    final urlController = TextEditingController();
    final colorScheme = Theme.of(parentContext).colorScheme;

    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('Add Image from URL'),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(
            hintText: 'Enter image URL...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (urlController.text.isNotEmpty) {
                // Add URL to images
                final newImages = [...initialImages, urlController.text];
                onImagesChanged(newImages);
                // Update FormBuilder field
                FormBuilder.of(
                  parentContext,
                )?.fields['product_images']?.didChange(newImages);
                Navigator.pop(context);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
