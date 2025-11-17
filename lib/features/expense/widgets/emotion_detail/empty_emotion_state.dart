import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter/material.dart';

/// 감정별 지출 없음 상태 위젯
class EmptyEmotionState extends StatelessWidget {
  /// 감정별 지출 없음 상태 위젯 생성자
  const EmptyEmotionState({
    super.key,
    required this.emotion,
  });

  /// 표시할 감정 상태
  final ExpenseEmotions emotion;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _getStatusEmoji(emotion),
            style: const TextStyle(fontSize: 80),
          ),
          const SizedBox(height: 16),
          Text(
            '아직 ${emotion.label} 지출이 없습니다',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusEmoji(ExpenseEmotions emotion) {
    switch (emotion) {
      case ExpenseEmotions.good:
        return '😊';
      case ExpenseEmotions.normal:
        return '😐';
      case ExpenseEmotions.regret:
        return '😕';
      case ExpenseEmotions.bad:
        return '😩';
    }
  }
}
