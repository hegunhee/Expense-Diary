import 'package:expense_tracker/features/expense/models/expense.dart';

/// 지출 목록과 필터 상태를 보관하는 상태 모델
class ExpenseState {
  ///  상태 모델 생성자
  const ExpenseState({
    required this.expenses,
    this.filter,
  });

  /// 전체 지출 목록
  final List<Expense> expenses;

  /// 선택된 감정 필터 (null이면 전체)
  final ExpenseEmotions? filter;

  /// 선택된 필터에 따라 필터링된 지출 목록
  List<Expense> get filteredExpenses {
    if (filter == null) {
      return expenses;
    }
    return expenses.where((e) => e.emotion == filter).toList();
  }

  /// 필터링된 지출의 총 금액
  int get totalAmount =>
      filteredExpenses.fold(0, (sum, e) => sum + e.amount);

  /// 상태 일부를 변경하여 새로운 ExpenseState를 생성한다
  ///
  /// [resetFilter]가 true이면 필터를 null로 초기화한다.
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
