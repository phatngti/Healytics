import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/revenue_impl.repository.dart';
import '../../domain/entities/revenue.entity.dart';

part 'revenue.provider.g.dart';

@riverpod
class RevenueFilter extends _$RevenueFilter {
  @override
  RevenueFilterState build() {
    return RevenueFilterState(
      period: RevenuePeriod.day,
      selectedDate: DateTime.now(),
    );
  }

  void setPeriod(RevenuePeriod period) {
    if (period == state.period) return;
    state = state.copyWith(period: period);
  }

  void navigatePrevious() {
    state = state.copyWith(
      selectedDate: switch (state.period) {
        RevenuePeriod.day => state.selectedDate.subtract(
          const Duration(days: 1),
        ),
        RevenuePeriod.month => DateTime(
          state.selectedDate.year,
          state.selectedDate.month - 1,
        ),
        RevenuePeriod.year => DateTime(state.selectedDate.year - 1),
      },
    );
  }

  void navigateNext() {
    state = state.copyWith(
      selectedDate: switch (state.period) {
        RevenuePeriod.day => state.selectedDate.add(const Duration(days: 1)),
        RevenuePeriod.month => DateTime(
          state.selectedDate.year,
          state.selectedDate.month + 1,
        ),
        RevenuePeriod.year => DateTime(state.selectedDate.year + 1),
      },
    );
  }

  void goToToday() {
    final today = DateTime.now();
    if (_isSamePeriodDate(state.selectedDate, today, state.period)) {
      return;
    }
    state = state.copyWith(selectedDate: today);
  }

  bool _isSamePeriodDate(DateTime a, DateTime b, RevenuePeriod period) {
    return switch (period) {
      RevenuePeriod.day =>
        a.year == b.year && a.month == b.month && a.day == b.day,
      RevenuePeriod.month => a.year == b.year && a.month == b.month,
      RevenuePeriod.year => a.year == b.year,
    };
  }
}

@riverpod
Future<RevenueState> revenue(Ref ref) async {
  final filter = ref.watch(revenueFilterProvider);
  final repo = ref.watch(revenueRepositoryProvider);
  final results = await Future.wait([
    repo.getSummary(period: filter.period, date: filter.selectedDate),
    repo.getTrendData(period: filter.period, date: filter.selectedDate),
    repo.getBreakdown(period: filter.period, date: filter.selectedDate),
  ]);

  return RevenueState(
    summary: results[0] as RevenueSummaryEntity,
    trendData: results[1] as List<RevenueDataPoint>,
    breakdown: results[2] as List<RevenueBreakdownItem>,
    period: filter.period,
    selectedDate: filter.selectedDate,
  );
}

class RevenueFilterState {
  final RevenuePeriod period;
  final DateTime selectedDate;

  const RevenueFilterState({required this.period, required this.selectedDate});

  RevenueFilterState copyWith({RevenuePeriod? period, DateTime? selectedDate}) {
    return RevenueFilterState(
      period: period ?? this.period,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RevenueFilterState &&
            other.period == period &&
            other.selectedDate == selectedDate;
  }

  @override
  int get hashCode => Object.hash(period, selectedDate);
}

class RevenueState {
  final RevenueSummaryEntity summary;
  final List<RevenueDataPoint> trendData;
  final List<RevenueBreakdownItem> breakdown;
  final RevenuePeriod period;
  final DateTime selectedDate;

  const RevenueState({
    required this.summary,
    required this.trendData,
    required this.breakdown,
    required this.period,
    required this.selectedDate,
  });
}
