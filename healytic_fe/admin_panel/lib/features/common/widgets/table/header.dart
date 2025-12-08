import 'package:admin_panel/features/common/widgets/button/button.dart';
import 'package:admin_panel/features/common/widgets/table/function_button.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class TableHeaderWidget extends StatefulWidget {
  const TableHeaderWidget({
    super.key,
    required this.onSearchChanged,
    this.functionButtons,
    this.buttons,
  });

  final ValueChanged<String>? onSearchChanged;
  final List<TableFunctionButtonWidget>? functionButtons;
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
              width: 300,
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
