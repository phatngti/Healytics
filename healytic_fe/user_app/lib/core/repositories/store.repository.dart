import 'package:drift/drift.dart';
import 'package:user_app/core/database/repositories/drift.repository.dart';
import 'package:user_app/core/models/store.model.dart';

class DriftStoreRepository extends DriftDatabaseRepository {
  final Drift _db;
  final validStoreKeys = StoreKey.values.map((e) => e.id).toSet();

  DriftStoreRepository(super.db) : _db = db;

  Future<bool> deleteAll() async {
    return await transaction(() async {
      await _db.delete(_db.storeValue).go();
      return true;
    });
  }

  Stream<StoreModel<Object>> watchAll() {
    return _db
        .select(_db.storeValue)
        .watch()
        .asyncExpand(
          (entities) =>
              Stream.fromFutures(entities.map((e) async => _toUpdateEvent(e))),
        );
  }

  Future<int> count() async {
    final countQuery = _db.selectOnly(_db.storeValue)..addColumns([countAll()]);
    final count = await countQuery.getSingle();
    return count.read(countAll())!;
  }

  Future<void> delete<T>(StoreKey<T> key) async {
    return await transaction(
      () async => _db.delete(_db.storeValue)
        ..where((e) => e.id.equals(key.id))
        ..go(),
    );
  }

  Future<bool> insert<T>(StoreKey<T> key, T value) async {
    return await transaction(() async {
      await _db
          .into(_db.storeValue)
          .insert(
            await _fromValue(key, value),
            mode: InsertMode.insertOrReplace,
          );
      return true;
    });
  }

  Future<T?> tryGet<T>(StoreKey<T> key) async {
    final entity = await (_db.select(
      _db.storeValue,
    )..where((e) => e.id.equals(key.id))).getSingleOrNull();
    if (entity == null) {
      return null;
    }
    return await _toValue(key, entity);
  }

  Future<bool> update<T>(StoreKey<T> key, T value) async {
    return await transaction(() async {
      await _db.update(_db.storeValue).replace(await _fromValue(key, value));

      return true;
    });
  }

  Stream<T?> watch<T>(StoreKey<T> key) async* {
    yield* (_db.select(_db.storeValue)..where((e) => e.id.equals(key.id)))
        .watch()
        .asyncMap((e) async => e.map((e) => _toValue(key, e)).firstOrNull);
  }

  Future<StoreModel<Object>> _toUpdateEvent(StoreValueData entity) async {
    final key =
        StoreKey.values.firstWhere((e) => e.id == entity.id)
            as StoreKey<Object>;
    final value = await _toValue(key, entity);

    return StoreModel(key: key, value: value);
  }

  Future<T?> _toValue<T>(StoreKey<T> key, StoreValueData entity) async =>
      switch (key.type) {
            const (int) => entity.intValue,
            const (String) => entity.strValue,
            const (bool) => entity.intValue == 1,
            const (DateTime) =>
              entity.intValue == null
                  ? null
                  : DateTime.fromMillisecondsSinceEpoch(entity.intValue!),
            _ => null,
          }
          as T?;

  Future<StoreValueData> _fromValue<T>(StoreKey<T> key, T value) async {
    final (int? intValue, String? strValue) = switch (key.type) {
      const (int) => (value as int, null),
      const (String) => (null, value as String),
      const (bool) => ((value as bool) ? 1 : 0, null),
      const (DateTime) => ((value as DateTime).millisecondsSinceEpoch, null),
      _ => throw UnsupportedError(
        "Unsupported primitive type: ${key.type} for key: ${key.name}",
      ),
    };
    return StoreValueData(id: key.id, intValue: intValue, strValue: strValue);
  }

  Future<List<StoreModel<Object>>> getAll() async {
    final entities = await _db.select(_db.storeValue).get();
    return Future.wait(entities.map((e) => _toUpdateEvent(e)).toList());
  }
}
