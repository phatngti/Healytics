import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:admin_openapi/api.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Card widget for product organization (category & tags).
class ProductOrganizationCard extends ConsumerStatefulWidget {
  final String? initialCategory;
  final List<String> initialTags;
  final ValueChanged<String?>? onCategoryChanged;
  final ValueChanged<List<String>>? onTagsChanged;

  const ProductOrganizationCard({
    super.key,
    this.initialCategory,
    this.initialTags = const [],
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
  late List<String> _selectedTags;
  late Future<List<CategoryEntity>> _categoriesFuture;
  late Future<List<ServiceTagResponseDto>> _tagsFuture;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _selectedTags = List.from(widget.initialTags);

    final notifier = ref.read(productProvider.notifier);
    _categoriesFuture = notifier.getCategoriesForProduct();
    _tagsFuture = notifier.getServiceTagsForProduct();
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
          fieldKey: 'category',
          hintText: 'Select category...',
          initialValue: _category,
          label: 'Category',
          items: categories
              .map(
                (cat) => DropdownMenuItem(value: cat.id, child: Text(cat.name)),
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

        return FormFieldBuilders.buildChipSelectorField(
          context,
          label: 'Tags',
          emptyPlaceholder: 'Select tags...',
          chips: _selectedTags
              .map(
                (tag) => Chip(
                  label: Text(tag),
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () {
                    setState(() {
                      _selectedTags.remove(tag);
                    });
                    widget.onTagsChanged?.call(_selectedTags);
                  },
                ),
              )
              .toList(),
          onTap: () => _showTagSelectionDialog(context, allTags),
        );
      },
    );
  }

  /// Shows a dialog for selecting tags.
  void _showTagSelectionDialog(
    BuildContext context,
    List<ServiceTagResponseDto> allTags,
  ) {
    showDialog(
      context: context,
      builder: (context) => _TagSelectionDialog(
        allTags: allTags,
        selectedTags: _selectedTags,
        onConfirm: (selected) {
          setState(() {
            _selectedTags = selected;
          });
          widget.onTagsChanged?.call(_selectedTags);
        },
      ),
    );
  }
}

/// Dialog for selecting tags from available options.
class _TagSelectionDialog extends StatefulWidget {
  final List<ServiceTagResponseDto> allTags;
  final List<String> selectedTags;
  final ValueChanged<List<String>> onConfirm;

  const _TagSelectionDialog({
    required this.allTags,
    required this.selectedTags,
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
    _tempSelected = List.from(widget.selectedTags);
  }

  void _toggleTag(String tagName) {
    setState(() {
      if (_tempSelected.contains(tagName)) {
        _tempSelected.remove(tagName);
      } else {
        _tempSelected.add(tagName);
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
              final isSelected = _tempSelected.contains(tag.name);
              return CheckboxListTile(
                value: isSelected,
                onChanged: (_) => _toggleTag(tag.name),
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
