import 'package:expense_tracker/features/expense/models/expense_filter.dart';
import 'package:expense_tracker/features/expense/models/expense_statistics.dart';
import 'package:expense_tracker/features/expense/repositories/expense_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

/// 필터링된 지출 통계 Stream Provider
///
/// Repository의 watchExpenses를 사용하여 실시간으로 통계를 계산합니다.
final StreamProviderFamily<ExpenseAnalytics, ExpenseFilter>
expenseAnalyticsStreamProvider = StreamProvider.autoDispose
    .family<ExpenseAnalytics, ExpenseFilter>((ref, filter) {
      final repository = ref.read(expenseRepositoryProvider);

      return repository
          .watchExpenses(expenseFilter: filter)
          .map(ExpenseAnalytics.fromExpenses);
    });
