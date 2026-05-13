import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:common/widgets/images/multi_picker.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

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

  void _showAddFromUrlDialog(
    BuildContext parentContext,
    FormFieldState<List<dynamic>> field,
  ) {
    final urlController = TextEditingController();
    final colorScheme = Theme.of(parentContext).colorScheme;
    bool isLoading = false;

    showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Image from URL'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: urlController,
                    decoration: InputDecoration(
                      hintText: 'Enter image URL...',
                      border: OutlineInputBorder(
                        borderRadius: AppDimens.radiusSmall,
                      ),
                      enabled: !isLoading,
                    ),
                  ),
                  if (isLoading) ...[
                    AppDimens.verticalMedium,
                    const CircularProgressIndicator(),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (urlController.text.isNotEmpty) {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              final url = urlController.text;
                              final uri = Uri.parse(url);
                              final response = await http.get(uri);

                              if (response.statusCode == 200) {
                                final Uint8List bytes = response.bodyBytes;
                                final String fileName =
                                    uri.pathSegments.isNotEmpty
                                    ? uri.pathSegments.last
                                    : 'image_from_url.jpg';

                                final xFile = XFile.fromData(
                                  bytes,
                                  name: fileName,
                                );

                                // Upload file to S3
                                final key = await ref
                                    .read(s3ServiceProvider)
                                    .uploadFile(xFile);

                                if (key != null) {
                                  final r2Url = await ref
                                      .read(s3ServiceProvider)
                                      .getFileUrl(key);

                                  if (r2Url != null && parentContext.mounted) {
                                    // Add URL to images
                                    final currentImages = field.value ?? [];
                                    final newImages = [...currentImages, r2Url];
                                    field.didChange(newImages);
                                    Navigator.pop(context);
                                  } else {
                                    throw Exception('Failed to get file URL');
                                  }
                                } else {
                                  throw Exception('Upload returned null key');
                                }
                              } else {
                                throw Exception(
                                  'Failed to download image: ${response.statusCode}',
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error: $e'),
                                    backgroundColor: colorScheme.error,
                                  ),
                                );
                              }
                            } finally {
                              if (context.mounted) {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
