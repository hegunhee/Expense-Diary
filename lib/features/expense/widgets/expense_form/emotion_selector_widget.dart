import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter/material.dart';

/// 감정 상태 선택 위젯
class EmotionSelectorWidget extends StatelessWidget {
  /// 감정 상태 선택 위젯 생성자
  const EmotionSelectorWidget({
    super.key,
    required this.selectEmotion,
    required this.onChanged,
  });

  /// 선택된 감정 상태
  final ExpenseEmotions? selectEmotion;

  /// 감정 상태 변경 콜백
  final ValueChanged<ExpenseEmotions?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '감정',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ExpenseEmotions.values.map((emotion) {
            final isSelected = selectEmotion == emotion;
            return GestureDetector(
              onTap: () => onChanged(emotion),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? emotion.color : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? emotion.color : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      emotion.emoji,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      emotion.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
