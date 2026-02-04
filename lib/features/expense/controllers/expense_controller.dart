import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:expense_tracker/features/expense/models/expense_statistics.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 컨트롤러 Provider
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

  /// 지출 추가
  Future<void> addExpense(ExpenseForm form) async {
    final addedExpenseId = await _repository.addExpense(form);
    final addedExpense = await _repository.getById(addedExpenseId);

    final currentExpenses = state.value?.expenses ?? [];
    final updatedExpenses = [...currentExpenses, addedExpense]
      ..sort((a, b) => b.date.compareTo(a.date));

    state = state.whenData(
      (value) => value.copyWith(expenses: updatedExpenses),
    );
  }

  /// 지출 수정
  Future<void> updateExpense(int id, Expense expense) async {
    await _repository.updateExpense(expense);

    final currentExpenses = state.value?.expenses ?? [];
    final updatedExpenses = [
      for (final item in currentExpenses)
        if (item.id == id) expense else item,
    ]..sort((a, b) => b.date.compareTo(a.date));

    state = state.whenData(
      (value) => value.copyWith(expenses: updatedExpenses),
    );
  }

  /// 지출 삭제
  Future<void> deleteExpense(int id) async {
    await _repository.deleteExpense(id);

    final currentExpenses = state.value?.expenses ?? [];
    final updatedExpenses = currentExpenses
        .where((expense) => expense.id != id)
        .toList();

    state = state.whenData(
      (value) => value.copyWith(expenses: updatedExpenses),
    );
  }

  /// 필터 설정
  void setFilter(ExpenseEmotions? emotion) {
    state = state.whenData(
      (value) => value.copyWith(expenseEmotion: emotion)
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final expenses = await _repository.getAllExpenses();
      final currentFilter = state.value?.expenseEmotion;
      return ExpenseState(expenses: expenses, expenseEmotion: currentFilter);
    });
  }

  /// 통계 정보
  ExpenseAnalytics getAnalytics() {
    return ExpenseAnalytics.fromExpenses(state.value?.expenses ?? []);
  }
}

/// 지출 상태
class ExpenseState {
  /// 지출 상태 생성자
  const ExpenseState({required this.expenses, this.expenseEmotion});

  /// 지출 목록
  final List<Expense> expenses;

  /// 지출 감정
  final ExpenseEmotions? expenseEmotion;

  /// 감정에 의해 필터링 된 지출목록
  List<Expense> get filteredExpenses {
    if (expenseEmotion == null) {
      return expenses;
    }
    return expenses.where((e) => e.emotion == expenseEmotion).toList();
  }

  /// 필터링 된 지출 합계
  int get totalAmount {
    return filteredExpenses.fold(0, (sum, e) => sum + e.amount);
  }

  /// 상태 복사
  ExpenseState copyWith({
    List<Expense>? expenses,
    ExpenseEmotions? expenseEmotion,
  }) {
    return ExpenseState(
      expenses: expenses ?? this.expenses,
      expenseEmotion: expenseEmotion ?? this.expenseEmotion,
    );
  }
}
