import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:user_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:user_app/features/home/domain/repositories/home.repository.dart';

part 'home.provider.g.dart';

/// Provides the [HomeRepository] implementation
/// wired to the active remote datasource.
@riverpod
HomeRepository homeRepository(Ref ref) {
  final remoteDatasource = ref.read(homeRemoteDatasourceProvider);
  return HomeImplementRepository(remoteDatasource: remoteDatasource);
}
