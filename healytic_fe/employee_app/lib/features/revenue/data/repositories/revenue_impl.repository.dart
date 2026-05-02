import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../datasources/remote/revenue_remote_datasource.dart';
import '../../domain/entities/revenue.entity.dart';
import '../../domain/repositories/revenue.repository.dart';

part 'revenue_impl.repository.g.dart';

class RevenueRepositoryImpl implements RevenueRepository {
  final RevenueRemoteDatasource _ds;
  RevenueRepositoryImpl({required RevenueRemoteDatasource ds}) : _ds = ds;

  @override
  Future<RevenueSummaryEntity> getSummary({
    required RevenuePeriod period,
    DateTime? date,
  }) => _ds.getSummary(period: period, date: date);

  @override
  Future<List<RevenueDataPoint>> getTrendData({
    required RevenuePeriod period,
    DateTime? date,
  }) => _ds.getTrendData(period: period, date: date);

  @override
  Future<List<RevenueBreakdownItem>> getBreakdown({
    required RevenuePeriod period,
    DateTime? date,
  }) => _ds.getBreakdown(period: period, date: date);
}

@Riverpod(keepAlive: true)
RevenueRepository revenueRepository(Ref ref) {
  final ds = ref.watch(revenueRemoteDatasourceProvider);
  return RevenueRepositoryImpl(ds: ds);
}
