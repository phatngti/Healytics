import 'package:admin_panel/features/partner/employee/domain/employee.entity.dart';
import 'package:admin_panel/theme/app_theme.dart';
import 'package:admin_panel/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EmployeeWorkScheduleCard extends StatefulWidget {
  final List<EmployeeSchedule>? initialSchedule;

  const EmployeeWorkScheduleCard({super.key, this.initialSchedule});

  @override
  State<EmployeeWorkScheduleCard> createState() =>
      _EmployeeWorkScheduleCardState();
}

class _EmployeeWorkScheduleCardState extends State<EmployeeWorkScheduleCard> {
  bool _isExpanded = true;

  late final List<Map<String, dynamic>> _schedule;

  @override
  void initState() {
    super.initState();
    _initSchedule();
  }

  void _initSchedule() {
    final defaultSchedule = [
      {
        'key': 'monday',
        'display': 'Monday',
        'active': true,
        'start': '09:00',
        'end': '17:00',
      },
      {
        'key': 'tuesday',
        'display': 'Tuesday',
        'active': true,
        'start': '09:00',
        'end': '17:00',
      },
      {
        'key': 'wednesday',
        'display': 'Wednesday',
        'active': true,
        'start': '09:00',
        'end': '17:00',
      },
      {
        'key': 'thursday',
        'display': 'Thursday',
        'active': true,
        'start': '09:00',
        'end': '17:00',
      },
      {
        'key': 'friday',
        'display': 'Friday',
        'active': true,
        'start': '09:00',
        'end': '13:00',
      },
      {
        'key': 'saturday',
        'display': 'Saturday',
        'active': false,
        'start': '',
        'end': '',
      },
      {
        'key': 'sunday',
        'display': 'Sunday',
        'active': false,
        'start': '',
        'end': '',
      },
    ];

    if (widget.initialSchedule != null && widget.initialSchedule!.isNotEmpty) {
      _schedule = defaultSchedule.map((day) {
        final key = day['key'] as String;
        try {
          final scheduleItem = widget.initialSchedule!.firstWhere(
            (item) => item.day.toLowerCase() == key,
          );
          return {
            ...day,
            'active': scheduleItem.isWorking,
            'start': scheduleItem.start,
            'end': scheduleItem.end,
          };
        } catch (_) {
          return day;
        }
      }).toList();
    } else {
      _schedule = defaultSchedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final formEnabled = FormBuilder.of(context)?.enabled ?? true;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).extension<SemanticColors>()!.warning!.withAlpha(25),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).extension<SemanticColors>()!.warning!.withAlpha(50),
                      ),
                    ),
                    child: Icon(
                      Icons.schedule_outlined,
                      size: 18,
                      color: Theme.of(
                        context,
                      ).extension<SemanticColors>()!.warning,
                    ),
                  ),
                  AppDimens.horizontalMediumSmall,
                  Text(
                    'Work Schedule',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          ),
          // Content
          AnimatedCrossFade(
            firstChild: _buildContent(context, formEnabled),
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

  Widget _buildContent(BuildContext context, bool formEnabled) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Column(
        children: [
          // Preset Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).extension<SemanticColors>()!.warning!.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(
                  context,
                ).extension<SemanticColors>()!.warning!.withAlpha(50),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Theme.of(context).extension<SemanticColors>()!.warning,
                  size: 20,
                ),
                AppDimens.horizontalSmall,
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(
                          context,
                        ).extension<SemanticColors>()!.warning,
                      ),
                      children: const [
                        TextSpan(text: 'Default Shift Pattern: '),
                        TextSpan(
                          text: 'Full-Time (Morning)',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: formEnabled
                      ? () {
                          // TODO: Apply preset
                        }
                      : null,
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(
                      context,
                    ).extension<SemanticColors>()!.warning,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Apply Preset',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppDimens.verticalLarge,
          // Schedule Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: Text(
                    'DAY',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Center(
                    child: Text(
                      'STATUS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      'SHIFT HOURS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Schedule Rows
          ...List.generate(_schedule.length, (index) {
            final day = _schedule[index];
            return _buildScheduleRow(
              context,
              day: day['display'],
              isActive: day['active'],
              startTime: day['start'],
              endTime: day['end'],
              formEnabled: formEnabled,
              onActiveChanged: (value) {
                setState(() {
                  _schedule[index]['active'] = value ?? false;
                });
              },
              onStartTimeChanged: (time) {
                setState(() {
                  _schedule[index]['start'] = time;
                });
              },
              onEndTimeChanged: (time) {
                setState(() {
                  _schedule[index]['end'] = time;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScheduleRow(
    BuildContext context, {
    required String day,
    required bool isActive,
    required String startTime,
    required String endTime,
    required ValueChanged<bool?> onActiveChanged,
    required ValueChanged<String> onStartTimeChanged,
    required ValueChanged<String> onEndTimeChanged,
    required bool formEnabled,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedOpacity(
      opacity: isActive ? 1.0 : 0.6,
      duration: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: colorScheme.outlineVariant.withAlpha(50)),
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              child: Text(
                day,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isActive ? null : colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(
              width: 80,
              child: Center(
                child: Switch(
                  value: isActive,
                  onChanged: formEnabled ? onActiveChanged : null,
                  activeThumbColor: Theme.of(
                    context,
                  ).extension<SemanticColors>()!.success,
                  activeTrackColor: Theme.of(
                    context,
                  ).extension<SemanticColors>()!.success!.withAlpha(150),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: isActive
                    ? Row(
                        children: [
                          Expanded(
                            child: FormBuilderField<List<String>>(
                              name:
                                  'schedule_${day.toLowerCase().replaceAll(' ', '_')}',
                              initialValue: [startTime, endTime],
                              enabled: formEnabled,
                              onChanged: (val) {
                                if (val != null && val.length == 2) {
                                  onStartTimeChanged(val[0]);
                                  onEndTimeChanged(val[1]);
                                }
                              },
                              builder: (FormFieldState<List<String>> field) {
                                return Row(
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: _buildTimeField(
                                        context,
                                        value: field.value?[0] ?? '',
                                        enabled: formEnabled,
                                        onChanged: (val) {
                                          final newValue = [
                                            val,
                                            field.value?[1] ?? '',
                                          ];
                                          field.didChange(newValue);
                                          onStartTimeChanged(val);
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        'to',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 100,
                                      child: _buildTimeField(
                                        context,
                                        value: field.value?[1] ?? '',
                                        enabled: formEnabled,
                                        onChanged: (val) {
                                          final newValue = [
                                            field.value?[0] ?? '',
                                            val,
                                          ];
                                          field.didChange(newValue);
                                          onEndTimeChanged(val);
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    : Text(
                        'No shift scheduled',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeField(
    BuildContext context, {
    required String value,
    required ValueChanged<String> onChanged,
    required bool enabled,
  }) {
    return TextField(
      controller: TextEditingController(text: value)
        ..selection = TextSelection.collapsed(offset: value.length),
      onChanged: onChanged,
      enabled: enabled,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.outline.withAlpha(100),
          ),
        ),
        filled: true,
        fillColor: enabled
            ? Theme.of(context).colorScheme.surface
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        hintText: '--:--',
        hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
