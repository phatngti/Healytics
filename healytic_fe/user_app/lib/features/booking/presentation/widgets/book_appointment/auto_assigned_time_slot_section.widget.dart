import 'package:common/utils/demensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart'
    as service_details;

/// Service-level time slots for auto-assigned
/// bookings.
///
/// A slot is available when at least one specialist
/// assigned to the selected service can take it.
class AutoAssignedTimeSlotSection extends StatelessWidget {
  const AutoAssignedTimeSlotSection({
    super.key,
    required this.specialists,
    required this.selectedDate,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<service_details.SpecialistEntity> specialists;
  final DateTime selectedDate;
  final int selectedIndex;
  final void Function(int index, String label) onSelected;

  @override
  Widget build(BuildContext context) {
    final slots = _aggregateSlots();

    if (specialists.isEmpty) {
      return const _EmptySlotsMessage(
        message: 'No specialist is available for this service.',
      );
    }

    if (slots.isEmpty) {
      return const _EmptySlotsMessage(
        message: 'No available time slots for this date.',
      );
    }

    final morning = slots.where((s) => _isMorning(s.label)).toList();
    final afternoon = slots.where((s) => !_isMorning(s.label)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (morning.isNotEmpty)
          _SlotGroup(
            icon: Symbols.light_mode,
            label: 'Morning',
            slots: morning,
            selectedIndex: selectedIndex,
            onSelected: onSelected,
          ),
        if (morning.isNotEmpty && afternoon.isNotEmpty)
          SizedBox(height: AppDimens.spaceXxl),
        if (afternoon.isNotEmpty)
          _SlotGroup(
            icon: Symbols.wb_sunny,
            label: 'Afternoon',
            slots: afternoon,
            selectedIndex: selectedIndex,
            onSelected: onSelected,
          ),
      ],
    );
  }

  List<_AutoSlot> _aggregateSlots() {
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final availableByLabel = <String, bool>{};

    for (final specialist in specialists) {
      for (final day in specialist.daySchedules) {
        if (DateFormat('yyyy-MM-dd').format(day.date) != dateStr) {
          continue;
        }
        for (final slot in day.timeSlots) {
          final current = availableByLabel[slot.label] ?? false;
          availableByLabel[slot.label] = current || slot.isAvailable;
        }
      }
    }

    final labels = availableByLabel.keys.toList()
      ..sort((a, b) => _minutesOfDay(a).compareTo(_minutesOfDay(b)));

    return [
      for (var i = 0; i < labels.length; i++)
        _AutoSlot(
          index: i,
          label: labels[i],
          isAvailable: availableByLabel[labels[i]] ?? false,
        ),
    ];
  }

  bool _isMorning(String label) => _minutesOfDay(label) < 12 * 60;

  int _minutesOfDay(String label) {
    final normalized = label.trim().toUpperCase();
    try {
      final parsed = DateFormat('h:mm a').parse(normalized);
      return parsed.hour * 60 + parsed.minute;
    } catch (_) {
      final parts = normalized.split(':');
      final hour = int.tryParse(parts.first) ?? 0;
      final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      return hour * 60 + minute;
    }
  }
}

class _SlotGroup extends StatelessWidget {
  const _SlotGroup({
    required this.icon,
    required this.label,
    required this.slots,
    required this.selectedIndex,
    required this.onSelected,
  });

  final IconData icon;
  final String label;
  final List<_AutoSlot> slots;
  final int selectedIndex;
  final void Function(int index, String label) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: theme.colorScheme.primary),
            SizedBox(width: AppDimens.spaceSm),
            Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimens.spaceMd),
        Wrap(
          spacing: AppDimens.spaceSm,
          runSpacing: AppDimens.spaceSm,
          children: [
            for (final slot in slots)
              ChoiceChip(
                label: Text(slot.label),
                selected: selectedIndex == slot.index,
                onSelected: slot.isAvailable
                    ? (_) => onSelected(slot.index, slot.label)
                    : null,
              ),
          ],
        ),
      ],
    );
  }
}

class _EmptySlotsMessage extends StatelessWidget {
  const _EmptySlotsMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Text(message, style: theme.textTheme.bodyMedium),
    );
  }
}

class _AutoSlot {
  const _AutoSlot({
    required this.index,
    required this.label,
    required this.isAvailable,
  });

  final int index;
  final String label;
  final bool isAvailable;
}
