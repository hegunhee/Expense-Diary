import 'package:expense_tracker/features/expense/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 지출 요약 카드 위젯
class ExpenseSummaryCard extends StatelessWidget {
  /// 생성자
  const ExpenseSummaryCard({
    super.key,
    required this.totalAmount,
    required this.selectedDate,
    required this.onMonthChanged,
    this.selectedFilter,
  });

  /// 총 금액
  final int totalAmount;

  /// 선택된 날짜 (월 표시용)
  final DateTime selectedDate;

  /// 월 변경 콜백
  final Function(DateTime) onMonthChanged;

  /// 선택된 필터
  final ExpenseEmotions? selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // 월 선택 UI
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: () {
                  final previousMonth = DateTime(
                    selectedDate.year,
                    selectedDate.month - 1,
                  );
                  onMonthChanged(previousMonth);
                },
                color: const Color(0xFF4CAF50),
              ),
              Text(
                DateFormat('yyyy.MM').format(selectedDate),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: () {
                  final nextMonth = DateTime(
                    selectedDate.year,
                    selectedDate.month + 1,
                  );
                  onMonthChanged(nextMonth);
                },
                color: const Color(0xFF4CAF50),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 총 금액
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedFilter == null ? '총 지출' : selectedFilter!.label,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              Text(
                '${NumberFormat('#,###').format(totalAmount)}원',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
