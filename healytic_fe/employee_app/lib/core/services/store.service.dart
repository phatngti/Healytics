import 'dart:async' show StreamSubscription;

import '../models/store.model.dart';
import '../repositories/store.repository.dart';

class StoreService {
  final DriftStoreRepository _storeRepository;

  final Map<int, Object?> _cache = {};
  late final StreamSubscription<StoreModel> _sub;

  StoreService._({required DriftStoreRepository storeRepository})
    : _storeRepository = storeRepository;

  static StoreService? _instance;

  static StoreService get I {
    if (_instance == null) {
      throw UnsupportedError(
        'StoreService not initialized. '
        'Call init() first',
      );
    }
    return _instance!;
  }

  static Future<StoreService> init({
    required DriftStoreRepository storeRepository,
  }) async {
    _instance?.dispose();
    _instance = await create(storeRepository: storeRepository);
    return _instance!;
  }

  static Future<StoreService> create({
    required DriftStoreRepository storeRepository,
  }) async {
    final instance = StoreService._(storeRepository: storeRepository);
    await instance._populateCache();
    instance._sub = instance._listenForChange();
    return instance;
  }

  Future<void> _populateCache() async {
    final storeValues = await _storeRepository.getAll();
    for (StoreModel storeValue in storeValues) {
      _cache[storeValue.key.id] = storeValue.value;
    }
  }

  StreamSubscription<StoreModel> _listenForChange() =>
      _storeRepository.watchAll().listen((event) {
        _cache[event.key.id] = event.value;
      });

  void dispose() async {
    await _sub.cancel();
    _cache.clear();
  }

  T? tryGet<T>(StoreKey<T> key) => _cache[key.id] as T?;

  T get<T>(StoreKey<T> key, [T? defaultValue]) {
    final value = tryGet(key) ?? defaultValue;
    if (value == null) {
      throw StoreKeyNotFoundException(key);
    }
    return value;
  }

  Future<void> put<U extends StoreKey<T>, T>(U key, T value) async {
    if (_cache[key.id] == value) return;
    await _storeRepository.insert(key, value);
    _cache[key.id] = value;
  }

  Stream<T?> watch<T>(StoreKey<T> key) => _storeRepository.watch(key);

  Future<void> delete<T>(StoreKey<T> key) async {
    await _storeRepository.delete(key);
    _cache.remove(key.id);
  }

  Future<void> clear() async {
    await _storeRepository.deleteAll();
    _cache.clear();
  }
}

class StoreKeyNotFoundException implements Exception {
  final StoreKey key;
  const StoreKeyNotFoundException(this.key);

  @override
  String toString() => 'Key - <${key.name}> not available in Store';
}
