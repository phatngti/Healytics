import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// A reusable search text field for filtering content.
///
/// Renders a compact [TextField] with a search icon prefix,
/// themed borders, and transparent text/cursor styling.
/// Designed for use in table headers, filter bars, and
/// other non-form search contexts.
///
/// Uses an explicitly managed [FocusNode] and wraps the
/// field in a [GestureDetector] to guarantee tap-to-focus
/// even when placed inside widgets that consume pointer
/// events (e.g. [PaginatedDataTable2] headers).
///
/// ```dart
/// AppSearchField(
///   onChanged: (query) => filterItems(query),
///   hintText: 'Search employees...',
/// )
/// ```
class AppSearchField extends StatefulWidget {
  /// Creates an [AppSearchField].
  ///
  /// - [onChanged] — Callback invoked on every text change.
  /// - [hintText] — Placeholder text (defaults to `'Search...'`).
  /// - [controller] — Optional external controller.
  const AppSearchField({
    super.key,
    this.onChanged,
    this.hintText = 'Search...',
    this.controller,
    this.fieldKey,
  });

  /// Callback invoked when the search text changes.
  final ValueChanged<String>? onChanged;

  /// Placeholder text shown when the field is empty.
  final String hintText;

  /// Optional external text editing controller.
  final TextEditingController? controller;

  /// Optional key applied to the inner [TextField] for tests and automation.
  final Key? fieldKey;

  @override
  State<AppSearchField> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppSearchField> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // GestureDetector ensures that taps always reach
    // the TextField even when a parent widget (e.g.
    // DataTable2 header) has its own gesture handlers.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _focusNode.requestFocus(),
      child: TextField(
        key: widget.fieldKey,
        controller: widget.controller,
        focusNode: _focusNode,
        onChanged: widget.onChanged,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurface),
        cursorColor: colorScheme.primary,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: AppDimens.radiusSmall,
            borderSide: BorderSide(color: colorScheme.outline, width: 0.5),
          ),
          hintText: widget.hintText,
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          prefixIcon: Icon(Icons.search, size: AppDimens.sizeMedium.height),
          isDense: true,
          contentPadding: AppDimens.paddingAllSmall,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 30,
          ),
          fillColor: colorScheme.surface,
          focusColor: Theme.of(context).focusColor,
        ),
      ),
    );
  }
}
