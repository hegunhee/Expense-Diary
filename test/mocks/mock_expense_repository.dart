import 'dart:async';

import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_filter.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';

/// Mock ExpenseService for testing
class MockExpenseRepository implements ExpenseRepository {
  final List<Expense> _expenses = [];
  final _controller = StreamController<List<Expense>>.broadcast();

  @override
  Future<List<Expense>> getAllExpenses() async {
    return List.from(_expenses)..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<int> addExpense(ExpenseForm form) async {
    final expense = Expense(
      id: _expenses.length + 1,
      title: form.title,
      amount: form.amount,
      category: form.category,
      emotion: form.emotion,
      date: DateTime.now(),
      memo: form.memo,
      createdAt: DateTime.now(),
    );
    _expenses.add(expense);
    _notifyListeners();
    return expense.id;
  }

  @override
  Future<Expense> getById(int id) async {
    final expense = _expenses.firstWhere(
      (e) => e.id == id,
      orElse: () => throw StateError('expense with id $id not found'),
    );
    return expense;
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
      _notifyListeners();
    }
  }

  @override
  Future<void> deleteExpense(int id) async {
    _expenses.removeWhere((e) => e.id == id);
    _notifyListeners();
  }

  @override
  Future<List<Expense>> searchByTitleOrMemo(String query) async {
    if (query.isEmpty) {
      return getAllExpenses();
    }

    return _expenses.where(
      (expense) {
        final lowerQuery = query.toLowerCase();
        final titleMatch = expense.title.toLowerCase().contains(lowerQuery);
        final memoMatch =
            expense.memo?.toLowerCase().contains(lowerQuery) ?? false;
        return titleMatch || memoMatch;
      },
    ).toList()..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Expense>> filterByCategory(ExpenseCategory category) async {
    return _expenses.where((expense) => expense.category == category).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<List<Expense>> filterByStatus(ExpenseEmotions emotion) async {
    return _expenses.where((expense) => expense.emotion == emotion).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Stream<List<Expense>> watchExpenses({
    required ExpenseFilter expenseFilter,
  }) {
    // 초기 데이터 emit
    _notifyListeners();

    // Stream 변환: 필터링 적용
    return _controller.stream.map((expenses) {
      return expenses.where((expense) {
        // 날짜 필터링
        final isInDateRange =
            expense.date.isAfter(
              expenseFilter.startDate.subtract(const Duration(seconds: 1)),
            ) &&
            expense.date.isBefore(
              expenseFilter.endDate.add(const Duration(days: 1)),
            );

        if (!isInDateRange) {
          return false;
        }

        // 감정 필터링
        if (expenseFilter.emotion != null) {
          return expense.emotion == expenseFilter.emotion;
        }

        return true;
      }).toList()..sort((a, b) => b.date.compareTo(a.date));
    });
  }

  void _notifyListeners() {
    _controller.add(List.from(_expenses));
  }

  /// 테스트 종료 시 호출
  void dispose() {
    _controller.close();
  }
}
