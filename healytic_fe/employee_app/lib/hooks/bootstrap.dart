import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/config/app_environment.dart';
import '../core/database/repositories/drift.repository.dart';
import '../core/models/store.model.dart';
import '../core/repositories/store.repository.dart';
import '../core/services/log.service.dart';
import '../core/services/store.service.dart' show StoreService;

abstract final class Bootstrap {
  static Drift db = Drift();

  static Future<void> initDomain(
    Drift db, {
    bool shouldBufferLogs = true,
  }) async {
    try {
      final storeRepository = DriftStoreRepository(db);
      final env = AppEnvironment.fromDartDefine();
      AppEnvironment.setCurrent(env);
      final jsonString = await rootBundle.loadString(env.assetPath);

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      for (var key in jsonData.keys) {
        final storeKey = StoreKey.values.firstWhere(
          (e) => e.name == key,
          orElse: () => throw Exception('Key $key not found in StoreKey enum'),
        );
        final value = switch (storeKey.type) {
          const (int) => int.parse(jsonData[key]),
          const (String) =>
            jsonData[key] is Map || jsonData[key] is List
                ? jsonEncode(jsonData[key])
                : jsonData[key],
          const (bool) => jsonData[key] == 'true',
          const (DateTime) => DateTime.parse(jsonData[key]),
          _ => null,
        };

        if (value != null) {
          await storeRepository.insert(storeKey, value);
        }
      }
      await StoreService.init(storeRepository: storeRepository);
      await LogService.init(shouldBuffer: shouldBufferLogs);
    } catch (e) {
      debugPrint('error: $e');
      rethrow;
    }
  }
}
