part of 'form_field_builders.dart';

/// A reusable multi-select chip field with search functionality.
/// Allows users to select from existing options or create new ones.
class _AppMultiSelectChipField<T> extends StatefulWidget {
  /// The form field key/name used by FormBuilder.
  final String fieldKey;

  /// The label displayed above the field.
  final String label;

  /// Optional label text style.
  final TextStyle? labelStyle;

  /// List of available options for selection.
  final Map<T, String> availableOptions;

  /// Initial selected values.
  final List<T>? initialValue;

  /// Placeholder text for the search input.
  final String searchHint;

  /// Helper text shown below the field when there's no error.
  final String? helperText;

  /// Whether the field is required.
  final bool isRequired;

  /// Whether to allow creating new options by typing.
  final bool allowCreate;

  /// Optional validator function.
  final String? Function(List<T>?)? validator;

  /// Callback when the selection changes.
  final ValueChanged<List<T>>? onChanged;

  /// Chip background color.
  final Color? chipBackgroundColor;

  /// Chip border color.
  final Color? chipBorderColor;

  /// Chip text color.
  final Color? chipTextColor;

  /// Custom width for the field container.
  final double? width;

  /// Custom height for the field container.
  final double? height;

  /// Whether the field is enabled.
  final bool enabled;

  const _AppMultiSelectChipField({
    super.key,
    required this.fieldKey,
    required this.label,
    this.labelStyle,
    this.availableOptions = const {},
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
    this.width,
    this.height,
    this.enabled = true,
  });

  @override
  State<_AppMultiSelectChipField<T>> createState() =>
      _AppMultiSelectChipFieldState<T>();
}

class _AppMultiSelectChipFieldState<T>
    extends State<_AppMultiSelectChipField<T>> {
  final TextEditingController _searchController = TextEditingController();
  Map<T, String> _filteredOptions = {};

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
        _filteredOptions = Map.fromEntries(
          widget.availableOptions.entries.where(
            (entry) => entry.value.toLowerCase().contains(query),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isEnabled = widget.enabled && formEnabled;

    return FormBuilderField<List<T>>(
      name: widget.fieldKey,
      initialValue: widget.initialValue ?? [],
      validator: widget.validator,
      enabled: isEnabled,
      builder: (FormFieldState<List<T>> field) {
        final selectedItems = field.value ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.label.toUpperCase(),
              style:
                  widget.labelStyle ??
                  Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
            ),
            AppDimens.verticalSmall,
            Container(
              width: widget.width,
              height: widget.height,
              padding: AppDimens.paddingAllSmall,
              decoration: BoxDecoration(
                borderRadius: AppDimens.radiusSmall,
                border: Border.all(
                  color: field.hasError
                      ? Theme.of(context).colorScheme.error
                      : colorScheme.outlineVariant,
                ),
                color: isEnabled
                    ? colorScheme.surface
                    : colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      ...selectedItems.map(
                        (item) => _buildChip(item, field, isEnabled),
                      ),
                      SizedBox(
                        child: TextField(
                          controller: _searchController,
                          enabled: isEnabled,
                          decoration: InputDecoration(
                            hintText: isEnabled ? widget.searchHint : '',
                            hintStyle: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: AppDimens.fontSizeMedium,
                                ),
                            border: InputBorder.none,
                            filled: false,
                            isDense: true,
                          ),
                          onSubmitted: (value) {
                            if (widget.allowCreate &&
                                value.isNotEmpty &&
                                T == String &&
                                !selectedItems.contains(value as T)) {
                              final newList = [...selectedItems, value as T];
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
                      _filteredOptions.isNotEmpty &&
                      isEnabled)
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      constraints: const BoxConstraints(maxHeight: 120),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _filteredOptions.entries
                              .where(
                                (entry) => !selectedItems.contains(entry.key),
                              )
                              .map(
                                (entry) => ActionChip(
                                  label: Text(entry.value),
                                  onPressed: isEnabled
                                      ? () {
                                          final newList = [
                                            ...selectedItems,
                                            entry.key,
                                          ];
                                          field.didChange(newList);
                                          widget.onChanged?.call(newList);
                                          _searchController.clear();
                                        }
                                      : null,
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
            AppDimens.verticalExtraSmall,
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

  Widget _buildChip(T item, FormFieldState<List<T>> field, bool isEnabled) {
    final chipBg = widget.chipBackgroundColor ?? Colors.green.shade50;
    final chipBorder = widget.chipBorderColor ?? Colors.green.shade100;
    final chipText = widget.chipTextColor ?? Colors.green.shade700;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: isEnabled
            ? chipBg
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEnabled ? chipBorder : Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.availableOptions[item] ?? item.toString(),
            style: TextStyle(
              color: isEnabled
                  ? chipText
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
              fontSize: AppDimens.fontSizeSmall,
            ),
          ),
          if (isEnabled) ...[
            AppDimens.horizontalExtraSmall,
            InkWell(
              onTap: () {
                final currentItems = field.value ?? [];
                final newList = currentItems.where((i) => i != item).toList();
                field.didChange(newList);
                widget.onChanged?.call(newList);
              },
              child: Icon(
                Icons.close,
                size: AppDimens.fontSizeMedium,
                color: chipText,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
