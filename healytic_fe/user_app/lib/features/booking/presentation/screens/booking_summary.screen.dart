import 'package:common/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:common/utils/demensions.dart';
import 'package:intl/intl.dart';
import 'package:user_app/features/cart/presentation/'
    'providers/cart.provider.dart';
import 'package:user_app/features/checkout/domain/entities/'
    'booking_params.entity.dart';
import 'package:user_app/features/checkout/presentation/providers/'
    'checkout.provider.dart';

import '../../../../router/routes.dart';
import '../../domain/entities/'
    'eligibility_detail.entity.dart';
import '../providers/booking_flow.provider.dart';
import '../providers/'
    'eligibility_detail.provider.dart';
import '../widgets/book_appointment/'
    'booking_bottom_action.widget.dart';
import '../widgets/book_appointment/'
    'booking_step_indicator.widget.dart';
import '../widgets/booking_summary/'
    'specialist_service_card.widget.dart';

import '../widgets/booking_summary/'
    'category_service_info.widget.dart';
import '../widgets/booking_summary/'
    'location_details_card.widget.dart';
import '../widgets/booking_summary/'
    'price_breakdown_card.widget.dart';

/// Step 3 of the booking flow: Review all
/// booking selections before confirming payment.
///
/// Supports two entry flows:
/// - **Standard:** BookAppointment →
///   SelectSpecialist → BookingSummary
///   (category + service set).
/// - **Employee:** EmployeeBooking →
///   BookingSummary (only service +
///   specialist set).
///
/// When [eligibilityId] is available from the
/// selected specialist, fetches detailed info
/// from the eligibility API. Otherwise falls
/// back to [bookingFlowProvider] data.
class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() =>
      _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  bool _isAddingToCart = false;

  void _handleBack() {
    if (context.canPop()) context.pop();
  }

  Future<void> _handleAddToCart(
    BookingFlowState flowState,
    EligibilityDetailEntity? detail,
  ) async {
    if (_isAddingToCart) return;

    final bookingParams = _buildBookingParams(
      flowState: flowState,
      detail: detail,
    );
    if (bookingParams == null) {
      AppToast.error(context, 'Select a specialist and time slot first');
      return;
    }

    setState(() => _isAddingToCart = true);
    try {
      final timeSlot = _buildCartTimeSlot(
        bookingParams.selectedDate,
        bookingParams.selectedTimeSlot,
      );
      await ref
          .read(cartProvider.notifier)
          .addItem(
            serviceId: bookingParams.serviceId,
            employeeId: bookingParams.employeeId,
            timeSlot: timeSlot,
          );
      if (!mounted) return;
      AppToast.success(context, 'Added to cart');
    } catch (e) {
      if (!mounted) return;
      AppToast.error(context, 'Failed to add to cart');
    } finally {
      if (mounted) {
        setState(() => _isAddingToCart = false);
      }
    }
  }

  DateTime _buildCartTimeSlot(DateTime date, String timeLabel) {
    final parts = timeLabel.split(RegExp(r'[\s:]+'));
    if (parts.length >= 3) {
      var hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final period = parts[2].toUpperCase();
      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return DateTime(date.year, date.month, date.day, hour, minute);
    }

    return DateTime(date.year, date.month, date.day);
  }

  void _handleConfirm(
    BookingFlowState flowState,
    EligibilityDetailEntity? detail,
  ) {
    final bookingParams = _buildBookingParams(
      flowState: flowState,
      detail: detail,
    );
    if (bookingParams == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Missing booking data. Please select a '
            'service, specialist, date and time again.',
          ),
        ),
      );
      return;
    }
    ref.read(bookingParamsProvider.notifier).set(bookingParams);
    const CheckoutRoute().push(context);
  }

  BookingParams? _buildBookingParams({
    required BookingFlowState flowState,
    required EligibilityDetailEntity? detail,
  }) {
    final service = flowState.selectedService;
    final specialist = flowState.selectedSpecialist;
    final selectedDate = flowState.selectedDate;
    final selectedTimeSlot =
        flowState.selectedTimeSlotLabel ?? detail?.schedule?.timeSlotLabel;

    final serviceId = detail?.service.id ?? service?.id;
    final serviceName = detail?.service.title ?? service?.title;
    final employeeId = detail?.specialist.id ?? specialist?.id;
    final employeeName = detail?.specialist.name ?? specialist?.name;

    if (serviceId == null ||
        serviceName == null ||
        employeeId == null ||
        employeeName == null ||
        selectedDate == null ||
        selectedTimeSlot == null ||
        selectedTimeSlot.isEmpty) {
      return null;
    }

    return BookingParams(
      serviceId: serviceId,
      serviceName: serviceName,
      serviceImageUrl: detail?.service.imageUrl ?? service?.imageUrl ?? '',
      price: detail?.priceBreakdown.formattedTotal ?? service?.price ?? '0 VND',
      clinicName:
          detail?.location.name ?? service?.clinicName ?? 'Unknown clinic',
      clinicAddress:
          detail?.location.address ??
          service?.clinicAddress ??
          'Unknown address',
      clinicImageUrl: detail?.service.imageUrl ?? service?.imageUrl ?? '',
      employeeId: employeeId,
      employeeName: employeeName,
      selectedDate: selectedDate,
      selectedTimeSlot: selectedTimeSlot,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hPad = AppDimens.horizontalPadding(context);
    final sectionGap = AppDimens.sectionSpacing(context);
    final flowState = ref.watch(bookingFlowProvider);

    final eligibilityId = flowState.selectedSpecialist?.eligibilityId;
    final detail = eligibilityId != null
        ? ref.watch(eligibilityDetailProvider(eligibilityId)).asData?.value
        : null;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: _handleBack,
        ),
        title: const Text('Confirm Booking'),
      ),
      body: eligibilityId != null
          ? _EligibilityBody(
              eligibilityId: eligibilityId,
              flowState: flowState,
              hPad: hPad,
              sectionGap: sectionGap,
            )
          : _FallbackBody(
              flowState: flowState,
              hPad: hPad,
              sectionGap: sectionGap,
            ),
      bottomNavigationBar: BookingBottomAction(
        canContinue: flowState.isStep2Complete,
        onContinue: () => _handleConfirm(flowState, detail),
        label: 'Confirm & Pay',
        icon: Symbols.arrow_forward,
        onAddToCart: () => _handleAddToCart(flowState, detail),
        isAddingToCart: _isAddingToCart,
      ),
    );
  }
}

// ─── API-powered body ─────────────────────────────

/// Body that fetches eligibility detail from API.
class _EligibilityBody extends ConsumerWidget {
  const _EligibilityBody({
    required this.eligibilityId,
    required this.flowState,
    required this.hPad,
    required this.sectionGap,
  });

  final String eligibilityId;
  final BookingFlowState flowState;
  final double hPad;
  final double sectionGap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(eligibilityDetailProvider(eligibilityId));

    return detailAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (detail) => _SummaryBody(
        flowState: flowState,
        detail: detail,
        hPad: hPad,
        sectionGap: sectionGap,
      ),
    );
  }
}

// ─── Scrollable body with API data ────────────────

/// Scrollable body composing all summary cards
/// using data from the eligibility detail API.
class _SummaryBody extends StatelessWidget {
  const _SummaryBody({
    required this.flowState,
    required this.detail,
    required this.hPad,
    required this.sectionGap,
  });

  final BookingFlowState flowState;
  final EligibilityDetailEntity detail;
  final double hPad;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    final hasCategory = detail.category.name.isNotEmpty;

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
            // Progress bar (full at step 3/3)
            BookingStepIndicator(
              currentStep: 3,
              totalSteps: 3,
              stepLabel: 'Confirm',
            ),
            SizedBox(height: sectionGap),

            // Specialist hero card
            SpecialistServiceCard(
              specialistName: detail.specialist.name,
              formattedDate: _formatDate(flowState.selectedDate),
              formattedTime: flowState.selectedTimeSlotLabel ?? '—',
              avatarUrl: detail.specialist.avatarUrl,
              specialty: detail.specialist.specialty,
            ),
            SizedBox(height: sectionGap),

            // Category & Service info
            if (hasCategory) ...[
              CategoryServiceInfo(
                categoryName: detail.category.name,
                serviceTitle: detail.service.title,
                serviceSubtitle: detail.service.subtitle,
                serviceImageUrl: detail.service.imageUrl,
              ),
              SizedBox(height: sectionGap),
            ],

            // Location details (API data)
            LocationDetailsCard(
              partnerName: detail.location.name,
              address: detail.location.address,
              latitude: detail.location.latitude,
              longitude: detail.location.longitude,
            ),
            SizedBox(height: sectionGap),

            // Price breakdown (API data)
            PriceBreakdownCard(
              subtotal: detail.priceBreakdown.formattedSubTotal,
              discount: detail.priceBreakdown.formattedDiscount,
              totalAmount: detail.priceBreakdown.formattedTotal,
            ),
            SizedBox(height: sectionGap),
          ],
        ),
      ),
    );
  }

  /// Formats a [DateTime] to a friendly string.
  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('MMM d, yyyy').format(date);
  }
}

// ─── Fallback body (no eligibilityId) ─────────────

/// Fallback body using only bookingFlowProvider
/// data when eligibilityId is not available.
class _FallbackBody extends StatelessWidget {
  const _FallbackBody({
    required this.flowState,
    required this.hPad,
    required this.sectionGap,
  });

  final BookingFlowState flowState;
  final double hPad;
  final double sectionGap;

  @override
  Widget build(BuildContext context) {
    final hasCategory = flowState.selectedCategory != null;

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
            BookingStepIndicator(
              currentStep: 3,
              totalSteps: 3,
              stepLabel: 'Confirm',
            ),
            SizedBox(height: sectionGap),
            SpecialistServiceCard(
              specialistName: flowState.selectedSpecialist?.name ?? '—',
              formattedDate: _formatDate(flowState.selectedDate),
              formattedTime: flowState.selectedTimeSlotLabel ?? '—',
              avatarUrl: flowState.selectedSpecialist?.avatarUrl,
              specialty: flowState.selectedSpecialist?.specialty,
            ),
            SizedBox(height: sectionGap),

            if (hasCategory) ...[
              CategoryServiceInfo(
                categoryName: flowState.selectedCategory?.name ?? '—',
                serviceTitle: flowState.selectedService?.title ?? '—',
                serviceSubtitle: flowState.selectedService?.subtitle,
                serviceImageUrl: flowState.selectedService?.imageUrl,
              ),
              SizedBox(height: sectionGap),
            ],
            const LocationDetailsCard(),
            SizedBox(height: sectionGap),
            const PriceBreakdownCard(),
            SizedBox(height: sectionGap),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return DateFormat('MMM d, yyyy').format(date);
  }
}
