import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';

class TableFunctionButtonWidget extends StatefulWidget {
  const TableFunctionButtonWidget({
    super.key,
    required this.child,
    required this.label,
    required this.prefixIcon,
    this.offset,
  });

  final Widget child;
  final String label;
  final IconData prefixIcon;
  final Offset? offset;

  static const double maxWidth = 400;

  @override
  State<TableFunctionButtonWidget> createState() =>
      _TableFunctionButtonWidgetState();
}

class _TableFunctionButtonWidgetState extends State<TableFunctionButtonWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showPopup(Widget popupContent) {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeOverlay,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: widget.offset ?? Offset(0, 40),
            child: Material(
              elevation: 4,
              borderRadius: AppDimens.radiusSmall,
              color: Theme.of(context).cardColor,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: TableFunctionButtonWidget.maxWidth,
                ),
                child: Container(
                  padding: AppDimens.paddingAllSmall,
                  decoration: BoxDecoration(
                    borderRadius: AppDimens.radiusSmall,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      width: 0.5,
                    ),
                  ),
                  child: popupContent,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          _showPopup(widget.child);
        },
        child: CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.paddingHorizontalMedium.right,
              vertical: AppDimens.paddingVerticalSmall.top,
            ),
            decoration: BoxDecoration(
              borderRadius: AppDimens.radiusSmall,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                width: 0.5,
              ),
            ),
            child: Row(
              children: [
                Icon(widget.prefixIcon, size: AppDimens.sizeMedium.height),
                AppDimens.horizontalSmall,
                Text(
                  widget.label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
