import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 감정별 요약 카드 위젯
class EmotionSummaryCard extends StatelessWidget {
  /// 생성자
  const EmotionSummaryCard({
    super.key,
    required this.emotion,
    required this.count,
    required this.totalAmount,
  });

  /// 감정 상태
  final ExpenseEmotions emotion;

  /// 지출 건수
  final int count;

  /// 총 금액
  final int totalAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getStatusColor(emotion),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _getStatusColor(emotion).withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            _getStatusEmoji(emotion),
            style: const TextStyle(fontSize: 48),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  emotion.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '총 $count건',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                '총 지출',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${NumberFormat('#,###').format(totalAmount)}원',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
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

  Color _getStatusColor(ExpenseEmotions emotion) {
    switch (emotion) {
      case ExpenseEmotions.good:
        return const Color(0xFF4CAF50);
      case ExpenseEmotions.normal:
        return const Color(0xFF9E9E9E);
      case ExpenseEmotions.regret:
        return const Color(0xFFFF9800);
      case ExpenseEmotions.bad:
        return const Color(0xFFF44336);
    }
  }
}
