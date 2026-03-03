import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/checkout/data/datasources/remote/checkout_remote_datasource.dart';
import 'package:user_app/features/checkout/data/repositories/checkout_impl.repository.dart';
import 'package:user_app/features/checkout/domain/repositories/checkout.repository.dart';

part 'checkout.provider.g.dart';

/// Provides the [CheckoutRepository] implementation
/// wired to the active remote datasource.
@riverpod
CheckoutRepository checkoutRepository(Ref ref) {
  final remoteDatasource = ref.read(checkoutRemoteDatasourceProvider);
  return CheckoutRepositoryImpl(remoteDatasource: remoteDatasource);
}
