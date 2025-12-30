import 'package:expense_tracker/features/expense/models/expense.dart';

/// 지출을 추가할 때 사용하는 폼 객체
class ExpenseForm {
  /// 생성자
  const ExpenseForm({
    required this.title,
    required this.amount,
    required this.category,
    required this.emotion,
    required this.date,
    this.memo,
  });

  /// 지출의 제목
  final String title;

  /// 지출의 가격
  final int amount;

  /// 지출 카테고리
  final ExpenseCategory category;

  /// 지출 감정
  final ExpenseEmotions emotion;

  /// 지출 날짜
  final DateTime date;

  /// 메모
  final String? memo;

  /// 지출 폼 복사 메서드
  ExpenseForm copyWith({
    String? title,
    int? amount,
    ExpenseCategory? category,
    ExpenseEmotions? emotion,
    DateTime? date,
    String? memo,
  }) {
    return ExpenseForm(
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      emotion: emotion ?? this.emotion,
      date: date ?? this.date,
      memo: memo ?? this.memo,
    );
  }
}
