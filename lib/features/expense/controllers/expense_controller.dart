import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:expense_tracker/features/expense/models/expense_statistics.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 상태를 관리하는 컨트롤러 프로바이더
final expenseControllerProvider =
    AsyncNotifierProvider<ExpenseController, ExpenseState>(
      ExpenseController.new,
    );

/// 지출 컨트롤러
class ExpenseController extends AsyncNotifier<ExpenseState> {
  late final ExpenseRepository _repository;

  @override
  Future<ExpenseState> build() async {
    _repository = ref.read(expenseRepositoryProvider);

    final expenses = await _repository.getAllExpenses();

    return ExpenseState(expenses: expenses);
  }

  /// 필터 설정
  void setFilter(ExpenseEmotions? filter) {
    final current = state.value;
    if (current == null) {
      return;
    }
    state = AsyncValue.data(
      current.copyWith(
        filter: filter,
        resetFilter: filter == null,
      ),
    );
  }

  /// 지출 추가
  Future<void> addExpense(ExpenseForm form) async {
    final current = state.value;
    if (current == null) {
      return;
    }

    final id = await _repository.addExpense(form);
    final addedExpense = await _repository.getById(id);

    final updatedExpenses = [
      ...current.expenses,
      addedExpense,
    ]..sort((a, b) => b.date.compareTo(a.date));

    state = AsyncValue.data(
      current.copyWith(expenses: updatedExpenses),
    );
  }

  /// 지출 수정
  Future<void> updateExpense(Expense expense) async {
    final current = state.value;
    if (current == null) {
      return;
    }

    await _repository.updateExpense(expense);

    final updatedExpenses = [
      for (final e in current.expenses)
        if (e.id == expense.id) expense else e,
    ]..sort((a, b) => b.date.compareTo(a.date));

    state = AsyncValue.data(
      current.copyWith(expenses: updatedExpenses),
    );
  }

  /// 지출 삭제
  Future<void> deleteExpense(int id) async {
    final current = state.value;
    if (current == null) {
      return;
    }

    await _repository.deleteExpense(id);

    state = AsyncValue.data(
      current.copyWith(
        expenses: current.expenses.where((e) => e.id != id).toList(),
      ),
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    final currentFilter = state.value?.filter;
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final expenses = await _repository.getAllExpenses();
      return ExpenseState(expenses: expenses, filter: currentFilter);
    });
  }

  /// 통계 정보
  ExpenseAnalytics getAnalytics() {
    final current = state.value;

    if (current == null) {
      return ExpenseAnalytics.empty;
    }
    return ExpenseAnalytics.fromExpenses(current.expenses);
  }
}

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
  int get totalAmount => filteredExpenses.fold(0, (sum, e) => sum + e.amount);

  /// 상태 일부를 변경하여 새로운 ExpenseState를 생성한다
  ///
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
