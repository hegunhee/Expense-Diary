import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

/// 지출 레포지토리 Provider
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  final repository = ExpenseRepository();
  repository.init();
  return repository;
});

/// 지출 데이터 처리 서비스
class ExpenseRepository {
  static const _boxName = 'expenses';
  Box<Expense>? _box;

  /// Hive Box 초기화
  void init() {
    _box = Hive.box<Expense>(_boxName);
  }

  /// 모든 지출 조회
  List<Expense> getAllExpenses() {
    if (_box == null) {
      return [];
    }
    return _box!.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date)); // 최신순 정렬
  }

  /// 지출 추가
  Future<void> addExpense(Expense expense) async {
    await _box?.put(expense.id, expense);
  }

  /// 지출 수정
  Future<void> updateExpense(Expense expense) async {
    await _box?.put(expense.id, expense);
  }

  /// 지출 삭제
  Future<void> deleteExpense(String id) async {
    await _box?.delete(id);
  }

  /// 제목으로 검색 (향후 검색 기능용)
  List<Expense> searchByTitle(String query) {
    if (_box == null || query.isEmpty) {
      return getAllExpenses();
    }

    return _box!.values
        .where(
          (expense) =>
              expense.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 카테고리별 필터링
  List<Expense> filterByCategory(ExpenseCategory category) {
    if (_box == null) {
      return [];
    }

    return _box!.values
        .where((expense) => expense.category == category)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  /// 상태별 필터링
  List<Expense> filterByStatus(ExpenseStatus status) {
    if (_box == null) {
      return [];
    }

    return _box!.values.where((expense) => expense.status == status).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
