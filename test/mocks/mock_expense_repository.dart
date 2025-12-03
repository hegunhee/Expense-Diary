import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:expense_tracker/features/expense/repositories//expense_repository.dart';

/// Mock ExpenseService for testing
class MockExpenseRepository implements ExpenseRepository {
  final List<Expense> _expenses = [];

  @override
  List<Expense> getAllExpenses() {
    return List.from(_expenses)..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Future<void> addExpense(ExpenseForm form) async {
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
  }

  @override
  Future<void> updateExpense(Expense expense) async {
    final index = _expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      _expenses[index] = expense;
    }
  }

  @override
  Future<void> deleteExpense(int id) async {
    _expenses.removeWhere((e) => e.id == id);
  }

  @override
  List<Expense> searchByTitle(String query) {
    if (query.isEmpty) {
      return getAllExpenses();
    }

    return _expenses
        .where(
          (expense) =>
              expense.title.toLowerCase().contains(query.toLowerCase()),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<Expense> filterByCategory(ExpenseCategory category) {
    return _expenses.where((expense) => expense.category == category).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  List<Expense> filterByStatus(ExpenseEmotions emotion) {
    return _expenses.where((expense) => expense.emotion == emotion).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }
}
