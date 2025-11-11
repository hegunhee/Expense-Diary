import 'package:expense_tracker/features/expense/models/expense.dart';

/// 감정별 통계 데이터
class EmotionStatistics {
  /// 감정별 통계 데이터 생성자
  const EmotionStatistics({
    required this.status,
    required this.count,
    required this.amount,
  });

  /// 감정 상태
  final ExpenseStatus status;

  /// 지출 건수
  final int count;

  /// 총 금액
  final int amount;

  /// 백분율 계산 (전체 건수 대비)
  double getPercentage(int totalCount) {
    if (totalCount == 0) {
      return 0;
    }
    return count / totalCount * 100;
  }
}

/// 전체 통계 데이터
class ExpenseStatistics {
  /// 전체 통계 데이터 생성자
  const ExpenseStatistics({
    required this.totalAmount,
    required this.totalCount,
    required this.emotionStats,
  });

  /// 지출 목록으로부터 통계 계산
  factory ExpenseStatistics.fromExpenses(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return ExpenseStatistics.empty;
    }

    // 감정별 통계 계산
    final statsMap = <ExpenseStatus, EmotionStatistics>{};

    for (final status in ExpenseStatus.values) {
      final filteredExpenses = expenses
          .where((e) => e.status == status)
          .toList();
      final count = filteredExpenses.length;
      final amount = filteredExpenses.fold<int>(0, (sum, e) => sum + e.amount);

      statsMap[status] = EmotionStatistics(
        status: status,
        count: count,
        amount: amount,
      );
    }

    final totalAmount = expenses.fold<int>(0, (sum, e) => sum + e.amount);
    final totalCount = expenses.length;

    return ExpenseStatistics(
      totalAmount: totalAmount,
      totalCount: totalCount,
      emotionStats: ExpenseStatus.values
          .map((status) => statsMap[status]!)
          .toList(),
    );
  }

  /// 총 지출 금액
  final int totalAmount;

  /// 총 지출 건수
  final int totalCount;

  /// 감정별 통계 목록
  final List<EmotionStatistics> emotionStats;

  /// 빈 통계 데이터
  static const empty = ExpenseStatistics(
    totalAmount: 0,
    totalCount: 0,
    emotionStats: [],
  );
}
