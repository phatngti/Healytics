import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:admin_panel/core/services/storage.service.dart';

part 'storage.provider.g.dart';

@Riverpod(keepAlive: true)
StorageService storageService(Ref _) => StorageService();
