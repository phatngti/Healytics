import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/core/services/api.service.dart';

part 'api.provider.g.dart';

@Riverpod(keepAlive: true)
ApiService apiService(Ref _) => ApiService();
