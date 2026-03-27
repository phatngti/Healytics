import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Represents a single option in a [SelectorSwitch].
///
/// - [label] — Display text shown on the switch segment.
/// - [value] — Underlying value associated with this option.
class SelectorSwitchOption {
  /// The text displayed on the switch segment.
  final String label;

  /// The underlying value for this option.
  final String value;

  /// Creates a [SelectorSwitchOption] with a [label] and [value].
  SelectorSwitchOption({required this.label, required this.value});
}

/// Controller for programmatically reading and writing the selected index
/// and value of a [SelectorSwitch].
///
/// Extends [ChangeNotifier] so listeners (including the switch widget itself)
/// are notified when the selection changes.
///
/// ```dart
/// final controller = SelectorSwitchController(initialIndex: 0);
/// // later…
/// controller.index = 1; // programmatically select the second option
/// print(controller.value?.label); // read current selection
/// ```
class SelectorSwitchController extends ChangeNotifier {
  int _index;
  SelectorSwitchOption? _value;

  /// Creates a controller with an optional [initialIndex] (defaults to 0).
  SelectorSwitchController({int initialIndex = 0}) : _index = initialIndex;

  /// The currently selected index.
  int get index => _index;

  /// The [SelectorSwitchOption] corresponding to the current index.
  SelectorSwitchOption? get value => _value;

  /// Sets the selected index and notifies listeners if it changed.
  set index(int value) {
    if (_index != value) {
      _index = value;
      notifyListeners();
    }
  }

  /// Updates the selected option and notifies listeners.
  void setValue(SelectorSwitchOption option) {
    _value = option;
    notifyListeners();
  }
}

/// A segmented toggle switch that allows the user to pick one option
/// from a horizontal list of [SelectorSwitchOption]s.
///
/// The selected segment is highlighted with the primary color, while
/// unselected segments use the surface container color. The transition
/// is animated for a polished UX.
///
/// ```dart
/// SelectorSwitch(
///   options: [
///     SelectorSwitchOption(label: 'Day', value: 'day'),
///     SelectorSwitchOption(label: 'Week', value: 'week'),
///     SelectorSwitchOption(label: 'Month', value: 'month'),
///   ],
///   onChanged: (index) => print('Selected index: $index'),
///   controller: _switchController, // optional
/// )
/// ```
class SelectorSwitch extends StatefulWidget {
  /// Callback fired when the user selects a different segment.
  final ValueChanged<int> onChanged;

  /// The list of options displayed as segments.
  final List<SelectorSwitchOption> options;

  /// Optional text style override for segment labels.
  final TextStyle? textStyle;

  /// Optional controller for programmatic read/write of the selection.
  final SelectorSwitchController? controller;

  /// Creates a [SelectorSwitch].
  const SelectorSwitch({
    super.key,
    required this.onChanged,
    required this.options,
    this.textStyle,
    this.controller,
  });

  @override
  State<SelectorSwitch> createState() => _SelectorSwitchState();
}

class _SelectorSwitchState extends State<SelectorSwitch> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.controller?.index ?? 0;
    if (widget.controller != null && widget.options.isNotEmpty) {
      widget.controller!.setValue(widget.options[_selectedIndex]);
    }
    widget.controller?.addListener(_handleControllerChange);
  }

  @override
  void didUpdateWidget(covariant SelectorSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChange);
      widget.controller?.addListener(_handleControllerChange);
      if (widget.controller != null) {
        _selectedIndex = widget.controller!.index;
      }
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChange);
    super.dispose();
  }

  void _handleControllerChange() {
    if (widget.controller != null &&
        widget.controller!.index != _selectedIndex) {
      setState(() {
        _selectedIndex = widget.controller!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppDimens.responsiveValue<EdgeInsets>(
        context,
        mobile: const EdgeInsets.all(4),
        web: const EdgeInsets.all(6),
      ),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest, // Dark background (Slate-800)
        borderRadius: AppDimens.radiusSmall,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.options.length,
          (index) =>
              _buildButton(index: index, text: widget.options[index].label),
        ),
      ),
    );
  }

  Widget _buildButton({required int index, required String text}) {
    final isSelected = _selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (_selectedIndex != index) {
            setState(() => _selectedIndex = index);
            widget.controller?.index = index;
            widget.controller?.setValue(widget.options[index]);
            widget.onChanged(index);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          padding: AppDimens.paddingVerticalSmall,
          decoration: BoxDecoration(
            // If selected: Lighter Blue/Grey. If not: Transparent.
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: AppDimens.radiusSmall,
          ),
          child: Text(
            text,
            style:
                widget.textStyle?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ) ??
                Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface,
                ),
          ),
        ),
      ),
    );
  }
}
