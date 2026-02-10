import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'share_preferences_register_local_datasource.g.dart';

const _kPartialRegKey = 'partial_registration_data';

abstract class RegistrationLocalDatasource {
  Future<void> savePartialData(Map<String, dynamic> data);
  Future<Map<String, dynamic>?> loadPartialData();
  Future<void> clearPartialData();
}

class SharedPreferencesRegisterLocalDatasource
    implements RegistrationLocalDatasource {
  SharedPreferencesRegisterLocalDatasource(
    Future<SharedPreferences> prefsFuture,
  ) : _prefsFuture = prefsFuture;

  final Future<SharedPreferences> _prefsFuture;
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _instance async {
    if (_prefs != null) {
      return _prefs!;
    }
    _prefs = await _prefsFuture;
    return _prefs!;
  }

  // Implementation using SharedPreferences or similar local storage
  @override
  Future<void> savePartialData(Map<String, dynamic> data) async {
    final prefs = await _instance;
    // Save data to local storage
    final jsonString = jsonEncode(data);
    await prefs.setString(_kPartialRegKey, jsonString);
  }

  @override
  Future<Map<String, dynamic>?> loadPartialData() async {
    final prefs = await _instance;
    final jsonString = prefs.getString(_kPartialRegKey);
    if (jsonString != null) {
      return Future.value(
        Map<String, dynamic>.from(
          jsonDecode(jsonString) as Map<String, dynamic>,
        ),
      );
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> clearPartialData() async {
    final prefs = await _instance;
    await prefs.remove(_kPartialRegKey);
  }
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) async {
  return SharedPreferences.getInstance();
}

@riverpod
RegistrationLocalDatasource registerLocalDatasource(Ref ref) {
  final prefsFuture = ref.watch(sharedPreferencesProvider.future);
  return SharedPreferencesRegisterLocalDatasource(prefsFuture);
}
