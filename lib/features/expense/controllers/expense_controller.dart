import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_statistics.dart';
import 'package:expense_tracker/features/expense/repositories//expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 컨트롤러 Provider
final expenseControllerProvider =
    AsyncNotifierProvider<ExpenseController, List<Expense>>(
      ExpenseController.new,
    );

/// 지출 컨트롤러
class ExpenseController extends AsyncNotifier<List<Expense>> {
  late final ExpenseRepository _repository;

  @override
  Future<List<Expense>> build() async {
    _repository = ref.read(expenseRepositoryProvider);
    return _repository.getAllExpenses();
  }

  /// 지출 추가
  Future<void> addExpense(Expense expense) async {
    await _repository.addExpense(expense);
    state = AsyncValue.data(
      [...state.value ?? [], expense]..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  /// 지출 수정
  Future<void> updateExpense(String id, Expense expense) async {
    await _repository.updateExpense(expense);
    state = AsyncValue.data(
      [
        for (final item in state.value ?? [])
          if (item.id == id) expense else item,
      ]..sort((a, b) => b.date.compareTo(a.date)),
    );
  }

  /// 지출 삭제
  Future<void> deleteExpense(String id) async {
    await _repository.deleteExpense(id);
    state = AsyncValue.data(
      (state.value ?? []).where((expense) => expense.id != id).toList(),
    );
  }

  /// 새로고침
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return _repository.getAllExpenses();
    });
  }

  /// 통계 정보
  ExpenseAnalytics getAnalytics() {
    return ExpenseAnalytics.fromExpenses(state.value ?? []);
  }
}

/// 필터 컨트롤러
class FilterController extends Notifier<ExpenseEmotions?> {
  @override
  ExpenseEmotions? build() => null;

  /// 필터 상태 설정
  void setFilter(ExpenseEmotions? status) {
    state = status;
  }
}

/// 필터 컨트롤러 Provider
final filterControllerProvider =
    NotifierProvider<FilterController, ExpenseEmotions?>(
      FilterController.new,
    );

/// 필터링된 지출 목록
final filteredExpenseProvider = Provider<List<Expense>>((ref) {
  final expensesAsync = ref.watch(expenseControllerProvider);
  final filter = ref.watch(filterControllerProvider);

  return expensesAsync.when(
    data: (expenses) {
      if (filter == null) {
        return expenses;
      }
      return expenses.where((expense) => expense.emotion == filter).toList();
    },
    loading: () => [],
    error: (error, stackTrace) => [],
  );
});

/// 총 지출 금액
final totalExpenseProvider = Provider<int>((ref) {
  final expenses = ref.watch(filteredExpenseProvider);
  return expenses.fold<int>(0, (sum, expense) => sum + expense.amount);
});
