import 'package:common/utils/demensions.dart';
import 'package:common/widgets/horizontal_date_selector.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:user_app/features/service_details/domain/entities/service_details.entity.dart';
import 'package:user_app/features/service_details/presentation/providers/service_details.provider.dart';

/// Type aliases for backward compatibility within this file.
typedef Specialist = SpecialistEntity;
typedef TimeSlot = TimeSlotEntity;

/// Full specialist section: header, avatar scroll, quote card
/// with expandable "Show More" panel, date selector, and
/// time-slot grid.
///
/// Watches [serviceEmployeesProvider] via [serviceId] to
/// load specialist data. Tapping an avatar switches the
/// selected specialist and resets the expanded state.
class SpecialistSection extends ConsumerStatefulWidget {
  const SpecialistSection({
    super.key,
    required this.serviceId,
    this.onViewAll,
    this.onSpecialistChanged,
    this.onSlotSelected,
  });

  /// Service identifier used to fetch employees.
  final String serviceId;
  final VoidCallback? onViewAll;

  /// Fires when the selected specialist changes.
  /// Provides (employeeId, employeeName).
  final void Function(String employeeId, String employeeName)?
  onSpecialistChanged;

  /// Fires when a time slot is tapped.
  /// Provides (selectedDate, slotLabel).
  final void Function(DateTime selectedDate, String slotLabel)? onSlotSelected;

  @override
  ConsumerState<SpecialistSection> createState() => _SpecialistSectionState();
}

class _SpecialistSectionState extends ConsumerState<SpecialistSection> {
  late int _selectedIndex;
  bool _showMore = false;

  /// Currently selected date for viewing time slots.
  late DateTime _selectedDate;

  // ── Cached schedule data ──
  Set<DateTime> _disabledDates = {};
  Set<DateTime> _enabledDates = {};
  List<TimeSlot> _slotsForDate = const [];

  /// Currently selected time-slot label (e.g. "09:00 AM").
  String? _selectedSlotLabel;

  /// The last specialist list used to compute caches.
  List<Specialist> _lastSpecialists = const [];

  @override
  void initState() {
    super.initState();
    _selectedDate = _today;
  }

  /// Initialise the selected index the first time data
  /// arrives, and re-cache schedules when the specialists
  /// list changes.
  void _syncWithSpecialists(List<Specialist> specialists) {
    if (identical(specialists, _lastSpecialists)) return;
    _lastSpecialists = specialists;

    _selectedIndex = specialists.indexWhere((s) => s.isSelected);
    if (_selectedIndex < 0) _selectedIndex = 0;
    _cacheSchedules(specialists[_selectedIndex].daySchedules);
    _notifySpecialistChanged(specialists[_selectedIndex]);
  }

  /// Pre-compute disabled/enabled date sets and
  /// slots for the selected date.
  void _cacheSchedules(List<DayScheduleEntity> daySchedules) {
    _disabledDates = daySchedules
        .where((d) => !d.isAvailable)
        .map((d) => DateTime(d.date.year, d.date.month, d.date.day))
        .toSet();
    _enabledDates = daySchedules
        .where((d) => d.isAvailable)
        .map((d) => DateTime(d.date.year, d.date.month, d.date.day))
        .toSet();
    _updateSlotsForDate(daySchedules);
  }

  /// Update cached slots for [_selectedDate].
  void _updateSlotsForDate(List<DayScheduleEntity> daySchedules) {
    final schedule = daySchedules.where(
      (d) => _isSameDay(d.date, _selectedDate),
    );
    _slotsForDate = schedule.isEmpty ? const [] : schedule.first.timeSlots;
  }

  /// Today at midnight.
  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Returns a [DateTime] with time set to midnight.
  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Returns true if two dates represent the same day.
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  void _onAvatarTap(int index, List<Specialist> specialists) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      _showMore = false;
      _selectedSlotLabel = null;
      _cacheSchedules(specialists[index].daySchedules);
    });
    _notifySpecialistChanged(specialists[index]);
  }

  void _onDateSelected(DateTime date, List<DayScheduleEntity> daySchedules) {
    setState(() {
      _selectedDate = date;
      _selectedSlotLabel = null;
      _updateSlotsForDate(daySchedules);
    });
  }

  void _onSlotTap(String label) {
    setState(() => _selectedSlotLabel = label);
    widget.onSlotSelected?.call(_selectedDate, label);
  }

  void _notifySpecialistChanged(Specialist specialist) {
    widget.onSpecialistChanged?.call(specialist.id, specialist.name);
  }

  void _toggleShowMore() => setState(() => _showMore = !_showMore);

  /// Opens the material date picker modal with
  /// disabled dates grayed out.
  Future<void> _showCalendarModal(List<DayScheduleEntity> daySchedules) async {
    final firstDate = daySchedules.isNotEmpty
        ? _dateOnly(daySchedules.first.date)
        : _today;
    final lastDate = daySchedules.isNotEmpty
        ? _dateOnly(daySchedules.last.date)
        : _today.add(const Duration(days: 30));

    final enabled = _enabledDates;

    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (date) {
        return enabled.contains(DateTime(date.year, date.month, date.day));
      },
    );
    if (picked != null && mounted) {
      _onDateSelected(picked, daySchedules);
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncEmployees = ref.watch(
      serviceEmployeesProvider(serviceId: widget.serviceId),
    );

    return asyncEmployees.when(
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimens.spaceLg),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (specialists) {
        if (specialists.isEmpty) {
          return const SizedBox.shrink();
        }
        _syncWithSpecialists(specialists);
        return _buildContent(context, specialists);
      },
    );
  }

  Widget _buildContent(BuildContext context, List<Specialist> specialists) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    final selected = specialists[_selectedIndex];
    final daySchedules = selected.daySchedules;

    // Determine first date from schedules
    final firstDate = daySchedules.isNotEmpty
        ? DateTime(
            daySchedules.first.date.year,
            daySchedules.first.date.month,
            daySchedules.first.date.day,
          )
        : _today;

    final slots = _slotsForDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Meet your Specialist',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: widget.onViewAll,
              child: Text(
                'View all',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        AppDimens.verticalMedium,

        // Specialist avatars – horizontal scroll
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              for (int i = 0; i < specialists.length; i++) ...[
                if (i > 0) AppDimens.horizontalMedium,
                GestureDetector(
                  onTap: () => _onAvatarTap(i, specialists),
                  child: _SpecialistAvatar(
                    specialist: specialists[i],
                    isSelected: i == _selectedIndex,
                  ),
                ),
              ],
            ],
          ),
        ),
        AppDimens.verticalMedium,

        // Quote card + expandable details
        _QuoteCard(
          specialist: selected,
          showMore: _showMore,
          onToggle: _toggleShowMore,
          isDark: isDark,
        ),
        AppDimens.verticalLarge,

        // Available slots header
        Text(
          'Available Slots',
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        AppDimens.verticalMediumSmall,

        // Horizontal date selector + calendar modal
        HorizontalDateSelector(
          firstDate: firstDate,
          selectedDate: _selectedDate,
          onDateSelected: (d) => _onDateSelected(d, daySchedules),
          dayCount: 7,
          disabledDates: _disabledDates,
          onShowMore: () => _showCalendarModal(daySchedules),
        ),
        AppDimens.verticalExtraLarge,

        // Selected date label
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: AppDimens.iconMd,
              color: colorScheme.primary,
            ),
            AppDimens.horizontalSmall,
            Text(
              DateFormat.yMMMMEEEEd().format(_selectedDate),
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        AppDimens.verticalMediumSmall,

        // Time slots grid or empty state
        // Key on selected date so expand/collapse
        // state resets when the date changes.
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: slots.isEmpty
              ? _NoSlotsMessage(
                  key: ValueKey('empty-$_selectedDate'),
                  isDark: isDark,
                )
              : _MorningAfternoonSlots(
                  key: ValueKey('slots-$_selectedDate'),
                  slots: slots,
                  selectedLabel: _selectedSlotLabel,
                  onSlotTap: _onSlotTap,
                ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────
// No-slots empty state
// ───────────────────────────────────────────────────

class _NoSlotsMessage extends StatelessWidget {
  const _NoSlotsMessage({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainerLow,
        borderRadius: AppDimens.radiusMediumSmall,
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_busy,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            size: AppDimens.iconLg,
          ),
          AppDimens.verticalSmall,
          Text(
            'No slots available on this date',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────
// Quote Card with animated "Show More / Show Less"
// ───────────────────────────────────────────────────

class _QuoteCard extends StatelessWidget {
  const _QuoteCard({
    required this.specialist,
    required this.showMore,
    required this.onToggle,
    required this.isDark,
  });

  final Specialist specialist;
  final bool showMore;
  final VoidCallback onToggle;
  final bool isDark;

  /// True when there is any extra content to reveal.
  bool get _hasExpandableContent =>
      specialist.experience != null ||
      specialist.specializations != null ||
      specialist.bio != null;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (specialist.quote == null && !_hasExpandableContent) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: AppDimens.paddingAllMedium,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: AppDimens.radiusMediumSmall,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          // Quote row
          if (specialist.quote != null) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.format_quote,
                  color: colorScheme.primary,
                  size: AppDimens.iconMd,
                ),
                AppDimens.horizontalMediumSmall,
                Expanded(
                  child: Text(
                    specialist.quote!,
                    style: textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                      color: isDark
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            AppDimens.verticalSmall,
            Divider(
              color: colorScheme.primary.withValues(alpha: 0.1),
              height: 1,
            ),
            AppDimens.verticalSmall,
          ],

          // Credentials + Show More toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Credentials
              Expanded(child: _Credentials(specialist: specialist)),
              // Show More / Less toggle
              if (_hasExpandableContent)
                GestureDetector(
                  onTap: onToggle,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        showMore ? 'Show Less' : 'Show More',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      AnimatedRotation(
                        turns: showMore ? 0.5 : 0.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.expand_more,
                          size: AppDimens.iconXs,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          // Expandable details panel
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            alignment: Alignment.topCenter,
            child: showMore
                ? _ExpandedDetails(specialist: specialist, isDark: isDark)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────
// Credentials row (degrees + languages)
// ───────────────────────────────────────────────────

class _Credentials extends StatelessWidget {
  const _Credentials({required this.specialist});

  final Specialist specialist;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        if (specialist.degrees != null) ...[
          Icon(
            Icons.school,
            size: AppDimens.iconXs,
            color: colorScheme.primary,
          ),
          AppDimens.horizontalExtraSmall,
          Flexible(
            child: Text(
              specialist.degrees!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          AppDimens.horizontalMediumSmall,
        ],
        if (specialist.languages != null) ...[
          Icon(
            Icons.language,
            size: AppDimens.iconXs,
            color: colorScheme.primary,
          ),
          AppDimens.horizontalExtraSmall,
          Flexible(
            child: Text(
              specialist.languages!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ───────────────────────────────────────────────────
// Expanded details (experience, specializations, bio)
// ───────────────────────────────────────────────────

class _ExpandedDetails extends StatelessWidget {
  const _ExpandedDetails({required this.specialist, required this.isDark});

  final Specialist specialist;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: AppDimens.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: colorScheme.primary.withValues(alpha: 0.1), height: 1),
          const SizedBox(height: AppDimens.spaceMd),

          // Experience
          if (specialist.experience != null) ...[
            _DetailRow(
              icon: Icons.work_outline,
              label: 'Experience',
              value: specialist.experience!,
            ),
            const SizedBox(height: AppDimens.spaceSm),
          ],

          // Specializations chips
          if (specialist.specializations != null &&
              specialist.specializations!.isNotEmpty) ...[
            _DetailRow(icon: Icons.star_outline, label: 'Specializations'),
            const SizedBox(height: AppDimens.spaceXs),
            Wrap(
              spacing: AppDimens.spaceXs,
              runSpacing: AppDimens.spaceXs,
              children: specialist.specializations!
                  .map(
                    (tag) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimens.spaceSm,
                        vertical: AppDimens.spaceXxs,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: AppDimens.spaceSm),
          ],

          // Bio
          if (specialist.bio != null)
            Text(
              specialist.bio!,
              style: textTheme.bodySmall?.copyWith(
                height: 1.6,
                color: isDark
                    ? colorScheme.onSurface
                    : colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

/// Small helper row: icon + label + optional value.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.icon, required this.label, this.value});

  final IconData icon;
  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: AppDimens.iconXs, color: colorScheme.primary),
        AppDimens.horizontalExtraSmall,
        Text(
          value != null ? '$label: $value' : label,
          style: textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────
// Specialist avatar
// ───────────────────────────────────────────────────

/// Individual specialist avatar with selection ring
/// and check badge.
class _SpecialistAvatar extends StatelessWidget {
  const _SpecialistAvatar({required this.specialist, required this.isSelected});

  final Specialist specialist;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Apply reduced opacity via color alpha instead
    // of the Opacity widget to avoid an extra
    // compositing layer.
    final double alpha = isSelected ? 1.0 : 0.6;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          // Avatar with optional ring
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: EdgeInsets.all(isSelected ? 3 : 1),
                  decoration: isSelected
                      ? BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.primary,
                            width: 2,
                          ),
                        )
                      : null,
                  child: ClipOval(
                    child: Image.network(
                      specialist.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.person,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                // Check badge
                if (isSelected)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          AppDimens.verticalSmall,
          // Name
          Text(
            specialist.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.onSurface.withValues(alpha: alpha),
            ),
          ),
          // Role
          Text(
            specialist.role.toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              fontSize: 10,
              letterSpacing: 0.5,
              color: colorScheme.onSurfaceVariant.withValues(alpha: alpha),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────────────────────────────────
// Morning & Afternoon split
// ───────────────────────────────────────────────────

/// Splits time slots into morning (AM) and afternoon
/// (PM) groups, rendering each in its own labeled grid
/// with independent expand/collapse.
class _MorningAfternoonSlots extends StatefulWidget {
  const _MorningAfternoonSlots({
    super.key,
    required this.slots,
    this.selectedLabel,
    this.onSlotTap,
  });

  final List<TimeSlot> slots;
  final String? selectedLabel;
  final ValueChanged<String>? onSlotTap;

  @override
  State<_MorningAfternoonSlots> createState() => _MorningAfternoonSlotsState();
}

class _MorningAfternoonSlotsState extends State<_MorningAfternoonSlots> {
  /// Max slots shown before "See more" appears.
  static const _maxCollapsed = 6;

  bool _morningExpanded = false;
  bool _afternoonExpanded = false;

  @override
  Widget build(BuildContext context) {
    final morning = widget.slots
        .where((s) => s.label.toUpperCase().contains('AM'))
        .toList();
    final afternoon = widget.slots
        .where((s) => s.label.toUpperCase().contains('PM'))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (morning.isNotEmpty) ...[
          _SectionHeader(
            icon: Icons.wb_sunny_outlined,
            label: 'Morning',
            totalCount: morning.length,
            isExpanded: _morningExpanded,
            onToggle: morning.length > _maxCollapsed
                ? () => setState(() => _morningExpanded = !_morningExpanded)
                : null,
          ),
          AppDimens.verticalSmall,
          _TimeSlotsGrid(
            slots: _morningExpanded
                ? morning
                : morning.take(_maxCollapsed).toList(),
            selectedLabel: widget.selectedLabel,
            onSlotTap: widget.onSlotTap,
          ),
        ],
        if (afternoon.isNotEmpty) ...[
          if (morning.isNotEmpty) AppDimens.verticalMedium,
          _SectionHeader(
            icon: Icons.wb_twilight,
            label: 'Afternoon',
            totalCount: afternoon.length,
            isExpanded: _afternoonExpanded,
            onToggle: afternoon.length > _maxCollapsed
                ? () => setState(() => _afternoonExpanded = !_afternoonExpanded)
                : null,
          ),
          AppDimens.verticalSmall,
          _TimeSlotsGrid(
            slots: _afternoonExpanded
                ? afternoon
                : afternoon.take(_maxCollapsed).toList(),
            selectedLabel: widget.selectedLabel,
            onSlotTap: widget.onSlotTap,
          ),
        ],
      ],
    );
  }
}

/// Section header with icon, label, and optional
/// "See more / See less" toggle.
class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
    required this.totalCount,
    required this.isExpanded,
    this.onToggle,
  });

  final IconData icon;
  final String label;
  final int totalCount;
  final bool isExpanded;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: AppDimens.iconSm, color: colorScheme.primary),
        AppDimens.horizontalExtraSmall,
        Text(
          label,
          style: textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        if (onToggle != null)
          GestureDetector(
            onTap: onToggle,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isExpanded ? 'See less' : 'See more',
                  style: textTheme.labelSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.expand_more,
                    size: AppDimens.iconXs,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// ───────────────────────────────────────────────────
// Time-slot grid
// ───────────────────────────────────────────────────

/// 3-column grid of time-slot buttons.
class _TimeSlotsGrid extends StatelessWidget {
  const _TimeSlotsGrid({
    required this.slots,
    this.selectedLabel,
    this.onSlotTap,
  });

  final List<TimeSlot> slots;
  final String? selectedLabel;
  final ValueChanged<String>? onSlotTap;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      padding: EdgeInsets.zero,
      mainAxisSpacing: AppDimens.spaceMd,
      crossAxisSpacing: AppDimens.spaceMd,
      childAspectRatio: 2.6,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final slot in slots)
          _SlotButton(
            label: slot.label,
            isAvailable: slot.isAvailable,
            isSelected: slot.label == selectedLabel,
            onTap: slot.isAvailable ? () => onSlotTap?.call(slot.label) : null,
          ),
      ],
    );
  }
}

/// Individual time-slot button — filled primary if
/// available, grey if unavailable.
class _SlotButton extends StatelessWidget {
  const _SlotButton({
    required this.label,
    required this.isAvailable,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final bool isAvailable;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;

    // Unavailable slot — greyed out, not tappable.
    if (!isAvailable) {
      return Container(
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surfaceContainerLow,
          borderRadius: AppDimens.radiusMediumSmall,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    // Selected slot — filled primary with ring.
    // Available slot — outlined primary.
    final bgColor = isSelected ? colorScheme.primary : Colors.transparent;
    final textColor = isSelected ? colorScheme.onPrimary : colorScheme.primary;
    final border = isSelected
        ? null
        : Border.all(color: colorScheme.primary.withValues(alpha: 0.4));

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: AppDimens.radiusMediumSmall,
          border: border,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
