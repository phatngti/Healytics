import 'dart:convert';

import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Displays manager notes / description for an employee.
///
/// The [description] field is expected to contain
/// Quill Delta JSON (a serialized list of Delta ops).
/// Falls back to plain text rendering when the value
/// is not valid JSON.
class EmployeeNotesCard extends StatefulWidget {
  /// Employee description or manager notes
  /// (Quill Delta JSON string).
  final String? description;

  /// Whether the parent form is in editing mode.
  final bool isEditing;

  const EmployeeNotesCard({
    super.key,
    this.description,
    this.isEditing = false,
  });

  @override
  State<EmployeeNotesCard> createState() => _EmployeeNotesCardState();
}

class _EmployeeNotesCardState extends State<EmployeeNotesCard> {
  QuillController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(EmployeeNotesCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.description != oldWidget.description) {
      _controller?.dispose();
      _initController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────

  void _initController() {
    final content = _tryParseQuillContent(widget.description);
    if (content != null) {
      _controller = QuillController(
        document: Document.fromJson(content),
        selection: const TextSelection.collapsed(offset: 0),
      );
      _controller!.readOnly = true;
    } else {
      _controller = null;
    }
  }

  /// Parses a JSON string into a Quill Delta ops list.
  ///
  /// Returns `null` when the value is empty, null,
  /// or contains only a bare newline Delta.
  /// If the string is not valid JSON it is wrapped in
  /// a minimal Delta so plain text still renders.
  static List<Map<String, dynamic>>? _tryParseQuillContent(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
      return null;
    } on FormatException {
      // Not JSON — wrap as plain-text Delta.
      return <Map<String, dynamic>>[
        {'insert': '$raw\n'},
      ];
    }
  }

  // ── Build ─────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: semanticColors.warning?.withAlpha(25),
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(
          color:
              semanticColors.warning?.withAlpha(50) ??
              colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 20,
                color: semanticColors.warning,
              ),
              AppDimens.horizontalSmall,
              Text(
                'Manager Notes',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          AppDimens.verticalSmall,
          if (_controller != null)
            QuillEditor(
              controller: _controller!,
              focusNode: FocusNode(canRequestFocus: false),
              scrollController: ScrollController(),
              config: const QuillEditorConfig(
                showCursor: false,
                autoFocus: false,
                expands: false,
                padding: EdgeInsets.zero,
              ),
            )
          else
            Text(
              'No manager notes available.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                height: 1.5,
              ),
            ),
        ],
      ),
    );
  }
}
