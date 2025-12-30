// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ExpenseEntityTable extends ExpenseEntity
    with TableInfo<$ExpenseEntityTable, ExpenseEntityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpenseEntityTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emotionMeta = const VerificationMeta(
    'emotion',
  );
  @override
  late final GeneratedColumn<String> emotion = GeneratedColumn<String>(
    'emotion',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memoMeta = const VerificationMeta('memo');
  @override
  late final GeneratedColumn<String> memo = GeneratedColumn<String>(
    'memo',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _previousEmotionMeta = const VerificationMeta(
    'previousEmotion',
  );
  @override
  late final GeneratedColumn<String> previousEmotion = GeneratedColumn<String>(
    'previous_emotion',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emotionChangeReasonMeta =
      const VerificationMeta('emotionChangeReason');
  @override
  late final GeneratedColumn<String> emotionChangeReason =
      GeneratedColumn<String>(
        'emotion_change_reason',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amount,
    category,
    emotion,
    date,
    memo,
    previousEmotion,
    emotionChangeReason,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_entity';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseEntityData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('emotion')) {
      context.handle(
        _emotionMeta,
        emotion.isAcceptableOrUnknown(data['emotion']!, _emotionMeta),
      );
    } else if (isInserting) {
      context.missing(_emotionMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('memo')) {
      context.handle(
        _memoMeta,
        memo.isAcceptableOrUnknown(data['memo']!, _memoMeta),
      );
    }
    if (data.containsKey('previous_emotion')) {
      context.handle(
        _previousEmotionMeta,
        previousEmotion.isAcceptableOrUnknown(
          data['previous_emotion']!,
          _previousEmotionMeta,
        ),
      );
    }
    if (data.containsKey('emotion_change_reason')) {
      context.handle(
        _emotionChangeReasonMeta,
        emotionChangeReason.isAcceptableOrUnknown(
          data['emotion_change_reason']!,
          _emotionChangeReasonMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseEntityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseEntityData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      emotion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotion'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      memo: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}memo'],
      ),
      previousEmotion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_emotion'],
      ),
      emotionChangeReason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emotion_change_reason'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ExpenseEntityTable createAlias(String alias) {
    return $ExpenseEntityTable(attachedDatabase, alias);
  }
}

class ExpenseEntityData extends DataClass
    implements Insertable<ExpenseEntityData> {
  /// DB Primary Key : autoIncrement
  final int id;

  /// 지출 이름
  final String title;

  /// 지출 금액
  final int amount;

  /// 지출 카테고리
  final String category;

  /// 지출 감정
  final String emotion;

  /// 지출 날짜
  final DateTime date;

  /// 메모
  final String? memo;

  /// 이전 감정
  final String? previousEmotion;

  /// 감정 변경 사유
  final String? emotionChangeReason;

  /// 생성 시간
  final DateTime createdAt;

  /// 수정 시간
  final DateTime? updatedAt;
  const ExpenseEntityData({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.emotion,
    required this.date,
    this.memo,
    this.previousEmotion,
    this.emotionChangeReason,
    required this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['amount'] = Variable<int>(amount);
    map['category'] = Variable<String>(category);
    map['emotion'] = Variable<String>(emotion);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || memo != null) {
      map['memo'] = Variable<String>(memo);
    }
    if (!nullToAbsent || previousEmotion != null) {
      map['previous_emotion'] = Variable<String>(previousEmotion);
    }
    if (!nullToAbsent || emotionChangeReason != null) {
      map['emotion_change_reason'] = Variable<String>(emotionChangeReason);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<DateTime>(updatedAt);
    }
    return map;
  }

  ExpenseEntityCompanion toCompanion(bool nullToAbsent) {
    return ExpenseEntityCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      category: Value(category),
      emotion: Value(emotion),
      date: Value(date),
      memo: memo == null && nullToAbsent ? const Value.absent() : Value(memo),
      previousEmotion: previousEmotion == null && nullToAbsent
          ? const Value.absent()
          : Value(previousEmotion),
      emotionChangeReason: emotionChangeReason == null && nullToAbsent
          ? const Value.absent()
          : Value(emotionChangeReason),
      createdAt: Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ExpenseEntityData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseEntityData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<int>(json['amount']),
      category: serializer.fromJson<String>(json['category']),
      emotion: serializer.fromJson<String>(json['emotion']),
      date: serializer.fromJson<DateTime>(json['date']),
      memo: serializer.fromJson<String?>(json['memo']),
      previousEmotion: serializer.fromJson<String?>(json['previousEmotion']),
      emotionChangeReason: serializer.fromJson<String?>(
        json['emotionChangeReason'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<int>(amount),
      'category': serializer.toJson<String>(category),
      'emotion': serializer.toJson<String>(emotion),
      'date': serializer.toJson<DateTime>(date),
      'memo': serializer.toJson<String?>(memo),
      'previousEmotion': serializer.toJson<String?>(previousEmotion),
      'emotionChangeReason': serializer.toJson<String?>(emotionChangeReason),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime?>(updatedAt),
    };
  }

  ExpenseEntityData copyWith({
    int? id,
    String? title,
    int? amount,
    String? category,
    String? emotion,
    DateTime? date,
    Value<String?> memo = const Value.absent(),
    Value<String?> previousEmotion = const Value.absent(),
    Value<String?> emotionChangeReason = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> updatedAt = const Value.absent(),
  }) => ExpenseEntityData(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    category: category ?? this.category,
    emotion: emotion ?? this.emotion,
    date: date ?? this.date,
    memo: memo.present ? memo.value : this.memo,
    previousEmotion: previousEmotion.present
        ? previousEmotion.value
        : this.previousEmotion,
    emotionChangeReason: emotionChangeReason.present
        ? emotionChangeReason.value
        : this.emotionChangeReason,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ExpenseEntityData copyWithCompanion(ExpenseEntityCompanion data) {
    return ExpenseEntityData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      category: data.category.present ? data.category.value : this.category,
      emotion: data.emotion.present ? data.emotion.value : this.emotion,
      date: data.date.present ? data.date.value : this.date,
      memo: data.memo.present ? data.memo.value : this.memo,
      previousEmotion: data.previousEmotion.present
          ? data.previousEmotion.value
          : this.previousEmotion,
      emotionChangeReason: data.emotionChangeReason.present
          ? data.emotionChangeReason.value
          : this.emotionChangeReason,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseEntityData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('emotion: $emotion, ')
          ..write('date: $date, ')
          ..write('memo: $memo, ')
          ..write('previousEmotion: $previousEmotion, ')
          ..write('emotionChangeReason: $emotionChangeReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amount,
    category,
    emotion,
    date,
    memo,
    previousEmotion,
    emotionChangeReason,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseEntityData &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.category == this.category &&
          other.emotion == this.emotion &&
          other.date == this.date &&
          other.memo == this.memo &&
          other.previousEmotion == this.previousEmotion &&
          other.emotionChangeReason == this.emotionChangeReason &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ExpenseEntityCompanion extends UpdateCompanion<ExpenseEntityData> {
  final Value<int> id;
  final Value<String> title;
  final Value<int> amount;
  final Value<String> category;
  final Value<String> emotion;
  final Value<DateTime> date;
  final Value<String?> memo;
  final Value<String?> previousEmotion;
  final Value<String?> emotionChangeReason;
  final Value<DateTime> createdAt;
  final Value<DateTime?> updatedAt;
  const ExpenseEntityCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.category = const Value.absent(),
    this.emotion = const Value.absent(),
    this.date = const Value.absent(),
    this.memo = const Value.absent(),
    this.previousEmotion = const Value.absent(),
    this.emotionChangeReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ExpenseEntityCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required int amount,
    required String category,
    required String emotion,
    required DateTime date,
    this.memo = const Value.absent(),
    this.previousEmotion = const Value.absent(),
    this.emotionChangeReason = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : title = Value(title),
       amount = Value(amount),
       category = Value(category),
       emotion = Value(emotion),
       date = Value(date);
  static Insertable<ExpenseEntityData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<int>? amount,
    Expression<String>? category,
    Expression<String>? emotion,
    Expression<DateTime>? date,
    Expression<String>? memo,
    Expression<String>? previousEmotion,
    Expression<String>? emotionChangeReason,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (category != null) 'category': category,
      if (emotion != null) 'emotion': emotion,
      if (date != null) 'date': date,
      if (memo != null) 'memo': memo,
      if (previousEmotion != null) 'previous_emotion': previousEmotion,
      if (emotionChangeReason != null)
        'emotion_change_reason': emotionChangeReason,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ExpenseEntityCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<int>? amount,
    Value<String>? category,
    Value<String>? emotion,
    Value<DateTime>? date,
    Value<String?>? memo,
    Value<String?>? previousEmotion,
    Value<String?>? emotionChangeReason,
    Value<DateTime>? createdAt,
    Value<DateTime?>? updatedAt,
  }) {
    return ExpenseEntityCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      emotion: emotion ?? this.emotion,
      date: date ?? this.date,
      memo: memo ?? this.memo,
      previousEmotion: previousEmotion ?? this.previousEmotion,
      emotionChangeReason: emotionChangeReason ?? this.emotionChangeReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (emotion.present) {
      map['emotion'] = Variable<String>(emotion.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (memo.present) {
      map['memo'] = Variable<String>(memo.value);
    }
    if (previousEmotion.present) {
      map['previous_emotion'] = Variable<String>(previousEmotion.value);
    }
    if (emotionChangeReason.present) {
      map['emotion_change_reason'] = Variable<String>(
        emotionChangeReason.value,
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseEntityCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('category: $category, ')
          ..write('emotion: $emotion, ')
          ..write('date: $date, ')
          ..write('memo: $memo, ')
          ..write('previousEmotion: $previousEmotion, ')
          ..write('emotionChangeReason: $emotionChangeReason, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ExpenseEntityTable expenseEntity = $ExpenseEntityTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [expenseEntity];
}

typedef $$ExpenseEntityTableCreateCompanionBuilder =
    ExpenseEntityCompanion Function({
      Value<int> id,
      required String title,
      required int amount,
      required String category,
      required String emotion,
      required DateTime date,
      Value<String?> memo,
      Value<String?> previousEmotion,
      Value<String?> emotionChangeReason,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });
typedef $$ExpenseEntityTableUpdateCompanionBuilder =
    ExpenseEntityCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<int> amount,
      Value<String> category,
      Value<String> emotion,
      Value<DateTime> date,
      Value<String?> memo,
      Value<String?> previousEmotion,
      Value<String?> emotionChangeReason,
      Value<DateTime> createdAt,
      Value<DateTime?> updatedAt,
    });

class $$ExpenseEntityTableFilterComposer
    extends Composer<_$AppDatabase, $ExpenseEntityTable> {
  $$ExpenseEntityTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousEmotion => $composableBuilder(
    column: $table.previousEmotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emotionChangeReason => $composableBuilder(
    column: $table.emotionChangeReason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExpenseEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpenseEntityTable> {
  $$ExpenseEntityTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emotion => $composableBuilder(
    column: $table.emotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memo => $composableBuilder(
    column: $table.memo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousEmotion => $composableBuilder(
    column: $table.previousEmotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emotionChangeReason => $composableBuilder(
    column: $table.emotionChangeReason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExpenseEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpenseEntityTable> {
  $$ExpenseEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get emotion =>
      $composableBuilder(column: $table.emotion, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get memo =>
      $composableBuilder(column: $table.memo, builder: (column) => column);

  GeneratedColumn<String> get previousEmotion => $composableBuilder(
    column: $table.previousEmotion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get emotionChangeReason => $composableBuilder(
    column: $table.emotionChangeReason,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ExpenseEntityTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpenseEntityTable,
          ExpenseEntityData,
          $$ExpenseEntityTableFilterComposer,
          $$ExpenseEntityTableOrderingComposer,
          $$ExpenseEntityTableAnnotationComposer,
          $$ExpenseEntityTableCreateCompanionBuilder,
          $$ExpenseEntityTableUpdateCompanionBuilder,
          (
            ExpenseEntityData,
            BaseReferences<
              _$AppDatabase,
              $ExpenseEntityTable,
              ExpenseEntityData
            >,
          ),
          ExpenseEntityData,
          PrefetchHooks Function()
        > {
  $$ExpenseEntityTableTableManager(_$AppDatabase db, $ExpenseEntityTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpenseEntityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpenseEntityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpenseEntityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> emotion = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> memo = const Value.absent(),
                Value<String?> previousEmotion = const Value.absent(),
                Value<String?> emotionChangeReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ExpenseEntityCompanion(
                id: id,
                title: title,
                amount: amount,
                category: category,
                emotion: emotion,
                date: date,
                memo: memo,
                previousEmotion: previousEmotion,
                emotionChangeReason: emotionChangeReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required int amount,
                required String category,
                required String emotion,
                required DateTime date,
                Value<String?> memo = const Value.absent(),
                Value<String?> previousEmotion = const Value.absent(),
                Value<String?> emotionChangeReason = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> updatedAt = const Value.absent(),
              }) => ExpenseEntityCompanion.insert(
                id: id,
                title: title,
                amount: amount,
                category: category,
                emotion: emotion,
                date: date,
                memo: memo,
                previousEmotion: previousEmotion,
                emotionChangeReason: emotionChangeReason,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExpenseEntityTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpenseEntityTable,
      ExpenseEntityData,
      $$ExpenseEntityTableFilterComposer,
      $$ExpenseEntityTableOrderingComposer,
      $$ExpenseEntityTableAnnotationComposer,
      $$ExpenseEntityTableCreateCompanionBuilder,
      $$ExpenseEntityTableUpdateCompanionBuilder,
      (
        ExpenseEntityData,
        BaseReferences<_$AppDatabase, $ExpenseEntityTable, ExpenseEntityData>,
      ),
      ExpenseEntityData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ExpenseEntityTableTableManager get expenseEntity =>
      $$ExpenseEntityTableTableManager(_db, _db.expenseEntity);
}
