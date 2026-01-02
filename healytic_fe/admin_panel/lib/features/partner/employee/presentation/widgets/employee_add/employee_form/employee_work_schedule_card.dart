import 'package:admin_panel/features/common/widgets/input/form_field_builders.dart';
import 'package:flutter/material.dart';

class EmployeeWorkScheduleCard extends StatefulWidget {
  const EmployeeWorkScheduleCard({super.key});

  @override
  State<EmployeeWorkScheduleCard> createState() =>
      _EmployeeWorkScheduleCardState();
}

class _EmployeeWorkScheduleCardState extends State<EmployeeWorkScheduleCard> {
  bool _isExpanded = true;

  final List<Map<String, dynamic>> _schedule = [
    {'day': 'Monday', 'active': true, 'start': '09:00', 'end': '17:00'},
    {'day': 'Tuesday', 'active': true, 'start': '09:00', 'end': '17:00'},
    {'day': 'Wednesday', 'active': true, 'start': '09:00', 'end': '17:00'},
    {'day': 'Thursday', 'active': true, 'start': '09:00', 'end': '17:00'},
    {'day': 'Friday', 'active': true, 'start': '09:00', 'end': '13:00'},
    {'day': 'Saturday', 'active': false, 'start': '', 'end': ''},
    {'day': 'Sunday', 'active': false, 'start': '', 'end': ''},
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
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
                      color: Colors.orange.shade50,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange.shade100),
                    ),
                    child: Icon(
                      Icons.schedule_outlined,
                      size: 18,
                      color: Colors.orange.shade600,
                    ),
                  ),
                  const SizedBox(width: 12),
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
            firstChild: _buildContent(context),
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

  Widget _buildContent(BuildContext context) {
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
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.shade100),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.amber.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.amber.shade800,
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
                  onPressed: () {
                    // TODO: Apply preset
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.amber.shade800,
                    padding: EdgeInsets.zero,
                  ),
                  child: const Text(
                    'Apply Preset',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
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
              day: day['day'],
              isActive: day['active'],
              startTime: day['start'],
              endTime: day['end'],
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
                  onChanged: onActiveChanged,
                  activeThumbColor: Colors.green.shade600,
                  activeTrackColor: Colors.green.shade400,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: isActive
                    ? Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: _buildTimeField(
                              context,
                              fieldKey:
                                  'schedule_${day.toLowerCase().replaceAll(' ', '_')}_start',
                              value: startTime,
                              onChanged: onStartTimeChanged,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              'to',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: _buildTimeField(
                              context,
                              fieldKey:
                                  'schedule_${day.toLowerCase().replaceAll(' ', '_')}_end',
                              value: endTime,
                              onChanged: onEndTimeChanged,
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
    required String fieldKey,
    required String value,
    required ValueChanged<String> onChanged,
  }) {
    return FormFieldBuilders.buildTextField(
      context,
      fieldKey: fieldKey,
      label: '', // Empty label as it is inline
      initialValue: value,
      onChanged: (val) {
        if (val != null) {
          onChanged(val.toString());
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      labelStyle: const TextStyle(height: 0), // Try to minimize label height?
    );
  }
}
