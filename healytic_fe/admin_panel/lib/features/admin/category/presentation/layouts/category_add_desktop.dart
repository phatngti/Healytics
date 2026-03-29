import 'package:common/widgets/button/back_button.dart';
import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/admin/category/domain/category_form_field.dart';
import 'package:admin_panel/features/admin/category/domain/category_status.dart';
import 'package:admin_panel/router/admin_routes.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';

class CategoryAddDesktop extends StatefulWidget {
  final VoidCallback? onCancel;
  final ValueChanged<Map<String, dynamic>>? onSubmit;
  final Map<String, dynamic> initialValue;

  const CategoryAddDesktop({
    super.key,
    this.onCancel,
    this.onSubmit,
    this.initialValue = const {},
  });

  @override
  State<CategoryAddDesktop> createState() => _CategoryAddDesktopState();
}

class _CategoryAddDesktopState extends State<CategoryAddDesktop> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isLoading = false;

  void _handleSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      setState(() => _isLoading = true);
      try {
        widget.onSubmit?.call(_formKey.currentState!.value);
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FormBuilder(
      key: _formKey,
      initialValue: widget.initialValue,
      child: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              bottom: 24.0,
              top: 100, // Height for the floating header
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Information Card
                    _buildFormCard(
                      context,
                      title: 'Category Information',
                      icon: Icons.category_outlined,
                      children: [
                        // Category Name Field
                        FormFieldBuilders.buildTextField(
                          context,
                          label: 'Category Name',
                          hintText: 'Enter category name',
                          isRequired: true,
                          prefixIcon: Icons.label_outline,
                          validator: (value) {
                            if (value == null ||
                                value.toString().trim().isEmpty) {
                              return 'Category name is required';
                            }
                            if (value.toString().trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        AppDimens.verticalMedium,
                        // Description Field
                        FormFieldBuilders.buildTextField(
                          context,
                          label: 'Description',
                          hintText: 'Enter category description (optional)',
                          maxLines: 4,
                          validator: (value) {
                            if (value != null &&
                                value.toString().length > 500) {
                              return 'Description cannot exceed 500 characters';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    AppDimens.verticalLarge,
                    // Category Settings Card
                    _buildFormCard(
                      context,
                      title: 'Category Settings',
                      icon: Icons.settings_outlined,
                      children: [
                        // Status Dropdown
                        FormFieldBuilders.buildDropdownField(
                          context,
                          label: 'Status',
                          items: CategoryStatus.values
                              .map(
                                (s) => s.displayName,
                              )
                              .toList(),
                          initialValue:
                              CategoryStatus.active.displayName,
                          hintText: 'Select status',
                        ),
                        AppDimens.verticalMedium,
                        // Sort Order Field
                        FormFieldBuilders.buildTextField(
                          context,
                          label: 'Sort Order',
                          hintText: 'Enter display order (e.g., 0, 1, 2)',
                          initialValue: '0',
                          keyboardType: TextInputType.number,
                          prefixIcon: Icons.sort,
                          validator: (value) {
                            if (value != null && value.toString().isNotEmpty) {
                              final number = int.tryParse(value.toString());
                              if (number == null) {
                                return 'Please enter a valid number';
                              }
                            }
                            return null;
                          },
                        ),
                        AppDimens.verticalMedium,
                        // Icon Selection (Text field for icon name)
                        FormFieldBuilders.buildTextField(
                          context,
                          label: 'Icon Name',
                          hintText:
                              'Enter Material icon name (e.g., spa, category)',
                          prefixIcon: Icons.emoji_symbols_outlined,
                        ),
                        AppDimens.verticalMedium,
                        // Color Selection
                        FormFieldBuilders.buildTextField(
                          context,
                          label: 'Color (Hex)',
                          fieldKey:
                              CategoryFormField.colorHex.key,
                          hintText: 'Enter hex color (e.g., #1A7B99)',
                          prefixIcon: Icons.color_lens_outlined,
                          validator: (value) {
                            if (value != null && value.toString().isNotEmpty) {
                              final hexPattern = RegExp(
                                r'^#?([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$',
                              );
                              if (!hexPattern.hasMatch(value.toString())) {
                                return 'Please enter a valid hex color';
                              }
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Floating header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: colorScheme.outlineVariant),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withAlpha(8),
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
                      AppBackButton(
                        onTap:
                            widget.onCancel ??
                            () {
                              context.goNamed(CategoryHomeRoute.name);
                            },
                      ),
                      AppDimens.horizontalMedium,
                      Text(
                        'Create Category',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  _buildFormActions(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: colorScheme.primary),
              AppDimens.horizontalSmall,
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppDimens.verticalMedium,
          Divider(color: colorScheme.outlineVariant, height: 1),
          AppDimens.verticalMedium,
          ...children,
        ],
      ),
    );
  }

  Widget _buildFormActions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        AppButton(
          buttonType: ButtonType.outline,
          onPressed: _isLoading ? null : widget.onCancel,
          child: const Text('Cancel'),
        ),
        AppDimens.horizontalSmall,
        AppButton(
          buttonType: ButtonType.elevated,
          onPressed: _isLoading ? null : _handleSubmit,
          isLoading: _isLoading,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_circle_outline,
                size: 18,
                color: colorScheme.onPrimary,
              ),
              AppDimens.horizontalSmall,
              const Text('Create Category'),
            ],
          ),
        ),
      ],
    );
  }
}
