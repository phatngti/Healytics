import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/cart/data/datasources/remote/cart_remote_datasource.dart';
import 'package:user_app/features/cart/data/repositories/cart_impl.repository.dart';
import 'package:user_app/features/cart/domain/repositories/cart.repository.dart';

part 'cart.provider.g.dart';

/// Provides the [CartRepository] implementation
/// wired to the active remote datasource.
@riverpod
CartRepository cartRepository(Ref ref) {
  final remoteDatasource = ref.read(cartRemoteDatasourceProvider);
  return CartRepositoryImpl(remoteDatasource: remoteDatasource);
}
