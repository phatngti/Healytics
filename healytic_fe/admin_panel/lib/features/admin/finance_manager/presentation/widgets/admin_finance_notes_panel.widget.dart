import 'package:admin_panel/features/admin/finance_manager/domain/admin_finance.entity.dart';
import 'package:admin_panel/features/admin/finance_manager/presentation/widgets/admin_finance_ui_helpers.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';

/// Notes panel showing attached notes with timestamps.
class AdminFinanceNotesPanel extends StatelessWidget {
  const AdminFinanceNotesPanel({
    super.key,
    required this.notes,
    this.onAddNote,
  });

  final List<AdminFinanceNote> notes;
  final VoidCallback? onAddNote;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppDimens.radiusMd,
        side: BorderSide(
          color: cs.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: AppDimens.paddingAllMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Notes',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: AppDimens.fontWeightBold,
                  ),
                ),
                const Spacer(),
                if (onAddNote != null)
                  IconButton(
                    icon: const Icon(
                      Icons.add_comment_rounded,
                      size: 20,
                    ),
                    tooltip: 'Add note',
                    onPressed: onAddNote,
                  ),
              ],
            ),
            AppDimens.verticalSmall,
            if (notes.isEmpty)
              Text(
                'No notes yet.',
                style: tt.bodySmall?.copyWith(
                  color: cs.onSurfaceVariant,
                ),
              )
            else
              ...notes.map(
                (n) => _NoteRow(note: n),
              ),
          ],
        ),
      ),
    );
  }
}

class _NoteRow extends StatelessWidget {
  const _NoteRow({required this.note});

  final AdminFinanceNote note;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppDimens.spaceSmMd,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.sticky_note_2_outlined,
            size: 16,
            color: cs.onSurfaceVariant,
          ),
          AppDimens.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  note.content,
                  style: tt.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${note.createdBy} · '
                  '${formatAdminDateTime(note.createdAt)}',
                  style: tt.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
