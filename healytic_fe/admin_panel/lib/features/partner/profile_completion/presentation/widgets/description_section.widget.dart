import 'dart:convert';

import 'package:admin_panel/features/partner/profile_completion/presentation/widgets/clinic_identity_card.widget.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

/// Description section with a rich-text Quill
/// viewer, summary card and an explicit edit action.
///
/// The [description] value may be Quill Delta JSON
/// (a serialized list of ops) or legacy plain text.
class DescriptionSectionWidget extends StatefulWidget {
  const DescriptionSectionWidget({
    required this.description,
    required this.showValidationErrors,
    required this.isDescriptionValid,
    required this.trimmedLength,
    required this.minLength,
    required this.maxLength,
    required this.onEdit,
    super.key,
  });

  final String description;
  final bool showValidationErrors;
  final bool isDescriptionValid;
  final int trimmedLength;
  final int minLength;
  final int maxLength;
  final VoidCallback onEdit;

  @override
  State<DescriptionSectionWidget> createState() =>
      _DescriptionSectionWidgetState();
}

class _DescriptionSectionWidgetState
    extends State<DescriptionSectionWidget> {
  QuillController? _controller;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  @override
  void didUpdateWidget(DescriptionSectionWidget old) {
    super.didUpdateWidget(old);
    if (widget.description != old.description) {
      _controller?.dispose();
      _initController();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────

  void _initController() {
    final content =
        _tryParseQuillContent(widget.description);
    if (content != null) {
      _controller = QuillController(
        document: Document.fromJson(content),
        selection:
            const TextSelection.collapsed(offset: 0),
      );
      _controller!.readOnly = true;
    } else {
      _controller = null;
    }
  }

  /// Parses a raw string into Quill Delta ops.
  ///
  /// Returns `null` when empty. Non-JSON strings are
  /// wrapped in a minimal Delta for plain-text display.
  static List<Map<String, dynamic>>?
      _tryParseQuillContent(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is List && decoded.isNotEmpty) {
        return decoded
            .map(
              (e) =>
                  Map<String, dynamic>.from(e as Map),
            )
            .toList();
      }
      return null;
    } on FormatException {
      return <Map<String, dynamic>>[
        {'insert': '$raw\n'},
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasDescription = widget.description.isNotEmpty;
    final isTooShort = widget.trimmedLength < widget.minLength;
    final isInvalid =
        widget.showValidationErrors &&
        (widget.trimmedLength == 0 || isTooShort);

    return SectionCardWidget(
      title: 'About clinic',
      subtitle:
          'Write a concise, patient-friendly '
          'description that covers your '
          'positioning, specialties, and care '
          'experience.',
      trailing: FilledButton.tonalIcon(
        onPressed: widget.onEdit,
        icon: Icon(
          hasDescription
              ? Icons.edit_outlined
              : Icons.add_rounded,
        ),
        label: Text(
          hasDescription
              ? 'Edit description'
              : 'Add description',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              AppDimens.spaceLg + AppDimens.spaceXxs,
            ),
            decoration: BoxDecoration(
              color: hasDescription
                  ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
                  : colorScheme.surfaceContainerHigh.withValues(alpha: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppDimens.spaceLg + AppDimens.spaceXxs),
              ),
              border: Border.all(
                color: isInvalid
                    ? colorScheme.error
                    : colorScheme.outlineVariant,
              ),
            ),
            child: hasDescription && _controller != null
                ? QuillEditor(
                    controller: _controller!,
                    focusNode:
                        FocusNode(canRequestFocus: false),
                    scrollController: ScrollController(),
                    config: const QuillEditorConfig(
                      showCursor: false,
                      autoFocus: false,
                      expands: false,
                      padding: EdgeInsets.zero,
                    ),
                  )
                : hasDescription
                ? Text(
                    widget.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      AppDimens.verticalMediumSmall,
                      Text(
                        'No clinic description '
                        'added yet.',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(
                        height:
                            AppDimens.spaceXs +
                            AppDimens.spaceXxs,
                      ),
                      Text(
                        'Add a short profile summary '
                        'to explain specialties, '
                        'patient experience, and '
                        'care approach.',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(
                              color:
                                  colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
          ),
          AppDimens.verticalMediumSmall,
          Row(
            children: [
              Icon(
                widget.isDescriptionValid
                    ? Icons.check_circle_rounded
                    : Icons.edit_note_rounded,
                size: AppDimens.iconSmMd,
                color: widget.isDescriptionValid
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
              AppDimens.horizontalSmall,
              Text(
                widget.isDescriptionValid
                    ? 'Description is ready '
                          'for publishing.'
                    : widget.trimmedLength == 0
                    ? 'Description required. '
                          'Target ${widget.minLength}-'
                          '${widget.maxLength} characters.'
                    : '${widget.trimmedLength}/${widget.minLength} '
                          'minimum characters',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(
                  color: widget.isDescriptionValid
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          if (isInvalid) ...[
            AppDimens.verticalSmall,
            Text(
              'Description must be at least '
              '${widget.minLength} characters.',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(
                color: colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
