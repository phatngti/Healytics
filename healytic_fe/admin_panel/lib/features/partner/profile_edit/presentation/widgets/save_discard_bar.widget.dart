import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Floating bottom bar visible only when the user
/// has unsaved changes. Shows Discard and Save
/// actions.
class SaveDiscardBarWidget extends StatelessWidget {
  const SaveDiscardBarWidget({
    required this.isDirty,
    required this.isSaving,
    required this.onDiscard,
    required this.onSave,
    super.key,
  });

  /// Whether the draft differs from the snapshot.
  final bool isDirty;

  /// Whether a save operation is in progress.
  final bool isSaving;

  /// Resets draft to the last server snapshot.
  final VoidCallback onDiscard;

  /// Persists the current draft.
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    if (!isDirty && !isSaving) {
      return const SizedBox.shrink();
    }

    final cs = Theme.of(context).colorScheme;

    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spaceXxl,
        vertical: AppDimens.spaceMd,
      ),
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: cs.outlineVariant,
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: cs.shadow
                .withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.end,
        children: [
          if (isDirty) ...[
            OutlinedButton.icon(
              onPressed:
                  isSaving ? null : onDiscard,
              icon:
                  const Icon(Icons.undo_rounded),
              label: const Text(
                'Discard Changes',
              ),
            ),
            AppDimens.horizontalMedium,
          ],
          FilledButton.icon(
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? const SizedBox(
                    width: AppDimens.iconSm,
                    height: AppDimens.iconSm,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.save_rounded,
                  ),
            label: Text(
              isSaving ? 'Saving…' : 'Save',
            ),
          ),
        ],
      ),
    );
  }
}
