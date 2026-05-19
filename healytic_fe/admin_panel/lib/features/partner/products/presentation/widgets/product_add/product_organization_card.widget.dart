import 'package:admin_panel/features/partner/products/domain/product_form_field.dart';
import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_openapi/api.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Card widget for product organization (category & tags).
class ProductOrganizationCard extends ConsumerStatefulWidget {
  final String? initialCategory;

  /// Initial selected **tag IDs** (UUIDs), not tag names.
  final List<String> initialTagIds;
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<List<String>>? onTagsChanged;

  const ProductOrganizationCard({
    super.key,
    this.initialCategory,
    this.initialTagIds = const [],
    this.onCategoryChanged,
    this.onTagsChanged,
  });

  @override
  ConsumerState<ProductOrganizationCard> createState() =>
      _ProductOrganizationCardState();
}

class _ProductOrganizationCardState
    extends ConsumerState<ProductOrganizationCard> {
  late String? _category;

  /// Holds the currently selected **tag IDs** (UUIDs).
  late List<String> _selectedTagIds;
  late Future<List<CategoryEntity>> _categoriesFuture;
  late Future<List<ServiceTagResponseDto>> _tagsFuture;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _selectedTagIds = List.from(widget.initialTagIds);

    final notifier = ref.read(productProvider.notifier);
    _categoriesFuture = notifier.getCategoriesForProduct();
    _tagsFuture = notifier.getServiceTagsForProduct();
  }

  @override
  void didUpdateWidget(ProductOrganizationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      _category = widget.initialCategory;
    }

    if (!_sameStringList(oldWidget.initialTagIds, widget.initialTagIds)) {
      final updatedTagIds = List<String>.from(widget.initialTagIds);
      setState(() => _selectedTagIds = updatedTagIds);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _syncFormField(updatedTagIds),
      );
    }
  }

  bool _sameStringList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppDimens.paddingAllMediumLarge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ORGANIZATION',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          AppDimens.verticalMedium,
          _buildCategoryDropdown(),
          AppDimens.verticalMedium,
          _buildTagsField(),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return FutureBuilder<List<CategoryEntity>>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final categories = snapshot.data ?? [];

        return FormFieldBuilders.buildCustomDropdownField<String>(
          context,
          fieldKey: ProductFormField.category.key,
          hintText: 'Select category...',
          initialValue: _category,
          label: 'Category',
          isRequired: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Category is required';
            }
            return null;
          },
          items: categories
              .map(
                (cat) => DropdownMenuItem(
                  value: cat.id,
                  child: Text(cat.name),
                ),
              )
              .toList(),
          onChanged: (val) {
            setState(() => _category = val);
            widget.onCategoryChanged?.call(val);
          },
        );
      },
    );
  }

  Widget _buildTagsField() {
    return FutureBuilder<List<ServiceTagResponseDto>>(
      future: _tagsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final allTags = snapshot.data ?? [];

        // Build a lookup map: id → name for display purposes only.
        final tagNameById = {for (final t in allTags) t.id: t.name};

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hidden FormBuilderField to persist selected IDs into FormBuilder.
            FormBuilderField<List<String>>(
              name: ProductFormField.tags.key,
              initialValue: _selectedTagIds,
              builder: (field) => const SizedBox.shrink(),
            ),
            FormFieldBuilders.buildChipSelectorField(
              context,
              label: 'Tags (optional)',
              emptyPlaceholder: 'Select tags...',
              chips: _selectedTagIds
                  .map((id) {
                    final name = tagNameById[id] ?? id;
                    return Chip(
                      label: Text(name),
                      deleteIcon: const Icon(Icons.close, size: 14),
                      onDeleted: () {
                        final updated = List<String>.from(_selectedTagIds)
                          ..remove(id);
                        setState(() => _selectedTagIds = updated);
                        _syncFormField(updated);
                        widget.onTagsChanged?.call(updated);
                      },
                    );
                  })
                  .toList(),
              onTap: () => _showTagSelectionDialog(context, allTags),
            ),
          ],
        );
      },
    );
  }

  /// Writes the current tag ID selection back into the [FormBuilder] state
  /// so that [ProductAddScreen._submitForm] can read it via form data.
  void _syncFormField(List<String> ids) {
    final formState = FormBuilder.of(context);
    formState?.fields[ProductFormField.tags.key]?.didChange(ids);
  }

  /// Shows a dialog for selecting tags.
  /// Operates entirely on tag **IDs** to ensure correct data is persisted.
  void _showTagSelectionDialog(
    BuildContext context,
    List<ServiceTagResponseDto> allTags,
  ) {
    showDialog(
      context: context,
      builder: (context) => _TagSelectionDialog(
        allTags: allTags,
        selectedTagIds: _selectedTagIds,
        onConfirm: (selectedIds) {
          setState(() => _selectedTagIds = selectedIds);
          _syncFormField(selectedIds);
          widget.onTagsChanged?.call(selectedIds);
        },
      ),
    );
  }
}

/// Dialog for selecting tags from available options.
/// Operates entirely on tag **IDs** internally.
class _TagSelectionDialog extends StatefulWidget {
  final List<ServiceTagResponseDto> allTags;
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onConfirm;

  const _TagSelectionDialog({
    required this.allTags,
    required this.selectedTagIds,
    required this.onConfirm,
  });

  @override
  State<_TagSelectionDialog> createState() => _TagSelectionDialogState();
}

class _TagSelectionDialogState extends State<_TagSelectionDialog> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedTagIds);
  }

  void _toggleTag(String tagId) {
    setState(() {
      if (_tempSelected.contains(tagId)) {
        _tempSelected.remove(tagId);
      } else {
        _tempSelected.add(tagId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(
        'Select Tags',
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      content: SizedBox(
        width: 300,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.allTags.map((tag) {
              final isSelected = _tempSelected.contains(tag.id);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (_) => _toggleTag(tag.id),
                title: Text(
                  tag.name,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                activeColor: colorScheme.primary,
                dense: true,
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            widget.onConfirm(_tempSelected);
            Navigator.of(context).pop();
          },
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}
