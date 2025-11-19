import 'package:expense_tracker/features/expense/controllers/expense_controller.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/widgets/emotion_detail/emotion_summary_card.dart';
import 'package:expense_tracker/features/expense/widgets/emotion_detail/empty_emotion_state.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/expense_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 감정별 상세 화면
class EmotionDetailScreen extends ConsumerWidget {
  /// 감정별 상세 화면 생성자
  const EmotionDetailScreen({super.key, required this.emotion});

  /// 표시할 감정 상태
  final ExpenseEmotions emotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expensesAsync = ref.watch(expenseControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emotion.emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(width: 8),
            Text(
              emotion.label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: emotion.color,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: expensesAsync.when(
        data: (expenses) {
          // 해당 감정의 지출만 필터링
          final filteredExpenses =
              expenses.where((e) => e.emotion == emotion).toList()
                ..sort((a, b) => b.date.compareTo(a.date));

          if (filteredExpenses.isEmpty) {
            return EmptyEmotionState(emotion: emotion);
          }

          final totalAmount = filteredExpenses.fold(
            0,
            (sum, e) => sum + e.amount,
          );

          return Column(
            children: [
              // 상단 요약 카드 (위젯으로 분리)
              EmotionSummaryCard(
                emotion: emotion,
                count: filteredExpenses.length,
                totalAmount: totalAmount,
              ),
              // 지출 목록
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredExpenses.length,
                  itemBuilder: (context, index) {
                    return ExpenseCardWidget(expense: filteredExpenses[index]);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
      ),
    );
  }
}
