import 'package:flutter/material.dart';

class EmployeeScheduleSection extends StatelessWidget {
  const EmployeeScheduleSection({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final days = [
      {'day': 'MON', 'time': '9-5', 'active': true},
      {'day': 'TUE', 'time': '9-5', 'active': true},
      {'day': 'WED', 'time': '9-5', 'active': true},
      {'day': 'THU', 'time': '9-5', 'active': true},
      {'day': 'FRI', 'time': '9-5', 'active': true},
      {'day': 'SAT', 'time': 'OFF', 'active': false},
      {'day': 'SUN', 'time': 'OFF', 'active': false},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'WORK SCHEDULE SUMMARY',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: colorScheme.outlineVariant),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shift Type',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.wb_sunny,
                              size: 18,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Full Time - Morning',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Weekly Hours',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '40h',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: days.map((day) {
                    final isActive = day['active'] as bool;
                    return Opacity(
                      opacity: isActive ? 1.0 : 0.5,
                      child: Column(
                        children: [
                          Text(
                            day['day'] as String,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 32,
                            height: 6,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.green
                                  : colorScheme.outlineVariant,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            day['time'] as String,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: isActive
                                      ? null
                                      : colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
