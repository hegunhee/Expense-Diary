import 'package:expense_tracker/features/expense/models/expense.dart';

/// 지출 필터 조건
class ExpenseFilter {
  /// 필터 생성자
  const ExpenseFilter({
    this.emotion,
    required this.startDate,
    required this.endDate,
  });

  /// 이번 달 필터 생성
  factory ExpenseFilter.thisMonth({ExpenseEmotions? emotion}) {
    final now = DateTime.now();
    return ExpenseFilter(
      emotion: emotion,
      startDate: DateTime(now.year, now.month),
      endDate: DateTime(now.year, now.month + 1, 0),
    );
  }

  /// 특정 달 필터 생성
  factory ExpenseFilter.month(
    int year,
    int month, {
    ExpenseEmotions? emotion,
  }) {
    return ExpenseFilter(
      emotion: emotion,
      startDate: DateTime(year, month),
      endDate: DateTime(year, month + 1, 0),
    );
  }

  /// 감정 필터 (null이면 전체)
  final ExpenseEmotions? emotion;

  /// 시작 날짜
  final DateTime startDate;

  /// 종료 날짜
  final DateTime endDate;

  /// 필터 복사
  ExpenseFilter copyWith({
    ExpenseEmotions? emotion,
    DateTime? startDate,
    DateTime? endDate,
    bool clearEmotion = false,
  }) {
    return ExpenseFilter(
      emotion: clearEmotion ? null : (emotion ?? this.emotion),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ExpenseFilter &&
        other.emotion == emotion &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode => Object.hash(emotion, startDate, endDate);
}
