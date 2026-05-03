import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../entities/store.entity.dart';

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
              name: 'employee_app',
              native: const DriftNativeOptions(shareAcrossIsolates: true),
            ),
      );

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
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
