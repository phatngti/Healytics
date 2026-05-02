// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift.repository.dart';

// ignore_for_file: type=lint
class $StoreValueTable extends StoreValue
    with TableInfo<$StoreValueTable, StoreValueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreValueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _intValueMeta = const VerificationMeta(
    'intValue',
  );
  @override
  late final GeneratedColumn<int> intValue = GeneratedColumn<int>(
    'int_value',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _strValueMeta = const VerificationMeta(
    'strValue',
  );
  @override
  late final GeneratedColumn<String> strValue = GeneratedColumn<String>(
    'str_value',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 4096,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, intValue, strValue];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_value';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoreValueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('int_value')) {
      context.handle(
        _intValueMeta,
        intValue.isAcceptableOrUnknown(data['int_value']!, _intValueMeta),
      );
    }
    if (data.containsKey('str_value')) {
      context.handle(
        _strValueMeta,
        strValue.isAcceptableOrUnknown(data['str_value']!, _strValueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreValueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreValueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      intValue: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}int_value'],
      ),
      strValue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}str_value'],
      ),
    );
  }

  @override
  $StoreValueTable createAlias(String alias) {
    return $StoreValueTable(attachedDatabase, alias);
  }
}

class StoreValueData extends DataClass implements Insertable<StoreValueData> {
  final int id;
  final int? intValue;
  final String? strValue;
  const StoreValueData({required this.id, this.intValue, this.strValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || intValue != null) {
      map['int_value'] = Variable<int>(intValue);
    }
    if (!nullToAbsent || strValue != null) {
      map['str_value'] = Variable<String>(strValue);
    }
    return map;
  }

  StoreValueCompanion toCompanion(bool nullToAbsent) {
    return StoreValueCompanion(
      id: Value(id),
      intValue: intValue == null && nullToAbsent
          ? const Value.absent()
          : Value(intValue),
      strValue: strValue == null && nullToAbsent
          ? const Value.absent()
          : Value(strValue),
    );
  }

  factory StoreValueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreValueData(
      id: serializer.fromJson<int>(json['id']),
      intValue: serializer.fromJson<int?>(json['intValue']),
      strValue: serializer.fromJson<String?>(json['strValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'intValue': serializer.toJson<int?>(intValue),
      'strValue': serializer.toJson<String?>(strValue),
    };
  }

  StoreValueData copyWith({
    int? id,
    Value<int?> intValue = const Value.absent(),
    Value<String?> strValue = const Value.absent(),
  }) => StoreValueData(
    id: id ?? this.id,
    intValue: intValue.present ? intValue.value : this.intValue,
    strValue: strValue.present ? strValue.value : this.strValue,
  );
  StoreValueData copyWithCompanion(StoreValueCompanion data) {
    return StoreValueData(
      id: data.id.present ? data.id.value : this.id,
      intValue: data.intValue.present ? data.intValue.value : this.intValue,
      strValue: data.strValue.present ? data.strValue.value : this.strValue,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreValueData(')
          ..write('id: $id, ')
          ..write('intValue: $intValue, ')
          ..write('strValue: $strValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, intValue, strValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreValueData &&
          other.id == this.id &&
          other.intValue == this.intValue &&
          other.strValue == this.strValue);
}

class StoreValueCompanion extends UpdateCompanion<StoreValueData> {
  final Value<int> id;
  final Value<int?> intValue;
  final Value<String?> strValue;
  const StoreValueCompanion({
    this.id = const Value.absent(),
    this.intValue = const Value.absent(),
    this.strValue = const Value.absent(),
  });
  StoreValueCompanion.insert({
    this.id = const Value.absent(),
    this.intValue = const Value.absent(),
    this.strValue = const Value.absent(),
  });
  static Insertable<StoreValueData> custom({
    Expression<int>? id,
    Expression<int>? intValue,
    Expression<String>? strValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (intValue != null) 'int_value': intValue,
      if (strValue != null) 'str_value': strValue,
    });
  }

  StoreValueCompanion copyWith({
    Value<int>? id,
    Value<int?>? intValue,
    Value<String?>? strValue,
  }) {
    return StoreValueCompanion(
      id: id ?? this.id,
      intValue: intValue ?? this.intValue,
      strValue: strValue ?? this.strValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (intValue.present) {
      map['int_value'] = Variable<int>(intValue.value);
    }
    if (strValue.present) {
      map['str_value'] = Variable<String>(strValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreValueCompanion(')
          ..write('id: $id, ')
          ..write('intValue: $intValue, ')
          ..write('strValue: $strValue')
          ..write(')'))
        .toString();
  }
}

abstract class _$Drift extends GeneratedDatabase {
  _$Drift(QueryExecutor e) : super(e);
  $DriftManager get managers => $DriftManager(this);
  late final $StoreValueTable storeValue = $StoreValueTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [storeValue];
}

typedef $$StoreValueTableCreateCompanionBuilder =
    StoreValueCompanion Function({
      Value<int> id,
      Value<int?> intValue,
      Value<String?> strValue,
    });
typedef $$StoreValueTableUpdateCompanionBuilder =
    StoreValueCompanion Function({
      Value<int> id,
      Value<int?> intValue,
      Value<String?> strValue,
    });

class $$StoreValueTableFilterComposer
    extends Composer<_$Drift, $StoreValueTable> {
  $$StoreValueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intValue => $composableBuilder(
    column: $table.intValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get strValue => $composableBuilder(
    column: $table.strValue,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoreValueTableOrderingComposer
    extends Composer<_$Drift, $StoreValueTable> {
  $$StoreValueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intValue => $composableBuilder(
    column: $table.intValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get strValue => $composableBuilder(
    column: $table.strValue,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoreValueTableAnnotationComposer
    extends Composer<_$Drift, $StoreValueTable> {
  $$StoreValueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get intValue =>
      $composableBuilder(column: $table.intValue, builder: (column) => column);

  GeneratedColumn<String> get strValue =>
      $composableBuilder(column: $table.strValue, builder: (column) => column);
}

class $$StoreValueTableTableManager
    extends
        RootTableManager<
          _$Drift,
          $StoreValueTable,
          StoreValueData,
          $$StoreValueTableFilterComposer,
          $$StoreValueTableOrderingComposer,
          $$StoreValueTableAnnotationComposer,
          $$StoreValueTableCreateCompanionBuilder,
          $$StoreValueTableUpdateCompanionBuilder,
          (
            StoreValueData,
            BaseReferences<_$Drift, $StoreValueTable, StoreValueData>,
          ),
          StoreValueData,
          PrefetchHooks Function()
        > {
  $$StoreValueTableTableManager(_$Drift db, $StoreValueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoreValueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoreValueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoreValueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> intValue = const Value.absent(),
                Value<String?> strValue = const Value.absent(),
              }) => StoreValueCompanion(
                id: id,
                intValue: intValue,
                strValue: strValue,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> intValue = const Value.absent(),
                Value<String?> strValue = const Value.absent(),
              }) => StoreValueCompanion.insert(
                id: id,
                intValue: intValue,
                strValue: strValue,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoreValueTableProcessedTableManager =
    ProcessedTableManager<
      _$Drift,
      $StoreValueTable,
      StoreValueData,
      $$StoreValueTableFilterComposer,
      $$StoreValueTableOrderingComposer,
      $$StoreValueTableAnnotationComposer,
      $$StoreValueTableCreateCompanionBuilder,
      $$StoreValueTableUpdateCompanionBuilder,
      (
        StoreValueData,
        BaseReferences<_$Drift, $StoreValueTable, StoreValueData>,
      ),
      StoreValueData,
      PrefetchHooks Function()
    >;

class $DriftManager {
  final _$Drift _db;
  $DriftManager(this._db);
  $$StoreValueTableTableManager get storeValue =>
      $$StoreValueTableTableManager(_db, _db.storeValue);
}
