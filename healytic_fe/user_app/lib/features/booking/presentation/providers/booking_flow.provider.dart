import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:user_app/features/booking/domain/entities/booking.entity.dart';
import 'package:user_app/features/home/domain/entities/home.entity.dart';

part 'booking_flow.provider.g.dart';

/// Holds the complete booking state across all 3
/// steps of the booking wizard.
///
/// Step 1: [selectedCategory] + [selectedService]
/// Step 2: [selectedSpecialist] + [selectedDate]
///         + [selectedTimeSlotIndex]
/// Step 3: Summary review — reads all above fields.
class BookingFlowState {
  final HomeCategory? selectedCategory;
  final BookingService? selectedService;
  final BookingSpecialist? selectedSpecialist;
  final DateTime? selectedDate;
  final int? selectedTimeSlotIndex;
  final String? selectedTimeSlotLabel;

  const BookingFlowState({
    this.selectedCategory,
    this.selectedService,
    this.selectedSpecialist,
    this.selectedDate,
    this.selectedTimeSlotIndex,
    this.selectedTimeSlotLabel,
  });

  /// Whether Step 1 selections are complete.
  bool get isStep1Complete =>
      selectedCategory != null &&
      selectedService != null;

  /// Whether Step 2 selections are complete.
  bool get isStep2Complete =>
      selectedSpecialist != null &&
      selectedDate != null &&
      selectedTimeSlotIndex != null;

  /// Whether all steps are complete.
  bool get isAllComplete =>
      isStep1Complete && isStep2Complete;

  /// Copy with updated fields.
  BookingFlowState copyWith({
    HomeCategory? selectedCategory,
    BookingService? selectedService,
    BookingSpecialist? selectedSpecialist,
    DateTime? selectedDate,
    int? selectedTimeSlotIndex,
    String? selectedTimeSlotLabel,
    bool clearService = false,
    bool clearSpecialist = false,
    bool clearDate = false,
    bool clearTimeSlot = false,
  }) {
    return BookingFlowState(
      selectedCategory:
          selectedCategory ?? this.selectedCategory,
      selectedService: clearService
          ? null
          : selectedService ?? this.selectedService,
      selectedSpecialist: clearSpecialist
          ? null
          : selectedSpecialist ??
              this.selectedSpecialist,
      selectedDate: clearDate
          ? null
          : selectedDate ?? this.selectedDate,
      selectedTimeSlotIndex: clearTimeSlot
          ? null
          : selectedTimeSlotIndex ??
              this.selectedTimeSlotIndex,
      selectedTimeSlotLabel: clearTimeSlot
          ? null
          : selectedTimeSlotLabel ??
              this.selectedTimeSlotLabel,
    );
  }
}

/// Riverpod notifier managing the booking flow state
/// across all 3 wizard steps.
///
/// Uses [keepAlive] so state persists across screen
/// navigation (Step 1 → Step 2 → Step 3).
@Riverpod(keepAlive: true)
class BookingFlow extends _$BookingFlow {
  @override
  BookingFlowState build() =>
      const BookingFlowState();

  /// Step 1: Set selected category and clear
  /// downstream selections.
  void selectCategory(HomeCategory category) {
    state = state.copyWith(
      selectedCategory: category,
      clearService: true,
      clearSpecialist: true,
      clearDate: true,
      clearTimeSlot: true,
    );
  }

  /// Step 1: Set selected service.
  void selectService(BookingService service) {
    state = state.copyWith(
      selectedService: service,
      clearSpecialist: true,
      clearDate: true,
      clearTimeSlot: true,
    );
  }

  /// Step 2: Set selected specialist.
  void selectSpecialist(
    BookingSpecialist specialist,
  ) {
    state = state.copyWith(
      selectedSpecialist: specialist,
      clearDate: true,
      clearTimeSlot: true,
    );
  }

  /// Step 2: Set the selected date.
  void selectDate(DateTime date) {
    state = state.copyWith(
      selectedDate: date,
      clearTimeSlot: true,
    );
  }

  /// Step 2: Set the selected time slot.
  void selectTimeSlot(int index, String label) {
    state = state.copyWith(
      selectedTimeSlotIndex: index,
      selectedTimeSlotLabel: label,
    );
  }

  /// Reset entire booking flow state.
  void reset() {
    state = const BookingFlowState();
  }
}
