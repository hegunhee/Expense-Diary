import 'package:expense_tracker/features/expense/controllers/expense_controller.dart';
import 'package:expense_tracker/features/expense/state/expense_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final expenseControllerProvider =
    AsyncNotifierProvider<ExpenseController, ExpenseState>(
  ExpenseController.new,
);