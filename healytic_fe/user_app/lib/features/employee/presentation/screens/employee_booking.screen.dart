import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'package:user_app/features/employee/'
    'presentation/providers/'
    'employee_services.provider.dart';
import 'package:user_app/features/booking/'
    'domain/entities/booking.entity.dart';
import 'package:user_app/features/booking/'
    'presentation/providers/'
    'booking.provider.dart';
import 'package:user_app/features/booking/'
    'presentation/providers/'
    'booking_flow.provider.dart';
import 'package:user_app/features/booking/'
    'presentation/widgets/book_appointment/'
    'date_picker_row.widget.dart';
import 'package:user_app/features/booking/'
    'presentation/widgets/book_appointment/'
    'specialist_card_list.widget.dart';
import 'package:user_app/features/booking/'
    'presentation/widgets/book_appointment/'
    'time_slot_section.widget.dart';
import 'package:user_app/features/service_details/'
    'presentation/widgets/service_details/'
    'reviews_section_loader.widget.dart';
import 'package:user_app/features/employee/'
    'presentation/widgets/'
    'employee_booking_summary/'
    'booking_bottom_action.widget.dart';
import 'package:user_app/router/routes.dart';

/// Booking screen reached from the Employee
/// Detail → Explore Services flow.
///
/// Fetches specialists by [serviceId] and
/// auto-selects the one matching [employeeId].
/// When the specialist is found, selection is
/// locked. If not found, a warning is shown and
/// the user may pick freely.
class EmployeeBookingScreen
    extends ConsumerStatefulWidget {
  const EmployeeBookingScreen({
    super.key,
    required this.employeeId,
    required this.serviceId,
  });

  /// Employee whose profile the user came from.
  final String employeeId;

  /// Service that was tapped in the Explore
  /// Services grid.
  final String serviceId;

  @override
  ConsumerState<EmployeeBookingScreen>
      createState() =>
          _EmployeeBookingScreenState();
}

class _EmployeeBookingScreenState
    extends ConsumerState<EmployeeBookingScreen> {
  int _selectedSpecialistIdx = -1;
  int _selectedDateIdx = -1;
  int _selectedTimeSlotIdx = -1;
  String _selectedTimeSlotLabel = '';

  List<BookingSpecialist> _specialists = [];

  /// Whether auto-selection has been attempted.
  bool _hasAutoSelected = false;

  /// True when the employee was found and locked.
  bool _isLocked = false;

  /// True when the employee was NOT found in the
  /// specialist list.
  bool _showWarning = false;

  bool get _canContinue =>
      _selectedSpecialistIdx >= 0 &&
      _selectedDateIdx >= 0 &&
      _selectedTimeSlotIdx >= 0;

  void _handleBack() {
    if (context.canPop()) context.pop();
  }

  void _handleContinue() {
    if (!_canContinue) return;

    final specialist =
        _specialists[_selectedSpecialistIdx];
    final flowNotifier =
        ref.read(bookingFlowProvider.notifier);

    // Service MUST be set before specialist,
    // because selectService() clears the
    // specialist field internally.
    final servicesAsync = ref.read(
      employeeServicesProvider(
        widget.employeeId,
      ),
    );
    servicesAsync.whenData((services) {
      final service = services.firstWhere(
        (s) => s.id == widget.serviceId,
        orElse: () => services.first,
      );
      flowNotifier.selectService(service);
    });

    flowNotifier.selectSpecialist(specialist);

    final selectedDate = DateTime.now().add(
      Duration(days: _selectedDateIdx),
    );
    flowNotifier.selectDate(selectedDate);

    flowNotifier.selectTimeSlot(
      _selectedTimeSlotIdx,
      _selectedTimeSlotLabel,
    );

    const EmployeeBookingSummaryRoute()
        .push(context);
  }

  void _onSpecialistSelected(int index) {
    if (_isLocked) return;
    setState(() {
      _selectedSpecialistIdx = index;
      _selectedDateIdx = -1;
      _selectedTimeSlotIdx = -1;
    });
  }

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIdx = index;
      _selectedTimeSlotIdx = -1;
    });
  }

  void _onTimeSlotSelected(
    int index,
    String label,
  ) {
    setState(() {
      _selectedTimeSlotIdx = index;
      _selectedTimeSlotLabel = label;
    });
  }

  /// Auto-selects the specialist matching
  /// [widget.employeeId] on first data load.
  void _tryAutoSelect(
    List<BookingSpecialist> specialists,
  ) {
    if (_hasAutoSelected) return;
    _hasAutoSelected = true;

    final idx = specialists.indexWhere(
      (s) => s.id == widget.employeeId,
    );

    if (idx >= 0) {
      _selectedSpecialistIdx = idx;
      _isLocked = true;
      log(
        'EmployeeBooking: auto-selected '
        'specialist at index $idx',
      );
    } else {
      _showWarning = true;
      log(
        'EmployeeBooking: employee '
        '${widget.employeeId} not found in '
        'specialist list',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPad =
        AppDimens.horizontalPadding(context);
    final sectionGap =
        AppDimens.sectionSpacing(context);

    final specialistsAsync = ref.watch(
      specialistsByServiceProvider(
        widget.serviceId,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _handleBack,
        ),
        title: const Text('Book Appointment'),
      ),
      body: specialistsAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (e, _) => Center(
          child: Text('Error: $e'),
        ),
        data: (specialists) {
          _specialists = specialists;
          _tryAutoSelect(specialists);
          return _EmployeeBookingBody(
            hPad: hPad,
            sectionGap: sectionGap,
            specialists: specialists,
            serviceId: widget.serviceId,
            selectedSpecialistIdx:
                _selectedSpecialistIdx,
            selectedDateIdx: _selectedDateIdx,
            selectedTimeSlotIdx:
                _selectedTimeSlotIdx,
            onSpecialistSelected:
                _onSpecialistSelected,
            onDateSelected: _onDateSelected,
            onTimeSlotSelected:
                _onTimeSlotSelected,
            isLocked: _isLocked,
            showWarning: _showWarning,
          );
        },
      ),
      bottomNavigationBar: BookingBottomAction(
        canContinue: _canContinue,
        onContinue: _handleContinue,
      ),
    );
  }
}

// ─── Scrollable body ──────────────────────────────

class _EmployeeBookingBody
    extends StatelessWidget {
  const _EmployeeBookingBody({
    required this.hPad,
    required this.sectionGap,
    required this.specialists,
    required this.serviceId,
    required this.selectedSpecialistIdx,
    required this.selectedDateIdx,
    required this.selectedTimeSlotIdx,
    required this.onSpecialistSelected,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
    required this.isLocked,
    required this.showWarning,
  });

  final double hPad;
  final double sectionGap;
  final List<BookingSpecialist> specialists;
  final String serviceId;
  final int selectedSpecialistIdx;
  final int selectedDateIdx;
  final int selectedTimeSlotIdx;
  final ValueChanged<int> onSpecialistSelected;
  final ValueChanged<int> onDateSelected;
  final void Function(int, String) onTimeSlotSelected;
  final bool isLocked;
  final bool showWarning;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.of(context)
            .textScaler
            .clamp(
              minScaleFactor: 0.8,
              maxScaleFactor: 1.3,
            ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: AppDimens.spaceLg,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // Warning banner when employee
            // is not in the specialist list
            if (showWarning)
              _SpecialistWarningBanner(),

            // Select Specialist
            SpecialistCardList(
              specialists: specialists,
              selectedIndex:
                  selectedSpecialistIdx,
              onSelected: onSpecialistSelected,
              isLocked: isLocked,
            ),

            // Date (once specialist picked)
            if (selectedSpecialistIdx >= 0) ...[
              SizedBox(height: sectionGap),
              _SectionTitle(
                title: 'Select Date',
              ),
              SizedBox(
                height: AppDimens.spaceMd,
              ),
              DatePickerRow(
                selectedIndex: selectedDateIdx,
                onSelected: onDateSelected,
              ),
            ],

            // Time slots (once date picked)
            if (selectedDateIdx >= 0) ...[
              SizedBox(height: sectionGap),
              _SectionTitle(
                title: 'Available Time Slots',
              ),
              SizedBox(
                height: AppDimens.spaceMd,
              ),
              TimeSlotSection(
                employeeId: specialists[
                        selectedSpecialistIdx]
                    .id,
                currentServiceId: serviceId,
                selectedDate: DateTime.now().add(
                  Duration(
                    days: selectedDateIdx,
                  ),
                ),
                selectedIndex:
                    selectedTimeSlotIdx,
                onSelected: onTimeSlotSelected,
              ),
            ],

            SizedBox(height: sectionGap),

            // Reviews for selected specialist
            if (selectedSpecialistIdx >= 0 &&
                specialists.isNotEmpty)
              ReviewsSectionLoader(
                employeeId: specialists[
                        selectedSpecialistIdx]
                    .id,
                onViewMoreTap: (context) => EmployeeReviewsRoute(
                  employeeId: specialists[selectedSpecialistIdx].id,
                  employeeName: specialists[selectedSpecialistIdx].name,
                ).push(context),
              ),

            SizedBox(height: sectionGap),
          ],
        ),
      ),
    );
  }
}

// ─── Warning banner ───────────────────────────────

class _SpecialistWarningBanner
    extends StatelessWidget {
  const _SpecialistWarningBanner();

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.only(
        bottom: AppDimens.spaceMd,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.spaceMd,
          vertical: AppDimens.spaceSm,
        ),
        decoration: BoxDecoration(
          color: colorScheme.errorContainer
              .withValues(alpha: 0.3),
          borderRadius:
              AppDimens.radiusMediumSmall,
          border: Border.all(
            color: colorScheme.error
                .withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Symbols.warning,
              size: AppDimens.iconMd,
              color: colorScheme.error,
            ),
            SizedBox(width: AppDimens.spaceSm),
            Expanded(
              child: Text(
                'The requested specialist is '
                'not available for this '
                'service. Please select a '
                'different specialist.',
                style: textTheme.bodySmall
                    ?.copyWith(
                  color: colorScheme.error,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section title ────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
