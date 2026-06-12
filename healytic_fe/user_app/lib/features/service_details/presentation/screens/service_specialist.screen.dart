import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:common/utils/demensions.dart';

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
    'auto_assigned_time_slot_section.widget.dart';
import 'package:user_app/features/booking/'
    'presentation/widgets/book_appointment/'
    'booking_bottom_action.widget.dart';
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
    'domain/entities/service_details.entity.dart'
    as service_details;
import 'package:user_app/features/service_details/'
    'presentation/providers/'
    'service_details.provider.dart';
import 'package:user_app/features/service_details/'
    'presentation/widgets/service_details/'
    'reviews_section_loader.widget.dart';
import 'package:user_app/router/routes.dart';

/// Specialist selection screen for the Service
/// Treatment flow.
///
/// Fetches specialists by [serviceId] and lets
/// the user pick a specialist, date, and time
/// slot. No step indicator or booking-flow
/// state is involved.
class ServiceSpecialistScreen extends ConsumerStatefulWidget {
  const ServiceSpecialistScreen({super.key, required this.serviceId});

  /// Service identifier used to fetch
  /// specialists.
  final String serviceId;

  @override
  ConsumerState<ServiceSpecialistScreen> createState() =>
      _ServiceSpecialistScreenState();
}

class _ServiceSpecialistScreenState
    extends ConsumerState<ServiceSpecialistScreen> {
  int _selectedSpecialistIdx = -1;
  int _selectedDateIdx = -1;
  int _selectedTimeSlotIdx = -1;
  String _selectedTimeSlotLabel = '';

  bool get _canContinue => _selectedDateIdx >= 0 && _selectedTimeSlotIdx >= 0;

  void _handleBack() {
    if (context.canPop()) context.pop();
  }

  void _handleContinue() {
    if (!_canContinue) return;

    final flowNotifier = ref.read(bookingFlowProvider.notifier);

    // Build a BookingService from the cached
    // ServiceDetailsEntity for this serviceId.
    final detailsAsync = ref.read(
      serviceDetailsProvider(serviceId: widget.serviceId),
    );
    detailsAsync.whenData((details) {
      final service = BookingService(
        id: details.id,
        title: details.title,
        duration: _extractDuration(details),
        price: details.price,
        imageUrl: details.images.isNotEmpty ? details.images.first : null,
        clinicName: details.clinic.name,
        clinicAddress: details.clinic.address,
      );
      flowNotifier.selectService(service);
    });

    if (_selectedSpecialistIdx >= 0) {
      final specialists = ref
          .read(specialistsByServiceProvider(widget.serviceId))
          .value;
      if (specialists == null || _selectedSpecialistIdx >= specialists.length) {
        return;
      }
      flowNotifier.selectSpecialist(specialists[_selectedSpecialistIdx]);
    } else {
      flowNotifier.selectAutoAssignedSpecialist();
    }

    final selectedDate = DateTime.now().add(Duration(days: _selectedDateIdx));
    flowNotifier.selectDate(selectedDate);

    flowNotifier.selectTimeSlot(_selectedTimeSlotIdx, _selectedTimeSlotLabel);

    const BookingSummaryRoute().push(context);
  }

  /// Extracts a duration label from feature tags
  /// or falls back to a default.
  String _extractDuration(dynamic details) {
    for (final tag in details.featureTags) {
      final label = tag.label.toLowerCase();
      if (label.contains('min') || label.contains('hour')) {
        return tag.label;
      }
    }
    return '';
  }

  void _onSpecialistSelected(int index) {
    setState(() {
      _selectedSpecialistIdx = _selectedSpecialistIdx == index ? -1 : index;
      _selectedDateIdx = -1;
      _selectedTimeSlotIdx = -1;
      _selectedTimeSlotLabel = '';
    });
  }

  void _onDateSelected(int index) {
    setState(() {
      _selectedDateIdx = index;
      _selectedTimeSlotIdx = -1;
    });
  }

  void _onTimeSlotSelected(int index, String label) {
    setState(() {
      _selectedTimeSlotIdx = index;
      _selectedTimeSlotLabel = label;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);
    final sectionGap = AppDimens.sectionSpacing(context);

    final bookingSpecialistsAsync = ref.watch(
      specialistsByServiceProvider(widget.serviceId),
    );
    final autoSpecialistsAsync = ref.watch(
      serviceEmployeesProvider(serviceId: widget.serviceId),
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _handleBack,
        ),
        title: const Text('Schedule Appointment'),
      ),
      body: _CombinedSpecialistBody(
        bookingSpecialistsAsync: bookingSpecialistsAsync,
        autoSpecialistsAsync: autoSpecialistsAsync,
        builder: (bookingSpecialists, autoSpecialists) {
          return _ServiceSpecialistBody(
            hPad: hPad,
            sectionGap: sectionGap,
            serviceId: widget.serviceId,
            bookingSpecialists: bookingSpecialists,
            autoSpecialists: autoSpecialists,
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

/// Scrollable body for service specialist
/// selection — no step indicator.
class _ServiceSpecialistBody extends StatelessWidget {
  const _ServiceSpecialistBody({
    required this.hPad,
    required this.sectionGap,
    required this.serviceId,
    required this.bookingSpecialists,
    required this.autoSpecialists,
    required this.selectedSpecialistIdx,
    required this.selectedDateIdx,
    required this.selectedTimeSlotIdx,
    required this.onSpecialistSelected,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
  });

  final double hPad;
  final double sectionGap;
  final String serviceId;
  final List<BookingSpecialist> bookingSpecialists;
  final List<service_details.SpecialistEntity> autoSpecialists;
  final int selectedSpecialistIdx;
  final int selectedDateIdx;
  final int selectedTimeSlotIdx;
  final ValueChanged<int> onSpecialistSelected;
  final ValueChanged<int> onDateSelected;
  final void Function(int, String) onTimeSlotSelected;

  @override
  Widget build(BuildContext context) {
    final hasSelectedSpecialist =
        selectedSpecialistIdx >= 0 &&
        selectedSpecialistIdx < bookingSpecialists.length;
    final selectedSpecialist = hasSelectedSpecialist
        ? bookingSpecialists[selectedSpecialistIdx]
        : null;

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
            _OptionalSpecialistNotice(specialistCount: autoSpecialists.length),

            SizedBox(height: sectionGap),
            if (bookingSpecialists.isEmpty)
              const _EmptySpecialistMessage()
            else
              SpecialistCardList(
                specialists: bookingSpecialists,
                selectedIndex: hasSelectedSpecialist
                    ? selectedSpecialistIdx
                    : -1,
                onSelected: onSpecialistSelected,
                title: 'Select Specialist (Optional)',
              ),

            SizedBox(height: sectionGap),
            _SectionTitle(title: 'Select Date'),
            SizedBox(height: AppDimens.spaceMd),
            DatePickerRow(
              selectedIndex: selectedDateIdx,
              onSelected: onDateSelected,
            ),

            if (selectedDateIdx >= 0) ...[
              SizedBox(height: sectionGap),
              _SectionTitle(title: 'Available Time Slots'),
              SizedBox(height: AppDimens.spaceMd),
              if (selectedSpecialist != null)
                TimeSlotSection(
                  employeeId: selectedSpecialist.id,
                  currentServiceId: serviceId,
                  selectedDate: DateTime.now().add(
                    Duration(days: selectedDateIdx),
                  ),
                  selectedIndex: selectedTimeSlotIdx,
                  onSelected: onTimeSlotSelected,
                )
              else
                AutoAssignedTimeSlotSection(
                  specialists: autoSpecialists,
                  selectedDate: DateTime.now().add(
                    Duration(days: selectedDateIdx),
                  ),
                  selectedIndex: selectedTimeSlotIdx,
                  onSelected: onTimeSlotSelected,
                ),
            ],

            SizedBox(height: sectionGap),

            if (selectedSpecialist != null)
              ReviewsSectionLoader(
                employeeId: selectedSpecialist.id,
                onViewMoreTap: (context) => EmployeeReviewsRoute(
                  employeeId: selectedSpecialist.id,
                  employeeName: selectedSpecialist.name,
                ).push(context),
              ),

            SizedBox(height: sectionGap),
          ],
        ),
      ),
    );
  }
}

class _CombinedSpecialistBody extends StatelessWidget {
  const _CombinedSpecialistBody({
    required this.bookingSpecialistsAsync,
    required this.autoSpecialistsAsync,
    required this.builder,
  });

  final AsyncValue<List<BookingSpecialist>> bookingSpecialistsAsync;
  final AsyncValue<List<service_details.SpecialistEntity>> autoSpecialistsAsync;
  final Widget Function(
    List<BookingSpecialist>,
    List<service_details.SpecialistEntity>,
  )
  builder;

  @override
  Widget build(BuildContext context) {
    if (bookingSpecialistsAsync.isLoading || autoSpecialistsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final error = bookingSpecialistsAsync.error ?? autoSpecialistsAsync.error;
    if (error != null) {
      return Center(child: Text('Error: $error'));
    }

    return builder(
      bookingSpecialistsAsync.value ?? const [],
      autoSpecialistsAsync.value ?? const [],
    );
  }
}

class _OptionalSpecialistNotice extends StatelessWidget {
  const _OptionalSpecialistNotice({required this.specialistCount});

  final int specialistCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDimens.spaceLg),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
        borderRadius: AppDimens.radiusMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a specialist or let the clinic assign one',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppDimens.spaceXs),
          Text(
            specialistCount > 0
                ? 'Leave specialist unselected to book with the best available specialist from $specialistCount eligible clinic staff.'
                : 'The clinic will confirm the specialist after booking.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySpecialistMessage extends StatelessWidget {
  const _EmptySpecialistMessage();

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
      child: Text(
        'No specialist list is available. The clinic will assign one automatically.',
        style: theme.textTheme.bodyMedium,
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
