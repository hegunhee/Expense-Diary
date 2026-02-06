import 'package:expense_tracker/features/expense/controllers/expense_controller.dart';
import 'package:expense_tracker/features/expense/state/expense_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 상태를 관리하는 컨트롤러 프로바이더
final expenseControllerProvider =
    AsyncNotifierProvider<ExpenseController, ExpenseState>(
  ExpenseController.new,
);
