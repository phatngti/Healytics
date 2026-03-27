part of 'form_field_builders.dart';

/// A multi-select picker field that shows selected items as chips
/// and opens a dialog with a searchable checkbox list for selection.
///
/// Used by [FormFieldBuilders.buildMultiSelectPopoverField]. Chips can
/// be individually removed, and the dialog supports search filtering
/// with confirm/cancel actions.
class MultiSelectPickerField<T> extends StatefulWidget {
  /// Label text displayed above the field.
  final String label;

  /// Map of selectable items — keys are values, entries are display labels.
  final Map<T, String> items;

  /// Initially selected values.
  final List<T>? initialValue;

  /// Called whenever the selection changes.
  final ValueChanged<List<T>>? onChanged;

  /// Validator function for form validation.
  final String? Function(List<T>?)? validator;

  /// Placeholder text shown when nothing is selected.
  final String searchHint;

  /// Helper text shown below the field.
  final String? helperText;

  /// Whether the field is required (shows asterisk).
  final bool isRequired;

  /// Custom label text style.
  final TextStyle? labelStyle;

  /// Container width constraint.
  final double? width;

  /// Container height constraint.
  final double? height;

  /// Whether the field is enabled.
  final bool enabled;

  /// Creates a [MultiSelectPickerField].
  const MultiSelectPickerField({
    super.key,
    required this.label,
    required this.items,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.searchHint = 'Search...',
    this.helperText,
    this.isRequired = false,
    this.labelStyle,
    this.width,
    this.height,
    this.enabled = true,
  });

  @override
  State<MultiSelectPickerField<T>> createState() =>
      _MultiSelectPickerFieldState<T>();
}

class _MultiSelectPickerFieldState<T> extends State<MultiSelectPickerField<T>> {
  @override
  Widget build(BuildContext context) {
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;
    final isEnabled = widget.enabled && formEnabled;

    return FormBuilderField<List<T>>(
      name: widget.label.toLowerCase().replaceAll(' ', '_'),
      initialValue: widget.initialValue ?? [],
      validator: widget.validator,
      enabled: isEnabled,
      builder: (FormFieldState<List<T>> field) {
        final selectedValues = field.value ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
            InkWell(
              onTap: isEnabled ? () => _showPicker(context, field) : null,
              child: InputDecorator(
                isFocused: false,
                isEmpty: selectedValues.isEmpty,
                decoration: InputDecoration(
                  enabled: isEnabled,
                  hintText: selectedValues.isEmpty ? widget.searchHint : null,
                  helperText: widget.helperText,
                  errorText: field.errorText,
                  filled: true,
                  fillColor: isEnabled
                      ? Theme.of(context).colorScheme.surface
                      : Theme.of(context).colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: AppDimens.paddingHorizontalSmall.left,
                    vertical: AppDimens.paddingVerticalSmall.top,
                  ),
                ),
                child: selectedValues.isEmpty
                    ? const SizedBox.shrink()
                    : Wrap(
                        spacing: 2.0,
                        runSpacing: 4.0,
                        children: selectedValues.map((value) {
                          return Chip(
                            label: Text(
                              widget.items[value] ?? value.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            deleteIcon: Icon(
                              Icons.close,
                              size: AppDimens.fontSizeLarge,
                            ),
                            onDeleted: isEnabled
                                ? () {
                                    final newValues = List<T>.from(
                                      selectedValues,
                                    );
                                    newValues.remove(value);
                                    field.didChange(newValues);
                                    widget.onChanged?.call(newValues);
                                  }
                                : null,
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPicker(BuildContext context, FormFieldState<List<T>> field) {
    final currentSelection = List<T>.from(field.value ?? []);

    showDialog(
      context: context,
      builder: (dialogContext) {
        // Use separate state for the dialog to handle "Draft" selection
        List<T> draftSelection = List.from(currentSelection);
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setState) {
            final filteredItems = widget.items.entries.where((entry) {
              return entry.value.toLowerCase().contains(
                searchQuery.toLowerCase(),
              );
            }).toList();

            return AlertDialog(
              title: Text('Select ${widget.label}'),
              contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: widget.searchHint,
                        prefixIcon: const Icon(Icons.search),
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: AppDimens.radiusSmall,
                        ),
                      ),
                    ),
                    AppDimens.verticalMediumSmall,
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.4,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final entry = filteredItems[index];
                          final isSelected = draftSelection.contains(entry.key);

                          return CheckboxListTile(
                            title: Text(entry.value),
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  draftSelection.add(entry.key);
                                } else {
                                  draftSelection.remove(entry.key);
                                }
                              });
                            },
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // Update the actual field only on Confirm
                    field.didChange(draftSelection);
                    widget.onChanged?.call(draftSelection);
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
