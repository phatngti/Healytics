import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/booking_status.dart';
import '../providers/bookings_controller.provider.dart';

/// Multi-control filter bar for the partner bookings dashboard.
///
/// Exposes two independent filter axes:
/// - Status multi-select chips (Req 5.1)
/// - Free-text search field with 200-char cap (Req 5.4)
///
/// Calls the corresponding [BookingsController] setter methods
/// on value change.
///
/// _(Req 5.1, 5.4)_
class FilterBar extends ConsumerStatefulWidget {
  /// Creates the filter bar.
  const FilterBar({super.key});

  @override
  ConsumerState<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends ConsumerState<FilterBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final state = ref.watch(bookingsControllerProvider).asData?.value;
    if (state == null) return const SizedBox.shrink();

    final activeStatuses = state.filters.statuses;

    return LayoutBuilder(
      builder: (context, constraints) {
        final searchWidth = constraints.maxWidth < 520
            ? constraints.maxWidth
            : 260.0;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ..._buildStatusChips(colorScheme, activeStatuses),
            _buildSearchField(colorScheme, searchWidth),
          ],
        );
      },
    );
  }

  List<Widget> _buildStatusChips(
    ColorScheme colorScheme,
    Set<BookingStatus> activeStatuses,
  ) {
    final isAllSelected = activeStatuses.isEmpty;

    return [
      FilterChip(
        label: const Text('All'),
        selected: isAllSelected,
        onSelected: (_) {
          ref.read(bookingsControllerProvider.notifier).setStatusFilter({});
        },
        selectedColor: colorScheme.primaryContainer,
        checkmarkColor: colorScheme.onPrimaryContainer,
      ),
      ...BookingStatus.values.map((status) {
        final isSelected = activeStatuses.contains(status);
        return FilterChip(
          label: Text(labelFor(status)),
          selected: isSelected,
          onSelected: (selected) {
            final updated = Set<BookingStatus>.from(activeStatuses);
            if (selected) {
              updated.add(status);
            } else {
              updated.remove(status);
            }
            ref
                .read(bookingsControllerProvider.notifier)
                .setStatusFilter(updated);
          },
          selectedColor: colorScheme.primaryContainer,
          checkmarkColor: colorScheme.onPrimaryContainer,
        );
      }),
    ];
  }

  Widget _buildSearchField(ColorScheme colorScheme, double width) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: _searchController,
        maxLength: 200,
        decoration: InputDecoration(
          hintText: 'Search...',
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
          counterText: '',
          isDense: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        onChanged: (value) {
          ref.read(bookingsControllerProvider.notifier).setSearchQuery(value);
        },
      ),
    );
  }
}

class BookingDateStrip extends ConsumerStatefulWidget {
  const BookingDateStrip({super.key});

  @override
  ConsumerState<BookingDateStrip> createState() => _BookingDateStripState();
}

class _BookingDateStripState extends ConsumerState<BookingDateStrip> {
  late final ScrollController _controller;

  static const _pastDays = 7;
  static const _futureDays = 21;
  static const _itemExtent = 78.0;
  static const _visiblePastDays = 3;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController(
      initialScrollOffset: (_pastDays - _visiblePastDays) * _itemExtent,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingsControllerProvider).asData?.value;
    if (state == null) return const SizedBox.shrink();

    final selected = _dateOnly(
      state.filters.dateRange?.start.toLocal() ?? DateTime.now(),
    );
    final today = _dateOnly(DateTime.now());
    final dates = List<DateTime>.generate(
      _pastDays + _futureDays + 1,
      (index) => today.add(Duration(days: index - _pastDays)),
    );

    return SizedBox(
      height: 72,
      child: ListView.separated(
        controller: _controller,
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = _isSameDay(date, selected);
          return _DateChip(
            date: date,
            isSelected: isSelected,
            onPressed: () {
              final selectedDay = _dateOnly(date);
              ref
                  .read(bookingsControllerProvider.notifier)
                  .setDateRange(
                    DateTimeRange(start: selectedDay, end: selectedDay),
                  );
            },
          );
        },
      ),
    );
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.date,
    required this.isSelected,
    required this.onPressed,
  });

  final DateTime date;
  final bool isSelected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final background = isSelected
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final foreground = isSelected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: 70,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat.E().format(date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat.d().format(date),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
