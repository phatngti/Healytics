import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// A reusable multi-select chip field with search functionality.
/// Allows users to select from existing options or create new ones.
class AppMultiSelectChipField extends StatefulWidget {
  /// The form field key/name used by FormBuilder.
  final String fieldKey;

  /// The label displayed above the field.
  final String label;

  /// Optional label text style.
  final TextStyle? labelStyle;

  /// List of available options for selection.
  final List<String> availableOptions;

  /// Initial selected values.
  final List<String>? initialValue;

  /// Placeholder text for the search input.
  final String searchHint;

  /// Helper text shown below the field when there's no error.
  final String? helperText;

  /// Whether the field is required.
  final bool isRequired;

  /// Whether to allow creating new options by typing.
  final bool allowCreate;

  /// Optional validator function.
  final String? Function(List<String>?)? validator;

  /// Callback when the selection changes.
  final ValueChanged<List<String>>? onChanged;

  /// Chip background color.
  final Color? chipBackgroundColor;

  /// Chip border color.
  final Color? chipBorderColor;

  /// Chip text color.
  final Color? chipTextColor;

  const AppMultiSelectChipField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.labelStyle,
    this.availableOptions = const [],
    this.initialValue,
    this.searchHint = 'Search...',
    this.helperText,
    this.isRequired = false,
    this.allowCreate = true,
    this.validator,
    this.onChanged,
    this.chipBackgroundColor,
    this.chipBorderColor,
    this.chipTextColor,
  });

  @override
  State<AppMultiSelectChipField> createState() =>
      _AppMultiSelectChipFieldState();
}

class _AppMultiSelectChipFieldState extends State<AppMultiSelectChipField> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.availableOptions;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredOptions = widget.availableOptions;
      } else {
        _filteredOptions = widget.availableOptions
            .where((option) => option.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FormBuilderField<List<String>>(
      name: widget.fieldKey,
      initialValue: widget.initialValue ?? [],
      validator: widget.validator,
      builder: (FormFieldState<List<String>> field) {
        final selectedItems = field.value ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label,
              style:
                  widget.labelStyle ??
                  Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: field.hasError
                      ? Theme.of(context).colorScheme.error
                      : colorScheme.outlineVariant,
                ),
                color: colorScheme.surface,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...selectedItems.map((item) => _buildChip(item, field)),
                      SizedBox(
                        width: 150,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: widget.searchHint,
                            hintStyle: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            filled: false,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 8,
                            ),
                            isDense: true,
                          ),
                          onSubmitted: (value) {
                            if (widget.allowCreate &&
                                value.isNotEmpty &&
                                !selectedItems.contains(value)) {
                              final newList = [...selectedItems, value];
                              field.didChange(newList);
                              widget.onChanged?.call(newList);
                              _searchController.clear();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (_searchController.text.isNotEmpty &&
                      _filteredOptions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      constraints: const BoxConstraints(maxHeight: 120),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _filteredOptions
                              .where(
                                (option) => !selectedItems.contains(option),
                              )
                              .map(
                                (option) => ActionChip(
                                  label: Text(option),
                                  onPressed: () {
                                    final newList = [...selectedItems, option];
                                    field.didChange(newList);
                                    widget.onChanged?.call(newList);
                                    _searchController.clear();
                                  },
                                  backgroundColor:
                                      colorScheme.surfaceContainerHighest,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            if (field.hasError)
              Text(
                field.errorText ?? '',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              )
            else if (widget.helperText != null)
              Text(
                widget.helperText!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildChip(String item, FormFieldState<List<String>> field) {
    final chipBg = widget.chipBackgroundColor ?? Colors.green.shade50;
    final chipBorder = widget.chipBorderColor ?? Colors.green.shade100;
    final chipText = widget.chipTextColor ?? Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item,
            style: TextStyle(
              color: chipText,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: () {
              final currentItems = field.value ?? [];
              final newList = currentItems.where((i) => i != item).toList();
              field.didChange(newList);
              widget.onChanged?.call(newList);
            },
            child: Icon(Icons.close, size: 14, color: chipText),
          ),
        ],
      ),
    );
  }
}
