import 'package:expense_tracker/features/expense/controllers/expense_controller.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/screens/add_expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// 지출 카드 위젯
class ExpenseCardWidget extends ConsumerWidget {
  /// 생성자
  const ExpenseCardWidget({
    super.key,
    required this.expense,
  });

  /// 지출 데이터
  final Expense expense;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddExpenseScreen(expense: expense),
          ),
        );
      },
      onLongPress: () {
        _showDeleteDialog(context, ref);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // 카테고리 아이콘
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                expense.category.icon,
                color: const Color(0xFF666666),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),

            // 제목, 카테고리, 상태
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expense.category.label,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF999999),
                    ),
                  ),
                  const SizedBox(height: 4),
                  // 감정 변경이 있는 경우
                  if (expense.previousEmotion != null &&
                      expense.statusChangeReason != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${expense.previousEmotion!.emoji} ${expense.previousEmotion!.label} → ${expense.emotion.emoji} ${expense.emotion.label}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _getStatusColor(expense.emotion),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          expense.statusChangeReason!,
                          style: TextStyle(
                            fontSize: 12,
                            color: _getStatusColor(expense.emotion),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  else
                    Text(
                      '${expense.emotion.emoji} ${expense.emotion.label}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(expense.emotion),
                      ),
                    ),
                  if (expense.memo != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '메모: ${expense.memo!}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // 금액
            Text(
              '${NumberFormat('#,###').format(expense.amount)}원',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
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

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            '삭제 확인',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          content: const Text(
            '이 지출 내역을 삭제하시겠습니까?',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF666666),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                '취소',
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 14,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(expenseControllerProvider.notifier)
                    .deleteExpense(expense.id);
                Navigator.pop(dialogContext);
              },
              child: const Text(
                '삭제',
                style: TextStyle(
                  color: Color(0xFFF44336),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
