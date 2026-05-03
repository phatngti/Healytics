import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/repositories/revenue_impl.repository.dart';
import '../../domain/entities/revenue.entity.dart';

part 'revenue.provider.g.dart';

@riverpod
class RevenueNotifier extends _$RevenueNotifier {
  RevenuePeriod _period = RevenuePeriod.day;
  DateTime _selectedDate = DateTime.now();

  RevenuePeriod get period => _period;
  DateTime get selectedDate => _selectedDate;

  @override
  Future<RevenueState> build() async {
    return _load();
  }

  Future<RevenueState> _load() async {
    final repo = ref.read(revenueRepositoryProvider);
    final results = await Future.wait([
      repo.getSummary(period: _period, date: _selectedDate),
      repo.getTrendData(period: _period, date: _selectedDate),
      repo.getBreakdown(period: _period, date: _selectedDate),
    ]);
    return RevenueState(
      summary: results[0] as RevenueSummaryEntity,
      trendData: results[1] as List<RevenueDataPoint>,
      breakdown: results[2] as List<RevenueBreakdownItem>,
      period: _period,
      selectedDate: _selectedDate,
    );
  }

  Future<void> setPeriod(RevenuePeriod period) async {
    _period = period;
    state = const AsyncLoading();
    state = AsyncData(await _load());
  }

  Future<void> navigatePrevious() async {
    _selectedDate = switch (_period) {
      RevenuePeriod.day => _selectedDate.subtract(const Duration(days: 1)),
      RevenuePeriod.month => DateTime(
        _selectedDate.year,
        _selectedDate.month - 1,
      ),
      RevenuePeriod.year => DateTime(_selectedDate.year - 1),
    };
    state = const AsyncLoading();
    state = AsyncData(await _load());
  }

  Future<void> navigateNext() async {
    _selectedDate = switch (_period) {
      RevenuePeriod.day => _selectedDate.add(const Duration(days: 1)),
      RevenuePeriod.month => DateTime(
        _selectedDate.year,
        _selectedDate.month + 1,
      ),
      RevenuePeriod.year => DateTime(_selectedDate.year + 1),
    };
    state = const AsyncLoading();
    state = AsyncData(await _load());
  }

  Future<void> goToToday() async {
    _selectedDate = DateTime.now();
    state = const AsyncLoading();
    state = AsyncData(await _load());
  }
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
