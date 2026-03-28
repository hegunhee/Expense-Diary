import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_filter.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// 필터링된 지출 목록 Stream Provider
///
/// 이 Provider는:
/// 1. ExpenseFilter를 파라미터로 받아 필터링
/// 2. DB에서 필터링된 데이터만 가져옴
/// 3. DB 변경 시 자동으로 갱신 (Drift의 watch 기능)
final StreamProviderFamily<List<Expense>, ExpenseFilter> expenseListStreamProvider = StreamProvider.autoDispose
    .family<List<Expense>, ExpenseFilter>((ref, filter) {
      final repository = ref.read(expenseRepositoryProvider);

      return repository.watchExpenses(
        expenseFilter: filter,
      );
    });
