import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class SelectorSwitchOption {
  final String label;
  final String value;

  SelectorSwitchOption({required this.label, required this.value});
}

class SelectorSwitchController extends ChangeNotifier {
  int _index;
  SelectorSwitchOption? _value;

  SelectorSwitchController({int initialIndex = 0}) : _index = initialIndex;

  int get index => _index;
  SelectorSwitchOption? get value => _value;

  set index(int value) {
    if (_index != value) {
      _index = value;
      notifyListeners();
    }
  }

  void setValue(SelectorSwitchOption option) {
    _value = option;
    notifyListeners();
  }
}

class SelectorSwitch extends StatefulWidget {
  final ValueChanged<int> onChanged;
  final List<SelectorSwitchOption> options;
  final TextStyle? textStyle;
  final SelectorSwitchController? controller;

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
      padding: const EdgeInsets.all(5),
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
