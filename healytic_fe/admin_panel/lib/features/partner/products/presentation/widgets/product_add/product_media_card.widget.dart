import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:common/widgets/images/multi_picker.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProductMediaCard extends ConsumerStatefulWidget {
  const ProductMediaCard({super.key});

  @override
  ConsumerState<ProductMediaCard> createState() => _ProductMediaCardState();
}

class _ProductMediaCardState extends ConsumerState<ProductMediaCard> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilderField<List<dynamic>>(
      name: ProductFormField.productImages.key,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'At least one image is required';
        }
        return null;
      },
      builder: (FormFieldState<List<dynamic>> field) {
        final currentImages = field.value ?? [];
        final hasError = field.errorText != null;

        return Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: AppDimens.radiusMediumSmall,
            border: Border.all(
              color: hasError ? colorScheme.error : colorScheme.outlineVariant,
            ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Media Gallery',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
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
                        AppDimens.verticalExtraSmall,
                        Text(
                          'Upload at least one image.',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content
              Padding(
                padding: AppDimens.paddingAllLarge,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageUploadWidget(
                      initialImages: currentImages.whereType<String>().toList(),
                      onImagesChanged: (images) {
                        field.didChange(images);
                      },
                      onUpload: (XFile file) async {
                        final key = await ref
                            .read(s3ServiceProvider)
                            .uploadFile(file);
                        if (key != null) {
                          final url = await ref
                              .read(s3ServiceProvider)
                              .getFileUrl(key);
                          if (url != null) return url;
                          return key;
                        }
                        throw Exception('Upload failed');
                      },
                    ),
                    if (hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          field.errorText!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.error),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
