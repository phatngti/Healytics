import 'package:user_app/features/checkout/data/datasources/remote/checkout_remote_datasource.dart';
import 'package:user_app/features/checkout/domain/entities/checkout.entity.dart';
import 'package:user_app/features/checkout/domain/repositories/checkout.repository.dart';

/// Concrete [CheckoutRepository] backed by a remote
/// datasource.
class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDatasource remoteDatasource;

  CheckoutRepositoryImpl({required this.remoteDatasource});

  @override
  Future<CheckoutData> getCheckoutData() async {
    return remoteDatasource.getCheckoutData();
  }
}
