import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        const ActivityItem(
          icon: Symbols.schedule,
          iconBgColor: Color(0xFFEFF6FF),
          iconColor: Color(0xFF3B82F6),
          title: 'Aromatherapy',
          subtitle: 'Yesterday at 3:00 PM',
          status: 'Completed',
          statusBgColor: Color(0xFFF0FDF4),
          statusTextColor: Color(0xFF15803D),
        ),
        const SizedBox(height: 12),
        const ActivityItem(
          icon: Symbols.check_circle,
          iconBgColor: Color(0xFFF0FDF4),
          iconColor: Color(0xFF16A34A),
          title: 'Wellness Consult',
          subtitle: 'Tomorrow at 10:00 AM',
          status: 'Scheduled',
          statusBgColor: Color(0xFFEFF6FF),
          statusTextColor: Color(0xFF2563EB),
        ),
      ],
    );
  }
}

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String status;
  final Color statusBgColor;
  final Color statusTextColor;

  const ActivityItem({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.statusBgColor,
    required this.statusTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: statusTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
