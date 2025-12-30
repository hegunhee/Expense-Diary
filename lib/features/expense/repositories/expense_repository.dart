import 'package:drift/drift.dart' show Value;
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/daos/expense_dao.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 레포지토리 Provider
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final dao = ref.read(expenseDaoProvider);
  return ExpenseRepository(dao);
});

/// 지출 데이터 처리 서비스
class ExpenseRepository {
  /// Dao가 들어가는 생성자
  ExpenseRepository(this._dao);

  /// CRUD를 처리하는 Dao
  final ExpenseDao _dao;

  /// 모든 지출 조회
  Future<List<Expense>> getAllExpenses() async {
    final rows = await _dao.getAllExpenses();
    // Dao에서 이미 date DESC 정렬해서 주면, 여기서 추가 정렬은 생략 가능
    return rows.map(_expenseEntityToExpense).toList();
  }

  /// 키 값을 기준으로 지출 조회
  Future<Expense> getById(int id) async {
    final row = await _dao.getById(id);
    return row != null
        ? _expenseEntityToExpense(row)
        : throw StateError('expense with id $id not found');
  }

  /// 지출 추가
  Future<int> addExpense(ExpenseForm form) {
    /// 데이터 추가
    return _dao.addExpense(_formToInsertCompanion(form));
  }

  /// 지출 수정
  Future<void> updateExpense(Expense expense) async {
    final companion = _expenseToUpdateCompanion(expense);
    await _dao.updateExpense(companion);
  }

  /// 지출 삭제
  Future<void> deleteExpense(int id) async {
    await _dao.deleteExpense(id);
  }

  /// 제목으로 검색 (향후 검색 기능용)
  Future<List<Expense>> searchByTitle(String query) async {
    if (query.isEmpty) {
      return getAllExpenses();
    }

    final rows = await _dao.searchByTitle(query);
    return rows.map(_expenseEntityToExpense).toList();
  }

  /// 카테고리별 필터링
  Future<List<Expense>> filterByCategory(ExpenseCategory category) async {
    final rows = await _dao.filterByCategory(category.name);
    return rows.map(_expenseEntityToExpense).toList();
  }

  /// 상태별 필터링
  Future<List<Expense>> filterByStatus(ExpenseEmotions emotion) async {
    final rows = await _dao.filterByStatus(emotion.name);
    return rows.map(_expenseEntityToExpense).toList();
  }

  // 아래부터는 Drift DB 매핑용 헬퍼 메서드들

  /// 추가용: ExpenseForm -> ExpenseEntityCompanion.insert
  ExpenseEntityCompanion _formToInsertCompanion(ExpenseForm form) {
    return ExpenseEntityCompanion.insert(
      title: form.title,
      amount: form.amount,
      category: form.category.name,
      emotion: form.emotion.name,
      date: form.date,
      memo: form.memo != null
          ? Value(form.memo) // 값이 있을 때
          : const Value.absent(),
    );
  }

  /// 조회용: ExpenseEntityData -> Expense
  Expense _expenseEntityToExpense(ExpenseEntityData row) {
    return Expense(
      id: row.id,
      title: row.title,
      amount: row.amount,
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == row.category,
      ),
      emotion: ExpenseEmotions.values.firstWhere((e) => e.name == row.emotion),
      date: row.date,
      memo: row.memo,
      previousEmotion: row.previousEmotion != null
          ? ExpenseEmotions.values.firstWhere(
              (e) => e.name == row.previousEmotion,
            )
          : null,
      emotionChangeReason: row.emotionChangeReason,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  /// 업데이트용: Expense -> ExpenseEntityCompanion
  ExpenseEntityCompanion _expenseToUpdateCompanion(Expense expense) {
    return ExpenseEntityCompanion(
      id: Value(expense.id),
      title: Value(expense.title),
      amount: Value(expense.amount),
      category: Value(expense.category.name),
      emotion: Value(expense.emotion.name),
      date: Value(expense.date),
      memo: expense.memo != null ? Value(expense.memo) : const Value.absent(),
      previousEmotion: expense.previousEmotion != null
          ? Value(expense.previousEmotion!.name)
          : const Value.absent(),
      emotionChangeReason: expense.emotionChangeReason != null
          ? Value(expense.emotionChangeReason)
          : const Value.absent(),
      createdAt: Value(expense.createdAt),
      updatedAt: Value(DateTime.now()),
    );
  }
}
