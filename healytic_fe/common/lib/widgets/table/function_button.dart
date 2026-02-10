import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A button that opens a popup overlay relative to itself when tapped.
///
/// Used inside [AppTable] headers for filter or sort controls. The popup
/// is positioned via [CompositedTransformFollower] and dismissed by tapping
/// outside or pressing the button again.
///
/// ```dart
/// TableFunctionButtonWidget(
///   label: 'Filter',
///   prefixIcon: Icons.filter_list,
///   child: MyFilterPanel(),
/// )
/// ```
class TableFunctionButtonWidget extends StatefulWidget {
  /// Creates a [TableFunctionButtonWidget].
  ///
  /// - [child] — Widget displayed in the popup overlay.
  /// - [label] — Text displayed on the button.
  /// - [prefixIcon] — Icon displayed before the label.
  /// - [offset] — Optional offset for the popup position.
  const TableFunctionButtonWidget({
    super.key,
    required this.child,
    required this.label,
    required this.prefixIcon,
    this.offset,
  });

  /// Widget content displayed inside the popup overlay.
  final Widget child;

  /// Text label displayed on the button.
  final String label;

  /// Icon displayed before the label text.
  final IconData prefixIcon;

  /// Optional offset for positioning the popup relative to the button.
  final Offset? offset;

  /// Maximum width of the popup overlay.
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
