import 'package:common/widgets/button/button.dart';
import 'package:common/widgets/table/function_button.dart';
import 'package:common/utils/demensions.dart';
import 'package:common/utils/responsive.dart';
import 'package:flutter/material.dart';

/// The header row for [AppTable], containing a search bar and action buttons.
///
/// Renders a responsive search field on the left, with function buttons
/// and general action buttons on the right.
class TableHeaderWidget extends StatefulWidget {
  /// Creates a [TableHeaderWidget].
  ///
  /// - [onSearchChanged] — Callback when the search text changes.
  /// - [functionButtons] — Dropdown-style function buttons.
  /// - [buttons] — General action buttons.
  const TableHeaderWidget({
    super.key,
    required this.onSearchChanged,
    this.functionButtons,
    this.buttons,
  });

  /// Callback invoked when the search text changes.
  final ValueChanged<String>? onSearchChanged;

  /// Optional list of function buttons (dropdown popup menus).
  final List<TableFunctionButtonWidget>? functionButtons;

  /// Optional list of general action buttons.
  final List<AppButton>? buttons;

  @override
  State<TableHeaderWidget> createState() => _TableHeaderWidgetState();
}

class _TableHeaderWidgetState extends State<TableHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        if (widget.onSearchChanged != null)
          Flexible(
            child: SizedBox(
              width: responsive<double>(
                context,
                mobile: 200,
                tablet: 250,
                web: 300,
              ),
              // height: double.maxFinite,
              child: TextField(
                onChanged: widget.onSearchChanged,
                style: Theme.of(context).textTheme.bodySmall,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSmall,
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.outline,
                      width: 0.5,
                    ),
                  ),
                  hintText: 'Search...',
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  prefixIcon: Icon(
                    Icons.search,
                    size: AppDimens.sizeMedium.height,
                  ),
                  isDense: true,
                  contentPadding: AppDimens.paddingAllSmall,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 30,
                    minHeight: 30,
                  ),
                  fillColor: Theme.of(context).colorScheme.surface,
                  focusColor: Theme.of(context).focusColor,
                ),
              ),
            ),
          ),
        Row(
          children: [
            if (widget.functionButtons != null) ...[
              for (var functionButton in widget.functionButtons!) ...[
                AppDimens.horizontalSmall,
                functionButton,
              ],
            ],
            if (widget.buttons != null) ...[
              for (var button in widget.buttons!) ...[
                AppDimens.horizontalSmall,
                button,
              ],
            ],
          ],
        ),
      ],
    );
  }
}
