import 'package:flutter/material.dart';

/// 지출 카테고리
enum ExpenseCategory {
  /// 식비 카테고리
  food('식비', Icons.restaurant),

  /// 교통 카테고리
  transport('교통', Icons.directions_car),

  /// 쇼핑 카테고리
  shopping('쇼핑', Icons.shopping_bag),

  /// 문화생활 카테고리
  culture('문화생활', Icons.movie);

  const ExpenseCategory(this.label, this.icon);

  /// 카테고리 라벨
  final String label;

  /// 카테고리 아이콘
  final IconData icon;
}

/// 지출 감정 (잘 쓴 돈, 그저 그런 돈, 아까운 돈, 후회한 돈)
enum ExpenseEmotions {
  /// 잘 쓴 돈
  good('잘 쓴 돈', Color(0xFF4CAF50), '😊'),

  /// 그저 그런 돈
  normal('그저 그런 돈', Color(0xFF9E9E9E), '😐'),

  /// 아까운 돈
  regret('아까운 돈', Color(0xFFFF9800), '😕'),

  /// 후회한 돈
  bad('후회한 돈', Color(0xFFF44336), '😩');

  const ExpenseEmotions(this.label, this.color, this.emoji);

  /// 상태 라벨
  final String label;

  /// 상태 색상
  final Color color;

  /// 상태 이모지
  final String emoji;
}

/// 지출 데이터 모델
class Expense {
  /// 지출 생성자
  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.emotion,
    required this.date,
    this.memo,
    this.previousEmotion,
    this.emotionChangeReason,
    required this.createdAt,
    this.updatedAt,
  });

  /// 지출 고유 ID
  final int id;

  /// 지출 제목
  final String title;

  /// 지출 금액
  final int amount;

  /// 지출 카테고리
  final ExpenseCategory category;

  /// 지출 감정 상태
  final ExpenseEmotions emotion;

  /// 지출 날짜
  final DateTime date;

  /// 메모 (선택사항)
  final String? memo;

  /// 이전 감정 상태 (변경된 경우)
  final ExpenseEmotions? previousEmotion;

  /// 감정 상태 변경 사유
  final String? emotionChangeReason;

  /// 지출 내용이 생성된 시점의 시간 (추후 시간을 변경할수도 있으므로)
  final DateTime createdAt;

  /// 업데이트된 시간 아직 생성만 한 지출의 경우 null이 될 수 있음
  final DateTime? updatedAt;

  /// 지출 복사 메서드
  Expense copyWith({
    int? id,
    String? title,
    int? amount,
    ExpenseCategory? category,
    ExpenseEmotions? emotion,
    DateTime? date,
    String? memo,
    ExpenseEmotions? previousEmotion,
    String? emotionChangeReason,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      emotion: emotion ?? this.emotion,
      date: date ?? this.date,
      memo: memo ?? this.memo,
      previousEmotion: previousEmotion ?? this.previousEmotion,
      emotionChangeReason: emotionChangeReason ?? this.emotionChangeReason,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
