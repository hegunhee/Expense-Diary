import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/daos/expense_dao.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'expense_repository_test.mocks.dart';

@GenerateMocks([ExpenseDao])
void main() {
  late MockExpenseDao mockDao;
  late ExpenseRepository repository;

  setUp(() {
    mockDao = MockExpenseDao();
    repository = ExpenseRepository(mockDao);
  });

  group('ExpenseRepository.getAllExpenses', () {
    test('Dao에서 받은 Row를 Expense 리스트로 매핑한다', () async {
      // given
      final now = DateTime(2024, 1, 2);
      final rows = <ExpenseEntityData>[
        ExpenseEntityData(
          id: 1,
          title: '점심',
          amount: 10000,
          category: ExpenseCategory.food.name,
          emotion: ExpenseEmotions.good.name,
          date: now,
          memo: '맛있었다',
          createdAt: now,
        ),
      ];

      when(mockDao.getAllExpenses()).thenAnswer((_) async => rows);

      // when
      final result = await repository.getAllExpenses();

      // then
      expect(result.length, 1);
      final e = result.first;
      expect(e.id, 1);
      expect(e.title, '점심');
      expect(e.amount, 10000);
      expect(e.category, ExpenseCategory.food);
      expect(e.emotion, ExpenseEmotions.good);
      expect(e.memo, '맛있었다');
      expect(e.createdAt, now);
      expect(e.updatedAt, isNull);
    });
  });

  group('ExpenseRepository.addExpense', () {
    test('ExpenseForm을 Companion으로 매핑해서 Dao.addExpense를 호출한다', () async {
      // given
      final form = ExpenseForm(
        title: '택시',
        amount: 8000,
        category: ExpenseCategory.transport,
        emotion: ExpenseEmotions.normal,
        date: DateTime(2024, 1, 2),
        memo: '늦어서 탔다',
      );

      when(mockDao.addExpense(any)).thenAnswer((_) async => 10);

      // when
      final returnedId = await repository.addExpense(form);

      // then
      expect(returnedId, 10);
      final captured =
          verify(mockDao.addExpense(captureAny)).captured.single
              as ExpenseEntityCompanion;

      expect(captured.title.value, form.title);
      expect(captured.amount.value, form.amount);
      expect(captured.category.value, form.category.name);
      expect(captured.emotion.value, form.emotion.name);
      expect(captured.date.value, form.date);
      expect(captured.memo.value, form.memo);
    });
  });

  group('ExpenseRepository.getById', () {
    test('row가 없으면 StateError를 던진다', () {
      when(mockDao.getById(999)).thenAnswer((_) async => null);

      expect(
        () => repository.getById(999),
        throwsA(isA<StateError>()),
      );
    });
  });
}
