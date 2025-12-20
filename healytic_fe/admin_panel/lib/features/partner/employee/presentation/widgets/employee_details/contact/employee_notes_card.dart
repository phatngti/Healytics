import 'package:flutter/material.dart';

class EmployeeNotesCard extends StatelessWidget {
  const EmployeeNotesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.yellow.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.yellow.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sticky_note_2_outlined,
                size: 20,
                color: Colors.yellow.shade800,
              ),
              const SizedBox(width: 8),
              Text(
                'Manager Notes',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Sarah is exceptionally skilled in deep tissue. Clients often request her for back pain relief. Prefers morning shifts.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.yellow.shade900,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
