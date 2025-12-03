import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppDatabase / ExpenseEntity Drift 테스트', () {
    late AppDatabase db;

    setUp(() {
      // 각 테스트마다 인메모리 SQLite 를 사용하는 AppDatabase 생성
      db = AppDatabase.inMemoryForTest();
    });

    tearDown(() async {
      await db.close();
    });

    test('지출을 추가하면 autoIncrement id와 createdAt이 자동으로 설정된다', () async {
      // given
      final now = DateTime.now();

      final companion = ExpenseEntityCompanion.insert(
        title: '점심 식사',
        amount: 12000,
        category: 'food',
        emotion: 'good',
        date: now,
      );

      // when
      final id = await db.into(db.expenseEntity).insert(companion);

      // then
      expect(id, 1); // 첫 번째 insert 이므로 1

      final rows = await db.select(db.expenseEntity).get();
      expect(rows.length, 1);

      final row = rows.first;
      expect(row.id, id);
      expect(row.title, '점심 식사');
      expect(row.amount, 12000);
      expect(row.category, 'food');
      expect(row.emotion, 'good');
      // Drift/SQLite 에서 millis 단위로 저장되며 미세한 차이가 날 수 있으므로
      // inSeconds 기준으로 1초 이내인지만 검증한다.
      expect(row.date.difference(now).inSeconds.abs(), lessThanOrEqualTo(1));
      // createdAt 은 withDefault(currentDateAndTime) 이므로 null 이 아니어야 함
      expect(row.createdAt, isNotNull);
      // updatedAt 은 아직 null
      expect(row.updatedAt, isNull);
    });

    test('여러 지출을 추가하면 id가 자동 증가한다', () async {
      final now = DateTime.now();

      final expense1 = ExpenseEntityCompanion.insert(
        title: '지출 1',
        amount: 1000,
        category: 'food',
        emotion: 'good',
        date: now,
      );

      final expense2 = ExpenseEntityCompanion.insert(
        title: '지출 2',
        amount: 2000,
        category: 'transport',
        emotion: 'normal',
        date: now,
      );

      final id1 = await db.into(db.expenseEntity).insert(expense1);
      final id2 = await db.into(db.expenseEntity).insert(expense2);

      expect(id1, 1);
      expect(id2, 2);

      final rows = await db.select(db.expenseEntity).get();
      expect(rows.length, 2);
      expect(rows.any((r) => r.id == 1), isTrue);
      expect(rows.any((r) => r.id == 2), isTrue);
    });

    test('지출을 수정하면 updatedAt 을 직접 설정할 수 있다', () async {
      final now = DateTime.now();

      final id = await db
          .into(db.expenseEntity)
          .insert(
            ExpenseEntityCompanion.insert(
              title: '원래 제목',
              amount: 5000,
              category: 'food',
              emotion: 'good',
              date: now,
            ),
          );

      final updatedAt = DateTime.now().add(const Duration(minutes: 1));

      final updatedCompanion = ExpenseEntityCompanion(
        id: drift.Value(id),
        title: const drift.Value('수정된 제목'),
        amount: const drift.Value(6000),
        category: const drift.Value('shopping'),
        emotion: const drift.Value('regret'),
        date: drift.Value(now),
        updatedAt: drift.Value(updatedAt),
      );

      final updatedCount = await db
          .update(db.expenseEntity)
          .replace(updatedCompanion);

      expect(updatedCount, isTrue);

      final row = await (db.select(
        db.expenseEntity,
      )..where((t) => t.id.equals(id))).getSingle();

      expect(row.title, '수정된 제목');
      expect(row.amount, 6000);
      expect(row.category, 'shopping');
      expect(row.emotion, 'regret');
      expect(row.updatedAt, isNotNull);
    });

    test('지출을 삭제하면 행이 제거된다', () async {
      final now = DateTime.now();

      final id = await db
          .into(db.expenseEntity)
          .insert(
            ExpenseEntityCompanion.insert(
              title: '삭제될 지출',
              amount: 3000,
              category: 'food',
              emotion: 'normal',
              date: now,
            ),
          );

      final deletedCount = await (db.delete(
        db.expenseEntity,
      )..where((t) => t.id.equals(id))).go();

      expect(deletedCount, 1);

      final rows = await db.select(db.expenseEntity).get();
      expect(rows, isEmpty);
    });
  });
}
