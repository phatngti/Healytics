import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/features/partner/employee/domain/employee_form_field.dart';
import 'package:admin_panel/features/partner/employee/domain/work_history_key.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

/// Collapsible card for managing employee work history
/// entries in add/edit forms.
///
/// Stores data as `List<Map<String, dynamic>>` in the
/// FormBuilder field named `'work_history'`.
class EmployeeWorkHistoryCard extends StatefulWidget {
  /// Pre-populated work history entries (edit mode).
  final List<WorkHistoryEntry>? initialEntries;

  const EmployeeWorkHistoryCard({super.key, this.initialEntries});

  @override
  State<EmployeeWorkHistoryCard> createState() =>
      _EmployeeWorkHistoryCardState();
}

class _EmployeeWorkHistoryCardState extends State<EmployeeWorkHistoryCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppDimens.radiusMedium,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          _buildHeader(colorScheme, textTheme),
          AnimatedCrossFade(
            firstChild: _buildFormContent(context),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme, TextTheme textTheme) {
    return InkWell(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                shape: BoxShape.circle,
                border: Border.all(color: colorScheme.primary.withAlpha(75)),
              ),
              child: Icon(
                Icons.work_history_outlined,
                size: 18,
                color: colorScheme.primary,
              ),
            ),
            AppDimens.horizontalMediumSmall,
            Text(
              'Work History',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            AnimatedRotation(
              turns: _isExpanded ? 0.5 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                Icons.expand_more,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final initialValue =
        widget.initialEntries?.map((e) => e.toJson()).toList() ??
        <Map<String, dynamic>>[];

    return FormBuilderField<List<Map<String, dynamic>>>(
      name: EmployeeFormField.workHistory.key,
      initialValue: initialValue,
      builder: (field) {
        final entries = field.value ?? [];
        return Container(
          padding: AppDimens.paddingAllLarge,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...entries.asMap().entries.map(
                (e) => _WorkHistoryEntryTile(
                  entry: e.value,
                  onEdit: () => _editEntry(context, field, e.key),
                  onDelete: () => _deleteEntry(field, e.key),
                ),
              ),
              AppDimens.verticalSmall,
              _AddEntryButton(onTap: () => _addEntry(context, field)),
            ],
          ),
        );
      },
    );
  }

  void _addEntry(
    BuildContext context,
    FormFieldState<List<Map<String, dynamic>>> field,
  ) {
    _showEntryDialog(context).then((result) {
      if (result != null) {
        final current = List<Map<String, dynamic>>.from(field.value ?? []);
        current.add(result);
        field.didChange(current);
      }
    });
  }

  void _editEntry(
    BuildContext context,
    FormFieldState<List<Map<String, dynamic>>> field,
    int index,
  ) {
    final entries = field.value ?? [];
    if (index >= entries.length) return;

    _showEntryDialog(context, existing: entries[index]).then((result) {
      if (result != null) {
        final current = List<Map<String, dynamic>>.from(entries);
        current[index] = result;
        field.didChange(current);
      }
    });
  }

  void _deleteEntry(
    FormFieldState<List<Map<String, dynamic>>> field,
    int index,
  ) {
    final current = List<Map<String, dynamic>>.from(field.value ?? []);
    current.removeAt(index);
    field.didChange(current);
  }

  Future<Map<String, dynamic>?> _showEntryDialog(
    BuildContext context, {
    Map<String, dynamic>? existing,
  }) {
    final facilityCtrl = TextEditingController(
      text: existing?[WorkHistoryKey.facility]
          as String? ??
          '',
    );
    final positionCtrl = TextEditingController(
      text: existing?[WorkHistoryKey.position]
          as String? ??
          '',
    );
    final periodCtrl = TextEditingController(
      text: existing?[WorkHistoryKey.period]
          as String? ??
          '',
    );

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: Text(
              existing != null ? 'Edit Work History' : 'Add Work History',
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: facilityCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Facility / Company',
                      hintText: 'e.g. Glow Saigon Spa',
                    ),
                  ),
                  AppDimens.verticalMedium,
                  TextField(
                    controller: positionCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Position',
                      hintText: 'e.g. Head of Dermatology',
                    ),
                  ),
                  AppDimens.verticalMedium,
                  TextField(
                    controller: periodCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Period',
                      hintText: 'e.g. 2022\u2013Present',
                    ),
                  ),
                  AppDimens.verticalMedium,
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (facilityCtrl.text.isEmpty ||
                      positionCtrl.text.isEmpty ||
                      periodCtrl.text.isEmpty) {
                    return;
                  }
                  Navigator.pop(ctx, {
                    WorkHistoryKey.facility:
                        facilityCtrl.text,
                    WorkHistoryKey.position:
                        positionCtrl.text,
                    WorkHistoryKey.period:
                        periodCtrl.text,
                    WorkHistoryKey.isCurrent:
                        false,
                  });
                },
                child: Text(existing != null ? 'Update' : 'Add'),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Tile for a single work history entry with
/// edit / delete actions.
class _WorkHistoryEntryTile extends StatelessWidget {
  final Map<String, dynamic> entry;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _WorkHistoryEntryTile({
    required this.entry,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final semanticColors = Theme.of(context).extension<SemanticColors>()!;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        borderRadius: AppDimens.radiusSmall,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          _buildTimeline(colorScheme, semanticColors),
          AppDimens.horizontalMedium,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry[WorkHistoryKey.facility]
                                as String? ??
                            '',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  entry[WorkHistoryKey.position]
                          as String? ??
                      '',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  entry[WorkHistoryKey.period]
                          as String? ??
                      '',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              size: 18,
              color: colorScheme.onSurfaceVariant,
            ),
            onPressed: onEdit,
            tooltip: 'Edit',
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: 18,
              color: colorScheme.error,
            ),
            onPressed: onDelete,
            tooltip: 'Delete',
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(
    ColorScheme colorScheme,
    SemanticColors semanticColors,
  ) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.outlineVariant,
        border: Border.all(color: colorScheme.outline, width: 2),
      ),
    );
  }
}

/// Button to add a new work history entry.
class _AddEntryButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddEntryButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: AppDimens.radiusSmall,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: AppDimens.radiusSmall,
          border: Border.all(
            color: colorScheme.primary.withAlpha(75),
            style: BorderStyle.solid,
          ),
          color: colorScheme.primary.withAlpha(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 18,
              color: colorScheme.primary,
            ),
            AppDimens.horizontalSmall,
            Text(
              'Add Work History',
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
