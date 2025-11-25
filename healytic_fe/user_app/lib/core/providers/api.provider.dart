import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_app/core/services/api.service.dart';

part 'api.provider.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(Ref _) => ApiService();
