import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:admin_panel/core/database/repositories/drift.repository.dart';
import 'package:admin_panel/core/models/store.model.dart';
import 'package:admin_panel/core/repositories/store.repository.dart';
import 'package:admin_panel/core/services/log.service.dart';
import 'package:admin_panel/core/services/store.service.dart' show StoreService;

abstract final class Bootstrap {
  static Drift db = Drift();

  static Future<void> initDomain(
    Drift db, {
    bool shouldBufferLogs = true,
  }) async {
    try {
      final storeRepository = DriftStoreRepository(db);
      // 1. Dùng rootBundle để load string thay vì File()
      // Hàm này trả về Future nên cần await
      final jsonString = await rootBundle.loadString('assets/store.json');

      final Map<String, dynamic> jsonData = jsonDecode(jsonString);

      for (var key in jsonData.keys) {
        final storeKey = StoreKey.values.firstWhere(
          (e) => e.name == key,
          orElse: () => throw Exception("Key $key not found in StoreKey enum"),
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
