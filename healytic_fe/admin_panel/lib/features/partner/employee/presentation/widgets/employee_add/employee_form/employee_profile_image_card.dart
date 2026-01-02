import 'package:admin_panel/core/providers/s3.provider.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

class EmployeeProfileImageCard extends ConsumerStatefulWidget {
  const EmployeeProfileImageCard({super.key});

  @override
  ConsumerState<EmployeeProfileImageCard> createState() =>
      _EmployeeProfileImageCardState();
}

class _EmployeeProfileImageCardState
    extends ConsumerState<EmployeeProfileImageCard> {
  XFile? _selectedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(FormFieldState<String> field) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile;
          _isUploading = true;
        });

        // Upload to S3
        try {
          final key = await ref.read(s3ServiceProvider).uploadFile(pickedFile);
          if (key != null) {
            // Get URL
            final url = await ref.read(s3ServiceProvider).getFileUrl(key);

            if (mounted) {
              setState(() {
                _isUploading = false;
              });

              if (url != null) {
                // Update FormBuilder
                field.didChange(url);
                field.save();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Failed to get file URL'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            }
          }
        } catch (e) {
          debugPrint('Error uploading image: $e');
          if (mounted) {
            setState(() {
              _isUploading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error uploading image: $e'),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilderField<String>(
      name: 'avatar_url',
      builder: (field) {
        ImageProvider? imageProvider;
        if (_selectedImage != null) {
          if (kIsWeb) {
            imageProvider = NetworkImage(_selectedImage!.path);
          } else {
            imageProvider = FileImage(File(_selectedImage!.path));
          }
        } else if (field.value != null && field.value!.isNotEmpty) {
          imageProvider = NetworkImage(field.value!);
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: colorScheme.outlineVariant),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(4),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Profile Image',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: _isUploading ? null : () => _pickImage(field),
                        child: Stack(
                          children: [
                            Container(
                              width: 144,
                              height: 144,
                              decoration: BoxDecoration(
                                color: colorScheme.surfaceContainerHighest
                                    .withAlpha(50),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: colorScheme.outlineVariant,
                                  width: 2,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                                image: imageProvider != null
                                    ? DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child:
                                  _selectedImage == null && field.value == null
                                  ? Icon(
                                      Icons.add_a_photo_outlined,
                                      size: 40,
                                      color: colorScheme.onSurfaceVariant,
                                    )
                                  : null,
                            ),
                            if (_isUploading)
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black26,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_selectedImage == null && field.value == null) ...[
                      Text(
                        'Allowed *.jpeg, *.jpg, *.png, *.gif\nMax size of 3.1 MB',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
                      AppDimens.verticalMedium,
                    ],

                    OutlinedButton.icon(
                      onPressed: _isUploading ? null : () => _pickImage(field),
                      icon: Icon(
                        _selectedImage == null && field.value == null
                            ? Icons.upload_outlined
                            : Icons.edit_outlined,
                        size: 16,
                      ),
                      label: Text(
                        _isUploading
                            ? 'Uploading...'
                            : (_selectedImage == null && field.value == null
                                  ? 'Upload Image'
                                  : 'Change Image'),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: colorScheme.primary),
                        backgroundColor: colorScheme.primaryContainer,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
