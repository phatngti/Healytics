import 'package:drift/drift.dart';

class StoreValue extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get intValue => integer().nullable()();
  TextColumn get strValue => text().nullable().withLength(min: 1, max: 4096)();
}
