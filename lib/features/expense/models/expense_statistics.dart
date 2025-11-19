import 'package:expense_tracker/features/expense/models/expense.dart';

/// 감정별 통계 데이터
class EmotionStatistics {
  /// 감정별 통계 데이터 생성자
  const EmotionStatistics({
    required this.emotion,
    required this.count,
    required this.amount,
  });

  /// 감정 상태
  final ExpenseEmotions emotion;

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
class ExpenseAnalytics {
  /// 전체 통계 데이터 생성자
  const ExpenseAnalytics({
    required this.totalAmount,
    required this.totalCount,
    required this.emotionStats,
  });

  /// 지출 목록으로부터 통계 계산
  factory ExpenseAnalytics.fromExpenses(List<Expense> expenses) {
    if (expenses.isEmpty) {
      return ExpenseAnalytics.empty;
    }

    // 감정별 통계 계산
    final statsMap = <ExpenseEmotions, EmotionStatistics>{};

    for (final emotion in ExpenseEmotions.values) {
      final filteredExpenses = expenses
          .where((e) => e.emotion == emotion)
          .toList();
      final count = filteredExpenses.length;
      final amount = filteredExpenses.fold<int>(0, (sum, e) => sum + e.amount);

      statsMap[emotion] = EmotionStatistics(
        emotion: emotion,
        count: count,
        amount: amount,
      );
    }

    final totalAmount = expenses.fold<int>(0, (sum, e) => sum + e.amount);
    final totalCount = expenses.length;

    return ExpenseAnalytics(
      totalAmount: totalAmount,
      totalCount: totalCount,
      emotionStats: ExpenseEmotions.values
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
  static const empty = ExpenseAnalytics(
    totalAmount: 0,
    totalCount: 0,
    emotionStats: [],
  );
}
