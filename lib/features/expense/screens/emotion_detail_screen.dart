import 'package:expense_tracker/core/themes/app_colors.dart';
import 'package:expense_tracker/core/utils/layout_utils.dart';
import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:expense_tracker/features/expense/models/expense_filter.dart';
import 'package:expense_tracker/features/expense/providers/expense_list_stream_provider.dart';
import 'package:expense_tracker/features/expense/widgets/emotion_detail/emotion_summary_card.dart';
import 'package:expense_tracker/features/expense/widgets/emotion_detail/empty_emotion_state.dart';
import 'package:expense_tracker/features/expense/widgets/expense_list/expense_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// 감정별 상세 화면
class EmotionDetailScreen extends ConsumerWidget {
  /// 감정별 상세 화면 생성자
  const EmotionDetailScreen({
    super.key,
    required this.emotion,
    required this.startDate,
    required this.endDate,
  });

  /// 표시할 감정 상태
  final ExpenseEmotions emotion;

  /// 시작 날짜
  final DateTime startDate;

  /// 종료 날짜
  final DateTime endDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ExpenseFilter(
      emotion: emotion,
      startDate: startDate,
      endDate: endDate,
    );
    final expensesAsync = ref.watch(expenseListStreamProvider(filter));

    return Scaffold(
      backgroundColor: context.colors.surface,
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
      body: Padding(
        padding: systemBarsPadding(context),
        child: expensesAsync.when(
          data: (expenses) {
            if (expenses.isEmpty) {
              return Column(
                children: [
                  _buildDateRangeHeader(
                    context,
                    filter.startDate,
                    filter.endDate,
                  ),
                  Expanded(child: EmptyEmotionState(emotion: emotion)),
                ],
              );
            }

            final totalAmount = expenses.fold(
              0,
              (sum, e) => sum + e.amount,
            );
            return Column(
              children: [
                _buildDateRangeHeader(
                  context,
                  filter.startDate,
                  filter.endDate,
                ),
                // 상단 요약 카드 (위젯으로 분리)
                EmotionSummaryCard(
                  emotion: emotion,
                  count: expenses.length,
                  totalAmount: totalAmount,
                ),
                // 지출 목록
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ExpenseCardWidget(
                          expense: expenses[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('오류가 발생했습니다: $error')),
        ),
      ),
    );
  }

  Widget _buildDateRangeHeader(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    final dateFormat = DateFormat('yyyy.MM.dd');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE0E0E0)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.calendar_today,
            size: 16,
            color: context.colors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            '${dateFormat.format(startDate)} ~ ${dateFormat.format(endDate)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
