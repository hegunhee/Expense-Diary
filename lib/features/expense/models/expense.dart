import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'expense.g.dart';

/// 지출 카테고리
@HiveType(typeId: 0)
enum ExpenseCategory {
  /// 식비 카테고리
  @HiveField(0)
  food('식비', Icons.restaurant),

  /// 교통 카테고리
  @HiveField(1)
  transport('교통', Icons.directions_car),

  /// 쇼핑 카테고리
  @HiveField(2)
  shopping('쇼핑', Icons.shopping_bag),

  /// 문화생활 카테고리
  @HiveField(3)
  culture('문화생활', Icons.movie);

  const ExpenseCategory(this.label, this.icon);

  /// 카테고리 라벨
  final String label;

  /// 카테고리 아이콘
  final IconData icon;
}

/// 지출 상태 (잘 쓴 돈, 그저 그런 돈, 아까운 돈, 후회한 돈)
@HiveType(typeId: 1)
enum ExpenseEmotions {
  /// 잘 쓴 돈
  @HiveField(0)
  good('잘 쓴 돈', Color(0xFF4CAF50), '😊'),

  /// 그저 그런 돈
  @HiveField(1)
  normal('그저 그런 돈', Color(0xFF9E9E9E), '😐'),

  /// 아까운 돈
  @HiveField(2)
  regret('아까운 돈', Color(0xFFFF9800), '😕'),

  /// 후회한 돈
  @HiveField(3)
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
@HiveType(typeId: 2)
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
    this.statusChangeReason,
  });

  /// 지출 고유 ID
  @HiveField(0)
  final String id;

  /// 지출 제목
  @HiveField(1)
  final String title;

  /// 지출 금액
  @HiveField(2)
  final int amount;

  /// 지출 카테고리
  @HiveField(3)
  final ExpenseCategory category;

  /// 지출 감정 상태
  @HiveField(4)
  final ExpenseEmotions emotion;

  /// 지출 날짜
  @HiveField(5)
  final DateTime date;

  /// 메모 (선택사항)
  @HiveField(6)
  final String? memo;

  /// 이전 감정 상태 (변경된 경우)
  @HiveField(7)
  final ExpenseEmotions? previousEmotion;

  /// 감정 상태 변경 사유
  @HiveField(8)
  final String? statusChangeReason;

  /// 지출 복사 메서드
  Expense copyWith({
    String? id,
    String? title,
    int? amount,
    ExpenseCategory? category,
    ExpenseEmotions? status,
    DateTime? date,
    String? memo,
    ExpenseEmotions? previousStatus,
    String? statusChangeReason,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      emotion: status ?? this.emotion,
      date: date ?? this.date,
      memo: memo ?? this.memo,
      previousEmotion: previousStatus ?? this.previousEmotion,
      statusChangeReason: statusChangeReason ?? this.statusChangeReason,
    );
  }
}
