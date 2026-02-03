import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_form.dart';
import 'package:expense_tracker/features/expense/models/expense_statistics.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';
import 'package:expense_tracker/features/expense/state/expense_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 컨트롤러
class ExpenseController extends AsyncNotifier<ExpenseState> {
  late final ExpenseRepository _repository;

  @override
  Future<ExpenseState> build() async {
    _repository = ref.read(expenseRepositoryProvider);

    final expenses = await _repository.getAllExpenses();

    return ExpenseState(expenses: expenses, filter: null);
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
  Future<void> updateExpense(int id, Expense expense) async {
    final current = state.value;
    if (current == null) {
      return;
    }

    await _repository.updateExpense(expense);

    final updatedExpenses = [
      for (final e in current.expenses)
        if (e.id == id) expense else e,
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
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final expenses = await _repository.getAllExpenses();
      return ExpenseState(expenses: expenses);
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
