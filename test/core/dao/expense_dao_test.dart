import 'package:drift/drift.dart' hide isNotNull;
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/daos/expense_dao.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppDatabase db;
  late ExpenseDao dao;

  setUp(() {
    // 인메모리 테스트용 DB 사용 (실제 파일에 영향 없음)
    db = AppDatabase.inMemoryForTest();
    dao = ExpenseDao(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('ExpenseDao', () {
    test('addExpense / getAllExpenses', () async {
      final companion = ExpenseEntityCompanion.insert(
        title: '점심',
        amount: 10000,
        category: ExpenseCategory.food.name,
        emotion: ExpenseEmotions.good.name,
        date: DateTime(2024, 1, 2),
        memo: const Value('맛있었다'),
      );

      final id = await dao.addExpense(companion);
      final all = await dao.getAllExpenses();

      expect(all.length, 1);
      final row = all.first;
      expect(row.id, id);
      expect(row.title, '점심');
      expect(row.amount, 10000);
      expect(row.category, 'food');
      expect(row.emotion, 'good');
      expect(row.memo, '맛있었다');
    });

    test('getById returns correct row', () async {
      final id = await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '택시',
          amount: 8000,
          category: ExpenseCategory.transport.name,
          emotion: ExpenseEmotions.normal.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final row = await dao.getById(id);

      expect(row, isNotNull);
      expect(row!.id, id);
      expect(row.title, '택시');
      expect(row.amount, 8000);
    });

    test('updateExpense replaces row', () async {
      final id = await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final updated = ExpenseEntityCompanion(
        id: Value(id),
        title: const Value('점심(수정)'),
        amount: const Value(12000),
        category: Value(ExpenseCategory.food.name),
        emotion: Value(ExpenseEmotions.regret.name),
        date: Value(DateTime(2024, 1, 2)),
      );

      final ok = await dao.updateExpense(updated);
      expect(ok, isTrue);

      final row = await dao.getById(id);
      expect(row, isNotNull);
      expect(row!.title, '점심(수정)');
      expect(row.amount, 12000);
      expect(row.emotion, 'regret');
    });

    test('deleteExpense removes row', () async {
      final id = await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '커피',
          amount: 5000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 3),
        ),
      );

      var all = await dao.getAllExpenses();
      expect(all.length, 1);

      await dao.deleteExpense(id);

      all = await dao.getAllExpenses();
      expect(all, isEmpty);
    });

    test('searchByTitle filters and sorts', () async {
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '친구랑 점심',
          amount: 15000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '아까운 커피',
          amount: 5000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.regret.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final result = await dao.searchByTitle('점심');

      expect(result.length, 1);
      expect(result.first.title, '친구랑 점심');
    });

    test('filterByCategory returns only matching category', () async {
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '지하철',
          amount: 1500,
          category: ExpenseCategory.transport.name,
          emotion: ExpenseEmotions.normal.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final food = await dao.filterByCategory(ExpenseCategory.food.name);

      expect(food.length, 1);
      expect(food.first.category, 'food');
      expect(food.first.title, '점심');
    });

    test('filterByStatus returns only matching emotion', () async {
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '좋은 점심',
          amount: 10000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: DateTime(2024, 1, 2),
        ),
      );
      await dao.addExpense(
        ExpenseEntityCompanion.insert(
          title: '아까운 커피',
          amount: 5000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.regret.name,
          date: DateTime(2024, 1, 2),
        ),
      );

      final regret = await dao.filterByStatus(ExpenseEmotions.regret.name);

      expect(regret.length, 1);
      expect(regret.first.emotion, 'regret');
      expect(regret.first.title, '아까운 커피');
    });
  });
}
