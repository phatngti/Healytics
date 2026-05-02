import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Shows a confirmation dialog with an optional
/// required note field for risky actions.
///
/// Returns the note text on confirm, `null` on cancel.
Future<String?> showAdminFinanceActionDialog(
  BuildContext context, {
  required String title,
  required String description,
  String confirmLabel = 'Confirm',
  bool requireNote = false,
  bool isDestructive = false,
}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => _ActionDialog(
      title: title,
      description: description,
      confirmLabel: confirmLabel,
      requireNote: requireNote,
      isDestructive: isDestructive,
    ),
  );
}

class _ActionDialog extends StatefulWidget {
  const _ActionDialog({
    required this.title,
    required this.description,
    required this.confirmLabel,
    required this.requireNote,
    required this.isDestructive,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final bool requireNote;
  final bool isDestructive;

  @override
  State<_ActionDialog> createState() =>
      _ActionDialogState();
}

class _ActionDialogState extends State<_ActionDialog> {
  final _noteController = TextEditingController();
  bool _isSubmitting = false;

  bool get _canConfirm =>
      !widget.requireNote ||
      _noteController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.title),
      content: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.description),
            if (widget.requireNote) ...[
              AppDimens.verticalMedium,
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add a note (required)...',
                  border: OutlineInputBorder(
                    borderRadius: AppDimens.radiusSm,
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSubmitting
              ? null
              : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: !_canConfirm || _isSubmitting
              ? null
              : () {
                  setState(() => _isSubmitting = true);
                  Navigator.of(context).pop(
                    _noteController.text.trim(),
                  );
                },
          style: widget.isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: cs.error,
                  foregroundColor: cs.onError,
                )
              : null,
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}

/// Shows an "Add Note" dialog.
Future<String?> showAdminFinanceAddNoteDialog(
  BuildContext context,
) {
  return showAdminFinanceActionDialog(
    context,
    title: 'Add Note',
    description: 'Add a note to this record.',
    confirmLabel: 'Save Note',
    requireNote: true,
  );
}

/// Shows a "Create Export" dialog with type selection.
Future<String?> showAdminFinanceCreateExportDialog(
  BuildContext context,
) {
  return showAdminFinanceActionDialog(
    context,
    title: 'Create Export',
    description:
        'A new finance export will be queued '
        'for processing.',
    confirmLabel: 'Create',
  );
}
