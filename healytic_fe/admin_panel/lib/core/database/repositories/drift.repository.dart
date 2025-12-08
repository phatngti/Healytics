import 'package:admin_panel/core/database/entities/store.entity.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'drift.repository.g.dart';

abstract interface class IDatabaseRepository {
  Future<T> transaction<T>(Future<T> Function() callback);
}

@DriftDatabase(tables: [StoreValue])
class Drift extends _$Drift implements IDatabaseRepository {
  Drift([QueryExecutor? executor])
    : super(
        executor ??
            driftDatabase(
              name: 'app',
              native: const DriftNativeOptions(shareAcrossIsolates: true),
              web: DriftWebOptions(
                sqlite3Wasm: Uri.parse('sqlite3.wasm'),
                driftWorker: Uri.parse('drift_worker.js'),
              ),
            ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (Migrator m, int from, int to) async {
      if (from < 2) {
        await m.deleteTable(storeValue.actualTableName);
        await m.createTable(storeValue);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
      await customStatement('PRAGMA synchronous = NORMAL');
      await customStatement('PRAGMA journal_mode = WAL');
    },
  );
}

class DriftDatabaseRepository implements IDatabaseRepository {
  final Drift _db;
  const DriftDatabaseRepository(this._db);

  @override
  Future<T> transaction<T>(Future<T> Function() callback) =>
      _db.transaction(callback);
}
