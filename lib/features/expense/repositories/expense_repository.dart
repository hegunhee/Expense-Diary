import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 지출 레포지토리 Provider
final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return ExpenseRepository();
});

/// 지출 데이터 처리 서비스
class ExpenseRepository {
  /// 메모리에만 저장하는 리스트 (앱 재시작 시 초기화됨, Hive를 걷어내고 Drift 연동 전에 임시방편)
  final List<Expense> _items = [];

  /// 모든 지출 조회
  List<Expense> getAllExpenses() {
    final list = List<Expense>.from(_items);
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// 지출 추가
  Future<void> addExpense(Expense expense) async {
    _items.removeWhere((e) => e.id == expense.id);
    _items.add(expense);
  }

  /// 지출 수정
  Future<void> updateExpense(Expense expense) async {
    _items.removeWhere((e) => e.id == expense.id);
    _items.add(expense);
  }

  /// 지출 삭제
  Future<void> deleteExpense(String id) async {
    _items.removeWhere((e) => e.id == id);
  }

  /// 제목으로 검색 (향후 검색 기능용)
  List<Expense> searchByTitle(String query) {
    if (query.isEmpty) {
      return getAllExpenses();
    }

    final lower = query.toLowerCase();
    final list = _items
        .where((expense) => expense.title.toLowerCase().contains(lower))
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// 카테고리별 필터링
  List<Expense> filterByCategory(ExpenseCategory category) {
    final list = _items
        .where((expense) => expense.category == category)
        .toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  /// 상태별 필터링
  List<Expense> filterByStatus(ExpenseEmotions emotion) {
    final list = _items.where((expense) => expense.emotion == emotion).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }
}
