import 'package:expense_tracker/features/expense/models/expense.dart';

class ExpenseState {
  const ExpenseState({
    required this.expenses,
    this.filter,
  });
  final List<Expense> expenses;
  final ExpenseEmotions? filter;

  List<Expense> get filteredExpenses {
    if (filter == null) return expenses;
    return expenses.where((e) => e.emotion == filter).toList();
  }

  int get totalAmount =>
      filteredExpenses.fold(0, (sum, e) => sum + e.amount);


  ExpenseState copyWith({
    List<Expense>? expenses,
    ExpenseEmotions? filter,
    bool resetFilter = false,

  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      filter: resetFilter ? null : (filter ?? this.filter),
    );
  }
  
}