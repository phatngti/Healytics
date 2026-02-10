import 'package:common/widgets/input/form_field_builders.dart';
import 'package:admin_panel/features/partner/products/domain/category.entity.dart';
import 'package:admin_panel/features/partner/products/presentation/providers/product.provider.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  late List<String> _tags;
  final TextEditingController _tagController = TextEditingController();
  List<CategoryEntity> _categories = [];
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _category = widget.initialCategory;
    _tags = List.from(widget.initialTags);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ref
          .read(productProvider.notifier)
          .getCategoriesForProduct();
      if (mounted) {
        setState(() {
          _categories = categories;
          _isLoadingCategories = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _tagController.dispose();
    super.dispose();
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
      });
      _tagController.clear();
      widget.onTagsChanged?.call(_tags);
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
    widget.onTagsChanged?.call(_tags);
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
          // Category Dropdown
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              _isLoadingCategories
                  ? const Center(
                      child: Padding(
                        padding: AppDimens.paddingAllSmall,
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : FormFieldBuilders.buildCustomDropdownField<String>(
                      context,
                      fieldKey: 'category',
                      hintText: 'Select category...',
                      initialValue: _category,
                      label: 'Category',
                      items: _categories
                          .map(
                            (cat) => DropdownMenuItem(
                              value: cat.id,
                              child: Text(cat.name),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
          AppDimens.verticalMedium,
          // Tags
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tags',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _tagController,
                decoration: InputDecoration(
                  hintText: 'Add tags...',
                  filled: true,
                  fillColor: colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
                onFieldSubmitted: _addTag,
              ),
              if (_tags.isNotEmpty) ...[
                AppDimens.verticalSmall,
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _tags
                      .map(
                        (tag) =>
                            _TagChip(tag: tag, onRemove: () => _removeTag(tag)),
                      )
                      .toList(),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String tag;
  final VoidCallback onRemove;

  const _TagChip({required this.tag, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding:
          AppDimens.paddingHorizontalSmall +
          AppDimens.paddingVerticalExtraSmall,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: AppDimens.radiusExtraSmall,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          AppDimens.horizontalExtraSmall,
          InkWell(
            onTap: onRemove,
            child: Icon(
              Icons.close,
              size: 14,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
