import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';

import '../../../../router/routes.dart';
import '../../domain/entities/booking.entity.dart';
import '../providers/booking.provider.dart';
import '../providers/booking_flow.provider.dart';
import '../widgets/book_appointment/booking_bottom_action.widget.dart';
import '../widgets/book_appointment/booking_step_indicator.widget.dart';
import '../widgets/book_appointment/date_picker_row.widget.dart';
import '../widgets/book_appointment/specialist_card_list.widget.dart';
import '../widgets/book_appointment/time_slot_section.widget.dart';
import 'package:user_app/features/service_details/presentation/widgets/service_details/reviews_section_loader.widget.dart';

/// Step 2 of the booking flow: Select Specialist,
/// Date, and Time Slot.
///
/// Fetches specialists by [categoryId] selected
/// in Step 1.
///
/// Navigates to [BookingSummaryRoute] on continue.
class SelectSpecialistScreen extends ConsumerStatefulWidget {
  const SelectSpecialistScreen({super.key, required this.categoryId});

  /// Category identifier used to fetch
  /// specialists.
  final String categoryId;

  @override
  ConsumerState<SelectSpecialistScreen> createState() =>
      _SelectSpecialistScreenState();
}

class _SelectSpecialistScreenState
    extends ConsumerState<SelectSpecialistScreen> {
  int _selectedSpecialistIdx = -1;
  int _selectedDateIdx = -1;
  int _selectedTimeSlotIdx = -1;
  String _selectedTimeSlotLabel = '';

  List<BookingSpecialist> _specialists = [];

  bool get _canContinue =>
      _selectedSpecialistIdx >= 0 &&
      _selectedDateIdx >= 0 &&
      _selectedTimeSlotIdx >= 0;

  void _handleBack() {
    if (context.canPop()) context.pop();
  }

  void _handleContinue() {
    if (!_canContinue) return;

    final specialist = _specialists[_selectedSpecialistIdx];
    final flowNotifier = ref.read(bookingFlowProvider.notifier);

    flowNotifier.selectSpecialist(specialist);

    final selectedDate = DateTime.now().add(
      Duration(days: _selectedDateIdx),
    );
    flowNotifier.selectDate(selectedDate);

    flowNotifier.selectTimeSlot(
      _selectedTimeSlotIdx,
      _selectedTimeSlotLabel,
    );

    const BookingSummaryRoute().push(context);
  }

  void _onSpecialistSelected(int index) {
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

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hPad = AppDimens.horizontalPadding(context);
    final sectionGap = AppDimens.sectionSpacing(context);

    final specialistsAsync = ref.watch(
      specialistsByCategoryProvider(widget.categoryId),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (specialists) {
          _specialists = specialists;
          return _Step2Body(
            categoryId: widget.categoryId,
            hPad: hPad,
            sectionGap: sectionGap,
            specialists: specialists,
            selectedSpecialistIdx: _selectedSpecialistIdx,
            selectedDateIdx: _selectedDateIdx,
            selectedTimeSlotIdx: _selectedTimeSlotIdx,
            onSpecialistSelected: _onSpecialistSelected,
            onDateSelected: _onDateSelected,
            onTimeSlotSelected: _onTimeSlotSelected,
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

/// Scrollable body for Step 2.
class _Step2Body extends StatelessWidget {
  const _Step2Body({
    required this.categoryId,
    required this.hPad,
    required this.sectionGap,
    required this.specialists,
    required this.selectedSpecialistIdx,
    required this.selectedDateIdx,
    required this.selectedTimeSlotIdx,
    required this.onSpecialistSelected,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
  });

  final String categoryId;
  final double hPad;
  final double sectionGap;
  final List<BookingSpecialist> specialists;
  final int selectedSpecialistIdx;
  final int selectedDateIdx;
  final int selectedTimeSlotIdx;
  final ValueChanged<int> onSpecialistSelected;
  final ValueChanged<int> onDateSelected;
  final void Function(int, String) onTimeSlotSelected;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: MediaQuery.of(
          context,
        ).textScaler.clamp(minScaleFactor: 0.8, maxScaleFactor: 1.3),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: hPad,
          vertical: AppDimens.spaceLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            BookingStepIndicator(
              currentStep: 2,
              totalSteps: 3,
              stepLabel: 'Schedule',
            ),
            SizedBox(height: sectionGap),

            // Select Specialist
            SpecialistCardList(
              specialists: specialists,
              selectedIndex: selectedSpecialistIdx,
              onSelected: onSpecialistSelected,
            ),

            // Date & Time (only if specialist
            // is selected)
            if (selectedSpecialistIdx >= 0) ...[
              SizedBox(height: sectionGap),
              _SectionTitle(title: 'Select Date'),
              SizedBox(height: AppDimens.spaceMd),
              DatePickerRow(
                selectedIndex: selectedDateIdx,
                onSelected: onDateSelected,
              ),
            ],

            if (selectedDateIdx >= 0) ...[
              SizedBox(height: sectionGap),
              _SectionTitle(title: 'Available Time Slots'),
              SizedBox(height: AppDimens.spaceMd),
              TimeSlotSection(
                employeeId: specialists[
                        selectedSpecialistIdx]
                    .id,
                selectedDate: DateTime.now().add(
                  Duration(days: selectedDateIdx),
                ),
                selectedIndex: selectedTimeSlotIdx,
                onSelected: onTimeSlotSelected,
              ),
            ],

            SizedBox(height: sectionGap),

            // ── Reviews (shown when specialist
            //    is selected) ──
            if (selectedSpecialistIdx >= 0 && specialists.isNotEmpty)
              ReviewsSectionLoader(
                employeeId: specialists[selectedSpecialistIdx].id,
              ),

            SizedBox(height: sectionGap),
          ],
        ),
      ),
    );
  }
}

/// Reusable section heading.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
